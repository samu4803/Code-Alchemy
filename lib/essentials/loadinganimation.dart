import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({
    super.key,
    this.size = 115,
  });
  final double size;
  @override
  Widget build(BuildContext context) {
    return SpinKitSpinningLines(
      color: Colors.blueAccent,
      size: size,
      lineWidth: 3,
    );
  }
}
