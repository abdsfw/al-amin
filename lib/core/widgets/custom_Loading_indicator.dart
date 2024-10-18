import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
    this.color = Colors.white,
    this.size = 50,
  });

  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFoldingCube(
        color: color,
        size: size,
      ),
    );
  }
}
