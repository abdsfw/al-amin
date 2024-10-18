import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/features/home/presentation/views/home_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_Loading_indicator.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_no_data_widget.dart';
import '../data/amdin_api.dart';
import '../data/amdin_model.dart';
import 'all_manger_screen.dart';
import 'inbox_home_page.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.adminname,
    required this.press,
  }) : super(key: key);

  final String adminname;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 12.5, vertical: 12.5 * 0.75),
        child: Row(
          children: [
            const Stack(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.kPrimaryColor,
                  radius: 26,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adminname,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Teacher>>(
      future: TeacherApi.fetchAllTeachersHasMessage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CustomLoadingIndicator(
            color: AppColor.kPrimaryColor,
          )); // Show a loading indicator while fetching data
        } else if (snapshot.hasError) {
          return const CustomErrorWidget(
            errMessage: "Try agin",
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text(
            "No message from any teacher tapon + to start",
            style: Styles.textStyle18,
          ));
        } else {
          final teachers = snapshot.data!;
          return ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              return ChatCard(
                adminname:
                    teachers[index].name, // Assuming you have a Chat model
                press: () {
                  // Navigate to the ChatScreen with the selected teacher's name
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          selectedTeacher: teachers[index].id,
                          nameT: teachers[index].name ?? ""),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

class ChatScreens extends StatelessWidget {
  const ChatScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat with teatchers",
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
      body: Container(
        child: const Body(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.kPrimaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManagerListScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
