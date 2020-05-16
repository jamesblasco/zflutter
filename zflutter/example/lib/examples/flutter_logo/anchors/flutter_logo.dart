import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';



class FlutterAnchor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZPositioned(
        scale: ZVector.all(3),
        child: ZGroup(children: [
          ZLineTop(
            bottomLeft: ZVector.only(x: 0, y: -3.81),
            bottomRight: ZVector.only(x: 3.81, y: 0),
            topRight: ZVector.only(x: 20, y: -16.8),
            topLeft: ZVector.only(x: 12.37, y: -16.8),
            z: -5,
            front: Colors.blue[400],
            side: Colors.blue[500],
            inside: Colors.blue[600],
          ),
          ZPositioned(translate: ZVector.only(x: 5.7, y: 6.2),
            child:
            ZGroup(children: [
              MiddleZLine(
                bottomLeft: ZVector.only(x: 3.9, y: -7.8),
                bottomRight: ZVector.only(x: 7.6, y: -4),
                topRight: ZVector.only(x: 14.27, y: -10.5),
                topLeft: ZVector.only(x: 6.65, y: -10.5),
                z: -5,
                front: Colors.blue[400],
                side: Colors.blue[500],
                inside: Colors.blue[600],
              ),
            ]),),
          ZPositioned(translate: ZVector.only(x: 5.7, y: -1.5),
            child:
            ZGroup(children: [

              BottomZLine(
                bottomLeft: ZVector.only(x: 5.9, y: 9.8),
                bottomRight: ZVector.only(x: 13.57, y: 9.8),
                topRight: ZVector.only(x: 3.8, y: 0),
                topLeft: ZVector.only(x: 0, y: 3.8),
                middleRight: ZVector.only(x: 7.6, y: 3.8),
                z: -5,
                back: Colors.blue[400],
                front: Colors.blue[900],
                side: Colors.blue[900],
                inside: Colors.blue[600],
              ),
            ]),),
        ],
        ));
  }
}

class ZLineTop extends StatelessWidget {
  final ZVector translate;
  final ZVector bottomLeft;
  final ZVector bottomRight;
  final ZVector topRight;
  final ZVector topLeft;
  final double z;
  final Color front;
  final Color inside;
  final Color side;

  ZLineTop({this.translate,
    this.bottomLeft,
    this.bottomRight,
    this.topRight,
    this.topLeft,
    this.z,
    this.front,
    this.inside,
    this.side});

  @override
  Widget build(BuildContext context) {
    final stroke = 0.0;
    final height = 4.0;

    final frontZShape = ZShape(path: [
      ZMove.vector(bottomLeft),
      ZLine.vector(bottomRight),
      ZLine.vector(topRight),
      ZLine.vector(topLeft),
    ], color: front, fill: true, stroke: 2);

    final topZShape = ZGroup(sortMode: SortMode.update, children: [
      ZPositioned(
        translate: ZVector.only(z: -stroke),
        child: ZShape(
          path: [
            ZMove.vector(topRight),
            ZLine.vector(topLeft),
            ZLine.vector(topLeft.copyWith(z: -height)),
            ZLine.vector(topRight.copyWith(z: -height)),
          ],

          front: (topRight - topLeft).cross(ZVector.only(z: height)),
          fill: true,
          stroke: 2,
          color: side,
          backfaceColor: inside,
        ),),
      ZPositioned(
        translate: ZVector.only(y: -10),
        child: ZShape(
          path: [
            ZMove.vector(topRight),
            ZLine.vector(topLeft),
            ZLine.vector(topLeft.copyWith(z: -height)),
            ZLine.vector(topRight.copyWith(z: -height)),
          ],
          visible: false,

          front: (topRight - topLeft).cross(ZVector.only(z: height)),
          fill: true,
          stroke: 2,
          color: side,
          backfaceColor: inside,
        ),)
    ]);

    final leftZShape = ZPositioned(
      translate: ZVector.only(z: -stroke),
      child: ZShape(
      path: [
        ZMove.vector(bottomLeft),
        ZLine.vector(topLeft),
        ZLine.vector(topLeft.copyWith(z: -height)),
        ZLine.vector(bottomLeft.copyWith(z: -height)),
      ],

      front: (bottomLeft - topLeft).cross(ZVector.only(z: -height)),
      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
    ),);

    final bottomZShape = ZPositioned(
        translate: ZVector.only(z: -stroke),
        child: ZShape(
      path: [
        ZMove.vector(bottomRight),
        ZLine.vector(bottomLeft),
        ZLine.vector(bottomLeft.copyWith(z: -height)),
        ZLine.vector(bottomRight.copyWith(z: -height)),
      ],
      front: (bottomLeft - bottomRight).cross(ZVector.only(z: height)),

      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
      //rotate: ZVector.only(x: -tau / 4),
    ),);
    final rightZShape = ZPositioned(
      translate: ZVector.only(z: -stroke),
      child: ZShape(
      path: [
        ZMove.vector(bottomRight),
        ZLine.vector(topRight),
        ZLine.vector(topRight.copyWith(z: -height)),
        ZLine.vector(bottomRight.copyWith(z: -height)),
      ],
      front: (bottomRight - topRight).cross(ZVector.only(z: height)).unit(),
      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
    ),);
    return ZGroup(
      children: [
        frontZShape,
        rightZShape,
        leftZShape,
        topZShape,
        bottomZShape,
      ],
    );
  }
}

