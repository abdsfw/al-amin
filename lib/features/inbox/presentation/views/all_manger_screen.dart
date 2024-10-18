import 'package:flutter/material.dart';

import '../../../../core/utils/color_app.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/custom_Loading_indicator.dart';
import '../../../../core/widgets/custom_no_data_widget.dart';
import '../data/amdin_api.dart';
import '../data/amdin_model.dart';
import 'chat_screen.dart';
import 'inbox_home_page.dart';
// Import your ManagerApi class

class ManagerListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All teatchers',
          style: Styles.textStyle14White,
        ),
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
      body: FutureBuilder<List<Teacher>>(
        future: TeacherApi.fetchAllTeachers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CustomLoadingIndicator(
              color: AppColor.kPrimaryColor,
            ));
          } else if (snapshot.hasError) {
            return const Text('Error Try again');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              "You have not registered for any course",
              style: Styles.textStyle18,
            ));
          } else {
            final managers = snapshot.data!;
            return ListView.builder(
              itemCount: managers.length,
              itemBuilder: (context, index) {
                final manager = managers[index];
                return ChatCard(
                  adminname: manager.name,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                            selectedTeacher: manager.id,
                            nameT: manager.name ?? ""),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
