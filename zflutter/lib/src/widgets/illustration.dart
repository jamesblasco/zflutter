import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zflutter/src/core/render/render_box.dart';
import 'package:zflutter/src/core/widgets/widget.dart';


class ZIllustration extends ZMultiChildWidget {
  final double zoom;

  ZIllustration({
    List<Widget> children,
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

  RenderZIllustration({
    double zoom,
    List<RenderZBox> children,
  })  : assert(zoom != null && zoom >= 0),
        _zoom = zoom,
        super(children: children, sortMode: SortMode.update);

  @override
  void paint(PaintingContext context, Offset offset) {
    Matrix4 matrix = Matrix4.identity()
      ..translate(size.width / 2, size.height / 2)
      ..scale(zoom, zoom, zoom);
    context.pushTransform(true, offset, matrix, (context, offset) {
      super.paint(context, offset);
    });
  }

  @override
  bool get isRepaintBoundary => true;


  // TODO: Work on hitTest
  @override
  bool hitTest(BoxHitTestResult result, {Offset position}) {
    assert(() {
      if (!hasSize) {
        if (debugNeedsLayout) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
                'Cannot hit test a render box that has never been laid out.'),
            describeForError(
                'The hitTest() method was called on this RenderBox'),
            ErrorDescription(
                "Unfortunately, this object's geometry is not known at this time, "
                'probably because it has never been laid out. '
                'This means it cannot be accurately hit-tested.'),
            ErrorHint('If you are trying '
                'to perform a hit test during the layout phase itself, make sure '
                "you only hit test nodes that have completed layout (e.g. the node's "
                'children, after their layout() method has been called).'),
          ]);
        }
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('Cannot hit test a render box with no size.'),
          describeForError('The hitTest() method was called on this RenderBox'),
          ErrorDescription(
              'Although this node is not marked as needing layout, '
              'its size is not set.'),
          ErrorHint('A RenderBox object must have an '
              'explicit size before it can be hit-tested. Make sure '
              'that the RenderBox in question sets its size during layout.'),
        ]);
      }
      return true;
    }());
    if (size.contains(position)) {
      return true;
    }
    return false;
  }
}
