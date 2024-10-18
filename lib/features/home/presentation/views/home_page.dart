import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/cache/cashe_helper.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/features/home/presentation/manager/cubit/f_ile_cubit.dart';
import 'package:alaminedu/features/home/presentation/views/widget/home_grid_view.dart';
import 'package:alaminedu/features/home/presentation/views/widget/notification_page.dart';
import 'package:alaminedu/features/home/presentation/views/widget/student_details.dart';
import 'package:alaminedu/features/login/resgister_r.dart';
import 'package:flutter/material.dart';

import '../../../../core/notifications/notification_services.dart';
import '../../../../core/utils/service_locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    getIt<NotificationServices>().isTokenRefresh();
    getIt<NotificationServices>().getDeviceToken();
    getIt<NotificationServices>().requestNotificationPermission();
    getIt<NotificationServices>().firebaseInit(context);
    getIt<NotificationServices>().setupInteractMessage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FIleCubit homeCubit = FIleCubit.get(context);
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColor.kPrimaryColor,
        title: const Text(
          "Al Amin",
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: "Agne",
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              homeCubit.getAllNotifications();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          )
        ],
        centerTitle: false,
        // Other AppBar properties...
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Column(
          children: [
            StudentDetails(),
            Divider(),
            HomeGridView(),
          ],
        ),
      ),
    );
  }
}
