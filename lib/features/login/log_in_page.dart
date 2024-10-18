import 'dart:convert';
import 'dart:io';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/core/widgets/custom_text_form_field.dart';
import 'package:alaminedu/features/home/presentation/views/home_page.dart';
import 'package:alaminedu/features/login/background.dart';
import 'package:alaminedu/features/login/resgister_r.dart';
import 'package:device_imei/device_imei.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../../constants.dart';
import '../../core/cache/cashe_helper.dart';
import '../../core/widgets/custom_Loading_indicator.dart';
import '../../core/widgets/custom_error_dailog.dart';
import 'data/login_api.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  static const Channel = MethodChannel('com.example.alaminedu');
  final String userNameFromSingin;
  final String phoneFromSingin;

  const LoginScreen(
      {super.key,
      required this.userNameFromSingin,
      required this.phoneFromSingin});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    _fullNameController.text = widget.userNameFromSingin;
    _phoneController.text = widget.phoneFromSingin;
    // TODO: implement initState
    super.initState();
    // getmac().then(
    //   (value) {
    //
    //   },
    // );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  List<TextInputFormatter> usernameInputFormatters = [
    // FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
  ];
  List<TextInputFormatter> phoneInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
  ];
  TextInputType? keyboardTypephone = TextInputType.number;
  TextInputType? keyboardTypeusername = TextInputType.text;
  bool _isPasswordVisible = false;
  Dio dio = Dio();

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    final success = await _performLogin();

    // final success = await postLoginDio(data: dataa);

    if (success) {
      await CasheHelper.setData(key: Constants.kIsFirstTime, value: true);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } else {
      // ignore: use_build_context_synchronously
    }
  }

  // var macAddress;

  // Future<void> getmac() async {
  //   macAddress = await ApiClass.getMacAddress();
  // }

  Future<bool> _performLogin() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    final url = Uri.parse('${Constants.kDomain}users/login');

    // final headers = {
    //   'Content-Type': 'application/json',
    // };

    //   final body = '''{
    //   "user": "${_fullNameController.text}",
    //   "phone": "${_phoneController.text}",
    //
    // }''';
    final body = {
      "user": _fullNameController.text,
      "phone": _phoneController.text
    };
    // "mac_address":"$macAddress" this was above

    try {
      final response = await http.post(url, body: body);
      //
      setState(() {
        _isLoading = false; // Set loading state to false
      });

      if (response.statusCode == 200) {
        final token = parseTokenFromResponse(response.body);

        if (token != null) {
          final decodeBody = json.decode(response.body);
          await CasheHelper.setData(key: Constants.kToken, value: token);
          /*
                 !this lines for storage Info User for waterMark
          String userName = decodeBody['data']['data']['user'].toString();
          String userId = decodeBody['data']['data']['id'].toString();
          String userPhone = decodeBody['data']['data']['phone'].toString();
          await CasheHelper.setData(key: Constants.kUserName, value: userName);
          await CasheHelper.setData(key: Constants.kUserId, value: userId);
          await CasheHelper.setData(
              key: Constants.kUserPhone, value: userPhone);
          */
        }
        return true;
      } else {
        final messageApi = jsonDecode(response.body);
        setState(() {
          if (messageApi['data'] == "User Not Found") {
            ErrorDialog.show(context, "User Not Found");
          } else if (messageApi['data'] ==
              "this account is opened on other device") {
            ErrorDialog.show(context, "this account is opened on other device");
          } else {
            ErrorDialog.show(context, "Invalid Phone");
          }
        });

        return false;
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Set loading state to false in case of an error
      });

      ErrorDialog.show(context, "An error occurred. Please try again.");
      return false;
    }
  }

  String parseTokenFromResponse(String responseBody) {
    // Parse the JSON response and extract the token
    final parsedJson = json.decode(responseBody);
    String token = '';
    if (parsedJson != null) {
      token = parsedJson['data']['token'];
    }

    return token;
  }

  // Future<Map<String, dynamic>> postt({
  //   required String endPoint,
  //   required var data,
  //   bool isLogin = false,
  // }) async {
  //   dio.options.headers['Content-Type'] = "application/json";
  //
  //   dynamic response = await dio
  //       .post('https://timeengcom.com/Al-amin/users/login', data: data);
  //
  //
  //   // print(
  //   //     ' ${response.data} ----------------------------------------\n ---------------------------------------');
  //   Map<String, dynamic> l = {};
  //   return l;
  //
  //   // return {'sdf':'sdf'};
  // }
  //
  // Future<bool> postLoginDio({required Map<String, dynamic> data}) async {
  //   setState(() {
  //     _isLoading = true; // Set loading state to true
  //   });
  //   try {
  //
  //     var response = await postt(
  //       endPoint: 'users/login',
  //       data: data,
  //     );
  //
  //
  //
  //     String token = response['data']['token'];
  //     await CasheHelper.setData(key: Constants.kToken, value: token);
  //     setState(() {
  //       _isLoading = false; // Set loading state to false
  //     });
  //     return true;
  //   } catch (e) {
  //     if (e is DioException) {
  //       final messageApi = jsonDecode(e.response!.data);
  //       setState(() {
  //         if (messageApi['data'] == "User Not Found") {
  //           ErrorDialog.show(context, "User Not Found");
  //         } else if (messageApi['data'] ==
  //             "this account is opened on other device") {
  //           ErrorDialog.show(context, "this account is opened on other device");
  //         } else {
  //           ErrorDialog.show(context, "Invalid Phone");
  //         }
  //
  //       });
  //
  //
  //       return false;
  //     }
  //
  //     ErrorDialog.show(context, "An error occurred. Please try again.");
  //
  //     setState(() {
  //       _isLoading = false; // Set loading state to false in case of an error
  //     });
  //
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.kFifthColor,
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: CustomFaield(
                    isPasswordVisible: _isPasswordVisible,
                    hintText: 'username',
                    isPassword: false,
                    controller: _fullNameController,
                    prefixIcon: Icons.person,
                    inputFormatters: usernameInputFormatters,
                    keyboardType: keyboardTypeusername,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: CustomFaield(
                    isPasswordVisible: _isPasswordVisible,
                    hintText: 'phone',
                    isPassword: false,
                    controller: _phoneController,
                    prefixIcon: Icons.phone,
                    inputFormatters: phoneInputFormatters,
                    keyboardType: keyboardTypephone,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: _isLoading
                        ? const Center(
                            child: CustomLoadingIndicator(
                            color: Colors.grey,
                          ))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.kFifthColor),
                            onPressed: () async {
                              if (_phoneController.text.isEmpty ||
                                  _fullNameController.text.isEmpty) {
                                ErrorDialog.show(
                                    context, "You must write ever thing");
                              } else {
                                //
                                // var deviceImei =  DeviceImei() ;
                                // String? imei =  await deviceImei.getDeviceImei() ;
                                //
                                // final storageStatus =

                                // final appDocDir =
                                //     Directory('storage/emulated/0/mama');
                                // if (await appDocDir.exists()) {
                                //
                                // } else {
                                //   await appDocDir.create();
                                //
                                // }

                                _login();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              width: size.width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              padding: const EdgeInsets.all(0),
                              child: const Text(
                                "LOGIN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreenA()))
                    },
                    child: TextButton(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't Have an Account? ",
                              style: Styles.textStyle16.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: "Sign up",
                              style: Styles.textStyle16.copyWith(
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreenA()));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomFaield extends StatelessWidget {
  const CustomFaield({
    super.key,
    required bool isPasswordVisible,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    required this.prefixIcon,
    required List<TextInputFormatter>? inputFormatters,
    required this.keyboardType,
    bool isread = false,
  })  : _isPasswordVisible = isPasswordVisible,
        _inputFormatters = inputFormatters,
        _isread = isread;

  final bool _isPasswordVisible;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final IconData prefixIcon;
  final List<TextInputFormatter>? _inputFormatters;
  final TextInputType? keyboardType;
  final bool _isread;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      readOnly: _isread,
      inputFormatters: _inputFormatters,
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: Styles.textStyle14,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(
            color: AppColor.kFifthColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(width: 0, color: Colors.black12),
        ),
        prefixIcon: Icon(prefixIcon),
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a valid $hintText';
        }
        return null;
      },
    );
  }
}
