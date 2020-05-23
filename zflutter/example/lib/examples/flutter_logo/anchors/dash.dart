import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

final Color darkBlue = Color(0xff5CC0EF);

final Color bodyColor = Color(0xffa0e6fe);

final Color brown = Color(0xff967C40);

final Color green = Color(0xff71d3c7);

final Color black = Color(0xff000000);


class Dash extends StatelessWidget {
  final double flight;

  Dash({this.flight});

  @override
  Widget build(BuildContext context) {
    return ZPositioned(
      translate: ZVector.only(y: flight),
      child: ZGroup(
        children: [
          ZShape(
            stroke: 40,
            fill: true,
            color: bodyColor,
          ),
          ZPositioned(translate: ZVector.only(y: -20), child: hair()),
          ZPositioned(
            translate: ZVector.only(x: 0, y: 12, z: -17),
            child: ZShape(
              stroke: 2,
              fill: true,
              path:
              const ZPath()
                  .move()
                  .arc(corner: ZVector(5, -10, -8), end: ZVector(8, -15, -10))
                  .arc(corner: ZVector(0, -25, -12), end: ZVector(-8, -15, -10))
                  .arc(corner: ZVector(-5, -10, -8), end: ZVector.zero),
              color: darkBlue,
            ),
          ),
          ZPositioned(
            translate: ZVector.only(x: -23, z: -2),
            rotate:
                ZVector.only(y: tau / 4 - tau / 40 - flight / 12, x: -tau / 12),
            child: wing(),
          ),
          ZPositioned(
            translate: ZVector.only(x: 23, z: -2),
            rotate:
                ZVector.only(y: tau / 4 + tau / 40 + flight / 12, x: -tau / 12),
            child: wing(),
          ),
          ZGroup(
            sortMode: SortMode.stack,
            children: [
              ZPositioned(
                translate: ZVector.only(x: 0, y: 0, z: 2),
                child: ZShape(
                  stroke: 2,
                  fill: true,
                  path: ZPath()
                      .move(z: 20)
                      .arc(corner: ZVector(-30, 7, 15), end: ZVector(0, 15, 15))
                      .arc(corner: ZVector(30, 7, 15), end: ZVector(0, 0, 20)),
                  color: Colors.white,
                ),
              ),
              ZPositioned(
                translate: ZVector.only(z: 20),
                child: ZGroup(sortMode: SortMode.update, children: [
                  eye(translate: ZVector.only(x: -7)),
                  eye(translate: ZVector.only(x: 7)),
                  ZPositioned(
                      rotate: ZVector.only(x: -tau / 20),
                      translate: ZVector.only(y: 7),
                      child: ZCone(
                        color: brown,
                        length: 10,
                        stroke: 2,
                        diameter: 3,
                      )),
                ]),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Todo: Migrate to widget system and use StatelessWidgets instead of functions
ZGroup hair() => ZGroup(
      children: [
        ZPositioned(
          translate: ZVector.only(y: -1, z: 0),
          child: ZEllipse(
            height: 6,
            width: 3,
            stroke: 4,
            color: bodyColor,
          ),
        ),
        ZPositioned(
          translate: ZVector.only(y: 1, x: -2),
          rotate: ZVector.only(z: -tau / 8),
          child: ZEllipse(
            height: 6,
            width: 3,
            stroke: 4,
            color: bodyColor,
          ),
        ),
        ZPositioned(
          translate: ZVector.only(y: 1, x: 2),
          rotate: ZVector.only(z: tau / 8),
          child: ZEllipse(
            height: 6,
            width: 3,
            stroke: 4,
            color: bodyColor,
          ),
        ),
      ],
    );

ZGroup eye({ZVector translate}) {
  return ZGroup(sortMode: SortMode.stack, children: [
    ZPositioned(
      translate: translate,
      child: ZCircle(
        stroke: 2,
        fill: true,
        diameter: 15,
        color: darkBlue,
      ),
    ),
    ZPositioned(
      translate: translate,
      scale: ZVector.all(1.2),
      child: ZEllipse(
        stroke: 2,
        fill: true,
        width: 6,
        height: 8,
        color: green,
      ),
    ),
    ZPositioned(
      translate: translate + ZVector.only(x: 0, y: 0, z: 0.1),
      child: ZEllipse(
        stroke: 2,
        fill: true,
        width: 6,
        height: 8,
        color: black,
      ),
    ),
    ZPositioned(
      translate: translate + ZVector.only(x: 2, y: -2, z: 1),
      child: ZCircle(
        stroke: 1,
        fill: true,
        diameter: 1,
        color: Colors.white,
      ),
    )
  ]);
}

ZGroup wing() => ZGroup(
      children: [
        ZPositioned(
            scale: ZVector.all(1.2),
            child: ZEllipse(
              stroke: 4,
              fill: true,
              width: 20,
              height: 15,
              color: darkBlue,
            )),
      ],
    );
