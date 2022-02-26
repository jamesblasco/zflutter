//@dart=2.12
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zflutter/zflutter.dart';

import '../core.dart';

/// A zWidget that paints a shape in a 3D space.
///
/// zWidget are special-purpose widgets that can be combined using a
/// [ZIllustration] to distribute them in a 3D space. A [ZShape]
/// is a basic zWidget that draws a shape in a 3D space
///
/// A [ZShape] widget must be a relative of a [ZIllustration], and the path from
/// the [ZShape] widget to its enclosing [ZIllustration] must contain only
/// [ZWidget], [StatelessWidget]s or [StatefulWidget]s.
///
/// The [path] param will define the shape that will be drawn. You can customize
/// the appearance of the shape with [closed], [stroke], [fill], [color] and [visible]
///
/// If a [ZShape] widget is relative to a [ZPositioned], the path will be transform
/// accordingly to provide a new path that simulates a 3D view of the shape.
///
/// It is possible to add a different color for the back face of the shape with
/// [backfaceColor]. You can redefine what is the front and back of a shape by
/// changing the [front] vector.
///
/// If no path is provided a dot will be painted with the stroke as diameter.
///
abstract class ZShapeBuilder extends SingleChildRenderObjectWidget
    with ZWidget {
  /// The color of the shape. If [stroke] is more than 0, the path will be painted
  /// with a stroke of this color. If [fill] is true, it will paint the inside of
  /// the path with this color
  final Color color;

  /// The width that will be used to paint the path
  final double stroke;

  /// True by default. It will close the path
  /// from the origin point to the end point
  final bool closed;

  /// If true the widget will paint the inside of the path.
  final bool fill;

  /// A vector that defines the front direction of the shape.
  /// The inverse sense will represent the back face of the shape
  final ZVector front;

  /// An optional parameter to define a different color for the
  /// back face of the shape
  final Color? backfaceColor;

  /// If false the shape won't be painted
  final bool visible;

  /// Position used for z-sorting
  /// If null the center of the path will be used instead
  final ZVector? sortPoint;

  const ZShapeBuilder({
    Key? key,
    required this.color,
    this.front = const ZVector.only(z: 1),
    this.backfaceColor,
    this.stroke = 1,
    this.closed = true,
    this.fill = false,
    this.visible = true,
    this.sortPoint,
  })  : assert(stroke >= 0),
        super(key: key);

  /// The path that will define the shape of the Widget
  /// It is an ordered list of path commands : [ZMove], [ZLine], [ZArc] & [ZBezier]
  /// See some prebuilt shapes as examples:  [ZRect], [ZRounderRect], [ZEllipse]
  PathBuilder buildPath();

  @override
  RenderZShape createRenderObject(BuildContext context) {
    return RenderZShape(
        color: color,
        pathBuilder: buildPath(),
        stroke: stroke,
        close: closed,
        fill: fill,
        visible: visible,
        backfaceColor: backfaceColor,
        front: front,
        sortPoint: sortPoint);
  }

  @override
  void updateRenderObject(BuildContext context, RenderZShape renderObject) {
    renderObject..color = color;
    renderObject..pathBuilder = buildPath();
    renderObject..stroke = stroke;
    renderObject..close = closed;
    renderObject..fill = fill;
    renderObject..backfaceColor = backfaceColor;
    renderObject..front = front;
    renderObject..visible = visible;
    renderObject..sortPoint = sortPoint;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(DoubleProperty('stroke', stroke));
    properties.add(
      ColorProperty('backfaceColor', backfaceColor),
    );
    //Todo - Add all properties
  }

  @override
  ZSingleChildRenderObjectElement createElement() =>
      ZSingleChildRenderObjectElement(this);
}

class ZShape extends ZShapeBuilder {
  /// The path that will define the shape of the Widget
  /// It is an ordered list of path commands : [ZMove], [ZLine], [ZArc] & [ZBezier]
  /// See some prebuilt shapes as examples:  [ZRect], [ZRounderRect], [ZEllipse]
  final PathBuilder path;

  ZShape({
    Key? key,
    List<ZPathCommand>? path,
    required Color color,
    Color? backfaceColor,
    double stroke = 1,
    bool fill = false,
    ZVector front = const ZVector.only(z: 1),
    bool visible = true,
    bool closed = true,
  })  : path = SimplePathBuilder(path ?? const []),
        assert(stroke >= 0),
        super(
          key: key,
          color: color,
          backfaceColor: backfaceColor,
          stroke: stroke,
          closed: closed,
          fill: fill,
          front: front,
          visible: visible,
        );

  @override
  PathBuilder buildPath() => path;
}
