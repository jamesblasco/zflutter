import 'package:flutter/rendering.dart';

import '../core.dart';

class RenderZBox extends RenderBox {
  double sortValue = 0;

  ZVector origin = ZVector.zero;

  void performSort() {
    sortValue = this.origin.z;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;
}

enum SortMode { inherit, stack, update }

class RenderZMultiChildBox extends RenderZBox
    with
        ContainerRenderObjectMixin<RenderZBox, ZParentData>,
        RenderBoxContainerDefaultsMixin<RenderZBox, ZParentData> {
  RenderZMultiChildBox({
    List<RenderZBox> children,
    SortMode sortMode = SortMode.inherit,
  })  : assert(sortMode != null),
        this.sortMode = sortMode {
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

    RenderZBox child = firstChild;

    while (child != null) {
      final ZParentData childParentData = child.parentData as ZParentData;

      if (child is RenderZMultiChildBox && child.sortMode == SortMode.inherit) {
        child.layout(constraints, parentUsesSize: true);
      } else {
        child.layout(constraints, parentUsesSize: true);
      }

      /*  final Size childSize = child.size;
        width = math.max(width, childSize.width);
        height = math.max(height, childSize.height);*/

      child = childParentData?.nextSibling;
    }
    performSort();
  }

  @override
  void performResize() {
    size = constraints.biggest;
    assert(size.isFinite);
  }

  @override
  void performSort() {
    if (sortMode == SortMode.stack || sortMode == SortMode.update) {
      final children = getFlatChildren();
      sortValue = children.fold(0,
              (previousValue, element) => previousValue + element.sortValue) /
          children.length;
    } else {
      super.performSort();
    }
  }

  @override
  bool get sizedByParent => true;

  SortMode sortMode;

  List<RenderZBox> getFlatChildren() {
    List<RenderZBox> children = [];

    RenderZBox child = firstChild;

    while (child != null) {
      final ZParentData childParentData = child.parentData as ZParentData;

      if (child is RenderZMultiChildBox && child.sortMode == SortMode.inherit) {
        children.addAll(child.getFlatChildren());
      } else {
        children.add(child);
      }

      /*  final Size childSize = child.size;
        width = math.max(width, childSize.width);
        height = math.max(height, childSize.height);*/

      child = childParentData?.nextSibling;
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
    List<RenderZBox> children = getFlatChildren();
    //List<RenderBox> children = getChildrenAsList()
    if (sortMode != SortMode.stack) {
      children..sort((a, b) => a.sortValue.compareTo(b.sortValue));
    }
    for (final child in children) {
      final ZParentData childParentData = child.parentData as ZParentData;
      context.paintChild(child, childParentData.offset + offset);
    }
  }
}

/// Parent data for use with [ZRenderer].
class ZParentData extends ContainerBoxParentData<RenderZBox> {
  ZVector translate = ZVector.zero;
  ZVector rotate = ZVector.zero;
  ZVector scale = ZVector.identity;

  List<ZTransform> transforms;

  ZParentData({
    this.rotate = ZVector.zero,
    this.scale = ZVector.identity,
    this.translate = ZVector.zero,
    List<ZTransform> transforms,
  }) : this.transforms = transforms ?? [];

  ZParentData clone() => ZParentData(
      rotate: rotate,
      scale: scale,
      translate: translate,
      transforms: List<ZTransform>.from(transforms));

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
