import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/cache/cashe_helper.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/presentation/views/home_page.dart';
import '../login/log_in_page.dart';
import '../login/resgister_r.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    navigateTo();
  }

  @override
  void dispose() {
    // Dispose the AnimationController when the widget is disposed.
    _scaleController.dispose();
    super.dispose();
  }

  navigateTo() async {
    await CasheHelper.setData(key: Constants.kIsFirstTime, value: true);
    // await CasheHelpemr.setData(
    // key: Constants.kToken,
    // value:
    // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzU0LCJ1c2VyIjoidGVzdDIiLCJpYXQiOjE3MDAzOTU2NTd9.qCLGR49PY8EfLQlw6KLdY3KtyVKt7-bAexg4s47Hxiw');

    await Future.delayed(const Duration(seconds: 5), () {});
    if (mounted) {
      _checkAuthentication();
    }
  }

  Future<bool> _retrieveStoredToken() async {
    final token = CasheHelper.getData(key: Constants.kToken);
    return token != null && token.isNotEmpty;
  }

  bool _checkedAuthentication = false;

  void _checkAuthentication() async {
    final hasToken = await _retrieveStoredToken();

    if (!_checkedAuthentication) {
      _checkedAuthentication = true;

      if (hasToken) {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
          (route) {
            return false;
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LoginScreen(phoneFromSingin: "", userNameFromSingin: ""),
          ),
          (route) {
            return false;
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Image.asset(
                      "assets/image/logo.png",
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              TypewriterAnimatedTextKit(
                onTap: () {},
                text: const ["Explore", "Learn", "Success!"],
                textStyle: const TextStyle(fontSize: 30.0, fontFamily: "Agne"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
