import 'package:bricks_game/logic/game_view_logic.dart';
import 'package:bricks_game/screens/game_view.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyGame());
}

class MyGame extends StatelessWidget {
  MyGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BrickGameView(),
    );
  }
}
