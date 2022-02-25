//@dart=2.12
import 'package:flutter/material.dart';
import 'package:zflutter/src/core/core.dart';

class ZRenderer {
  Path path = Path();

  Paint paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final Canvas? canvas;

  ZRenderer(this.canvas);

  void setLineCap(StrokeCap value) {
    paint.strokeCap = value;
  }

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

  void renderToPath(Path path, List<ZPathCommand> pathCommands, bool isClosed) {
    var previousPath = this.path;
    this.path = path;
    renderPath(pathCommands, isClosed: isClosed);
    this.path = previousPath;
  }

  void renderPath(List<ZPathCommand> pathCommands, {bool isClosed = false}) {
    begin();
    pathCommands.forEach((it) {
      it.render(this);
    });
    if (isClosed) {
      closePath();
    }
  }

  void stroke(Color color, double lineWidth) {
    paint.color = color;
    paint.strokeWidth = lineWidth;
    paint.style = PaintingStyle.stroke;
    canvas?.drawPath(path, paint);
  }

  void fill(Color color) {
    paint.color = color;
    paint.style = PaintingStyle.fill;
    canvas?.drawPath(path, paint);
  }
}
