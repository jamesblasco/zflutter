import 'package:flutter/rendering.dart';

import '../core.dart';

class RenderZToBoxAdapter extends RenderZBox
    with RenderObjectWithChildMixin<RenderBox> {
  double? _width;

  double? get width => _width;

  set width(double? value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  double? _height;

  double? get height => _height;

  set height(double? value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  RenderZToBoxAdapter({
    double? width,
    double? height,
  })  : _width = width,
        _height = height;

  @override
  bool get isRepaintBoundary => true;

  // bool get isRepaintBoundary => true;

  late List<ZPathCommand> transformedPath;

  @override
  void performLayout() {
    final ZParentData anchorParentData = parentData as ZParentData;
    child!.layout(BoxConstraints.expand(height: height, width: width),
        parentUsesSize: false);
    size = constraints.smallest;

    final x = width! / 2;
    final y = height! / 2;
    transformedPath = [
      ZMove.vector(ZVector.only(x: -x, y: -y)),
      ZLine.vector(ZVector.only(x: x, y: -y)),
      ZLine.vector(ZVector.only(x: x, y: y)),
      ZLine.vector(ZVector.only(x: -x, y: y))
    ];

    origin = ZVector.zero;

    anchorParentData.transforms.reversed.forEach((matrix4) {
      origin =
          origin.transform(matrix4.translate, matrix4.rotate, matrix4.scale);

      transformedPath = transformedPath
          .map((e) =>
              e.transform(matrix4.translate, matrix4.rotate, matrix4.scale))
          .toList();
    });

    performSort();
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
      sortValueTotal += this.transformedPath[i].endRenderPoint!.z!;
    }
    this.sortValue = sortValueTotal / pointCount;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(parentData is ZParentData);
    final ZParentData anchorParentData = parentData as ZParentData;

    Matrix4 matrix = Matrix4.translationValues(0, 0, 0);
    anchorParentData.transforms.forEach((transform) {
      final matrix4 = Matrix4.translationValues(
          transform.translate.x!, transform.translate.y!, transform.translate.z!);

      matrix4.rotateX(transform.rotate.x!);
      matrix4.rotateY(-transform.rotate.y!);
      matrix4.rotateZ(transform.rotate.z!);

      matrix4.scale(transform.scale.x, transform.scale.y, transform.scale.z);
      matrix..multiply(matrix4);
    });

    /* final transform2 = anchorParentData.transforms.reversed.toList()[1];
    matrix..rotateY(transform2.rotate.y);
    matrix..rotateX(transform2.rotate.x);

    final transform = anchorParentData.transforms.reversed.first;

    matrix..translate(transform.translate.x, transform.translate.y, transform.translate.z);*/

    /* context.canvas.save();

    context.canvas.transform(matrix.storage);

    context.paintChild(child, offset - Offset(width / 2, height / 2));

    context.canvas.restore();*/

    if (child != null) {
      final TransformLayer layer = TransformLayer();
      layer.transform = matrix;
      context.pushLayer(
        layer,
        (context, _) {
          context.paintChild(child!, offset - Offset(width! / 2, height! / 2));
        },
        Offset.zero,
        childPaintBounds: context.estimatedBounds,
      );
    }
  }
}
