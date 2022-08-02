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
        element.startParentData(renderObject, element.transform);
      }
      return element.widget is! RenderObjectWidget;
    });
  }
}

abstract class ZMultiChildWidget extends MultiChildRenderObjectWidget
    with ZWidget {
  ZMultiChildWidget({required List<Widget> children}) : super(children: children);

  @override
  RenderZMultiChildBox createRenderObject(BuildContext context) {
    return RenderZMultiChildBox();
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderZMultiChildBox renderObject) {}

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    /* properties.add(EnumProperty<AxisDirection>('axisDirection', axisDirection));
   properties.add(EnumProperty<AxisDirection>('crossAxisDirection', crossAxisDirection, defaultValue: null));
   properties.add(DiagnosticsProperty<ViewportOffset>('offset', offset));*/
  }

  @override
  AnchorMultipleChildRenderObjectElement createElement() =>
      AnchorMultipleChildRenderObjectElement(this);
}

class AnchorMultipleChildRenderObjectElement
    extends MultiChildRenderObjectElement {
  /// Creates an element that uses the given widget as its configuration.
  AnchorMultipleChildRenderObjectElement(MultiChildRenderObjectWidget widget)
      : assert(!debugChildrenHaveDuplicateKeys(widget, widget.children)),
        super(widget);

  @override
  void attachRenderObject(newSlot) {
    super.attachRenderObject(newSlot);

    visitAncestorElements((element) {
      if (element is UpdateParentDataElement<ZParentData>) {
        element.startParentData(renderObject, element.transform);
      }
      return element.widget is! RenderObjectWidget;
    });
  }
}
