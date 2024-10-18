import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/features/JCI/presentation/manager/jci_cubit/jci_cubit.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:alaminedu/features/home/data/models/notification_model.dart';
import 'package:alaminedu/features/home/presentation/views/home_page.dart';
import 'package:alaminedu/features/login/log_in_page.dart';
import 'package:alaminedu/firebase_options.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:safe_device/safe_device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/cache/cashe_helper.dart';
import 'core/notifications/notification_services.dart';
import 'core/utils/bloc_observer.dart';
import 'core/utils/permissions_class.dart';
import 'core/utils/service_locator.dart';
import 'features/collages/data/repo/college_repo_impl.dart';
import 'features/home/data/repo/home_repo_impl.dart';
import 'features/home/presentation/manager/cubit/f_ile_cubit.dart';
import 'features/login/manager/cubit/login_cubit.dart';
import 'features/splash/splach_view.dart';
import 'generated/l10n.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Save the received notification locally
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Map<String, dynamic>> notifications = [];
  if (prefs.containsKey(Constants.kNotification)) {
    final List<String> notificationsJson =
        prefs.getStringList(Constants.kNotification)!;
    notifications = notificationsJson
        .map((json) => jsonDecode(json))
        .toList()
        .cast<Map<String, dynamic>>();
  }

  notifications.add({
    'title': message.notification!.title!,
    'body': message.notification!.body!,
  });

  final notificationsJson =
      notifications.map((notification) => jsonEncode(notification)).toList();
  await prefs.setStringList(Constants.kNotification, notificationsJson);

  // Handle other background tasks
}

void main() async {
  /*
    This line makes sure that all lines are executed
    before the last line * runApp(const MyApp()); *
  */
  WidgetsFlutterBinding.ensureInitialized();
  /*
    Bloc observer is class that can tell me what
    the state now, and print state in every change in states
   */
  //? this added for android 7 exception `details exist after main function`
  HttpOverrides.global = MyHttpOverrides();
  //? -----------------------------------
  Bloc.observer = MyBlocObserver();
  await CasheHelper.casheInit();

  /*
    this code make app unable to auto rotate
  */
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
//! this firebase init ..
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ! this background Message ...
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /*
    Service Locator is class make me a single object from
    any class , ...
  */
  setupServiceLocator();

  getIt<NotificationServices>().requestNotificationPermission();

  await PermissionsClass.requestPermissions();
  // final storageStatus = await Permission.storage.request();

  //

  // bool isSafeDevice = await SafeDevice.isSafeDevice;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // bool isRooted = await DeviceCheck.isRooted;
  // bool isEmulator = await DeviceCheck.isEmulator;
  // bool jailbreaker = await FlutterJailbreakDetection.jailbroken;

  if (await CasheHelper.getData(key: Constants.kIsFirstTime)) {
    runApp(const MyApp());
  } else {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      bool safeDevice = await SafeDevice.isSafeDevice;
      bool isOnExternalStorage = await SafeDevice.isOnExternalStorage;
      bool isRealDevice = await SafeDevice.isRealDevice;
      bool isJailBroken = await SafeDevice.isJailBroken;
      bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
      bool canMockLocation = await SafeDevice.canMockLocation;
      if (androidInfo.isPhysicalDevice &&
          safeDevice &&
          !isOnExternalStorage &&
          isRealDevice &&
          !isJailBroken &&
          !isDevelopmentModeEnable &&
          !canMockLocation) {
        runApp(const MyApp());
      } else {
        runApp(NotSupported(
          isJailBroken: isJailBroken,
          isOnExternalStorage: isOnExternalStorage,
          isRealDevice: isRealDevice,
          safeDevice: safeDevice,
          canMockLocation: canMockLocation,
          isDevelopmentModeEnable: isDevelopmentModeEnable,
        ));
      }
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice) {
        runApp(const MyApp());
      } else {
        runApp(NotSupported());
      }
    }
  }
}

/*
? we trying to call apis in android 7 so we had the following error:
E/flutter ( 6264): HandshakeException: Handshake error in client 
(OS Error: E/flutter ( 6264):  CERTIFICATE_VERIFY_FAILED: unable 
to get local issuer certificate(handshake.cc:363))
? so in stackOverFlow the solution was to add this class an override `createHttpClient`
? function and the error was gone 

! we add 
 */
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
//? --------------------------------------------------------------------------------------

Future<void> _messageHandler(RemoteMessage message) async {}

Future<void> _fierbaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var iosSecureScreenShotChannel =
      const MethodChannel('secureScreenshotChannel');
  @override
  void initState() {
    startProtect();
    super.initState();
  }

  startProtect() async {
    if (Platform.isIOS) {
      iosSecureScreenShotChannel.invokeMethod("secureiOS");
    }
  }

  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //
  //       break;
  //     case AppLifecycleState.inactive:
  //
  //       break;
  //     case AppLifecycleState.paused:
  //
  //       break;
  //     case AppLifecycleState.detached:
  //
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CollegeCubit(getIt.get<CollegeRepoImpl>())..createDataBase(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => FIleCubit(
            getIt.get<HomeRepoImpl>(),
          ),
        ),
        BlocProvider(
          create: (context) => JciCubit(),
        ),
        // BlocProvider(
        //   create: (context) => FIleCubit()..createDataBase(),
        // ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: 'Al Amin',

        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: AppColor.kPrimaryColor,
          ),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: AppColor.kPrimaryColor,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.kPrimaryColor),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        // home: LoginScreen(),
        // home: RegisterScreenA(),
        home: const SplashScreen(),
      ),
    );
  }
}

