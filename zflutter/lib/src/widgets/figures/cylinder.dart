import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

class ZCylinder extends StatelessWidget {
  final double diameter;
  final double length;

  final double stroke;
  final bool fill;

  final Color color;
  final bool visible;

  final Color? backface;
  final Color? frontface;

  ZCylinder({
    this.diameter = 1,
    this.length = 1,
    this.stroke = 1,
    this.fill = true,
    required this.color,
    this.visible = true,
    this.backface,
    this.frontface,
  });

  @override
  Widget build(BuildContext context) {
    final baseZ = length / 2;
    final baseColor = backface != null ? backface : null;
    final frontBase = ZPositioned(
      translate: ZVector.only(z: baseZ),
      rotate: ZVector.only(y: (tau / 2)),
      child: ZCircle(
        diameter: diameter,
        color: color,
        stroke: stroke,
        fill: fill,
        backfaceColor: frontface != null ? frontface : baseColor,
      ),
    );

    final backBase = ZPositioned(
      translate: ZVector.only(z: -baseZ),
      rotate: ZVector.only(y: 0),
      child: ZCircle(
        diameter: diameter,
        color: color,
        stroke: stroke,
        fill: fill,
        backfaceColor: baseColor,
      ),
    );

    return ZGroup(
      children: [
        frontBase,
        backBase,
        _ZCylinderMiddle(
          color: color,
          diameter: diameter,
          stroke: stroke,
          path: [
            ZMove.vector(ZVector.only(z: baseZ)),
            ZLine.vector(
              ZVector.only(z: -baseZ),
            )
          ],
        )
      ],
    );
  }
}

class _ZCylinderMiddle extends ZShapeBuilder {
  final double diameter;

  final List<ZPathCommand> path;

  _ZCylinderMiddle(
      {required this.diameter,
      required this.path,
      double stroke = 1,
      required Color color})
      : super(stroke: stroke, color: color);

  @override
  RenderZCylinder createRenderObject(BuildContext context) {
    return RenderZCylinder(
      pathBuilder: buildPath(),
      stroke: stroke,
      diameter: diameter,
      color: color,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderZCylinder renderObject) {
    renderObject.diameter = diameter;
    renderObject.stroke = stroke;
    renderObject.pathBuilder = buildPath();
    renderObject.color = color;
  }

  @override
  PathBuilder buildPath() {
    return SimplePathBuilder(path);
  }
}

class RenderZCylinder extends RenderZShape {
  double _diameter;

  double get diameter => _diameter;

  set diameter(double value) {
    if (_diameter == value) return;
    _diameter = value;

    markNeedsLayout();
  }

  RenderZCylinder({
    required PathBuilder pathBuilder,
    required double diameter,
    required double stroke,
    required Color color,
  })  : _diameter = diameter,
        super(pathBuilder: pathBuilder, stroke: stroke, color: color);

  @override
  void render(ZRenderer renderer) {
    var scale = normalVector!.magnitude();
    var strokeWidth = diameter * scale + stroke;

    renderer.setLineCap(StrokeCap.butt);
    renderer.renderPath(transformedPath);
    renderer.stroke(color, strokeWidth);
    renderer.setLineCap(StrokeCap.round);
    super.render(renderer);
  }
}