class MiddleZLine extends StatelessWidget {
  final ZVector translate;
  final ZVector bottomLeft;
  final ZVector bottomRight;
  final ZVector topRight;
  final ZVector topLeft;
  final double z;
  final Color front;
  final Color inside;
  final Color side;

  MiddleZLine({this.translate,
    this.bottomLeft,
    this.bottomRight,
    this.topRight,
    this.topLeft,
    this.z,
    this.front,
    this.inside,
    this.side});

  @override
  Widget build(BuildContext context) {
    final stroke = 0.0;
    final height = 4.0;

    final frontZShape = ZShape(path: [
      ZMove.vector(bottomLeft),
      ZLine.vector(bottomRight),
      ZLine.vector(topRight),
      ZLine.vector(topLeft),
    ], color: front, fill: true, stroke: 2);

    final topZShape = ZPositioned(
      translate: ZVector.only(z: -stroke),
      child: ZShape(
      path: [
        ZMove.vector(topRight),
        ZLine.vector(topLeft),
        ZLine.vector(topLeft.copyWith(z: -height)),
        ZLine.vector(topRight.copyWith(z: -height)),
      ],

      front: (topRight - topLeft).cross(ZVector.only(z: height)),
      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
    ),);

    final leftZShape = ZPositioned(
      translate: ZVector.only(z: -stroke),
      child: ZShape(
      path: [
        ZMove.vector(bottomLeft),
        ZLine.vector(topLeft),
        ZLine.vector(topLeft.copyWith(z: -height)),
        ZLine.vector(bottomLeft.copyWith(z: -height)),
      ],

      front: (bottomLeft - topLeft).cross(ZVector.only(z: -height)),
      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
    ),);


    final bottomZShape =ZPositioned(
      translate: ZVector.only(z: -stroke),
      child:  ZShape(
      path: [
        ZMove.vector(bottomRight),
        ZLine.vector(bottomLeft),
        ZLine.vector(bottomLeft.copyWith(z: -height)),
        ZLine.vector(bottomRight.copyWith(z: -height)),
      ],
      front: (bottomLeft - bottomRight).cross(ZVector.only(z: height)),

      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
      //rotate: ZVector.only(x: -tau / 4),
    ),);

    final rightZShape = ZPositioned(
      translate: ZVector.only(z: -stroke),
      child: ZShape(
      path: [
        ZMove.vector(bottomRight),
        ZLine.vector(topRight),
        ZLine.vector(topRight.copyWith(z: -height)),
        ZLine.vector(bottomRight.copyWith(z: -height)),
      ],
      front: (bottomRight - topRight).cross(ZVector.only(z: height)).unit(),

      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
    ),);
    return ZGroup(
      children: [
        frontZShape,
        rightZShape,
        leftZShape,
        topZShape,
        //  bottomZShape,
      ],
    );
  }
}

