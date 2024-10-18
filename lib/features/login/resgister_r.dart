import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/features/login/background.dart';
import 'package:alaminedu/features/login/resgister.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/color_app.dart';
import 'log_in_page.dart';

class RegisterScreenA extends StatefulWidget {
  @override
  State<RegisterScreenA> createState() => _RegisterScreenAState();
}

class _RegisterScreenAState extends State<RegisterScreenA> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool obscurePassword = true;
  final RegExp alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
  String? hintMessage;
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
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "REGISTER",
                    style: Styles.textStyle35.copyWith(color: Colors.black26),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    inputFormatters: [
                      // FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                    ],
                    controller: userNameController,
                    decoration: const InputDecoration(
                        labelText: "Username", labelStyle: Styles.textStyle12),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: phoneController,
                    decoration: const InputDecoration(
                        labelText: "Mobile Number",
                        labelStyle: Styles.textStyle12),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9@$^&]+')),
                    ],
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: Styles.textStyle12,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        child: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color:
                              Colors.grey, // You can set the color of the icon
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.kFifthColor),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreenB(
                                    username: userNameController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  )));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.5,
                        padding: const EdgeInsets.all(0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreenB(
                                          username: userNameController.text,
                                          password: passwordController.text,
                                          phone: phoneController.text,
                                        )));
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                    phoneFromSingin: "",
                                    userNameFromSingin: "",
                                  )))
                    },
                    child: Text("Already Have an Account? Sign in",
                        style: Styles.textStyle16.copyWith(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
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
