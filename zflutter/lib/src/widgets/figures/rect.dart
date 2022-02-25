import 'package:flutter/widgets.dart';
import 'package:zflutter/zflutter.dart';
import 'dart:math' as math;

class ZRect extends ZShapeBuilder {
  const ZRect({
    Key? key,
    required this.width,
    required this.height,
    required Color color,
    Color? backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  }) : super(
          key: key,
          color: color,
          backfaceColor: backfaceColor,
          stroke: stroke,
          closed: true,
          fill: fill,
          front: front,
        );

  final double width;

  final double height;

  @override
  PathBuilder buildPath() {
    return RectPathBuilder(width, height);
  }
}

class RectPathBuilder extends PathBuilder {
  final double width;

  final double height;

  RectPathBuilder(this.width, this.height);

  @override
  List<ZPathCommand> buildPath() {
    final x = width / 2;
    final y = height / 2;
    return [
      ZMove.vector(ZVector.only(x: -x, y: -y)),
      ZLine.vector(ZVector.only(x: x, y: -y)),
      ZLine.vector(ZVector.only(x: x, y: y)),
      ZLine.vector(ZVector.only(x: -x, y: y))
    ];
  }

  @override
  bool shouldRebuildPath(covariant PathBuilder oldPathBuilder) {
    return !(oldPathBuilder is RectPathBuilder) ||
        oldPathBuilder.height != height ||
        oldPathBuilder.width != width;
  }
}

class ZRoundedRect extends ZShapeBuilder {
  final double width;
  final double height;
  final double borderRadius;

  ZRoundedRect({
    Key? key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required Color color,
    Color? backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
  }) : super(
          key: key,
          color: color,
          backfaceColor: backfaceColor,
          stroke: stroke,
          closed: true,
          fill: fill,
          front: front,
        );

  @override
  PathBuilder buildPath() {
    return RoundedRectPathBuilder(width, height, borderRadius);
  }
}

class RoundedRectPathBuilder extends PathBuilder {
  final double width;

  final double height;

  final double borderRadius;

  RoundedRectPathBuilder(this.width, this.height, this.borderRadius);

  @override
  List<ZPathCommand> buildPath() {
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

  @override
  bool shouldRebuildPath(covariant PathBuilder oldPathBuilder) {
    return !(oldPathBuilder is RoundedRectPathBuilder) ||
        oldPathBuilder.height != height ||
        oldPathBuilder.width != width ||
        oldPathBuilder.borderRadius != borderRadius;
  }
}

class ZCircle extends ZShapeBuilder {
  final double diameter;

  final int quarters;

  ZCircle({
    Key? key,
    required this.diameter,
    this.quarters = 4,
    required Color color,
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
        );

  @override
  PathBuilder buildPath() {
    return EllipsePathBuilder(
      height: diameter,
      width: diameter,
      quarters: quarters,
    );
  }
}

class ZEllipse extends ZShapeBuilder {
  final double width;
  final double height;

  final int quarters;

  ZEllipse({
    Key? key,
    required this.width,
    required this.height,
    this.quarters = 4,
    required Color color,
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
        );

  @override
  PathBuilder buildPath() {
    return EllipsePathBuilder(
      height: height,
      width: width,
      quarters: quarters,
    );
  }
}

class EllipsePathBuilder extends PathBuilder {
  final double width;
  final double height;

  final int quarters;

  EllipsePathBuilder({
    required this.width,
    required this.height,
    required this.quarters,
  });

  @override
  List<ZPathCommand> buildPath() {
    var x = width / 2;
    var y = height / 2;

    var path = [
      ZLine.vector(ZVector.only(x: 0, y: -y)),
      ZArc(
        previous: ZVector.only(x: 0, y: -y),
        corner: ZVector.only(x: x, y: -y),
        end: ZVector.only(x: x, y: 0),
      ),
    ];

    if (quarters > 1) {
      path.add(
        ZArc(
          previous: ZVector.only(x: x, y: 0),
          corner: ZVector.only(x: x, y: y),
          end: ZVector.only(x: 0, y: y),
        ),
      );
    }
    if (quarters > 2) {
      path.add(
        ZArc(
          previous: ZVector.only(x: 0, y: y),
          corner: ZVector.only(x: -x, y: y),
          end: ZVector.only(x: -x, y: 0),
        ),
      );
    }
    if (quarters > 3) {
      path.add(
        ZArc(
          previous: ZVector.only(x: -x, y: 0),
          corner: ZVector.only(x: -x, y: -y),
          end: ZVector.only(x: 0, y: -y),
        ),
      );
    }

    return path;
  }

  @override
  bool shouldRebuildPath(covariant PathBuilder oldPathBuilder) {
    return !(oldPathBuilder is EllipsePathBuilder) ||
        oldPathBuilder.height != height ||
        oldPathBuilder.width != width ||
        oldPathBuilder.quarters != quarters;
  }
}

class ZPolygon extends ZShapeBuilder {
  final int sides;
  final double radius;

  ZPolygon({
    Key? key,
    required this.sides,
    required this.radius,
    required Color color,
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
        );

  @override
  PathBuilder buildPath() {
    return PolygonPathBuilder(sides: sides, radius: radius);
  }
}

class PolygonPathBuilder extends PathBuilder {
  final int sides;
  final double radius;

  PolygonPathBuilder({
    required this.sides,
    required this.radius,
  });

  @override
  List<ZPathCommand> buildPath() {
    return List.generate(sides, (index) {
      final double theta = index / sides * tau - tau / 4;
      final double x = math.cos(theta) * radius;
      final double y = math.sin(theta) * radius;
      return ZLine.vector(ZVector.only(x: x, y: y));
    });
  }

  @override
  bool shouldRebuildPath(covariant PathBuilder oldPathBuilder) {
    return !(oldPathBuilder is PolygonPathBuilder) ||
        oldPathBuilder.sides != sides ||
        oldPathBuilder.radius != radius;
  }
}
