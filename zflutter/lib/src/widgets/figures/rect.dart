import 'package:flutter/widgets.dart';
import 'package:zflutter/zflutter.dart';
import 'dart:math' as math;

class ZRect extends ZShape {
  final double width;
  final double height;

  ZRect({
    Key? key,
    required this.width,
    required this.height,
    Color? color,
    Color? backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  })  : super(
            key: key,
            color: color,
            backfaceColor: backfaceColor,
            stroke: stroke,
            closed: true,
            fill: fill,
            front: front,
            path: performPath(width, height));

  static List<ZPathCommand> performPath(double width, double height) {
    final x = width / 2;
    final y = height / 2;
    return [
      ZMove.vector(ZVector.only(x: -x, y: -y)),
      ZLine.vector(ZVector.only(x: x, y: -y)),
      ZLine.vector(ZVector.only(x: x, y: y)),
      ZLine.vector(ZVector.only(x: -x, y: y))
    ];
  }
}

class ZRoundedRect extends ZShape {
  final double width;
  final double height;
  final double borderRadius;

  ZRoundedRect({
    Key? key,
    required this.width,
    required this.height,
    required this.borderRadius,
    Color? color,
    Color? backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  })  : super(
            key: key,
            color: color,
            backfaceColor: backfaceColor,
            stroke: stroke,
            closed: true,
            fill: fill,
            front: front,
            path: performPath(width, height, borderRadius));

  static List<ZPathCommand> performPath(
      double width, double height, double borderRadius) {
    var xA = width / 2;
    var yA = height / 2;
    var shortSide = math.min(xA, yA);
    var cornerRadius = math.min(borderRadius, shortSide);
    var xB = xA - cornerRadius;
    var yB = yA - cornerRadius;
    var path = [
      // top right corner
      ZMove.vector(ZVector.only(x: xB, y: -yA)),
      ZArc.list(
        [
          ZVector.only(x: xA, y: -yA),
          ZVector.only(x: xA, y: -yB),
        ],
        null,
      ),
    ];
    // bottom right corner
    if (yB != 0) {
      path.add(ZLine.vector(ZVector.only(x: xA, y: yB)));
    }
    path.add(ZArc.list(
      [
        ZVector.only(x: xA, y: yA),
        ZVector.only(x: xB, y: yA),
      ],
      null,
    ));

    // bottom left corner
    if (xB != 0) {
      path.add(ZLine.vector(ZVector.only(x: -xB, y: yA)));
    }
    path.add(ZArc.list(
      [
        ZVector.only(x: -xA, y: yA),
        ZVector.only(x: -xA, y: yB),
      ],
      null,
    ));

    // top left corner
    if (yB != 0) {
      path.add(ZLine.vector(ZVector.only(x: -xA, y: -yB)));
    }
    path.add(ZArc.list([
      ZVector.only(x: -xA, y: -yA),
      ZVector.only(x: -xB, y: -yA),
    ]));

    // back to top right corner
    if (xB != 0) {
      path.add(ZLine.vector(ZVector.only(x: xB, y: -yA)));
    }

    return path;
  }
}

class ZCircle extends ZShape {
  final double diameter;

  final int quarters;

  ZCircle({
    Key? key,
    required this.diameter,
    this.quarters = 4,
    Color? color,
    bool closed = false,
    Color? backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  })  : assert(quarters >= 0 && quarters <= 4),
        super(
            key: key,
            color: color,
            backfaceColor: backfaceColor,
            stroke: stroke,
            closed: closed,
            fill: fill,
            front: front,
            path: ZEllipse.performPath(diameter, diameter, quarters));
}

class ZEllipse extends ZShape {
  final double width;
  final double height;

  final int quarters;

  ZEllipse({
    Key? key,
    required this.width,
    required this.height,
    this.quarters = 4,
    Color? color,
    Color? backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  })  : assert(quarters >= 0 && quarters <= 4),
        super(
            key: key,
            color: color,
            backfaceColor: backfaceColor,
            stroke: stroke,
            closed: false,
            fill: fill,
            front: front,
            path: performPath(width, height, quarters));

  static List<ZPathCommand> performPath(
      double width, double height, int quarters) {
    var x = width / 2;
    var y = height / 2;

    var path = [
      ZLine.vector(ZVector.only(x: 0, y: -y)),
      ZArc.list(
        [
          ZVector.only(x: x, y: -y),
          ZVector.only(x: x, y: 0),
        ],
        null,
      ),
    ];

    if (quarters > 1) {
      path.add(ZArc.list(
        [
          ZVector.only(x: x, y: y),
          ZVector.only(x: 0, y: y),
        ],
        null,
      ));
    }
    if (quarters > 2) {
      path.add(ZArc.list(
        [
          ZVector.only(x: -x, y: y),
          ZVector.only(x: -x, y: 0),
        ],
        null,
      ));
    }
    if (quarters > 3) {
      path.add(ZArc.list(
        [
          ZVector.only(x: -x, y: -y),
          ZVector.only(x: 0, y: -y),
        ],
        null,
      ));
    }

    return path;
  }
}

class ZPolygon extends ZShape {
  final int sides;
  final double radius;

  ZPolygon({
    Key? key,
    required this.sides,
    required this.radius,
    Color? color,
    Color? backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  })  : assert(sides > 2),
        assert(radius > 0),
        super(
            key: key,
            color: color,
            backfaceColor: backfaceColor,
            stroke: stroke,
            closed: true,
            fill: fill,
            front: front,
            path: performPath(sides, radius));

  static List<ZPathCommand> performPath(int sides, double radius) {
    return List.generate(sides, (index) {
      final double theta = index / sides * tau - tau / 4;
      final double x = math.cos(theta) * radius;
      final double y = math.sin(theta) * radius;
      return ZLine.vector(ZVector.only(x: x, y: y));
    });
  }
}
