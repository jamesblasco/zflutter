//@dart=2.12
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zflutter/src/core/widgets/update_parent_data.dart';

import '../core.dart';

mixin ZWidget on Widget {}

class ZSingleChildRenderObjectElement extends SingleChildRenderObjectElement {
  ZSingleChildRenderObjectElement(SingleChildRenderObjectWidget widget)
      : super(widget);

  @override
  void attachRenderObject(newSlot) {
    super.attachRenderObject(newSlot);

    visitAncestorElements((element) {
      if (element is UpdateParentDataElement<ZParentData>) {
        element.startParentData(renderObject);
      }
      return element.widget is! RenderObjectWidget;
    });
  }
}

abstract class ZMultiChildWidget extends MultiChildRenderObjectWidget
    with ZWidget {
  ZMultiChildWidget({required List<Widget> children})
      : super(children: children);

  @override
  RenderMultiChildZBox createRenderObject(BuildContext context) {
    return RenderMultiChildZBox();
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderMultiChildZBox renderObject) {}

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }

  @override
  ZMultiChildRenderObjectElement createElement() =>
      ZMultiChildRenderObjectElement(this);
}

class ZMultiChildRenderObjectElement extends MultiChildRenderObjectElement {
  /// Creates an element that uses the given widget as its configuration.
  ZMultiChildRenderObjectElement(MultiChildRenderObjectWidget widget)
      : assert(!debugChildrenHaveDuplicateKeys(widget, widget.children)),
        super(widget);

  @override
  void attachRenderObject(newSlot) {
    super.attachRenderObject(newSlot);

    visitAncestorElements((element) {
      if (element is UpdateParentDataElement<ZParentData>) {
        element.startParentData(renderObject);
      }
      return element.widget is! RenderObjectWidget;
    });
  }
}
