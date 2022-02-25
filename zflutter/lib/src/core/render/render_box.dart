//@dart=2.12

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../core.dart';

class RenderZBox extends RenderBox {
  bool _debugSortedValue = false;

  double sortValue = 0;

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    _debugSortedValue = false;
    super.layout(constraints, parentUsesSize: parentUsesSize);
    sort();
  }

  void performSort() {}

  @mustCallSuper
  void sort() {
    _debugSortedValue = true;
    performSort();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(_debugSortedValue, 'requires sorted value');
    super.paint(context, offset);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void performResize() {
    size = constraints.biggest;
    assert(size.isFinite);
  }
}

enum SortMode {
  // Each child inside the group is sorted by its own center
  // The group acts as a proxy
  inherit,
  // Children are sorted following the order in the list
  stack,
  // Children are encapsulated and painted in the order described
  // The group is painted by
  update,
}

class RenderMultiChildZBox extends RenderZBox
    with
        ContainerRenderObjectMixin<RenderZBox, ZParentData>,
        RenderBoxContainerDefaultsMixin<RenderZBox, ZParentData> {
  RenderMultiChildZBox({
    List<RenderZBox>? children,
    SortMode? sortMode = SortMode.inherit,
    ZVector? sortPoint,
  })  : assert(sortMode != null),
        this.sortMode = sortMode,
        _sortPoint = sortPoint {
    addAll(children);
  }

  @override
  void setupParentData(RenderZBox child) {
    if (parentData is ZParentData) {
      child.parentData = (parentData as ZParentData).clone();
      return;
    }
    if (child.parentData is! ZParentData) {
      child.parentData = ZParentData();
    }
  }

  @override
  void performLayout() {
    super.performLayout();

    final BoxConstraints constraints = this.constraints;

    RenderZBox? child = firstChild;

    while (child != null) {
      final ZParentData childParentData = child.parentData as ZParentData;
      if (child is RenderMultiChildZBox && child.sortMode == SortMode.inherit) {
        child.layout(constraints, parentUsesSize: true);
      } else {
        child.layout(constraints, parentUsesSize: true);
      }
      child = childParentData.nextSibling;
    }
  }

  ZVector? get sortPoint => _sortPoint;
  ZVector? _sortPoint;
  set sortPoint(ZVector? value) {
    if (value == sortPoint) return;
    _sortPoint = value;
    markNeedsLayout();
  }

  List<RenderZBox>? sortedChildren;

  @override
  void performSort() {
    final children = _getFlatChildren();
    if (sortMode == SortMode.stack || sortMode == SortMode.update) {
      if (sortPoint != null) {
        final ZParentData anchorParentData = parentData as ZParentData;

        ZVector origin = _sortPoint!;
        anchorParentData.transforms.reversed.forEach(
          (matrix4) {
            origin = origin.transform(
              matrix4.translate,
              matrix4.rotate,
              matrix4.scale,
            );
          },
        );
        sortValue = origin.z;
      } else {
        sortValue = children.fold<double>(0, (previousValue, element) {
              return (previousValue + element.sortValue);
            }) /
            children.length;
      }
    }
    if (sortMode == SortMode.update) {
      children..sort((a, b) => a.sortValue.compareTo(b.sortValue));
    }
    sortedChildren = children;
  }

  @override
  bool get sizedByParent => true;

  SortMode? sortMode;

  List<RenderZBox> _getFlatChildren() {
    List<RenderZBox> children = [];

    RenderZBox? child = firstChild;

    while (child != null) {
      final ZParentData childParentData = child.parentData as ZParentData;

      if (child is RenderMultiChildZBox && child.sortMode == SortMode.inherit) {
        children.addAll(child._getFlatChildren());
      } else {
        children.add(child);
      }
      child = childParentData.nextSibling;
    }
    return children;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    performSort();
    assert(sortMode != null);
    if (sortMode == SortMode.inherit) return;

    for (final child in sortedChildren!) {
      context.paintChild(child, offset);
    }
  }

  bool defaultHitTestChildren(BoxHitTestResult result,
      {required Offset position}) {
    if (sortMode == SortMode.inherit) return false;
    // The x, y parameters have the top left of the node's box as the origin.
    List<RenderZBox> children = sortedChildren!;

    for (final child in children.reversed) {
      final bool isHit = child.hitTest(result, position: position);

      if (isHit) return true;
    }
    return false;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

/// Parent data for use with [ZRenderer].
class ZParentData extends ContainerBoxParentData<RenderZBox> {
  List<ZTransform> transforms;

  ZParentData({
    List<ZTransform>? transforms,
  }) : this.transforms = transforms ?? [];

  ZParentData clone() {
    return ZParentData(
      transforms: List<ZTransform>.from(transforms),
    );
  }
}
