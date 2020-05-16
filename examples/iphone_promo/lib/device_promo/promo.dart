import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zflutter/zflutter.dart';

import 'device.dart';
import 'modal_bottom_sheet.dart';

class DeviceStyle {
  final Color color;
  final Color backgroundColor;
  final Color shadow;

  DeviceStyle(this.color, this.backgroundColor, this.shadow);
}

class DeviceStyles {
  static final red = DeviceStyle(
      Color(0xff92011E), Color(0xff9F072B), Colors.black.withOpacity(0.4));
  static final white = DeviceStyle(
      Color(0xffD8DCDB), Color(0xffC1C8C8), Colors.black.withOpacity(0.4));
  static final black = DeviceStyle(
      Color(0xff222325), Color(0xff0B0B0C), Colors.black.withOpacity(0.4));
}

class IPhonePromo extends StatelessWidget {
  final DeviceStyle style;
  final double progress;
  final Color backgroundColor;

  IPhonePromo(
      {Key key, DeviceStyle style, this.progress = 1, Color backgroundColor})
      : this.style = style ?? DeviceStyles.black,
        this.backgroundColor = backgroundColor ?? style.backgroundColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.stack,
      children: [
        ZToBoxAdapter(
          width: MediaQuery.of(context).size.width * 2,
          height: MediaQuery.of(context).size.height *2,
          child: Container(
            color: style.backgroundColor,
          ),
        ),
        ZGroup(
          sortMode: SortMode.update,
          children: [
            ZPositioned(
              child: ZPositioned(
                rotate: ZVector.only(z: -tau / 4, x: -tau / 4 - tau / 20),
                child: ZPositioned(
                  translate: ZVector.only(y: (1 - progress) * 100),
                  child: Device(
                    border: 10,
                    color: style.color,
                    /* child: CupertinoTabView(
                  onGenerateRoute: (settings) {
                    return MaterialWithModalsPageRoute(
                        settings: settings,
                        builder: (context) => ModalBottomSheetExample());
                  },
                ),*/
                  ),
                ),
              ),
            )
          ],
        ),
        ZPositioned(
          scale: ZVector.all(1.2),
          translate: ZVector.only(x: 300),
          child: ZPositioned(
            rotate: ZVector.only(z: -tau / 4, x: -tau / 4 - tau / 20),
            child: ZToBoxAdapter(
                width: 60.6,
                height: 250,
                child: Container(
                    decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: style.shadow.withOpacity(progress * 0.4),
                      blurRadius: 50,
                      spreadRadius: 0)
                ]))),
          ),
        ),
        ZToBoxAdapter(
          width: MediaQuery.of(context).size.width * 2,
          height: MediaQuery.of(context).size.height *2,
          child: Container(
            color: style.backgroundColor.withOpacity(1 - progress),
          ),
        ),
      ],
    );
  }
}

class IPhonePromoFinal extends StatelessWidget {
  final DeviceStyle style;
  final double progress;
  final Color backgroundColor;

