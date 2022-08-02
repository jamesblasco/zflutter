import 'package:flutter/material.dart';
import 'package:z_flutter_example/spin.dart';
import 'package:zflutter/zflutter.dart';

import 'examples.dart';

class GettingStartedSamples {
  static final Example zoom = Example(
    title: 'Zoom',
    route: '/zoom',
    builder: (_) => ZIllustration(
      zoom: 2,
      children: [
        ZCircle(
          diameter: 80,
          stroke: 20,
          color: Color(0xFFCC2255),
        ),
      ],
    ),
  );

  static final Example animated = Example(
    title: 'Animated',
    route: '/animated',
    builder: (_) => Spin(
        builder: (context, rotate) => ZIllustration(
              zoom: 2,
              children: [
                ZPositioned(
                  rotate: rotate,
                  child: ZCircle(
                    diameter: 80,
                    stroke: 20,
                    color: Color(0xFFCC2255),
                  ),
                ),
              ],
            )),
  );

  static final Example drag = Example(
    title: 'Drag',
    route: '/drag',
    builder: (_) => ZDragDetector(
      builder: (context, controller) {
        return ZIllustration(
          children: [
            ZPositioned(
              rotate: controller.rotate,
              child: ZCircle(
                diameter: 80,
                stroke: 20,
                color: Color(0xFFCC2255),
              ),
            ),
          ],
        );
      },
    ),
  );

  static final Example boxAdapter = Example(
    title: 'Box Adapter',
    route: '/box_adapter',
    builder: (_) => ZDragDetector(
      builder: (context, controller) {
        return ZIllustration(
          zoom: 4,
          children: [
            ZPositioned(
              rotate: controller.rotate,
              child: ZToBoxAdapter(
                height: 80,
                width: 80,
                child: Container(color: Color(0xFFCC2255)),
              ),
            ),
          ],
        );
      },
    ),
  );



  static List<Example> get list => [zoom, animated, drag, boxAdapter];
}
