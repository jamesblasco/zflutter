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

  ZVector origin = ZVector.zero;
  @override
  void performTransformation() {
    origin = ZVector.zero.applyMatrix4(matrix);
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
      layer.transform = matrix.clone()..translate(-width / 2, -height / 2);
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
      transform: matrix,
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
    transform.multiply(matrix);
    transform.translate(-width / 2, -height / 2);
  }
}