  IPhonePromoFinal(
      {Key key, DeviceStyle style, this.progress = 1, Color backgroundColor})
      : this.style = style ?? DeviceStyles.black,
        this.backgroundColor = backgroundColor ?? style.backgroundColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.stack,
      children: [
        ZToBoxAdapter(
          width: MediaQuery.of(context).size.width * 2,
          height: MediaQuery.of(context).size.height *2,
          child: Container(color: backgroundColor),
        ),
        ZPositioned(
          scale: ZVector.all(1.2),
          translate: ZVector.only(x: 400),
          child: ZPositioned(
            rotate: ZVector.only(z: -tau / 4, x: -tau / 4 - tau / 20),
            child: ZToBoxAdapter(
                width: 80,
                height: 100,
                child: Container(
                    decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: style.shadow.withOpacity(progress * 0.4),
                      blurRadius: 50,
                      spreadRadius: 0)
                ]))),
          ),
        ),
        ZPositioned(
          child: ZPositioned(
            child: ZToBoxAdapter(
                width: 200,
                height: 300,
                child: Container(
                    decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: style.shadow.withOpacity(0.02),
                      blurRadius: 50,
                      spreadRadius: 0)
                ]))),
          ),
        ),
        ZGroup(
          sortMode: SortMode.update,
          children: [
            ZPositioned(
              scale: ZVector.all(0.8 * progress + (1 - progress) * 4),
              translate: ZVector.only(y: (1 - progress) * 300),
              rotate: ZVector.only(y: -tau / 2, x: (1 - progress) * tau / 4),
              child: Device(
                color: style.color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class IPhonePromoRotate extends StatelessWidget {
  final DeviceStyle style;
  final double progress;
  final Color backgroundColor;

  IPhonePromoRotate(
      {Key key, DeviceStyle style, this.progress = 1, Color backgroundColor})
      : this.style = style ?? DeviceStyles.black,
        this.backgroundColor = backgroundColor ?? style.backgroundColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.stack,
      children: [
        ZToBoxAdapter(
          width: MediaQuery.of(context).size.width * 2 ,
          height: MediaQuery.of(context).size.height *2,
          child: Container(color: backgroundColor),
        ),
        ZGroup(
          sortMode: SortMode.update,
          children: [
            ZPositioned(
                translate: ZVector.only(
                    x: -(1 - progress) * 80 + progress * 120, z: -150),
                rotate: ZVector.only(
                    y: tau / 2 -
                        (1 - progress) * tau / 6 +
                        progress * tau / 10),
                child: ZGroup(sortMode: SortMode.update, children: [
                  ZPositioned(
                      scale: ZVector.all(1.2),
                      rotate: ZVector.only(
                          x: (1 - progress) * (-tau / 12) +
                              progress * (-tau / 20)),
                      child: ZPositioned(
                        translate: ZVector.all(60),
                        child: Device(
                          color: style.color,
                          /* child: CupertinoTabView(
                  onGenerateRoute: (settings) {
                    return MaterialWithModalsPageRoute(
                        settings: settings,
                        builder: (context) => ModalBottomSheetExample());
                  },
                ),*/
                        ),
                      ))
                ])),
          ],
        ),
      ],
    );
  }
}

class IPhonePromoRotateItself extends StatelessWidget {
  final DeviceStyle style;
  final double progress;
  final Color backgroundColor;
  final Widget child;

  IPhonePromoRotateItself(
      {Key key,
      DeviceStyle style,
      this.progress = 1,
      Color backgroundColor,
      this.child})
      : this.style = style ?? DeviceStyles.black,
        this.backgroundColor = backgroundColor ?? style.backgroundColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.stack,
      children: [
        ZToBoxAdapter(
          width: MediaQuery.of(context).size.width * 2,
          height: MediaQuery.of(context).size.height *2,
          child: Container(
            color: style.backgroundColor,
          ),
        ),
        ZGroup(
          sortMode: SortMode.update,
          children: [
            ZPositioned(
                rotate: ZVector.only(y: -(1 - progress) * tau * 3.5),
                child: ZGroup(sortMode: SortMode.update, children: [
                  ZPositioned(
                      scale: ZVector.all(0.5 + 0.5 * progress),
                      child: ZPositioned(
                        child: Device(color: style.color, child: child),
                      ))
                ])),
          ],
        ),
        ZPositioned(
          scale: ZVector.all(1.2),
          translate: ZVector.only(x: 301),
          child: ZPositioned(
            rotate: ZVector.only(z: -tau / 4, x: -tau / 4 - tau / 20),
            child: ZToBoxAdapter(
              width: 2000,
              height: 2000,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 1000,
                  height: 1000,
                  color: backgroundColor.withOpacity(max(0, 0 - progress * 2)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SceneSide extends StatelessWidget {
  final DeviceStyle style;
  final double progress;
  final Color backgroundColor;
  final Widget child;

  SceneSide(
      {Key key,
      DeviceStyle style,
      this.progress = 1,
      Color backgroundColor,
      this.child})
      : this.style = style ?? DeviceStyles.black,
        this.backgroundColor = backgroundColor ?? style.backgroundColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.stack,
      children: [
        ZGroup(
          sortMode: SortMode.update,
          children: [
            ZPositioned(
                scale: ZVector.only(x: 1.2, y: 1, z: 1),
                rotate: ZVector.only(y: tau / 2, x: tau / 4),
                child: ZGroup(sortMode: SortMode.update, children: [
                  Device(color: style.color, child: child),
                ])),
          ],
        ),
      ],
    );
  }
}

class IPhonePromoFlick extends StatelessWidget {
  final DeviceStyle style;
  final double progress;
  final Color backgroundColor;
  final Widget child;

  IPhonePromoFlick(
      {Key key,
      DeviceStyle style,
      this.progress = 1,
      Color backgroundColor,
      this.child})
      : this.style = style ?? DeviceStyles.black,
        this.backgroundColor = backgroundColor ?? style.backgroundColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.stack,
      children: [
        ZToBoxAdapter(
          width: MediaQuery.of(context).size.width * 2,
          height: MediaQuery.of(context).size.height *2,
          child: Container(color: backgroundColor),
        ),
        ZGroup(
          sortMode: SortMode.stack,
          children: [
            ZPositioned(
              translate: ZVector.only(y: 80, z: -1000, x: 10),
              rotate: ZVector.only(y: tau / 4 + tau / 15),
              scale: ZVector.only(x: 1.8, y: 1.2, z: 1.8),
              child: ZPositioned(
                child: ZToBoxAdapter(
                    width: 138.6,
                    height: 320,
                    child: Container(
                        decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: style.shadow.withOpacity(0.2),
                          blurRadius: 120,
                          spreadRadius: 7)
                    ]))),
              ),
            ),
            ZPositioned(
                child: ZGroup(sortMode: SortMode.update, children: [
              ZPositioned(
                  translate: ZVector.only(y: 80),
                  rotate: ZVector.only(y: tau / 4 + tau / 15),
                  scale: ZVector.only(x: 1.8, y: 1.2, z: 1.8),
                  child: ZPositioned(
                    child: Device(
                      color: style.color,
                      child: child,
                      zoom: 1.8,
                    ),
                  ))
            ])),
            ZPositioned(
              translate: ZVector.only(y: 80, z: 0, x: 80),
              rotate: ZVector.only(y: tau / 4 + tau / 15),
              scale: ZVector.only(x: 1.8, y: 1.2, z: 1.8),
              child: ZPositioned(
                child: ZToBoxAdapter(
                    width: 138.6,
                    height: 320,
                    child: Container(
                        decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: style.shadow.withOpacity(0.05),
                          blurRadius: 120,
                          spreadRadius: 4)
                    ]))),
              ),
            ),
          ],
        ),
        ZPositioned(
          scale: ZVector.all(1.2),
          translate: ZVector.only(x: 301),
          child: ZPositioned(
            rotate: ZVector.only(z: -tau / 4, x: -tau / 4 - tau / 20),
            child: ZToBoxAdapter(
              width: 2000,
              height: 2000,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 1000,
                  height: 1000,
                  color: backgroundColor.withOpacity(max(0, 0 - progress * 2)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
