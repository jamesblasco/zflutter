import 'package:flutter/cupertino.dart';
import 'package:zflutter/zflutter.dart';

class ZFighting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZDragDetector(
      builder: (context, rotate) => ZIllustration(zoom: 2, children: [
        ZPositioned(
            rotate: rotate.rotate,
            child: ZGroup(
              children: [
                ZRect(
                  width: 120,
                  height: 120,
                  stroke: 16,
                  fill: true,
                  color: Color(0xffCC2255),
                ),
                _Group(isFixed: true),
                _Group(isFixed: false)
              ],
            )),
      ]),
    );
  }
}

class _Group extends StatelessWidget{
  final isFixed;

  const _Group({Key key, this.isFixed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double d = 45;
    final double x = d * (isFixed ? -1 : 1);

    return ZPositioned(
      translate: ZVector.only(z: isFixed ? 25 : -25),
      child: ZGroup(
        sortMode: SortMode.update,
        children: [
          // dot
          ZPositioned(
            translate: ZVector.only(x: x, y: -d),
            child: ZShape(
              stroke: 20,
              color: isFixed ? Color(0xffeeaa00) : Color(0xff663366),
            ),
          ),
          if (isFixed)
          // invisible Shape to counter-balance group z-index
            ZPositioned(
              translate: ZVector.only(x: -x, y: d),
              child: ZShape(
                stroke: 20,
                visible: false,
              ),
            ),
        ],
      ),
    );
  }
}