//@dart=2.12
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:zflutter/src/core/widgets/update_parent_data.dart';
import 'package:zflutter/src/widgets/illustration.dart';

import '../core.dart';

class ZTransform {
  ZVector rotate;
  ZVector translate;
  ZVector scale;

  ZTransform(
      {this.rotate = ZVector.zero,
      this.translate = ZVector.zero,
      this.scale = ZVector.identity});
}

/// A zWidget that transforms a child in a 3D space.
///
/// zWidget are special-purpose widgets that can be combined using a
/// [ZIllustration] to distribute them in a 3D space. A [ZPositioned]
/// is a basic zWidget that transforms other zWidgets in the 3D space
///
/// A [ZPositioned] widget must be a relative of a [ZIllustration], and the path from
/// the [ZPositioned] widget to its enclosing [ZIllustration] must contain only
/// [StatelessWidget]s or [StatefulWidget]s. Also its child must be a [ZWidget] or
/// the path from the [ZPositioned] widget to its enclosing [ZIllustration] must contain only
/// [StatelessWidget]s or [StatefulWidget]s
///
/// If a widget is wrapped in a [ZPositioned], then it is a _positioned_ widget
/// in its [ZIllustration] or other  [ZMultiChildWidget]s. The widget will use
/// [scale], [rotate] and [translate] to transform the child in a 3D space.
/// It will apply the [ZVector] transformations in that order.
///
/// It is possible to nest [ZPositioned], one inside another. In that case the
/// transformation will combine all [ZPositioned] transformations from the
/// closer [ZIllustration] or [ZMultiChildWidget] to its enclosing
/// child [RenderObjectWidget], in this same order.
///
class ZPositioned extends ZUpdateParentDataWidget<ZParentData> with ZWidget {
  /// Creates a widget that controls where a child of a [ZStack] is positioned.
  const ZPositioned({
    Key? key,
    this.scale = ZVector.identity,
    this.translate = ZVector.zero,
    this.rotate = ZVector.zero,
    required Widget child,
  }) : super(key: key, child: child);

  ZPositioned.scale({
    Key? key,
    double x = 1,
    double y = 1,
    double z = 1,
    required Widget child,
  })  : this.scale = ZVector(x, y, z),
        this.rotate = ZVector.zero,
        this.translate = ZVector.zero,
        super(key: key, child: child);

  ZPositioned.translate({
    Key? key,
    double x = 0,
    double y = 0,
    double z = 0,
    required Widget child,
  })  : this.scale = ZVector.identity,
        this.rotate = ZVector.zero,
        this.translate = ZVector(x, y, z),
        super(key: key, child: child);

  ZPositioned.rotate({
    Key? key,
    double x = 0,
    double y = 0,
    double z = 0,
    required Widget child,
  })  : this.scale = ZVector.identity,
        this.rotate = ZVector(x, y, z),
        this.translate = ZVector.zero,
        super(key: key, child: child);

  // Transformation vector that translates its child in a 3D space
  final ZVector translate;

  // Transformation vector that rotates its child in a 3D space.
  final ZVector rotate;

  // Transformation vector that scale its child in a 3D space.
  // Notice that this param won't scale the stroke of the [ZShape]
  // widgets and will only transform its path
  final ZVector scale;

  @override
  void updateParentData(
      RenderObject renderObject, ZPositioned oldWidget, ZTransform transform) {
    assert(renderObject.parentData is ZParentData);

    final ZParentData parentData = renderObject.parentData as ZParentData;
    bool needsLayout = false;
    assert(parentData.transforms.contains(transform));
    transform.scale = scale;
    transform.rotate = rotate;
    transform.translate = translate;

    if (scale != oldWidget.scale ||
        rotate != oldWidget.rotate ||
        translate != oldWidget.translate) {
      needsLayout = true;
    }

    if (renderObject is RenderZMultiChildBox) {
      RenderZBox? child = renderObject.firstChild;

      while (child != null) {
        final ZParentData childParentData = child.parentData as ZParentData;
        updateParentData(child, oldWidget, transform);
        child = childParentData.nextSibling;
      }
    }

    if (needsLayout) {
      renderObject.markNeedsLayout();
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => ZWidget;

  @override
  void startParentData(RenderObject renderObject, ZTransform transform) {
    assert(renderObject.parentData is ZParentData);
    final ZParentData parentData = renderObject.parentData as ZParentData;
    // print('crate matrix');
    transform.scale = scale;
    transform.translate = translate;
    transform.rotate = rotate;

    parentData.transforms.add(transform);

    if (renderObject is RenderZMultiChildBox) {
      RenderZBox? child = renderObject.firstChild;

      while (child != null) {
        final ZParentData childParentData = child.parentData as ZParentData;
        startParentData(child, transform);
        child = childParentData.nextSibling;
      }
    }

    final AbstractNode? targetParent = renderObject.parent;
    if (targetParent is RenderObject) targetParent.markNeedsLayout();
  }

/*  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('left', left, defaultValue: null));
    properties.add(DoubleProperty('top', top, defaultValue: null));
    properties.add(DoubleProperty('right', right, defaultValue: null));
    properties.add(DoubleProperty('bottom', bottom, defaultValue: null));
    properties.add(DoubleProperty('width', width, defaultValue: null));
    properties.add(DoubleProperty('height', height, defaultValue: null));
  }*/
}