class NotSupported extends StatefulWidget {
  NotSupported(
      {super.key,
      this.safeDevice,
      this.isOnExternalStorage,
      this.isRealDevice,
      this.isJailBroken,
      this.isDevelopmentModeEnable,
      this.canMockLocation});
  final bool? safeDevice;
  final bool? isOnExternalStorage;
  final bool? isRealDevice;
  final bool? isJailBroken;
  final bool? isDevelopmentModeEnable;
  final bool? canMockLocation;
  // Map<String, TestUnit> err = {};
  // List<TestUnit> err = [];
  // bool firstCheck = false;

  @override
  State<NotSupported> createState() => _NotSupportedState();
}

class TestUnit {
  final String errMessage;
  final void Function()? onTap;
  final String type;
  bool isHere;

  TestUnit(this.errMessage, this.onTap, this.type, {this.isHere = false});
}

class _NotSupportedState extends State<NotSupported>
    with WidgetsBindingObserver {
  /*     
  Future<void> check() async {
    widget.err.clear();
    // Location location = Location();
    // bool sasfeDeviceNew = await SafeDevice.isSafeDevice;
    await CasheHelper.setData(key: Constants.kIsFirstTime, value: false);

    setState(() {});
    // final _serviceEnabled = await location.requestService();
    //  
    bool isOnExternalStorageNew = await SafeDevice.isOnExternalStorage;
    bool isRealDeviceNew = await SafeDevice.isRealDevice;
    bool isJailBrokenNew = await SafeDevice.isJailBroken;
    bool isDevelopmentModeEnableNew = await SafeDevice.isDevelopmentModeEnable;
    bool canMockLocationNew = await SafeDevice.canMockLocation;

    if (isOnExternalStorageNew == true) {
      setState(() {
        const errMessage1 = ' run in internal storage.';
        widget.err['External'] = TestUnit(errMessage1, () {});
      });
       
    } else {
      widget.err.remove('External');
    }
    if (isRealDeviceNew == false) {
      setState(() {
        const errMessage2 = 'please run with real device.';
        widget.err['Real'] = TestUnit(errMessage2, () {});
      });
       
    } else {
      widget.err.remove('Real');
    }
    if (isJailBrokenNew == true) {
      setState(() {
        const errMessage3 = ' you can\'t run with root in your system';
        widget.err['Jail'] = TestUnit(errMessage3, () {});
      });
       
    } else {
      widget.err.remove('Jail');
    }
    if (isDevelopmentModeEnableNew == true) {
      setState(() {
        const errMessage4 = ' please turn off developer mode in your device.';
        widget.err['Dev'] = TestUnit(errMessage4, () {
          AppSettings.openAppSettings(
              type: AppSettingsType.developer, asAnotherTask: true);
        });
      });
       
    } else {
      widget.err.remove('Dev');
    }
    if (canMockLocationNew == true) {
      setState(() {
        const errMessage5 =
            ' please turn on location and turn off any vpn program then close Al-amin app and clear ram memory and try again';
        widget.err['Mock'] = TestUnit(errMessage5, () {
          AppSettings.openAppSettings(
              type: AppSettingsType.location, asAnotherTask: true);
        });
      });
       
    } else {
      widget.err.remove('Mock');
    }
     
    // setState(() {
    //   (widget.err.isEmpty)
    //       ? Navigator.of(context).pushAndRemoveUntil(
    //           MaterialPageRoute(
    //             builder: (newContext) => const SplashScreen(),
    //           ),
    //           (route) => false)
    //       : null;
    // });
  }
*/

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       // widget.err.clear();
  //
  //       await check();
  //       break;
  //     case AppLifecycleState.inactive:
  //
  //       break;
  //     case AppLifecycleState.paused:
  //
  //       break;
  //     case AppLifecycleState.detached:
  //
  //       break;
  //     case AppLifecycleState.hidden:
  //       // TODO: Handle this case.
  //       break;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    // String convertDriveLink(String sharedLink) {
    //   if (sharedLink.contains('drivesdk')) {
    //     sharedLink = sharedLink.replaceAll('drivesdk', 'sharing');
    //   }
    //   if (sharedLink.contains('/file/d/') &&
    //       sharedLink.contains('/view?usp=sharing')) {
    //     final startIdx = sharedLink.indexOf('/file/d/') + 8;
    //     final endIdx = sharedLink.indexOf('/view?usp=sharing');
    //     if (startIdx < endIdx) {
    //       final fileId = sharedLink.substring(startIdx, endIdx);
    //       return 'https://drive.google.com/uc?export=download&id=$fileId';
    //     }
    //   }
    //   return sharedLink;
    // }

    // int count = 1;
    // if (!widget.firstCheck) {
    //   widget.firstCheck = true;
    //   if (widget.isOnExternalStorage == true) {
    //     setState(() {
    //       final errMessage1 = '$count- run in internal storage.';
    //       widget.err['External'] = TestUnit(errMessage1, () {});
    //       count++;
    //     });
    //   }
    //   if (widget.isRealDevice == false) {
    //     setState(() {
    //       final errMessage2 = '$count- please run with real device.';
    //       widget.err['Real'] = (TestUnit(errMessage2, () {}));
    //       count++;
    //     });
    //   }
    //   if (widget.isJailBroken == true) {
    //     setState(() {
    //       final errMessage3 = '$count- you can\'t run with root in your system';
    //       widget.err['Jail'] = (TestUnit(errMessage3, () {}));
    //       count++;
    //     });
    //   }
    //   if (widget.isDevelopmentModeEnable == true) {
    //     setState(() {
    //       final errMessage4 =
    //           '$count- please turn off developer mode in your device.';
    //       widget.err['Dev'] = (TestUnit(errMessage4, () {
    //         AppSettings.openAppSettings(
    //             type: AppSettingsType.developer, asAnotherTask: true);
    //       }));
    //       count++;
    //     });
    //   }
    //   if (widget.canMockLocation == true) {
    //     setState(() {
    //       final errMessage5 =
    //           '$count- please turn on location and turn off any vpn program then close Al-amin app and clear ram memory and try again';
    //       widget.err['Mock'] = (TestUnit(errMessage5, () {
    //         AppSettings.openAppSettings(
    //             type: AppSettingsType.location, asAnotherTask: true);
    //       }));
    //       count++;
    //     });
    //   }
    // }
    // List<MapEntry<String, dynamic>> myList = widget.err.entries.toList();

    // print(convertDriveLink(
    // 'https://drive.google.com/file/d/1dcnvRcm02Oj6JbLXm7bNsm_vJ1WryRCj/view?usp=sharing'));

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CollegeCubit(getIt.get<CollegeRepoImpl>())..createDataBase(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => FIleCubit(
            getIt.get<HomeRepoImpl>(),
          ),
        ),
        // BlocProvider(
        //   create: (context) => SubjectBloc(),
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: AppColor.kPrimaryColor,
          ),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        // home: LoginScreen(),
        // home: RegisterScreenA(),
        home: const NotSupprtedBody(),
      ),
    );
  }
}

