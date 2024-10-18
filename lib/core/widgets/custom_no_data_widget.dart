import 'package:flutter/material.dart';

class CustomNoDataWidget extends StatelessWidget {
  const CustomNoDataWidget({
    super.key,
    this.color = Colors.white,
    this.size = 50,
  });

  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Image(
        image: AssetImage(
          'assets/image/noData.png',
        ),
        // height: 0,
      ),
    );
  }
}
