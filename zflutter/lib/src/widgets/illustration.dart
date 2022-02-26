import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zflutter/src/core/render/render_box.dart';
import 'package:zflutter/src/core/widgets/widget.dart';

class ZIllustration extends ZMultiChildWidget {
  final double zoom;

  /// Whether clipBehavioring children should be clipped. See [clipBehavior].
  ///
  /// Some children in a stack might clipBehavior its box. When this flag is set to
  /// [clipBehavior.clip], children cannot paint outside of the stack's box.
  final Clip clipBehavior;

  ZIllustration({
    this.clipBehavior = Clip.hardEdge,
    required List<Widget> children,
    this.zoom = 1,
  })  : assert(zoom >= 0),
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

class RenderZIllustration extends RenderMultiChildZBox {
  RenderZIllustration({
    Clip clipBehavior = Clip.none,
    double zoom = 0,
    List<RenderZBox>? children,
  })  : assert(zoom >= 0),
        _zoom = zoom,
        _clipBehavior = clipBehavior,
        super(children: children, sortMode: SortMode.update);

  double _zoom = 1;
  double get zoom => _zoom;
  set zoom(double value) {
    assert(_zoom >= 0);
    if (_zoom == value) return;
    _zoom = value;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  /// Whether clipBehavioring children should be clipped. See [clipBehavior].
  ///
  /// Some children in a stack might clipBehavior its box. When this flag is set to
  /// [clipBehavior.clip], children cannot paint outside of the stack's box.
  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior;
  set clipBehavior(Clip value) {
    if (_clipBehavior != value) {
      _clipBehavior = value;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_clipBehavior == Clip.none) {
      context.pushClipRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        paintIllustration,
        clipBehavior: Clip.hardEdge,
      );
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
  bool get isRepaintBoundary => true;

  @override
  bool hitTestSelf(Offset position) {
    final Rect bounds = position & size;
    return bounds.contains(position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
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
