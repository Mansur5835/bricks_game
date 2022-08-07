// ignore_for_file: must_call_super
import 'dart:math';
import 'package:bricks_game/logic/game_view_logic.dart';
import 'package:bricks_game/ui_component/back_view/board.dart';
import 'package:flutter/material.dart';
import '../constants/enums.dart';
import '../ui_component/back_view/brick_view.dart';

class BrickGameView extends StatefulWidget {
  const BrickGameView({
    Key? key,
  }) : super(key: key);

  @override
  State<BrickGameView> createState() => _BrickGameState();
}

class _BrickGameState extends State<BrickGameView> with GameLogic {
  @override
  void initState() {
    onInit();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoad) {
      size = MediaQuery.of(context).size;
      y = size.height - 100 * 2;
      x = size.width / 2;
      isLoad = true;
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blueGrey.shade900,
            Colors.black,
            Colors.black,
            Colors.black,
            Colors.black,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Stack(children: [
            GestureDetector(
              child: Board(
                bottomHit: bottomHit,
                topHit: topHit,
                leftHit: leftHit,
                rightHit: rightHit,
              ),
            ),
            ...List.generate(listOfTrace.length, (index) {
              return listOfTrace[index];
            }),
            ...List.generate(listOfBricks.length, (index) {
              return listOfBricks[index];
            }),
            Positioned(
                top: y,
                left: x,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.purpleAccent,
                            blurRadius: 2,
                            spreadRadius: 2)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 105),
              alignment: Alignment.center,
              child: GestureDetector(
                onPanEnd: (details) {
                  touchEnd(setState);
                },
                onPanUpdate: (details) async {
                  touchEvent(details, setState);
                },
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
