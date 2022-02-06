//@dart=2.12
import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:zflutter/zflutter.dart';

import '../core.dart';
import '../path_command.dart';
import '../renderer.dart';

class RenderZShape extends RenderZBox {
  Color _color;

  Color get color => _color;

  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  Color? _backfaceColor;

  Color? get backfaceColor => _backfaceColor;

  set backfaceColor(Color? value) {
    if (_backfaceColor == value) return;
    _backfaceColor = value;
    markNeedsPaint();
  }

  bool _close;

  bool get close => _close;

  set close(bool value) {
    if (_close == value) return;
    _close = value;
    markNeedsPaint();
  }

  bool _fill;

  bool get fill => _fill;

  set fill(bool value) {
    if (_fill == value) return;
    _fill = value;
    markNeedsPaint();
  }

  ZVector _front;

  ZVector get front => _front;

  set front(ZVector value) {
    if (_front == value) return;
    _front = value;
    //TODO: Transform front here so no need to rebuild layout a
    // markNeedsPaint();
    markNeedsLayout();
  }

  List<ZPathCommand> _path;

  List<ZPathCommand> get path => _path;

  set path(List<ZPathCommand> value) {
    if (_path == value) return;
    _path = value;

    markNeedsLayout();
  }

  double _sortValue;
  double get sortValue => _sortValue;

  set sortValue(double value) {
    if (_sortValue == value) return;
    _sortValue = value;
  }

  bool _visible;

  bool get visible => _visible;

  set visible(bool value) {
    if (_visible == value) return;
    _visible = value;
  }

  double _stroke;

  double get stroke => _stroke;

  set stroke(double value) {
    assert(value != null && value >= 0);
    if (_stroke == value) return;
    _stroke = value;
  }

  RenderZShape({
    required Color color,
    Color? backfaceColor,
    ZVector front = const ZVector.only(z: 1),
    bool close = false,
    bool visible = true,
    bool fill = false,
    double stroke = 1,
    List<ZPathCommand> path = const [],
    double sortValue = 0,
  })  : assert(path != null),
        assert(front != null),
        assert(close != null),
        assert(fill != null),
        assert(stroke != null && stroke >= 0),
        _stroke = stroke,
        _visible = visible,
        _backfaceColor = backfaceColor,
        _front = front,
        _close = close,
        _fill = fill,
        _color = color,
        _path = path,
        _sortValue = sortValue;

  @override
  bool get sizedByParent => true;

  /// With this markNeedsPaint will only repaint this core object and not their ancestors
  bool get isRepaintBoundary => true;

  ZVector? _transformedFront;
  ZVector? normalVector;
  final Matrix4 matrix4 = Matrix4.identity();

  @override
  void performLayout() {
    final ZParentData anchorParentData = parentData as ZParentData;

    matrix4.setIdentity();

    origin = ZVector.zero;
    anchorParentData.transforms.reversed.forEach((matrix4) {
      origin =
          origin.transform(matrix4.translate, matrix4.rotate, matrix4.scale);
    });

    _transformedFront = front;
    anchorParentData.transforms.reversed.forEach((matrix4) {
      _transformedFront = _transformedFront!
          .transform(matrix4.translate, matrix4.rotate, matrix4.scale);
    });

    normalVector = origin - _transformedFront!;
    transformedPath = path;
    anchorParentData.transforms.reversed.forEach((matrix4) {
      transformedPath = transformedPath
          .map((e) =>
              e.transform(matrix4.translate, matrix4.rotate, matrix4.scale))
          .toList();
    });

    performPathCommands();
    performSort();
  }

  

  List<ZPathCommand> transformedPath = [];


  void performPathCommands() {
    ZVector previousPoint = origin;
    if (transformedPath.isEmpty) {
      transformedPath.add(ZMove.vector(origin));
    } else {
      final first = transformedPath.first;
      //Todo: Check this, I think not needed and can cause error
      if (!(first is ZMove)) {
        transformedPath[0] = ZMove.vector(first.point());
      }
      transformedPath.forEach((it) {
        it.previous = previousPoint;
        previousPoint = it.endRenderPoint;
      });
    }
  }

  @override
  void performSort() {
    assert(transformedPath.isNotEmpty);
    var pointCount = this.transformedPath.length;
    var firstPoint = this.transformedPath[0].endRenderPoint;
    var lastPoint = this.transformedPath[pointCount - 1].endRenderPoint;
    // ignore the final point if self closing shape
    var isSelfClosing = pointCount > 2 && firstPoint == lastPoint;
    if (isSelfClosing) {
      pointCount -= 1;
    }

    double sortValueTotal = 0;
    for (var i = 0; i < pointCount; i++) {
      sortValueTotal += this.transformedPath[i].endRenderPoint.z;
    }
    this.sortValue = sortValueTotal / pointCount;
  }

  bool isFacingBack = false;
  bool showBackFace = true;

  Color get renderColor {
    final isBackFaceColor = backfaceColor != null && isFacingBack;
    return (isBackFaceColor ? backfaceColor : color) ?? color;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(parentData is ZParentData);
    if (!visible) return;

    final renderer = ZRenderer(context.canvas);
    render(renderer);
    final length = path.length;
    if (length <= 1) {
      paintDot(renderer);
    } else {
      isFacingBack = normalVector!.z > 0;
      if (!showBackFace && isFacingBack) {
        return super.paint(context, offset);
      }

      var isTwoPoints = transformedPath.length == 2 && (path[1] is ZLine);
      var isClosed = !isTwoPoints && _close == true;
      final color = renderColor;

      renderer.renderPath(transformedPath, isClosed: isClosed);
      if (stroke != null && stroke > 0) renderer.stroke(color, stroke);
      if (fill == true) renderer.fill(color);
    }

    //  context.canvas.restore();
    super.paint(context, offset);
  }

  void paintDot(ZRenderer renderer) {
    if (stroke == 0.0) {
      return;
    }
    final color = renderColor;

    final point = transformedPath.first.endRenderPoint;
    renderer.begin();
    final radius = stroke / 2;
    renderer.circle(point.x, point.y, radius);
    renderer.closePath();
    renderer.fill(color);
  }

  void render(ZRenderer renderer) {}

  @override
  bool hitTestSelf(Offset position) {
    print('test');
    final renderer = ZRenderer(null);
    var isTwoPoints = transformedPath.length == 2 && (path[1] is ZLine);
    var isClosed = !isTwoPoints && _close == true;
    renderer.renderPath(transformedPath, isClosed: isClosed);
    print(position);
    final hit =  path.contains(position);
    print(hit);
    return hit;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestSelf(position)) {
      result.add(BoxHitTestEntry(this, position));
      print('hitted');
      return true;
    }
    return false;
  }


}
