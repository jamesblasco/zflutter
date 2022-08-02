import 'package:flutter/cupertino.dart';
import 'package:zflutter/zflutter.dart';
import 'dart:math' as math;

class ZCone extends ZCircle {
  final double diameter;
  final double? length;

  ZCone({
    this.length,
    Key? key,
    required this.diameter,
    Color? color,
    bool closed = false,
    Color? backfaceColor,
    double stroke = 1,
    bool fill = true,
    ZVector front = const ZVector.only(z: 1),
  })  : super(
            key: key,
            color: color,
            backfaceColor: backfaceColor,
            stroke: stroke,
            closed: closed,
            fill: fill,
            front: front,
            diameter: diameter);

  @override
  RenderZCone createRenderObject(BuildContext context) {
    return RenderZCone(
        color: color,
        path: path!,
        stroke: stroke,
        close: closed,
        fill: fill,
        visible: visible,
        backfaceColor: backfaceColor,
        front: front,
        diameter: diameter,
        length: length!);
  }

  @override
  void updateRenderObject(BuildContext context, RenderZCone renderObject) {
    renderObject..color = color;
    renderObject..path = path;
    renderObject..stroke = stroke;
    renderObject..close = closed;
    renderObject..fill = fill;
    renderObject..backfaceColor = backfaceColor;
    renderObject..front = front;
    renderObject..visible = visible;
    renderObject..length = length;
    renderObject..diameter = diameter;
  }
}

class RenderZCone extends RenderZShape {
  double? _length;

  double? get length => _length;

  set length(double? value) {
    assert(value != null && value >= 0);
    if (_length == value) return;
    _length = value;
    markNeedsLayout();
  }

  double _diameter;

  double get diameter => _diameter;

  set diameter(double value) {
    assert(value >= 0);
    if (_diameter == value) return;
    _diameter = value;
    markNeedsLayout();
  }

  RenderZCone({
    required double length,
    required double diameter,
    Color? color,
    Color? backfaceColor,
    ZVector front = const ZVector.only(z: 1),
    bool close = false,
    bool visible = true,
    bool fill = false,
    double stroke = 1,
    List<ZPathCommand> path = const [],
  })  : _length = length,
        _diameter = diameter,
        super(
            color: color,
            backfaceColor: backfaceColor,
            front: front,
            close: close,
            visible: visible,
            fill: fill,
            stroke: stroke,
            path: path);

  ZVector tangentA = ZVector.zero;
  ZVector tangentB = ZVector.zero;

  ZVector? apex;

  @override
  void performLayout() {
    final ZParentData anchorParentData = parentData as ZParentData;
    matrix4.setIdentity();

    apex = ZVector.only(z: length);
    anchorParentData.transforms.reversed.forEach((matrix4) {
      apex = apex!.transform(matrix4.translate, matrix4.rotate, matrix4.scale);
    });
    super.performLayout();
  }

  @override
  void performSort() {
    final renderCentroid = ZVector.lerp(origin, apex, 1 / 3);
    sortValue = renderCentroid.z;
  }

  ZVector renderApex = ZVector.zero;

  @override
  void render(ZRenderer renderer) {
    _renderConeSurface(renderer);
    super.render(renderer);
  }

  void _renderConeSurface(ZRenderer renderer) {
    if (!visible) {
      return;
    }
    renderApex = apex! - origin;
    final scale = normalVector.magnitude();
    final apexDistance = renderApex.magnitude2d();
    final normalDistance = normalVector.magnitude2d();
    // eccentricity
    final eccenAngle = math.acos(normalDistance / scale);
    final eccen = math.sin(eccenAngle);
    final radius = diameter / 2 * scale;
    // does apex extend beyond eclipse of fac
    final isApexVisible = radius * eccen < apexDistance;
    if (!isApexVisible) {
      return;
    }

    final apexAngle = (math.atan2(normalVector.y!, normalVector.x!) + tau / 2);
    final projectLength = apexDistance / eccen;
    final projectAngle = math.acos(radius / projectLength);

    final xA = math.cos(projectAngle) * radius * eccen;
    final yA = math.sin(projectAngle) * radius;
    tangentA = tangentA.copyWith(x: xA, y: yA);
    tangentB = tangentA.multiply(ZVector.identity.copyWith(y: -1));

    tangentA = tangentA.rotateZ(apexAngle).addVector(origin);
    tangentB = tangentB.rotateZ(apexAngle).addVector(origin);

    final path = [
      ZMove.vector(tangentA),
      ZLine.vector(apex!),
      ZLine.vector(tangentB),
    ];

    renderer.renderPath(path);
    if (stroke! > 0) renderer.stroke(color!, stroke!);
    if (fill) renderer.fill(color!);
  }
}
