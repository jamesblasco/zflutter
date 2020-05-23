import 'package:flutter/widgets.dart';
import 'package:zflutter/zflutter.dart';
import 'dart:math' as math;

class ZRect extends ZShape {
  final double width;
  final double height;

  ZRect({
    Key key,
    @required this.width,
    @required this.height,
    Color color,
    Color backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  })  : assert(width != null && height != null),
        super(
            key: key,
            color: color,
            backfaceColor: backfaceColor,
            stroke: stroke,
            closed: true,
            fill: fill,
            front: front,
            path: performPath(width, height));

  static ZPath performPath(double width, double height) {
    final x = width / 2;
    final y = height / 2;
    return ZPath()
        .move(x: -x, y: -y)
        .line(x: x, y: -y)
        .line(x: x, y: y)
        .line(x: -x, y: y);
  }
}

class ZRoundedRect extends ZShape {
  final double width;
  final double height;
  final double borderRadius;

  ZRoundedRect({
    Key key,
    @required this.width,
    @required this.height,
    @required this.borderRadius,
    Color color,
    Color backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  })  : assert(width != null && height != null),
        assert(borderRadius != null),
        super(
            key: key,
            color: color,
            backfaceColor: backfaceColor,
            stroke: stroke,
            closed: true,
            fill: fill,
            front: front,
            path: performPath(width, height, borderRadius));

  static ZPath performPath(double width, double height, double borderRadius) {
    final xA = width / 2;
    final yA = height / 2;
    final shortSide = math.min(xA, yA);
    final cornerRadius = math.min(borderRadius, shortSide);
    final xB = xA - cornerRadius;
    final yB = yA - cornerRadius;
    final path = [
      // top right corner
      ZMove.only(x: xB, y: -yA),
      ZArc(
        corner: ZVector.only(x: xA, y: -yA),
        end: ZVector.only(x: xA, y: -yB),
      ),

      // bottom right corner
      if (yB != 0)
        ZLine.only(x: xA, y: yB),

      ZArc(
        corner: ZVector.only(x: xA, y: yA),
        end: ZVector.only(x: xB, y: yA),
      ),

      // bottom left corner
      if (xB != 0)
        ZLine.only(x: -xB, y: yA),

      ZArc(
        corner: ZVector.only(x: -xA, y: yA),
        end: ZVector.only(x: -xA, y: yB),
      ),

      // top left corner
      if (yB != 0)
        ZLine.only(x: -xA, y: -yB),

      ZArc(
        corner: ZVector.only(x: -xA, y: -yA),
        end: ZVector.only(x: -xB, y: -yA),
      ),

      // back to top right corner
      if (xB != 0)
        ZLine.only(x: xB, y: -yA)
    ];

    return ZPath(path);
  }
}

class ZCircle extends ZShape {
  final double diameter;

  final int quarters;

  ZCircle({
    Key key,
    @required this.diameter,
    this.quarters = 4,
    Color color,
    bool closed = false,
    Color backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  })  : assert(diameter != null),
        assert(quarters != null && quarters >= 0 && quarters <= 4),
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
    Key key,
    @required this.width,
    @required this.height,
    this.quarters = 4,
    Color color,
    Color backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  })  : assert(width != null && height != null),
        assert(quarters != null && quarters >= 0 && quarters <= 4),
        super(
            key: key,
            color: color,
            backfaceColor: backfaceColor,
            stroke: stroke,
            closed: false,
            fill: fill,
            front: front,
            path: performPath(width, height, quarters));

  static ZPath performPath(double width, double height, int quarters) {
    final x = width / 2;
    final y = height / 2;

    final path = [
      ZLine.only(x: 0, y: -y),
      ZArc(
        corner: ZVector.only(x: x, y: -y),
        end: ZVector.only(x: x, y: 0),
      ),
      if (quarters > 1)
        ZArc(
          corner: ZVector.only(x: x, y: y),
          end: ZVector.only(x: 0, y: y),
        ),
      if (quarters > 2)
        ZArc(
          corner: ZVector.only(x: -x, y: y),
          end: ZVector.only(x: -x, y: 0),
        ),
      if (quarters > 3)
        ZArc(
          corner: ZVector.only(x: -x, y: -y),
          end: ZVector.only(x: 0, y: -y),
        ),
    ];

    return ZPath(path);
  }
}

class ZPolygon extends ZShape {
  final int sides;
  final double radius;

  ZPolygon({
    Key key,
    @required this.sides,
    @required this.radius,
    Color color,
    Color backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  })  : assert(sides != null && sides > 2),
        assert(radius != null && radius > 0),
        super(
            key: key,
            color: color,
            backfaceColor: backfaceColor,
            stroke: stroke,
            closed: true,
            fill: fill,
            front: front,
            path: performPath(sides, radius));

  static ZPath performPath(int sides, double radius) {
    final commands = List.generate(sides, (index) {
      final double theta = index / sides * tau - tau / 4;
      final double x = math.cos(theta) * radius;
      final double y = math.sin(theta) * radius;
      return ZLine.only(x: x, y: y);
    });
    return ZPath(commands);
  }
}
