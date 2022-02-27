//@dart=2.12

import 'core.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
// TODO: This Paths needs to be immutable;

abstract class ZPathCommand {
  final ZVector endRenderPoint = ZVector.zero;

  const ZPathCommand();

  ZPathCommand transform(vector.Matrix4 transformation);

  void render(
    ZPathBuilder renderer,
    ZVector previousPoint,
  );

  ZVector point({index = 0});

  ZVector renderPoint({int index = 0});
}

class ZMove extends ZPathCommand {
  final ZVector _point;

  ZVector get endRenderPoint => _point;

  const ZMove.vector(this._point);

  ZMove(double x, double y, double z) : _point = ZVector(x, y, z);

  ZMove.only({double x = 0, double y = 0, double z = 0})
      : _point = ZVector(x, y, z);

  ZPathCommand transform(vector.Matrix4 transformation) {
    return ZMove.vector(_point.applyMatrix4(transformation));
  }

  void render(ZPathBuilder renderer, ZVector previousPoint) {
    renderer.move(_point);
  }

  ZVector point({index = 0}) {
    return _point;
  }

  ZVector renderPoint({index = 0}) {
    return _point;
  }
}

class ZLine extends ZPathCommand {
  late ZVector _point;

  late ZVector _renderPoint;

  ZVector get endRenderPoint => _renderPoint;

  ZLine.vector(this._point) {
    _renderPoint = _point.copy();
  }

  ZLine(double x, double y, double z) {
    _point = ZVector(x, y, z);
    _renderPoint = ZVector(x, y, z);
  }

  ZLine.only({double x = 0, double y = 0, double z = 0}) {
    _point = ZVector(x, y, z);
    _renderPoint = ZVector(x, y, z);
  }

  ZPathCommand transform(vector.Matrix4 transformation) {
    return ZLine.vector(_renderPoint.applyMatrix4(transformation));
  }

  void render(ZPathBuilder renderer, ZVector previousPoint) {
    renderer.line(_renderPoint);
  }

  ZVector point({index = 0}) {
    return _point;
  }

  ZVector renderPoint({index = 0}) {
    return _renderPoint;
  }
}

class ZBezier extends ZPathCommand {
  List<ZVector> points;

  late List<ZVector> renderPoints;

  ZVector get endRenderPoint => renderPoints.last;

  ZBezier(this.points) {
    renderPoints = points.map((e) => e.copy()).toList();
  }

  ZPathCommand transform(vector.Matrix4 transformation) {
    return ZBezier(renderPoints.map((point) {
      return point.applyMatrix4(transformation);
    }).toList());
  }

  void render(ZPathBuilder renderer, ZVector previousPoint) {
    renderer.bezier(renderPoints[0], renderPoints[1], renderPoints[2]);
  }

  ZVector point({index = 0}) {
    return points[index];
  }

  ZVector renderPoint({index = 0}) {
    return renderPoints[index];
  }
}

const double _arcHandleLength = 9 / 16;

class ZArc extends ZPathCommand {
  late List<ZVector> points;

  late List<ZVector> renderPoints;

  ZVector get endRenderPoint => renderPoints.last;

  ZArc.list(this.points, [ZVector? previous]) {
    renderPoints = points.map((e) => e.copy()).toList();
  }

  ZArc({required ZVector corner, required ZVector end}) {
    points = [corner, end];

    renderPoints = points.map((e) => e.copy()).toList();
  }

  List<ZVector> controlPoints = [ZVector.zero, ZVector.zero];

  void reset() {
    renderPoints = List.generate(renderPoints.length, (i) => points[i]);
  }

  ZPathCommand transform(vector.Matrix4 transformation) {
    return ZArc.list(renderPoints.map((point) {
      return point.applyMatrix4(transformation);
    }).toList());
  }

  void render(ZPathBuilder renderer, ZVector previousPoint) {
    var prev = previousPoint;
    var corner = renderPoints[0];
    var end = renderPoints[1];
    var a = ZVector.lerp(prev, corner, _arcHandleLength);
    var b = ZVector.lerp(end, corner, _arcHandleLength);
    renderer.bezier(a, b, end);
  }

  ZVector point({index = 0}) {
    return points[index];
  }

  ZVector renderPoint({index = 0}) {
    return renderPoints[index];
  }
}