class BottomZLine extends StatelessWidget {
  final ZVector translate;
  final ZVector bottomLeft;
  final ZVector bottomRight;
  final ZVector topRight;
  final ZVector topLeft;
  final double z;
  final Color front;
  final Color inside;
  final Color side;
  final Color back;
  final ZVector middleRight;

  BottomZLine({this.translate,
    this.middleRight,
    this.back,
    this.bottomLeft,
    this.bottomRight,
    this.topRight,
    this.topLeft,
    this.z,
    this.front,
    this.inside,
    this.side});

  @override
  Widget build(BuildContext context) {
    final stroke = 0.0;
    final height = 4.0;

    final frontZShape = ZShape(path: [
      ZMove.vector(bottomLeft),
      ZLine.vector(bottomRight),
      ZLine.vector(topRight),
      ZLine.vector(topLeft),
    ],
        color: front,
        backfaceColor: back,
        fill: true,
        stroke: 2);

    final topZShape = ZPositioned(
      translate: ZVector.only(z: -stroke),
      child: ZShape(
      path: [
        ZMove.vector(topRight),
        ZLine.vector(topLeft),
        ZLine.vector(topLeft.copyWith(z: -height)),
        ZLine.vector(topRight.copyWith(z: -height)),
      ],

      front: (topRight - topLeft).cross(ZVector.only(z: height)),
      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
    ),
    );

    final leftZShape = ZPositioned(
    translate: ZVector.only(z: -stroke),
      child: ZShape(
      path: [
        ZMove.vector(bottomLeft),
        ZLine.vector(topLeft),
        ZLine.vector(topLeft.copyWith(z: -height)),
        ZLine.vector(bottomLeft.copyWith(z: -height)),
      ],

      front: (bottomLeft - topLeft).cross(ZVector.only(z: -height)),
      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
    ),);

    final bottomZShape = ZPositioned(
        translate: ZVector.only(z: -stroke),
        child: ZShape(
      path: [
        ZMove.vector(bottomRight),
        ZLine.vector(bottomLeft),
        ZLine.vector(bottomLeft.copyWith(z: -height)),
        ZLine.vector(bottomRight.copyWith(z: -height)),
      ],
      front: (bottomLeft - bottomRight).cross(ZVector.only(z: height)),

      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
      //rotate: ZVector.only(x: -tau / 4),
        ),
    );
    final rightZShape = ZPositioned(
      translate: ZVector.only(z: -stroke),
      child: ZShape(
      path: [
        ZMove.vector(bottomRight),
        ZLine.vector(middleRight),
        ZLine.vector(middleRight.copyWith(z: -height)),
        ZLine.vector(bottomRight.copyWith(z: -height)),
      ],
      front: (bottomRight - middleRight).cross(ZVector.only(z: height)).unit(),

      fill: true,
      stroke: 2,
      color: side,
      backfaceColor: inside,
    ),);

    final middleZShape = ZPositioned(
      translate: ZVector.only(z: -stroke - height * 0.1),
      child:  ZShape(
      path: [
        ZMove.vector(middleRight),
        ZLine.vector(topLeft),
        ZLine.vector(topLeft.copyWith(z: -height * 0.9)),
        ZLine.vector(middleRight.copyWith(z: -height * 0.9)),
      ],
      front: (topLeft - middleRight).cross(ZVector.only(z: height)).unit(),
      fill: true,
      stroke: 2,
      color: inside,
      backfaceColor: inside,
    ),);
    return ZGroup(
      children: [
        frontZShape,
        rightZShape,
        leftZShape,
        topZShape,
        //middleZShape,
        bottomZShape,
      ],
    );
  }
}

