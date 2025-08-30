import 'package:flutter/material.dart';

class BackgroundDecoration extends StatelessWidget {
  const BackgroundDecoration({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Theme.of(context).colorScheme.tertiary,
        height: double.maxFinite,
        width: double.maxFinite,
      ),
      Image.asset(
        "assets/testBackground.png",
        height: double.infinity,
        fit: BoxFit.fitHeight,
      ),
      child,
    ]);
  }
}
