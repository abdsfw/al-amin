import 'package:alaminedu/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.errMessage,
    this.iconColor = Colors.white,
    this.textStyle = Styles.textStyle18White,
  });
  final String errMessage;
  final Color iconColor;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: iconColor,
        ),
        Text(
          errMessage,
          style: textStyle,
          textAlign: TextAlign.center,
          maxLines: 7,
        ),
      ],
    ));
  }
}
