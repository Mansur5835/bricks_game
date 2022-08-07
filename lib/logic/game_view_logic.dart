import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/enums.dart';
import '../ui_component/back_view/brick_view.dart';

mixin GameLogic {
  late double x;
  late double y;
  late Size size;
  bool isLoad = false;
  bool bottomHit = false;
  bool topHit = false;
  bool leftHit = false;
  bool rightHit = false;
  late Point trace;
  late Point traceUpdate;
  late Point traceStap;
  List<Widget> listOfTrace = [];
  List<Brick> listOfBricks = [];
  double traceStep = 10;

  Dirc dirc = Dirc.none;

  onInit() {
    double ss = 0;
    listOfBricks = List.generate(1, (index) {
      ss += 50;
      return Brick(
        count: 10,
        x: 5 + ss,
        color: Colors.orange,
        y: 305,
        globalKey: GlobalKey(),
      );
    });

    listOfBricks.add(Brick(
      count: 29,
      x: 5 + 100,
      y: 105,
      color: Colors.green,
      globalKey: GlobalKey(),
    ));

    listOfBricks.add(Brick(
      count: 59,
      x: 5 + 200,
      y: 105,
      globalKey: GlobalKey(),
    ));

    listOfBricks.add(Brick(
      count: 41,
      x: 5 + 300,
      y: 505,
      color: Colors.blueAccent,
      globalKey: GlobalKey(),
    ));
  }

  touchEvent(DragUpdateDetails details, Function setState) async {
    double _x = details.localPosition.dx;
    double _y = details.localPosition.dy + 100;

    traceStap = Point(_x, _y);

    List<Point> _list = await getTrace(Point(x, y), Point(_x, _y), size);
    setState(() {
      listOfTrace = List.generate(_list.length, (index) {
        return Positioned(
          left: _list[index].x.toDouble(),
          top: _list[index].y.toDouble() >= size.height - 100 * 2
              ? 100000
              : _list[index].y <= 105
                  ? 100000000
                  : _list[index].y.toDouble(),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100)),
          ),
        );
      });
    });
  }

  touchEnd(Function setState) {
    int road = traceStap.x >= size.width / 2 ? -1 : 1;

    if (road > 0) {
      dirc = Dirc.xPyP;
    } else {
      dirc = Dirc.xPyM;
    }

    traceStap = Point((size.width / 2 - traceStap.x).abs() / 20,
        (size.height - traceStap.y - 205).abs() / 20);
    listOfTrace.clear();

    _moveBox(traceStap, setState);
  }

  _moveBox(Point point, Function setState) async {
    listOfTrace.clear();
    Timer.periodic(const Duration(milliseconds: 25), (timer) {
      setState(() {
        switch (dirc) {
          case Dirc.xPyP:
            x += point.x;
            y += point.y;
            break;
          case Dirc.xMyP:
            x -= point.x;
            y += point.y;
            break;
          case Dirc.xMyM:
            x -= point.x;
            y -= point.y;
            break;
          case Dirc.xPyM:
            x += point.x;
            y -= point.y;
            break;
          case Dirc.none:
            // TODO: Handle this case.
            break;
        }

        _control();
      });
    });
  }

  _control() async {
    Point currentPoint = Point(x, y);

    _collisionControl(currentPoint);

    if (y >= size.height - 100 * 2) {
      _hitingBorder("bottom");
      if (dirc == Dirc.xPyP) {
        dirc = Dirc.xPyM;
      } else {
        dirc = Dirc.xMyM;
      }
    } else if (x <= 5) {
      _hitingBorder("left");
      if (dirc == Dirc.xMyM) {
        dirc = Dirc.xPyM;
      } else {
        dirc = Dirc.xPyP;
      }
    } else if (x >= size.width - 25) {
      _hitingBorder("right");
      if (dirc == Dirc.xPyP) {
        dirc = Dirc.xMyP;
      } else {
        dirc = Dirc.xMyM;
      }
    } else if (y <= 110) {
      _hitingBorder("top");
      if (dirc == Dirc.xPyM) {
        dirc = Dirc.xPyP;
      } else {
        dirc = Dirc.xMyP;
      }
    }
  }

  _collisionControl(Point currentPoint) {
    for (int i = 0; i < listOfBricks.length; i++) {
      if (listOfBricks[i].getBoxCollision(currentPoint).first) {
        listOfBricks[i].globalKey.currentState!.boxFlash();
        switch (listOfBricks[i].getBoxCollision(currentPoint).last) {
          case "left":
            {
              if (dirc == Dirc.xPyP) {
                dirc = Dirc.xMyP;
              } else {
                dirc = Dirc.xMyM;
              }
              break;
            }
          case 'top':
            {
              if (dirc == Dirc.xPyP) {
                dirc = Dirc.xPyM;
              } else {
                dirc = Dirc.xMyM;
              }
              break;
            }
          case "right":
            {
              if (dirc == Dirc.xMyM) {
                dirc = Dirc.xPyM;
              } else {
                dirc = Dirc.xPyP;
              }
              break;
            }
          case "bottom":
            {
              if (dirc == Dirc.xPyM) {
                dirc = Dirc.xPyP;
              } else {
                dirc = Dirc.xMyP;
              }
              break;
            }
        }
      }
    }
  }

  _hitingBorder(String dirc) async {
    switch (dirc) {
      case "top":
        topHit = true;
        await _deley();
        topHit = false;
        break;
      case "bottom":
        bottomHit = true;
        await _deley();
        bottomHit = false;
        break;
      case "right":
        rightHit = true;
        await _deley();
        rightHit = false;
        break;
      case "left":
        leftHit = true;
        await _deley();
        leftHit = false;
        break;
    }
  }

  _deley() async {
    await Future.delayed(Duration(milliseconds: 100));
  }

  Point getConstPoint(Point point1, Point point2) {
    Point _constPoint;

    if (point1.x - point2.x == 0) {
      return const Point(0, 0);
    }

    double a = (point1.y - point2.y) / (point1.x - point2.x);

    double b = point1.y - a * point1.x;

    _constPoint = Point(a, b);
    return _constPoint;
  }

  double getYCordinot(double x, Point consts) {
    if (consts.x == 0 && consts.y == 0) {
      return x;
    }
    return consts.x * x + consts.y;
  }

  Future<List<Point>> getTrace(Point point1, Point point2, Size size) async {
    List<Point> _list = [];

    Point _consts = getConstPoint(point1, point2);

    bool chack = _consts.x < 0;

    int add = chack ? -1 : 1;

    double length = sqrt((pow(point1.x - (chack ? size.width - 20 : 5), 2) -
            pow(
                point1.y -
                    getYCordinot(
                        ((chack ? size.width - 20 : 0)).toDouble(), _consts),
                2))
        .abs());

    for (int i = 0; i < length * 2; i = i + 10) {
      _list.add(Point(
          (chack ? size.width - 20 : 5) + add * i,
          getYCordinot(
              ((chack ? size.width - 20 : 5) + add * i).toDouble(), _consts)));
    }

    num yy = 09;

    for (int i = 0; i < _list.length; i++) {
      if (!chack) {
        if (_list[i].x < 10) {
          yy = _list[i].y;

          break;
        }
      } else {
        if (_list[i].x > size.width - 30) {
          yy = _list[i].y;

          break;
        }
      }
    }

    double y0 = yy.toDouble();
    double x0 = size.width / 2;

    Point _newConsts = Point(-(x0 / y0) * (chack ? 2.2 : 2.8), y0);

    double sss = 0;
    for (int i = 0; i < 15; i++) {
      sss += 15;

      if (!chack) {
        _list.add(Point(0 + sss, getYCordinot(0 + sss, _newConsts)));
      } else {
        _list.add(Point(size.width - sss, getYCordinot(0 + sss, _newConsts)));
      }
    }

    return _list;
  }
}
