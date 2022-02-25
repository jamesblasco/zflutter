import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

class ZGroup extends ZMultiChildWidget {
  
  ZGroup({
    required List<Widget> children,
    this.sortMode = SortMode.inherit,
    this.sortPoint,
  })  : assert(sortPoint == null || sortMode == SortMode.update,
            'sortPoint can only be used with SortMode.update'),
        super(children: children);

  final SortMode sortMode;

  // Overrides the point for the sort when SortMode.update
  final ZVector? sortPoint;

  @override
  RenderZMultiChildBox createRenderObject(BuildContext context) {
    return RenderZMultiChildBox(sortMode: sortMode, sortPoint: sortPoint);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderZMultiChildBox renderObject) {
    renderObject.sortMode = sortMode;
    renderObject.sortPoint = sortPoint;
  }
}
