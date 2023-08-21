import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

const tileHeight = 60.0;

const titleDepth = 2.0;

const depth = 40.0;
const floatingButtonSize = 56.0;
const floatingButtonMargin = kFloatingActionButtonMargin;

const zStart = 150.0;
const zFloatingButtonStart = 300.0;

class Ui3D extends StatefulWidget {
  @override
  _ZUiState createState() => _ZUiState();
}

class _ZUiState extends State<Ui3D> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    Future.delayed(Duration(seconds: 3),
        () => {animationController?.repeat(reverse: true)});

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(
        parent: animationController!, curve: Curves.easeInOutSine);

    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Material(
      color: Colors.black,
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (context, _) {
          final progress = 1 - curve.value;
          final appBarProgress =
              Interval(0, 0.4).transformInternal(1 - progress);
          final rotate = Interval(0, 0.9, curve: Curves.easeOutCubic)
              .transformInternal(1 - progress);
          final tileProgress = Interval(0.8, 1).transformInternal(1 - progress);
          final appBar = kToolbarHeight + MediaQuery.of(context).padding.top;
          return ZIllustration(
            children: <Widget>[
              ZPositioned(
                rotate: ZVector.only(
                    x: -(rotate) * tau / 30, y: (rotate) * tau / 4.5),
                scale: ZVector.all(max(0.7, 1 - rotate)),
                child: ZGroup(
                  sortMode: SortMode.stack,
                  children: <Widget>[
                    ZRect(
                      height: height,
                      width: width,
                      fill: true,
                      color: Colors.white.withOpacity(max(0, progress) * 0.5),
                    ),
                    ZGroup(
                      sortMode: SortMode.update,
                      children: <Widget>[
                        ZPositioned(
                            translate: ZVector(0, -height / 2 + appBar / 2,
                                zStart * appBarProgress),
                            child: ZAppBar()),
                        ZPositioned(
                            translate: ZVector(
                                width / 2 -
                                    floatingButtonSize / 2 -
                                    floatingButtonMargin,
                                height / 2 -
                                    floatingButtonSize / 2 -
                                    mediaQuery.padding.bottom -
                                    floatingButtonMargin,
                                zFloatingButtonStart * appBarProgress),
                            child: ZFloatingButton()),
                        ZGroup(
                          sortMode: SortMode.update,
                          children: <Widget>[
                            ...List.generate(11, (index) {
                              final top = -height / 2 + appBar;
                              return ZPositioned(
                                  translate: ZVector(
                                      0,
                                      top + index * tileHeight + tileHeight / 2,
                                      (-100 + (1 * index) * 20) * tileProgress +
                                          appBarProgress * 10),
                                  child: ZListTile(
                                    index: index,
                                  ));
                            })
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class ZAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final appBar = kToolbarHeight + MediaQuery.of(context).padding.top;
    return ZGroup(
      children: <Widget>[
        ZPositioned(
          translate: ZVector(0, 0, -depth / 2 - 1),
          child: ZBox(
            height: appBar,
            width: width,
            depth: depth,
            color: Colors.blueAccent[400]!,
          ),
        ),
        ZToBoxAdapter(
            height: appBar,
            width: width,
            child: AppBar(
              title: Text('3D'),
            )),
      ],
    );
  }
}

class ZFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZGroup(
      children: <Widget>[
        ZPositioned(
            translate: ZVector(0, 0, -depth / 2 - 1),
            child: ZCylinder(
              diameter: floatingButtonSize,
              length: depth,
              color: Colors.blueAccent[400]!,
            )),
        ZToBoxAdapter(
          height: floatingButtonSize,
          width: floatingButtonSize,
          child: FloatingActionButton(
            elevation: 0,
            child: Icon(Icons.threed_rotation),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class ZListTile extends StatelessWidget {
  final int? index;

  const ZListTile({Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ZGroup(
      children: <Widget>[
        ZPositioned(
            translate: ZVector(0, 0, -titleDepth / 2 - 1),
            child: ZBox(
              depth: titleDepth / 2,
              height: tileHeight,
              width: width,
              color: Colors.grey[100]!,
            )),
        ZToBoxAdapter(
          height: tileHeight,
          width: width,
          child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text('Item $index'),
              )),
        ),
      ],
    );
  }
}
