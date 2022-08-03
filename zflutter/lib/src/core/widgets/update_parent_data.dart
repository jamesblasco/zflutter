//@dart=2.12
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zflutter/src/core/core.dart';

abstract class ZUpdateParentDataWidget<T extends ParentData>
    extends ProxyWidget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const ZUpdateParentDataWidget({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  UpdateParentDataElement<T> createElement() =>
      UpdateParentDataElement<T>(this);

  /// Checks if this widget can apply its parent data to the provided
  /// `renderObject`.
  ///
  /// The [RenderObject.parentData] of the provided `renderObject` is
  /// typically set up by an ancestor [RenderObjectWidget] of the type returned
  /// by [debugTypicalAncestorWidgetClass].
  ///
  /// This is called just before [applyParentData] is invoked with the same
  /// [RenderObject] provided to that method.
  bool debugIsValidRenderObject(RenderObject renderObject) {
    assert(T != dynamic);
    assert(T != ParentData);
    return renderObject.parentData is T;
  }

  /// The [RenderObjectWidget] that is typically used to set up the [ParentData]
  /// that [applyParentData] will write to.
  ///
  /// This is only used in error messages to tell users what widget typically
  /// wraps this ParentDataWidget.
  Type get debugTypicalAncestorWidgetClass;

// TODO: Implement this
//  Iterable<DiagnosticsNode> _debugDescribeIncorrectParentDataType({
//    @required ParentData parentData,
//    RenderObjectWidget parentDataCreator,
//    DiagnosticsNode ownershipChain,
//  }) sync* {
//    assert(T != dynamic);
//    assert(T != ParentData);
//    assert(debugTypicalAncestorWidgetClass != null);
//
//    final String description = 'The ParentDataWidget $this wants to apply ParentData of type $T to a RenderObject';
//    if (parentData == null) {
//      yield ErrorDescription(
//          '$description, which has not been set up to receive any ParentData.'
//      );
//    } else {
//      yield ErrorDescription(
//          '$description, which has been set up to accept ParentData of incompatible type ${parentData.runtimeType}.'
//      );
//    }
//    yield ErrorHint(
//        'Usually, this means that the $runtimeType widget has the wrong ancestor RenderObjectWidget. '
//            'Typically, $runtimeType widgets are placed directly inside $debugTypicalAncestorWidgetClass widgets.'
//    );
//    if (parentDataCreator != null) {
//      yield ErrorHint(
//          'The offending $runtimeType is currently placed inside a ${parentDataCreator.runtimeType} widget.'
//      );
//    }
//    if (ownershipChain != null) {
//      yield ErrorDescription(
//          'The ownership chain for the RenderObject that received the incompatible parent data was:\n  $ownershipChain'
//      );
//    }
//  }

  /// Write the data from this widget into the given core object's parent data.
  ///
  /// The framework calls this function whenever it detects that the
  /// [RenderObject] associated with the [child] has outdated
  /// [RenderObject.parentData]. For example, if the core object was recently
  /// inserted into the core tree, the core object's parent data might not
  /// match the data in this widget.
  ///
  /// Subclasses are expected to override this function to copy data from their
  /// fields into the [RenderObject.parentData] field of the given core
  /// object. The core object's parent is guaranteed to have been created by a
  /// widget of type `T`, which usually means that this function can assume that
  /// the core object's parent data object inherits from a particular class.
  ///
  /// If this function modifies data that can change the parent's layout or
  /// painting, this function is responsible for calling
  /// [RenderObject.markNeedsLayout] or [RenderObject.markNeedsPaint] on the
  /// parent, as appropriate.
  @protected
  void updateParentData(RenderObject renderObject,
      covariant ZUpdateParentDataWidget<T> oldWidget, ZTransform transform);

  @protected
  void startParentData(RenderObject renderObject, ZTransform transform);

  /// Whether the [ParentDataElement.applyWidgetOutOfTurn] method is allowed
  /// with this widget.
  ///
  /// This should only return true if this widget represents a [ParentData]
  /// configuration that will have no impact on the layout or paint phase.
  ///
  /// See also:
  ///
  ///  * [ParentDataElement.applyWidgetOutOfTurn], which verifies this in debug
  ///    mode.
  @protected
  bool debugCanApplyOutOfTurn() => false;
}

/// An [Element] that uses a [ParentDataWidget] as its configuration.
class UpdateParentDataElement<T extends ParentData> extends ProxyElement {
  /// Creates an element that uses the given widget as its configuration.
  UpdateParentDataElement(ZUpdateParentDataWidget<T> widget) : super(widget);

  @override
  ZUpdateParentDataWidget<T> get widget =>
      super.widget as ZUpdateParentDataWidget<T>;

  ZTransform transform = ZTransform();

  void _updateParentData(
      ZUpdateParentDataWidget<T> widget, ZUpdateParentDataWidget<T> oldWidget) {
    void applyParentDataToChild(Element child) {
      if (child is RenderObjectElement) {
        widget.updateParentData(child.renderObject, oldWidget, transform);
      } else {
        child.visitChildren(applyParentDataToChild);
      }
    }

    visitChildren(applyParentDataToChild);
  }

  void startParentData(RenderObject renderObject) {
    widget.startParentData(renderObject, transform);
  }

  /// Calls [ParentDataWidget.applyParentData] on the given widget, passing it
  /// the [RenderObject] whose parent data this element is ultimately
  /// responsible for.
  ///
  /// This allows a core object's [RenderObject.parentData] to be modified
  /// without triggering a build. This is generally ill-advised, but makes sense
  /// in situations such as the following:
  ///
  ///  * Build and layout are currently under way, but the [ParentData] in question
  ///    does not affect layout, and the value to be applied could not be
  ///    determined before build and layout (e.g. it depends on the layout of a
  ///    descendant).
  ///
  ///  * Paint is currently under way, but the [ParentData] in question does not
  ///    affect layout or paint, and the value to be applied could not be
  ///    determined before paint (e.g. it depends on the compositing phase).
  ///
  /// In either case, the next build is expected to cause this element to be
  /// configured with the given new widget (or a widget with equivalent data).
  ///
  /// Only [ParentDataWidget]s that return true for
  /// [ParentDataWidget.debugCanApplyOutOfTurn] can be applied this way.
  ///
  /// The new widget must have the same child as the current widget.
  ///
  /// An example of when this is used is the [AutomaticKeepAlive] widget. If it
  /// receives a notification during the build of one of its descendants saying
  /// that its child must be kept alive, it will apply a [KeepAlive] widget out
  /// of turn. This is safe, because by definition the child is already alive,
  /// and therefore this will not change the behavior of the parent this frame.
  /// It is more efficient than requesting an additional frame just for the
  /// purpose of updating the [KeepAlive] widget.
  void applyWidgetOutOfTurn(ZUpdateParentDataWidget<T> newWidget) {
    assert(newWidget.debugCanApplyOutOfTurn());
    assert(newWidget.child == widget.child);
    _updateParentData(newWidget, widget);
  }

  @override
  void notifyClients(ZUpdateParentDataWidget<T> oldWidget) {
    _updateParentData(widget, oldWidget);
  }
}
