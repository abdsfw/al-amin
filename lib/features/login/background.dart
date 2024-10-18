import 'package:alaminedu/constants.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(Constants.ktop1, width: size.width),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(Constants.kbottom1, width: size.width),
          ),
          child
        ],
      ),
    );
  }
}
