import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/core/widgets/custom_error_widget.dart';
import 'package:alaminedu/features/home/presentation/manager/cubit/f_ile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    FIleCubit homeCubit = FIleCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Page',
          style: Styles.textStyle20White,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        // decoration: BoxDecoration(
        //   color: Colors.pink[50],
        //   borderRadius: BorderRadius.circular(
        //     16,
        //   ),
        // ),
        child: BlocConsumer<FIleCubit, FIleState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is LoadingGetNotificationsState) {
              return const CustomLoadingIndicator(
                color: AppColor.kPrimaryColor,
              );
            } else if (state is FailureGetNotificationsState) {
              return Center(
                child: CustomErrorWidget(
                  errMessage: state.errMessage,
                ),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  String date = DateFormat('yyyy-MM-dd', 'en').format(
                      homeCubit.notificationList[index].createdAt ??
                          DateTime.now());
                  String hour = homeCubit
                          .notificationList[index].createdAt?.hour
                          .toString() ??
                      '';
                  String minute = homeCubit
                          .notificationList[index].createdAt?.minute
                          .toString() ??
                      "";
                  return Card(
                    child: ListTile(
                      title: Text(
                        homeCubit.notificationList[index].title!,
                        style: Styles.textStyle20PriCol,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            homeCubit.notificationList[index].body!,
                            style: Styles.textStyle15PriCol,
                          ),
                          Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "$date     ",
                                    style: Styles.textStyle15PriCol.copyWith(
                                        color: AppColor.kPrimaryColor
                                            .withOpacity(0.3)),
                                  ),
                                ),
                                Text(
                                  hour,
                                  style: Styles.textStyle15PriCol.copyWith(
                                      color: AppColor.kPrimaryColor
                                          .withOpacity(0.3)),
                                ),
                                Text(
                                  ":$minute",
                                  style: Styles.textStyle15PriCol.copyWith(
                                      color: AppColor.kPrimaryColor
                                          .withOpacity(0.3)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      leading: const Icon(
                        Icons.notification_important_sharp,
                        color: AppColor.kPrimaryColor,
                      ),
                    ),
                  );
                },
                // ),
                itemCount: homeCubit.notificationList.length,
              );
            }
          },
        ),
      ),
    );
  }
}
