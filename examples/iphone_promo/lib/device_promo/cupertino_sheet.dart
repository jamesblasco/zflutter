import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoShareBottomSheet extends StatelessWidget {
  final ScrollController scrollController;

  const PhotoShareBottomSheet({Key key, this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
            color: Colors.transparent,
            child: Scaffold(
              backgroundColor: CupertinoTheme.of(context)
                  .scaffoldBackgroundColor
                  .withOpacity(0.95),
              extendBodyBehindAppBar: true,
              appBar: appBar(context),
              body: CustomScrollView(
                physics: ClampingScrollPhysics(),
                controller: scrollController,
                slivers: <Widget>[
                  SliverSafeArea(
                    bottom: false,
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        height: 318,
                        child: ListView(
                          padding: EdgeInsets.all(12).copyWith(
                              right:
                                  MediaQuery.of(context).size.width / 2 - 100),
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          physics: PageScrollPhysics(),
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Hero(
                                      tag: 'image',
                                      child:
                                          Image.asset('assets/demo_image.jpeg'),
                                    ))),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset('assets/demo_image.jpeg'),
                                )),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset('assets/demo_image.jpeg'),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Divider(height: 1),
                  ),
                  sliverContactsSection(context),
                  SliverToBoxAdapter(
                    child: Divider(height: 1),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 120,
                      padding: EdgeInsets.only(top: 12),
                      child: ListView.builder(
                        padding: EdgeInsets.all(10),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final app = apps[index];
                          return Container(
                              width: 72,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                children: <Widget>[
                                  Material(
                                    child: ClipRRect(
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(app.imageUrl),
                                                fit: BoxFit.cover),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    elevation: 12,
                                    shadowColor: Colors.black12,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    app.title,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11),
                                  )
                                ],
                              ));
                        },
                        itemCount: apps.length,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    sliver: SliverContainer(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed(
                              List<Widget>.from(actions.map(
                            (action) => Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: Text(
                                  action.title,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle,
                                )),
                          )).addItemInBetween(Divider(
                            height: 1,
                          ))),
                        )),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    sliver: SliverContainer(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed(
                              List<Widget>.from(actions1.map(
                            (action) => Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: Text(
                                  action.title,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle,
                                )),
                          )).addItemInBetween(Divider(
                            height: 1,
                          ))),
                        )),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    sliver: SliverContainer(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed(
                              List<Widget>.from(actions2.map(
                            (action) => Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: Text(
                                  action.title,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle,
                                )),
                          )).addItemInBetween(Divider(
                            height: 1,
                          ))),
                        )),
                  ),
                  SliverSafeArea(
                    top: false,
                    sliver: SliverPadding(
                        padding: EdgeInsets.only(
                      bottom: 20,
                    )),
                  )
                ],
              ),
            )));
  }

  Widget sliverContactsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 132,
        padding: EdgeInsets.only(top: 12),
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final person = people[index];
            return Container(
              width: 72,
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: <Widget>[
                  Material(
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        person.imageUrl,
                      ),
                      radius: 30,
                      backgroundColor: Colors.white,
                    ),
                    shape: CircleBorder(),
                    elevation: 12,
                    shadowColor: Colors.black12,
                  ),
                  SizedBox(height: 8),
                  Text(
                    person.title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
            );
          },
          itemCount: people.length,
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 74),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: CupertinoTheme.of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.8),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 18),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/demo_image.jpeg',
                            fit: BoxFit.cover,
                            height: 40,
                            width: 40,
                          )),
                      SizedBox(width: 12),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            '1 Photo selected',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  'Options',
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .actionTextStyle
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  CupertinoIcons.right_chevron,
                                  size: 14,
                                  color:
                                      CupertinoTheme.of(context).primaryColor,
                                )
                              ]),
                        ],
                      )),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 14),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                    ],
                  ),
                ),
                Divider(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Item {
  final String title;
  final String imageUrl;

  Item(this.title, this.imageUrl);
}

final people = [
  Item('MacBook Pro', 'assets/MacBook.jpg'),
  Item('Jaime Blasco', 'assets/jaimeblasco.jpeg'),
  Item('Mya Johnston', 'assets/person1.jpeg'),
  // https://images.unsplash.com/photo-1520813792240-56fc4a3765a7'
  Item('Maxime Nicholls', 'assets/person4.jpeg'),
  //https://images.unsplash.com/photo-1568707043650-eb03f2536825'
  Item('Susanna Thorne', 'assets/person2.jpeg'),
  //https://images.unsplash.com/photo-1520719627573-5e2c1a6610f0
  Item('Jarod Aguilar', 'assets/person3.jpeg')
  //https://images.unsplash.com/photo-1547106634-56dcd53ae883
];

final apps = [
  Item('Messages', 'assets/message.png'),
  Item('Github', 'assets/github_app.png'),
  Item('Slack', 'assets/slack.png'),
  Item('Twitter', 'assets/twitter.png'),
  Item('Mail', 'assets/mail.png'),
];

final actions = [
  Item('Copy Photo', null),
];
final actions1 = [
  Item('Add to Shared Album', null),
  Item('Add to Album', null),
  Item('Duplicate', null),
  Item('Hide', null),
  Item('Slideshow', null),
  Item('AirPlay', null),
  Item('Use as Wallpaper', null),
];

final actions2 = [
  Item('Create Watch', null),
  Item('Save to Files', null),
  Item('Asign to Contact', null),
  Item('Print', null),
];

extension ListUtils<T> on List<T> {
  List<T> addItemInBetween<T>(T item) => this.length == 0
      ? this
      : (this.fold([], (r, element) => [...r, element as T, item])
        ..removeLast());
}

class SimpleSliverDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SimpleSliverDelegate({
    this.child,
    this.height,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

@immutable
class SliverContainer extends RenderObjectWidget {
  SliverContainer(
      {Key key,
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero,
      this.borderRadius,
      this.decoration,
      this.foregroundDecoration,
      this.sliver})
      : super(key: key);

  final EdgeInsets margin;

  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final Decoration decoration;
  final Decoration foregroundDecoration;
  final Widget sliver;

  Widget get child => SliverPadding(padding: padding + margin, sliver: sliver);

  Container get backgroundDecorationBox => Container(decoration: decoration);

  Container get foregroundDecorationBox =>
      Container(decoration: foregroundDecoration);

  @override
  _RenderSliverGroup createRenderObject(BuildContext context) {
    return _RenderSliverGroup(
        margin: this.margin, borderRadius: this.borderRadius, padding: padding);
  }

  @override
  _SliverGroupElement createElement() => _SliverGroupElement(this);

  @override
  void updateRenderObject(
      BuildContext context, _RenderSliverGroup renderObject) {
    renderObject
      ..margin = margin
      ..padding = padding
      ..borderRadius = borderRadius;
  }
}

class _SliverGroupElement extends RenderObjectElement {
  _SliverGroupElement(SliverContainer widget) : super(widget);

  Element _backgroundDecoration;
  Element _foregroundDecoration;
  Element _sliver;

  @override
  SliverContainer get widget => super.widget;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_backgroundDecoration != null) visitor(_backgroundDecoration);
    if (_foregroundDecoration != null) visitor(_foregroundDecoration);
    if (_sliver != null) visitor(_sliver);
  }

  @override
  void forgetChild(Element child) {
    if (child == _backgroundDecoration) _backgroundDecoration = null;
    if (child == _foregroundDecoration) _foregroundDecoration = null;
    if (child == _sliver) _sliver = null;
    super.forgetChild(child);
  }

  @override
  void mount(Element parent, newSlot) {
    super.mount(parent, newSlot);
    _backgroundDecoration =
        updateChild(_backgroundDecoration, widget.backgroundDecorationBox, 0);
    _foregroundDecoration =
        updateChild(_foregroundDecoration, widget.foregroundDecorationBox, 1);
    _sliver = updateChild(_sliver, widget.child, 2);
  }

  @override
  void update(RenderObjectWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _backgroundDecoration =
        updateChild(_backgroundDecoration, widget.backgroundDecorationBox, 0);
    _foregroundDecoration =
        updateChild(_foregroundDecoration, widget.foregroundDecorationBox, 1);
    _sliver = updateChild(_sliver, widget.child, 2);
  }

  @override
  void insertChildRenderObject(RenderObject child, int slot) {
    final _RenderSliverGroup renderObject = this.renderObject;
    if (slot == 0) renderObject.decoration = child;
    if (slot == 1) renderObject.foregroundDecoration = child;
    if (slot == 2) renderObject.child = child;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveChildRenderObject(RenderObject child, slot) {
    assert(false);
  }

  @override
  void removeChildRenderObject(RenderObject child) {
    final _RenderSliverGroup renderObject = this.renderObject;
    if (renderObject.decoration == child) renderObject.decoration = null;
    if (renderObject.foregroundDecoration == child)
      renderObject.foregroundDecoration = null;
    if (renderObject.child == child) renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}

class _RenderSliverGroup extends RenderSliver with RenderSliverHelpers {
  _RenderSliverGroup(
      {EdgeInsetsGeometry margin,
      EdgeInsetsGeometry padding,
      BorderRadius borderRadius,
      RenderBox decoration,
      RenderBox foregroundDecoration,
      RenderSliver child}) {
    this.margin = margin;
    this.padding = padding;
    this.borderRadius = borderRadius;
    this.foregroundDecoration = foregroundDecoration;
    this.decoration = decoration;
    this.child = child;
  }

  RRect _clipRRect;

  EdgeInsetsGeometry get padding => _padding;
  EdgeInsetsGeometry _padding;

  set padding(EdgeInsetsGeometry value) {
    assert(value != null);
    assert(value.isNonNegative);
    if (_padding == value) return;
    _padding = value;
    markNeedsLayout();
  }

  EdgeInsetsGeometry get margin => _margin;
  EdgeInsetsGeometry _margin;

  set margin(EdgeInsetsGeometry value) {
    assert(value != null);
    assert(value.isNonNegative);
    if (_margin == value) return;
    _margin = value;
    markNeedsLayout();
  }

  BorderRadiusGeometry get borderRadius => _borderRadius;
  BorderRadiusGeometry _borderRadius;

  set borderRadius(BorderRadiusGeometry value) {
    if (value == _borderRadius) return;
    _borderRadius = value;
    markNeedsPaint();
  }

  RenderBox get decoration => _decoration;
  RenderBox _decoration;

  set decoration(RenderBox value) {
    if (_decoration != null) dropChild(_decoration);
    _decoration = value;
    if (_decoration != null) adoptChild(_decoration);
  }

  RenderBox get foregroundDecoration => _foregroundDecoration;
  RenderBox _foregroundDecoration;

  set foregroundDecoration(RenderBox value) {
    if (_foregroundDecoration != null) dropChild(_foregroundDecoration);
    _foregroundDecoration = value;
    if (_foregroundDecoration != null) adoptChild(_foregroundDecoration);
  }

  RenderSliver get child => _child;
  RenderSliver _child;

  set child(RenderSliver value) {
    if (_child != null) dropChild(_child);
    _child = value;
    if (_child != null) adoptChild(_child);
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData)
      child.parentData = new SliverPhysicalParentData();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_decoration != null) _decoration.attach(owner);
    if (_child != null) _child.attach(owner);
    if (_foregroundDecoration != null) _foregroundDecoration.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    if (_decoration != null) _decoration.detach();
    if (_child != null) _child.detach();
    if (_foregroundDecoration != null) _foregroundDecoration.detach();
  }

  @override
  void redepthChildren() {
    if (_decoration != null) redepthChild(_decoration);
    if (_child != null) redepthChild(_child);
    if (_foregroundDecoration != null) redepthChild(_foregroundDecoration);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_decoration != null) visitor(_decoration);
    if (_child != null) visitor(_child);
    if (_foregroundDecoration != null) visitor(_foregroundDecoration);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    List<DiagnosticsNode> result = <DiagnosticsNode>[];
    if (decoration != null) {
      result.add(decoration.toDiagnosticsNode(name: 'decoration'));
    }
    if (foregroundDecoration != null) {
      result.add(foregroundDecoration.toDiagnosticsNode(
          name: 'foreground_decoration'));
    }
    if (child != null) {
      result.add(child.toDiagnosticsNode(name: 'child'));
    }
    return result;
  }

  @override
  bool hitTestChildren(HitTestResult result,
      {double mainAxisPosition, double crossAxisPosition}) {
    assert(geometry.hitTestExtent > 0.0);
    return child.hitTest(result,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition);
  }

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry();
      return;
    }
    // child not null
    AxisDirection axisDirection = applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection);
    // layout sliver
    child.layout(constraints, parentUsesSize: true);
    final SliverGeometry childLayoutGeometry = child.geometry;
    geometry = childLayoutGeometry;

    // layout decoration with child size + margin
    //Todo: Support rtl
    EdgeInsets margin = this.margin.resolve(TextDirection.ltr);
    final maxExtent = childLayoutGeometry.maxPaintExtent - margin.horizontal;
    final crossAxisExtent = constraints.crossAxisExtent - margin.vertical;
    if (decoration != null) {
      decoration.layout(
          constraints.asBoxConstraints(
              maxExtent: maxExtent, crossAxisExtent: crossAxisExtent),
          parentUsesSize: true);
    }
    if (foregroundDecoration != null) {
      foregroundDecoration.layout(
          constraints.asBoxConstraints(
              maxExtent: maxExtent, crossAxisExtent: crossAxisExtent),
          parentUsesSize: true);
    }
    // compute decoration offset

    final SliverPhysicalParentData headerParentData = decoration.parentData;
    final SliverPhysicalParentData foregroundParentData =
        foregroundDecoration.parentData;
    double scrollOffset = -constraints.scrollOffset;
    Offset offset;
    switch (axisDirection) {
      case AxisDirection.up:
        offset = Offset(0.0, geometry.paintExtent);
        break;
      case AxisDirection.down:
        offset = Offset(0, scrollOffset);
        break;
      case AxisDirection.left:
        offset = Offset(geometry.paintExtent, 0.0);
        break;
      case AxisDirection.right:
        offset = Offset.zero;
        break;
    }
    offset += Offset(margin.left, margin.top);
    headerParentData.paintOffset = offset;
    foregroundParentData.paintOffset = offset;

    //compute child clip
    if (this.borderRadius != null) {
      BorderRadius borderRadius = this.borderRadius.resolve(TextDirection.ltr);
      _clipRRect = borderRadius.toRRect(Rect.fromLTRB(
          0, 0, constraints.crossAxisExtent, geometry.maxPaintExtent));
      double offSetY = scrollOffset;
      _clipRRect = _clipRRect.shift(Offset(0, offSetY));
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child != null);
    final SliverPhysicalParentData childParentData = child.parentData;
    childParentData.applyPaintTransform(transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (geometry.visible) {
      // paint decoration
      if (decoration != null) {
        final SliverPhysicalParentData childParentData = decoration.parentData;
        context.paintChild(decoration, offset + childParentData.paintOffset);
      }
      // paint child
      if (child != null && child.geometry.visible) {
        final SliverPhysicalParentData childParentData = child.parentData;
        final PaintingContextCallback painter =
            (PaintingContext context, Offset offset) {
          context.paintChild(child, offset);
        };
        if (_clipRRect != null && _clipRRect != RRect.zero) {
          context.pushClipRRect(
            needsCompositing,
            offset + childParentData.paintOffset,
            _clipRRect.outerRect,
            _clipRRect,
            painter,
          );
        } else {
          painter(context, offset + childParentData.paintOffset);
        }
      }
      if (foregroundDecoration != null) {
        final SliverPhysicalParentData childParentData =
            foregroundDecoration.parentData;
        context.paintChild(
            foregroundDecoration, offset + childParentData.paintOffset);
      }
    }
  }
}
