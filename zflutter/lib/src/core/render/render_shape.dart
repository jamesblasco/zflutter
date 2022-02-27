//@dart=2.12
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zflutter/zflutter.dart';
import '../core.dart';

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
    if (_backfaceColor == null) {
      // It needs to calculate normalVector when there is backface color
      return markNeedsLayout();
    }
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
    markNeedsLayout();
  }

  List<ZPathCommand> _path;
  List<ZPathCommand> get path => _path;
  set path(List<ZPathCommand> value) {
    if (_path == value) return;
    _path = value;

    markNeedsLayout();
  }

  PathBuilder _pathBuilder;
  PathBuilder get pathBuilder => _pathBuilder;
  set pathBuilder(PathBuilder value) {
    if (_pathBuilder == value) return;
    if (_pathBuilder.shouldRebuildPath(value)) {
      path = _pathBuilder.buildPath();
    }
    _pathBuilder = value;
  }

  ZVector? _sortPoint;
  ZVector? get sortPoint => _sortPoint;

  set sortPoint(ZVector? value) {
    if (_sortPoint == value) return;
    _sortPoint = value;
    markNeedsLayout();
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
    assert(value >= 0);
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
    PathBuilder pathBuilder = PathBuilder.empty,
    ZVector? sortPoint,
  })  : assert(stroke >= 0),
        _stroke = stroke,
        _visible = visible,
        _backfaceColor = backfaceColor,
        _front = front,
        _close = close,
        _fill = fill,
        _color = color,
        _pathBuilder = pathBuilder,
        _path = pathBuilder.buildPath(),
        _sortPoint = sortPoint;

  @override
  bool get sizedByParent => true;

  /// With this markNeedsPaint will only repaint this core object and not their ancestors
  bool get isRepaintBoundary => true;

  bool get needsDirection => backfaceColor != null;

  ZVector? _normalVector;
  ZVector get normalVector {
    assert(needsDirection,
        'needs direction needs to be true so normal vector can be retrieved');
    debugTransformed();
    return _normalVector!;
  }

  ZVector origin = ZVector.zero;

  ZVector? transformedSortPoint;

  @override
  void performTransformation() {
    origin = ZVector.zero.applyMatrix4(matrix);

    /// To optimize we calculate the sort point position
    if (sortPoint == ZVector.zero) {
      transformedSortPoint = origin;
    } else if (sortPoint == ZVector.zero) {
      transformedSortPoint = sortPoint!.applyMatrix4(matrix);
    } else {
      transformedSortPoint = null;
    }

    transformedPath = <ZPathCommand>[
      if (path.isEmpty)
        ZMove(0, 0, 0)
      else if (path.first is! ZMove)
        ZMove.vector(path.first.point()),
      ...path,
    ].map((e) => e.transform(matrix)).toList();

    if (needsDirection) {
      _normalVector = origin - front.applyMatrix4(matrix);
    }
  }

  List<ZPathCommand> transformedPath = [];

  @override
  void performSort() {
    if (transformedSortPoint != null) {
      sortValue = transformedSortPoint!.z;
    } else {
      assert(transformedPath.isNotEmpty);
      var pointCount = this.transformedPath.length;
      final firstPoint = this.transformedPath[0].endRenderPoint;
      final lastPoint = this.transformedPath[pointCount - 1].endRenderPoint;
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
  }

  bool get isFacingBack => normalVector.z > 0;
  bool showBackFace = true;

  Color get renderColor {
    final isBackFaceColor = backfaceColor != null && isFacingBack;
    return (isBackFaceColor ? backfaceColor : color) ?? color;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    assert(parentData is ZParentData);

    if (!visible || renderColor == Colors.transparent) return;

    final renderer = ZRenderer(context.canvas);
    render(renderer);
    final length = path.length;
    if (length <= 1) {
      paintDot(renderer);
    } else {
      if (!showBackFace && isFacingBack) {
        return super.paint(context, offset);
      }

      final isTwoPoints = transformedPath.length == 2 && (path[1] is ZLine);
      var isClosed = !isTwoPoints && _close == true;
      final color = renderColor;
      final builder = ZPathBuilder()
        ..renderPath(transformedPath, isClosed: isClosed);

      if (stroke > 0) renderer.stroke(builder.path, color, stroke);
      if (fill == true) renderer.fill(builder.path, color);
    }

    //  context.canvas.restore();
  }

  void paintDot(ZRenderer renderer) {
    if (stroke == 0.0) {
      return;
    }
    final color = renderColor;

    final point = transformedPath.first.endRenderPoint;
    final builder = ZPathBuilder();
    builder.begin();
    final radius = stroke / 2;
    builder.circle(point.x, point.y, radius);
    builder.closePath();
    renderer.fill(builder.path, color);
  }

  void render(ZRenderer renderer) {}

  @override
  bool hitTestSelf(Offset position) {
    var isTwoPoints = transformedPath.length == 2 && (path[1] is ZLine);
    var isClosed = !isTwoPoints && _close == true;
    final builder = ZPathBuilder();
    builder.renderPath(transformedPath, isClosed: isClosed);
    final hit = builder.path.contains(position);
    return hit;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestSelf(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }
}
