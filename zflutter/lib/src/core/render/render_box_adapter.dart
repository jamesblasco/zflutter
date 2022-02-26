//@dart=2.12
import 'package:flutter/rendering.dart';

import '../core.dart';

class RenderZToBoxAdapter extends RenderZBox
    with RenderObjectWithChildMixin<RenderBox> {
  double _width;

  double get width => _width;

  set width(double value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  double _height;

  double get height => _height;

  set height(double value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  RenderZToBoxAdapter({
    required double width,
    required double height,
  })  : _width = width,
        _height = height;

  @override
  bool get isRepaintBoundary => true;

  List<ZPathCommand>? transformedPath;

  @override
  void performLayout() {
    child?.layout(
      BoxConstraints.expand(height: height, width: width),
      parentUsesSize: false,
    );
    super.performLayout();
  }

  late Matrix4 _transform;

  ZVector origin = ZVector.zero;
  @override
  void performTransformation() {
    final ZParentData anchorParentData = parentData as ZParentData;

    origin = ZVector.zero;
    final transformations = anchorParentData.transforms.reversed;
    transformations.forEach((matrix4) {
      origin = origin.transform(
        matrix4.translate,
        matrix4.rotate,
        matrix4.scale,
      );
    });

    Matrix4 matrix = Matrix4.translationValues(0, 0, 0);
    anchorParentData.transforms.forEach((transform) {
      final matrix4 = Matrix4.translationValues(
          transform.translate.x, transform.translate.y, transform.translate.z);

      matrix4.rotateX(transform.rotate.x);
      matrix4.rotateY(-transform.rotate.y);
      matrix4.rotateZ(transform.rotate.z);

      matrix4.scale(transform.scale.x, transform.scale.y, transform.scale.z);
      matrix..multiply(matrix4);
    });
    _transform = matrix;
  }

  @override
  void performSort() {
    sortValue = origin.z;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (child != null) {
      final TransformLayer layer = TransformLayer();
      layer.transform = _transform.clone()..translate(-width / 2, -height / 2);
      context.pushLayer(
        layer,
        (context, _) {
          context.paintChild(child!, offset);
        },
        offset,
        childPaintBounds: context.estimatedBounds,
      );
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // RenderZToBoxAdapter objects don't check if they are
    // themselves hit, because it's confusing to think about
    // how the untransformed size and the child's transformed
    // position interact.
    return hitTestChildren(result, position: position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintTransform(
      transform: _transform,
      position: position,
      hitTest: (result, Offset position) {
        return child?.hitTest(
              result,
              position: position + Offset(width / 2, height / 2),
            ) ??
            false;
      },
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(_transform);
    transform.translate(-width / 2, -height / 2);
  }
}
