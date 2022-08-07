import 'package:bricks_game/logic/brick_view_logic.dart';
import 'package:flutter/material.dart';

class Brick extends StatefulWidget with BrickViewLogic {
  GlobalKey<_BrickState> globalKey;

  Brick(
      {required this.globalKey,
      required int count,
      required double x,
      required double y,
      Color color = Colors.purpleAccent})
      : super(key: globalKey) {
    colorLog = color;
    countlog = count;
    xLog = x;
    yLog = y;
  }

  @override
  State<Brick> createState() => _BrickState();
}

class _BrickState extends State<Brick> {
  bool _isHiting = false;

  boxFlash() async {
    setState(() {
      _isHiting = true;
      widget.countlog--;
    });

    await Future.delayed(const Duration(milliseconds: 100));

    setState(() {
      _isHiting = false;
      if (widget.countlog <= 0) {
        widget.xLog = 1000000;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.yLog,
      left: widget.xLog,
      child: Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        foregroundDecoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: _isHiting
                    ? Colors.white
                    : widget.colorLog ?? Colors.purpleAccent),
            color: widget.colorLog?.withOpacity(0.2) ??
                Colors.purpleAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          widget.countlog.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
