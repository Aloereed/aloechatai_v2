import 'package:flutter/material.dart';

Widget getLimitedWidthWidget({
  required double width,
  required Widget child,
}) {
  return Container(
    decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.lightGreen.shade100,
            Colors.lightGreen.shade400,
          ],
        )),
    child: Center(
      child: ClipRect(
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    ),
  );
}