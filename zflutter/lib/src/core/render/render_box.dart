//@dart=2.12

import 'package:flutter/rendering.dart';

import '../core.dart';

class RenderZBox extends RenderBox {
  double sortValue = 0;

  ZVector origin = ZVector.zero;

  void performSort() {
    sortValue = this.origin.z;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
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

class RenderZMultiChildBox extends RenderZBox
    with
        ContainerRenderObjectMixin<RenderZBox, ZParentData>,
        RenderBoxContainerDefaultsMixin<RenderZBox, ZParentData> {
  RenderZMultiChildBox({
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
      if (child is RenderZMultiChildBox && child.sortMode == SortMode.inherit) {
        child.layout(constraints, parentUsesSize: true);
      } else {
        child.layout(constraints, parentUsesSize: true);
      }
      child = childParentData.nextSibling;
    }
    performSort();
  }

  ZVector? get sortPoint => _sortPoint;
  ZVector? _sortPoint;
  set sortPoint(ZVector? value) {
    if (value == sortPoint) return;
    _sortPoint = value;
    markNeedsLayout();
  }

  @override
  void performResize() {
    size = constraints.biggest;
    assert(size.isFinite);
  }

  List<RenderZBox>? sortedChildren;

  @override
  void performSort() {
    if (sortMode == SortMode.stack || sortMode == SortMode.update) {
      sortedChildren = _getFlatChildren();
      if (sortPoint != null) {
        final ZParentData anchorParentData = parentData as ZParentData;

        ZVector origin = _sortPoint!;
        anchorParentData.transforms.reversed.forEach((matrix4) {
          origin = origin.transform(
              matrix4.translate, matrix4.rotate, matrix4.scale);
        });
        sortValue = origin.z;
      } else {
        sortValue = sortedChildren!.fold<double>(0,
                (previousValue, element) => previousValue + element.sortValue) /
            sortedChildren!.length;
      }

      if (sortMode != SortMode.stack) {
        sortedChildren!..sort((a, b) => a.sortValue.compareTo(b.sortValue));
      }
    } else {
      super.performSort();
    }
  }

  @override
  bool get sizedByParent => true;

  SortMode? sortMode;

  List<RenderZBox> _getFlatChildren() {
    List<RenderZBox> children = [];

    RenderZBox? child = firstChild;

    while (child != null) {
      final ZParentData childParentData = child.parentData as ZParentData;

      if (child is RenderZMultiChildBox && child.sortMode == SortMode.inherit) {
        children.addAll(child._getFlatChildren());
      } else {
        children.add(child);
      }

      /*  final Size childSize = child.size;
        width = math.max(width, childSize.width);
        height = math.max(height, childSize.height);*/

      child = childParentData.nextSibling;
    }
    return children;
  }

  ZVector rotation = ZVector.zero;
  ZVector scale = ZVector.zero;
  ZVector translate = ZVector.zero;

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(sortMode != null);
    if (sortMode == SortMode.inherit) return;
    List<RenderZBox> children = sortedChildren!;

    for (final child in children) {
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

      /* final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );*/
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
  //ZVector translate = ZVector.zero;
  //ZVector rotate = ZVector.zero;
  //ZVector scale = ZVector.identity;

  List<ZTransform> transforms;

  ZParentData({
    List<ZTransform>? transforms,
  }) : this.transforms = transforms ?? [];

  ZParentData clone() =>
      ZParentData(transforms: List<ZTransform>.from(transforms));

  /* String toString() {
    final List<String> values = <String>[
      if (top != null) 'top=${debugFormatDouble(top)}',
      if (right != null) 'right=${debugFormatDouble(right)}',
      if (bottom != null) 'bottom=${debugFormatDouble(bottom)}',
      if (left != null) 'left=${debugFormatDouble(left)}',
      if (width != null) 'width=${debugFormatDouble(width)}',
      if (height != null) 'height=${debugFormatDouble(height)}',
    ];
    if (values.isEmpty)
      values.add('not positioned');
    values.add(super.toString());
    return values.join('; ');
  }*/
}
