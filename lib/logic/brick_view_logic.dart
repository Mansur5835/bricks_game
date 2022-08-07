import 'dart:math';

import 'package:flutter/material.dart';

mixin BrickViewLogic {
  late double xLog;
  late double yLog;
  Color? colorLog;
  late int countlog;

  List getBoxCollision(Point size) {
    // //! left collision
    if ((size.x - xLog).abs() <= 10 && (size.y - yLog).abs() <= 50) {
      return [true, "left"];
    }

    //! top collision
    if ((size.x >= xLog - 5) &&
        (size.x <= xLog + 55) &&
        (size.y - yLog).abs() < 10) {
      return [true, "top"];
    }

    //! right collision
    if (((size.x - (xLog + 50)).abs() < 10) &&
        (size.x >= xLog) &&
        (size.y - yLog).abs() <= 50) {
      return [true, "right"];
    }

    //! bottom collision
    if ((size.x >= xLog - 5) &&
        (size.x <= xLog + 55) &&
        (size.y - (yLog + 50)).abs() < 10) {
      return [true, "bottom"];
    }

    return [false, null];
  }
}
