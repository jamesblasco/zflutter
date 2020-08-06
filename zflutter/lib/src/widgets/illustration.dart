import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zflutter/src/core/render/render_box.dart';
import 'package:zflutter/src/core/widgets/widget.dart';


class ZIllustration extends ZMultiChildWidget {
  final double zoom;

  /// Whether overflowing children should be clipped. See [Overflow].
  ///
  /// Some children in a stack might overflow its box. When this flag is set to
  /// [Overflow.clip], children cannot paint outside of the stack's box.
  final Overflow overflow;

  ZIllustration({
    List<Widget> children,
    this.overflow = Overflow.clip,
    this.zoom = 1,
  })  : assert(zoom != null && zoom >= 0),
        super(children: children);

  @override
  RenderZIllustration createRenderObject(BuildContext context) {
    return RenderZIllustration(zoom: zoom);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderZIllustration renderObject) {
    renderObject..zoom = zoom;
  }
}

class RenderZIllustration extends RenderZMultiChildBox {
  double _zoom = 1;

  double get zoom => _zoom;

  set zoom(double value) {
    assert(_zoom != null && _zoom >= 0);
    if (_zoom == value) return;
    _zoom = value;
    markNeedsPaint();
  }

  /// Whether overflowing children should be clipped. See [Overflow].
  ///
  /// Some children in a stack might overflow its box. When this flag is set to
  /// [Overflow.clip], children cannot paint outside of the stack's box.
  Overflow get overflow => _overflow;
  Overflow _overflow;
  set overflow(Overflow value) {
    assert(value != null);
    if (_overflow != value) {
      _overflow = value;
      markNeedsPaint();
    }
  }

  RenderZIllustration({
    double zoom,
    List<RenderZBox> children,
    Overflow overflow = Overflow.clip,
  })  : assert(zoom != null && zoom >= 0),
        assert(overflow != null),
        _zoom = zoom,
        _overflow = overflow,
        super(children: children, sortMode: SortMode.update);

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_overflow == Overflow.clip) {
      context.pushClipRect(needsCompositing, offset, Offset.zero & size, paintIllustration);
    } else {
      paintIllustration(context, offset);
    }

  }

  @protected
  void paintIllustration(PaintingContext context, Offset offset) {
    Matrix4 matrix = Matrix4.identity()
      ..translate(size.width / 2, size.height / 2)
      ..scale(zoom, zoom, zoom);
    context.pushTransform(true, offset, matrix, (context, offset) {
      super.paint(context, offset);
    });
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    Matrix4 matrix = Matrix4.identity()
      ..translate(size.width / 2, size.height / 2)
      ..scale(zoom, zoom, zoom);
    transform.multiply(matrix);
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    RenderZBox child = firstChild;

    while (child != null) {
      final ZParentData childParentData = child.parentData as ZParentData;

      if (child is RenderZMultiChildBox && child.sortMode == SortMode.inherit) {
        child.layout(constraints, parentUsesSize: false);
      } else {
        child.layout(constraints, parentUsesSize: false);
      }
      child = childParentData?.nextSibling;
    }
    performSort();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestSelf(Offset position) {
    final Rect bounds = position & size;
    return bounds.contains(position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    Matrix4 matrix = Matrix4.identity()
      ..translate(size.width / 2, size.height / 2)
      ..scale(zoom, zoom, zoom);
    return result.addWithPaintTransform(
      transform: matrix,
      position: position,
      hitTest: (BoxHitTestResult result, Offset position) {
        return super.hitTestChildren(result, position: position);
      },
    );
  }
}