class NotSupprtedBody extends StatefulWidget {
  const NotSupprtedBody({
    super.key,
    // required this.myList,
  });

  @override
  State<NotSupprtedBody> createState() => _NotSupprtedBodyState();
}

class _NotSupprtedBodyState extends State<NotSupprtedBody>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        // widget.err.clear();

        setState(() {});
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }

  Timer? _timer;
  void _startTimer() {
    const Duration interval = Duration(seconds: 2);
    _timer = Timer.periodic(interval, (_) {
      // Update the position of the watermark every 10 seconds
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();

    super.dispose();
  }

  // final List<MapEntry<String, dynamic>> myList;
  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit.get(context);
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: loginCubit.check(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return (!snapshot.data![index].isHere)
                    ? const SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  snapshot.data![index].errMessage,
                                  style: Styles.textStyle20PriCol,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: snapshot.data![index].onTap,
                            child: const Text(
                              'click here',
                              style: TextStyle(),
                            ),
                          ),
                          BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) {
                              if (state is SuccessTestState &&
                                  loginCubit.allDone) {
                                //
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SplashScreen(),
                                    ),
                                    (route) => false);
                              }
                            },
                            builder: (context, state) {
                              return SizedBox();
                            },
                          ),
                        ],
                      );
              },
            );
          } else {
            return const Center(
              child: CustomLoadingIndicator(
                color: AppColor.kPrimaryColor,
              ),
            );
          }
        },
      ),

      // BlocConsumer<LoginCubit, LoginState>(
      //   listener: (context, state) {},
      //   builder: (context, state) {
      //     if (state is LoadingTestState) {
      //       return const Center(
      //         child: CustomLoadingIndicator(),
      //       );
      //     } else {
      //       return ListView.builder(
      //         itemCount: loginCubit.test.length,
      //         itemBuilder: (context, index) {
      //           return Row(
      //             children: [
      //               Expanded(
      //                 child: Text(
      //                   loginCubit.test[index].errMessage,
      //                   style: Styles.textStyle20PriCol,
      //                 ),
      //               ),
      //               TextButton(
      //                   onPressed: loginCubit.test[index].onTap,
      //                   child: const Text(
      //                     'click here',
      //                     style: TextStyle(),
      //                   )),
      //             ],
      //           );
      //         },
      //       );
      //     }
      //   },
      // ),
    );
  }
}
