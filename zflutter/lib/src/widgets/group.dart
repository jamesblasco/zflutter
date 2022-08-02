import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

class ZGroup extends ZMultiChildWidget {
  final SortMode sortMode;
  ZGroup({required List<Widget> children, this.sortMode = SortMode.inherit})
      : super(children: children);

  @override
  RenderZMultiChildBox createRenderObject(BuildContext context) {
    return RenderZMultiChildBox(sortMode: sortMode);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderZMultiChildBox renderObject) {
    renderObject.sortMode = sortMode;
  }
}
