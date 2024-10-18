import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/cache/cashe_helper.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/core/widgets/custom_error_dailog.dart';
import 'package:alaminedu/features/login/log_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/utils/color_app.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import 'data/user_model.dart';

class StudentDetailsPage extends StatefulWidget {
  const StudentDetailsPage({super.key});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isRead = true;
  List<TextInputFormatter> usernameInputFormatters = [
    // FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
  ];
  List<TextInputFormatter> phoneInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
  ];
  TextInputType? keyboardTypephone = TextInputType.number;
  TextInputType? keyboardTypeusername = TextInputType.text;
  List<String> yearName = Constants.yearName;
  String? selectedYear;
  String? selectedGender;
  bool isLoading = true;
  bool iserror = false;
  Future<User?> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.kDomain}users/get'),
        headers: {
          'Authorization':
              'Bearer ${CasheHelper.getData(key: 'token')}', // Add the token to the headers
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final userData = jsonData['data'];

        if (userData != null) {
          debugPrint('userData: ${userData}');

          return User.fromJson(userData);
        }
      } else {
        setState(() {
          iserror = true;
        });
      }
    } catch (e) {
      debugPrint('fetchStudentInfoError: ${e}');

      iserror = true;
    }

    return null; // Return null if there's an error or no data
  }

  Future<void> _loadUserData() async {
    final user = await fetchUserData();

    if (user != null) {
      if (mounted) {
        setState(() {
          // _fullNameController.text = user.name;
          _usernameController.text = user.username;
          _passwordController.text = user.phone;
          selectedYear = user.year;
          selectedGender = user.gender;
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<User?> editUserData({
    // String? name,
    String? username,
    String? phone,
    String? year,
    String? gender,
  }) async {
    try {
      final Map<String, dynamic> userData = {
        // "name": name,
        "user": username,
        "phone": phone,
        "year": year,
        "gender": gender,
      };
      setState(() {
        isLoading = true;
      });
      final response = await http.put(
        Uri.parse('${Constants.kDomain}users/edit'),
        headers: {
          'Authorization': 'Bearer ${CasheHelper.getData(key: "token")}',
        },
        // body: jsonEncode(userData),
        body: userData,
      );

      if (response.statusCode == 200) {
        await _loadUserData();
        // final Map<String, dynamic> jsonData = json.decode(response.body);
        //
        // final updatedData = jsonData['data'];
        // // User updateUser = User( name: _fullNameController.text, username: _usernameController.text, phone: _passwordController.text, year: selectedYear!, gender: selectedGender! );
        //
        //   // return updateUser;
        // if (updatedData != null) {
        //   return User.fromJson(updatedData);
        // }
      } else {
        await _loadUserData();
        setState(() {
          isLoading = false;
        });
        if (response.statusCode == 400) {
          ErrorDialog.show(
              context, 'Please enter a valid user name or phone number');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }

    return null;
  }

  Future<void> _updateUserProfile() async {
    final updatedUser = await editUserData(
      // name: _fullNameController.text,
      username: _usernameController.text,
      phone: _passwordController.text,
      year: selectedYear,
      gender: selectedGender,
    );

    if (updatedUser != null) {
      // Handle successful profile update, e.g., show a success message.
    } else {
      // Handle the case where the update failed.
      // You may want to display an error message to the user.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "edit profile",
          style: Styles.textStyle16.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CustomLoadingIndicator(
                color: AppColor.kPrimaryColor,
              ),
            )
          : iserror
              ? const Center(child: Text("Error Try again"))
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12.5),
                    child: Column(
                      children: [
                        const Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CircleAvatar(
                                backgroundColor: AppColor.kFordColor,
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                  color: AppColor.kPrimaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              // color: Colors.pink[50],
                              color: AppColor.kFordColor,
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(15),
                          child: Form(
                              child: Column(
                            children: [
                              // CustomFaield(
                              //   isPasswordVisible: true,
                              //   hintText: "full name",
                              //   isPassword: false,
                              //   controller: _fullNameController,
                              //   prefixIcon: Icons.person_outline_rounded,
                              //   inputFormatters: usernameInputFormatters,
                              //   keyboardType: keyboardTypeusername,
                              //   isread: isRead,
                              // ),
                              // const SizedBox(
                              //   height: 15,
                              // ),
                              CustomFaield(
                                isPasswordVisible: true,
                                hintText: "username",
                                isPassword: false,
                                controller: _usernameController,
                                prefixIcon: Icons.edit,
                                inputFormatters: usernameInputFormatters,
                                keyboardType: keyboardTypeusername,
                                isread: isRead,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomFaield(
                                isPasswordVisible: true,
                                hintText: "Phone",
                                isPassword: false,
                                controller: _passwordController,
                                prefixIcon: Icons.phone,
                                inputFormatters: phoneInputFormatters,
                                keyboardType: keyboardTypephone,
                                isread: isRead,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText:
                                        "Year of Study", // Change the label to "Year of Study"
                                    labelStyle: Styles.textStyle12,
                                  ),
                                  value:
                                      selectedYear, // Initially selected value (can be null)
                                  onChanged: isRead
                                      ? null
                                      : (String? newValue) {
                                          setState(() {
                                            selectedYear =
                                                newValue; // Update the selected year when changed
                                          });
                                        },
                                  items: yearName.map<DropdownMenuItem<String>>(
                                      (String year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText:
                                        "Gender", // Change the label to "Gender"
                                    labelStyle: Styles.textStyle12,
                                  ),
                                  value:
                                      selectedGender, // Initially selected value (can be null)
                                  onChanged: isRead
                                      ? null
                                      : (String? newValue) {
                                          setState(() {
                                            selectedGender =
                                                newValue; // Update the selected gender when changed
                                          });
                                        },
                                  items: <String>['male', 'female']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: isRead
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isRead = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.kFordColor,
                                  ),
                                  child: Text(
                                    "Start edit profile",
                                    style: Styles.textStyle16.copyWith(
                                        color: AppColor.kPrimaryColor,
                                        fontWeight: FontWeight.bold),
                                  ))
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_passwordController.text.isEmpty ||
                                            _usernameController.text.isEmpty
                                        // ||
                                        // _fullNameController.text.isEmpty
                                        ) {
                                      ErrorDialog.show(context,
                                          'Please don\'t leave the fields blank');
                                    } else if ((!_passwordController.text
                                            .startsWith('09')) ||
                                        _passwordController.text.length != 10) {
                                      ErrorDialog.show(context,
                                          "Invalid phone number the phone number must start with 09 and It must be 10 numbers ");
                                    } else {
                                      print("sdfsdf");
                                      setState(() {
                                        isRead = true;
                                      });

                                      _updateUserProfile();
                                      //here call updateApi()
                                    }
                                  },
                                  child: Text(
                                    "Ok",
                                    style: Styles.textStyle16.copyWith(
                                        color: AppColor.kPrimaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
