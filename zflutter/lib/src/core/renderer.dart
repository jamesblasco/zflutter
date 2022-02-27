//@dart=2.12
import 'package:flutter/material.dart';
import 'package:zflutter/src/core/core.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ZRenderer {
  Paint paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final Canvas? canvas;

  ZRenderer(this.canvas);

  void setLineCap(StrokeCap value) {
    paint.strokeCap = value;
  }

  void stroke(Path path, Color color, double lineWidth) {
    paint.color = color;
    paint.strokeWidth = lineWidth;
    paint.style = PaintingStyle.stroke;
    canvas?.drawPath(path, paint);
  }

  void fill(Path path, Color color) {
    paint.color = color;
    paint.style = PaintingStyle.fill;
    canvas?.drawPath(path, paint);
  }
}

class ZPathBuilder {
  Path path = Path();

  ZPathBuilder();

  void begin() {
    path.reset();
  }

  void move(ZVector point) {
    path.moveTo(point.x, point.y);
  }

  void line(ZVector point) {
    path.lineTo(point.x, point.y);
  }

  void bezier(ZVector cp0, ZVector cp1, ZVector end) {
    path.cubicTo(
      cp0.x,
      cp0.y,
      cp1.x,
      cp1.y,
      end.x,
      end.y,
    );
  }

  void arc(double x, double y, double radius, double start, double end) {
    final rect = Rect.fromLTRB(x - radius, y - radius, x + radius, y + radius);
    path.arcTo(rect, start, start - end, false);
  }

  void circle(double x, double y, double radius) {
    final rect = Rect.fromLTRB(x - radius, y - radius, x + radius, y + radius);

    path.addOval(rect);
  }

  void closePath() {
    path.close();
  }

  Path renderPath(List<ZPathCommand> pathCommands, {bool isClosed = false}) {
    begin();
    ZVector previousPoint = ZVector.zero;
    pathCommands.forEach((it) {
      it.render(this, previousPoint);
      previousPoint = it.endRenderPoint;
    });

    if (isClosed) {
      closePath();
    }
    return path;
  }
}
