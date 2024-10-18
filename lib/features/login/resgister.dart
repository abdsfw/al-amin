import 'dart:convert';

import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/cache/cashe_helper.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/features/home/presentation/views/home_page.dart';
import 'package:alaminedu/features/login/background.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../core/widgets/custom_Loading_indicator.dart';
import 'data/collage_model.dart';
import 'data/login_api.dart';
import 'log_in_page.dart';

class RegisterScreenB extends StatefulWidget {
  final String username;
  final String phone;
  final String password;
  const RegisterScreenB(
      {super.key,
      required this.username,
      required this.phone,
      required this.password});

  @override
  State<RegisterScreenB> createState() => _RegisterScreenBState();
}

class _RegisterScreenBState extends State<RegisterScreenB> {
  Future<void> registerUser() async {
    setState(() {
      isLoading = true; // Set isLoading to true when the API request starts
    });
    final url = Uri.parse('${Constants.kDomain}users/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "user": widget.username,
          "phone": widget.phone,
          "year": selectedYear,
          // "mac_address": macAddress,
          "gender": selectedGender,
          "cardId": cardId.text,
          "collage": selectedCollageController.text,
        }),
      );
      if (kDebugMode) {
        // print(
        //   json.encode({
        //     "user": widget.username,
        //     "phone": widget.phone,
        //     "year": selectedYear,
        //     // "mac_address": macAddress,
        //     "gender": selectedGender,
        //     "cardId": cardId.text,
        //     "collage": selectedCollege.toString(),
        //   }),
        // );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen(
                    phoneFromSingin: widget.phone,
                    userNameFromSingin: widget.username,
                  )),
        );
      } else {
        // Handle different error scenarios

        // Check for specific error message in the response data array
        final responseData = json.decode(response.body);
        if (responseData.containsKey("data") &&
            responseData["data"] is List &&
            responseData["data"].isNotEmpty) {
          final errorData = responseData["data"][0];
          if (errorData.containsKey("message")) {
            showErrorDialog(errorData["message"]);
            return; // Stop further execution as error is displayed
          }
        }

        // For other errors or if message format is unexpected, display a generic message
        showErrorDialog("An error occurred. Please try again.");
      }
    } catch (error) {
      showErrorDialog("please try again");
    } finally {
      setState(() {
        isLoading =
            false; // Set isLoading to false when the API request is complete
      });
    }
  }

  //? ------------------------------------------------------
  /*
  ? this commit when the collage input was updated
  Future<void> fetchColleges() async {
    // String token = await CasheHelper.getData(key: Constants.kToken);
    // final headers = <String, String>{
    //   'Authorization': 'Bearer $token', // Add your token here
    //   // 'Authorization':
    //   // 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidXNlciI6ImhheWRhcmEiLCJpYXQiOjE2OTYzMzM2MzF9.XD2WqdFFKxGQjsOj8Iko4P1cbsxZH6A-yOoBRcaLLEs', // Add your token here
    // };
    try {
      final url = Uri.parse('${Constants.kDomain}users/collages/get-all');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final collegeList = data['data'] as List;
        setState(() {
          colleges =
              collegeList.map((college) => College.fromJson(college)).toList();
        });
      } else {}
    } catch (e) {}
  }
  */
  //? ------------------------------------------------------

  void showErrorDialog(String error) {
    // Show an error dialog or message to the user
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            body: Center(
              child: Text(
                error,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            title: 'Registration Failed',
            desc: 'An error occurred during registration.',
            btnOkOnPress: () {},
            btnOkColor: AppColor.kPrimaryColor)
        .show();
  }

  /*
  ? this commit when the collage input was updated
  String getCollegeNameFromId(int collegeId) {
    // Find the college in the list with a matching ID
    final selectedCollege = colleges.firstWhere(
        (college) => college.id == collegeId,
        orElse: () => College(
            id: -1,
            name:
                "Unknown College") // Return null if no matching college is found
        );

    // Check if selectedCollege is not null before accessing its name property
    if (selectedCollege != null) {
      return selectedCollege.name;
    } else {
      return "Unknown College"; // Return a default value if no match is found
    }
  }
  */
  // int? selectedCollegeId;
  String? selectedGender;
  String? selectedYear;
  TextEditingController selectedCollageController = TextEditingController();
  // String? selectedCollege;
  bool isLoading = false;

  TextEditingController cardId = TextEditingController();
  // var macAddress;
  List<String> years = Constants.yearName;
  /*
  ? this commit when the collage input was updated
  List<College> colleges = [];
  */
  @override
  void initState() {
    super.initState();
    /*
    ? this commit when the collage input was updated
    fetchColleges();
    */
    if (kDebugMode) {}
    // getmac().then((value) =>
  }

  // Future<void> getmac() async {
  //   macAddress = await ApiClass.getMacAddress();
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Background(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Gender", // Change the label to "Gender"
                    labelStyle: Styles.textStyle12,
                  ),
                  value:
                      selectedGender, // Initially selected value (can be null)
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender =
                          newValue; // Update the selected gender when changed
                    });
                  },
                  items: <String>['male', 'female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText:
                        "Year of Study", // Change the label to "Year of Study"
                    labelStyle: Styles.textStyle12,
                  ),
                  value: selectedYear, // Initially selected value (can be null)
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue;
                      // Update the selected year when changed
                    });
                  },
                  items: years.map<DropdownMenuItem<String>>((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomFaield(
                  isPasswordVisible: false,
                  hintText: 'collage',
                  isPassword: false,
                  controller: selectedCollageController,
                  prefixIcon: Icons.home_work_outlined,
                  inputFormatters: null,
                  keyboardType: TextInputType.name,
                ),
                /*
                ? this commit when the collage input was updated

                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: "College",
                    labelStyle: Styles.textStyle12,
                  ),
                  value: selectedCollegeId,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCollegeId = newValue;
                      selectedCollege = getCollegeNameFromId(newValue!);
                    });
                  },
                  items: colleges.map((college) {
                    return DropdownMenuItem<int>(
                      value: college.id, // Use college ID as the value
                      child: Text(college.name),
                    );
                  }).toList(),
                ),
                */
              ),
              SizedBox(height: size.height * 0.03),
              // Container(
              //   alignment: Alignment.center,
              //   margin: const EdgeInsets.symmetric(horizontal: 40),
              //   child: TextFormField(
              //     onTapOutside: (event) {
              //       FocusManager.instance.primaryFocus?.unfocus();
              //     },
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return "Phone number is required";
              //       }
              //       // Check if the phone number starts with "09" and has a length of 10
              //       if (!value.startsWith("09") && value.length != 10) {
              //         return "Invalid phone number";
              //       }
              //       return null; // Return null if the input is valid
              //     },
              //     keyboardType: TextInputType.number,
              //     controller: cardId,
              //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //     decoration: const InputDecoration(
              //         labelText: "cardId",
              //         labelStyle: Styles.textStyle12,
              //         suffixIcon: Icon(Icons.code)),
              //   ),
              // ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: isLoading
                    ? const Center(
                        child: CustomLoadingIndicator(
                        color: Colors.grey,
                      )) // Display loading indicator
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.kFifthColor),
                        onPressed: () async {
                          if (widget.password.isEmpty ||
                                  widget.username.isEmpty ||
                                  widget.phone.isEmpty ||
                                  selectedCollageController.text.isEmpty ||
                                  // selectedCollegeId == null ||
                                  selectedGender == null ||
                                  selectedYear == null
                              // ||
                              // cardId.text.isEmpty
                              ) {
                            print({
                              "user": widget.username,
                              "phone": widget.phone,
                              "year": selectedYear,
                              // "mac_address": macAddress,
                              "gender": selectedGender,
                              "cardId": cardId.text,
                              "collage": selectedCollageController.text,
                            });
                            showErrorDialog("please write all faields");
                          } else if ((!widget.phone.startsWith('09')) ||
                              widget.phone.length != 10) {
                            showErrorDialog(
                                "Invalid phone number the phone number must start with 09 and It must be 10 numbers ");
                          } else {
                            await registerUser();
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
                            "Resgister",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
// validator: (value) {
//       if (value == null || value.isEmpty) {
//         return "Phone number is required";
//       }
//       // Check if the phone number starts with "09" and has a length of 10
//       if (!value.startsWith("09") || value.length != 10) {
//         return "Invalid phone number";
//       }
//       return null; // Return null if the input is valid
//     },
