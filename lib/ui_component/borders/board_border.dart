import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

enum Location { top, left, right, bottom, none }

class BoardBorder extends StatefulWidget {
  Color? color;
  Color hitColor;
  bool isHiting;
  Location location;
  double widht;
  double height;

  BoardBorder(
      {Key? key,
      required this.widht,
      required this.height,
      this.color,
      required this.hitColor,
      this.isHiting = false,
      required this.location})
      : super(key: key);

  @override
  State<BoardBorder> createState() => _BoardBorderState();
}

class _BoardBorderState extends State<BoardBorder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widht,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.isHiting
            ? widget.hitColor
            : widget.color ?? Colors.purpleAccent,
        boxShadow: [
          BoxShadow(color: Colors.blue, blurRadius: 5, spreadRadius: 2)
        ],
        borderRadius: cantrolBorder(widget.location),
      ),
    );
  }
}

BorderRadius cantrolBorder(Location location) {
  switch (location) {
    case Location.top:
      return const BorderRadius.only(
          topLeft: Radius.circular(1000), topRight: Radius.circular(1000));
    case Location.left:
      return const BorderRadius.only(
          topLeft: Radius.circular(1000), bottomLeft: Radius.circular(1000));
    case Location.right:
      return const BorderRadius.only(
          bottomRight: Radius.circular(1000),
          bottomLeft: Radius.circular(1000));
    case Location.bottom:
      return const BorderRadius.only(
          bottomRight: Radius.circular(1000),
          bottomLeft: Radius.circular(1000));
    case Location.none:
      return BorderRadius.zero;
  }
}
