//@dart=2.12
import 'package:flutter/widgets.dart';
import 'package:zflutter/src/core/core.dart';
import 'package:zflutter/src/core/render/render_box_adapter.dart';
import 'package:zflutter/zflutter.dart';

/// A zWidget that contains a single box widget.
///
/// zWidget are special-purpose widgets that can be combined using a
/// [ZIllustration] to distribute them in a 3D space. A [ZToBoxAdapter]
/// is a basic zWidget that creates a bridge back to one of the usual box-based
/// widgets.
///
class ZToBoxAdapter extends SingleChildRenderObjectWidget with ZWidget {
  // Height of the box widget
  final double height;

  // Width of the box widget
  final double width;

  /// Creates a ZWidget that contains a single box widget.
  const ZToBoxAdapter({
    Key? key,
    required this.height,
    required this.width,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RenderZToBoxAdapter createRenderObject(BuildContext context) =>
      RenderZToBoxAdapter(height: height, width: width);

  @override
  void updateRenderObject(
      BuildContext context, RenderZToBoxAdapter renderObject) {
    renderObject.height = height;
    renderObject.width = width;
    super.updateRenderObject(context, renderObject);
  }

  @override
  ZSingleChildRenderObjectElement createElement() =>
      ZSingleChildRenderObjectElement(this);
}
