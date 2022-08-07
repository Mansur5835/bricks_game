import 'package:flutter/material.dart';

import '../borders/board_border.dart';

class Board extends StatelessWidget {
  bool bottomHit;
  bool topHit;
  bool leftHit;
  bool rightHit;
  Board({
    Key? key,
    this.bottomHit = false,
    this.leftHit = false,
    this.rightHit = false,
    this.topHit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        BoardBorder(
          isHiting: topHit,
          height: 5,
          widht: double.infinity,
          hitColor: Colors.purple.shade100,
          location: Location.top,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BoardBorder(
                isHiting: leftHit,
                height: double.infinity,
                widht: 5,
                hitColor: Colors.purple.shade100,
                location: Location.none,
              ),
              BoardBorder(
                isHiting: rightHit,
                height: double.infinity,
                widht: 5,
                hitColor: Colors.purple.shade100,
                location: Location.none,
              ),
            ],
          ),
        ),
        BoardBorder(
          isHiting: bottomHit,
          height: 5,
          widht: double.infinity,
          hitColor: Colors.purple.shade100,
          location: Location.bottom,
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
