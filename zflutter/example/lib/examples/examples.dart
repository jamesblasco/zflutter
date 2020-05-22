import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:z_flutter_example/examples/widget_box.dart';
import 'package:z_flutter_example/examples/z_fighting.dart';

import 'package:zflutter/zflutter.dart';

import '../flutter_widget.dart';
import '../spin.dart';
import 'device/device.dart';
import 'device/modal_bottom_sheet.dart';

import 'dice/dice.dart';
import 'dude.dart';
import 'flutter_logo/widget.dart';
import 'on_the_go.dart';

class Example {
  final String title;
  final String route;
  final Color backgroundColor;
  final WidgetBuilder builder;
  final FlutterLogoColor logoStyle;

  Example({
    this.logoStyle,
    @required this.title,
    @required this.route,
    this.backgroundColor,
    @required this.builder,
  });
}

class Examples {
  static final Example onTheGo = Example(
    title: 'On the go',
    route: '/on_the_go',
    backgroundColor: Color(0xFF0099DD),
    builder: (_) => OnTheGo(),
  );

  static final Example iphone = Example(
    title: 'iPhone',
    route: '/iphone',
    builder: (_) => ZDragDetector(builder: (context, controller) {
      return ZIllustration(
        zoom: 1.5,
        children: [
          ZPositioned(
            rotate: controller.rotate,
            child: Device(
              child: CupertinoTabView(
                onGenerateRoute: (settings) {
                  return MaterialWithModalsPageRoute(
                      settings: settings,
                      builder: (context) => ModalBottomSheetExample());
                },
              ),
            ),
          )
        ],
      );
    }),
  );

  static final Example flutterLogo = Example(
      title: 'Flutter Logo',
      route: '/logo',
      backgroundColor: Colors.blue[50],
      builder: (_) => FlutterAnimation(),
      logoStyle: FlutterLogoColor.black);

  static final Example dice = Example(
    title: 'Dice',
    route: '/dice',
    builder: (_) => Dices(),
  );

  static List<Example> get list => [
        onTheGo,
        iphone,
        flutterLogo,
        dice,
      ];
}

class BasicSamples {
  static final Example simpleLine = Example(
    title: 'Simple line',
    route: '/simple_line',
    builder: (_) => Template(
      childrenBuilder: () => [
        ZShape(
          path: [
            ZMove.vector(ZVector.only(x: -40)),
            ZLine.vector(ZVector.only(x: 40)),
          ],
          stroke: 20,
          color: Color(0xff663366),
        )
      ],
    ),
  );

  static final Example zPlain = Example(
    title: 'Plain Z',
    route: '/z_plain',
    builder: (_) => Template(
      childrenBuilder: () => [
        ZShape(
          path: [
            ZMove.vector(ZVector.only(x: -32, y: -40)), // start at top left
            ZLine.vector(ZVector.only(x: 32, y: -40)), // line to top right
            ZLine.vector(ZVector.only(x: -32, y: 40)), // line to bottom left
            ZLine.vector(ZVector.only(x: 32, y: 40)), // line to bottom right
          ],
          closed: false,
          stroke: 20,
          color: Color(0xff663366),
        )
      ],
    ),
  );
  static final Example z3d = Example(
    title: '3D Z',
    route: '/z_3d',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZShape(
                path: [
                  ZMove.vector(
                      ZVector.only(x: -32, y: -40, z: 40)), // start at top left
                  ZLine.vector(
                      ZVector.only(x: 32, y: -40)), // line to top right
                  ZLine.vector(ZVector.only(
                      x: -32, y: 40, z: 40)), // line to bottom left
                  ZLine.vector(ZVector.only(
                      x: 32, y: 40, z: -40)), // line to bottom right
                ],
                closed: false,
                stroke: 20,
                color: Color(0xff663366),
              )
            ]),
  );

  static final Example ball = Example(
    title: 'Sphere',
    route: '/sphere',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZShape(
                stroke: 80,
                color: Color(0xff663366),
              ),
            ]),
  );

  static final Example parallelLines = Example(
    title: 'Parallel Lines',
    route: '/parallel_lines',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZShape(
                path: [
                  ZMove.vector(
                      ZVector.only(x: -32, y: -40)), // start at top left
                  ZLine.vector(
                      ZVector.only(x: 32, y: -40)), // line to top right
                  ZMove.vector(
                      ZVector.only(x: -32, y: 40)), // line to bottom left
                  ZLine.vector(
                      ZVector.only(x: 32, y: 40)), // line to bottom right
                ],
                closed: false,
                stroke: 20,
                color: Color(0xff663366),
              )
            ]),
  );
  static final Example bezier = Example(
    title: 'Bezier',
    route: '/bezier',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZShape(
                path: [
                  ZMove.vector(ZVector.only(x: -60, y: -60)),
                  ZBezier([
                    ZVector.only(x: 20, y: -60),
                    ZVector.only(x: 20, y: 60),
                    ZVector.only(x: 60, y: 60)
                  ]),
                ],
                closed: false,
                stroke: 20,
                color: Color(0xff663366),
              ),
            ]),
  );
  static final Example arc = Example(
    title: 'Arc',
    route: '/arc',
    builder: (_) => Template(
        childrenBuilder: () => [
              ...generateArc(
                ZVector.only(x: -60, y: -60),
                ZVector.only(x: 20, y: -60),
                ZVector.only(x: 20, y: 20),
              ),
              ...generateArc(ZVector.only(x: 20, y: 20),
                  ZVector.only(x: 20, y: 60), ZVector.only(x: 60, y: 60))
            ]),
  );
  static final Example openTriangle = Example(
    title: 'Open Triangle',
    route: '/open_triangle',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZShape(
                path: [
                  ZMove.vector(ZVector.only(x: 0, y: -40)),
                  ZLine.vector(ZVector.only(x: 40, y: 40)),
                  ZLine.vector(ZVector.only(x: -40, y: 40)),
                ],
                closed: false,
                stroke: 20,
                color: Color(0xff663366),
              ),
            ]),
  );
  static final Example triangleColoredBack = Example(
    title: 'Triangle with Back Color',
    route: '/triangle_colored_ack',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZShape(
                path: [
                  ZMove.vector(ZVector.only(x: 0, y: -40)),
                  ZLine.vector(ZVector.only(x: 40, y: 40)),
                  ZLine.vector(ZVector.only(x: -40, y: 40)),
                ],
                closed: true,
                stroke: 20,
                color: Color(0xff663366),
                backfaceColor: Color(0xff000000),
              ),
            ]),
  );
  static final Example closedTriangle = Example(
    title: 'Closed Triangle',
    route: '/closedTriangle',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZShape(
                path: [
                  ZMove.vector(ZVector.only(x: 0, y: -40)),
                  ZLine.vector(ZVector.only(x: 40, y: 40)),
                  ZLine.vector(ZVector.only(x: -40, y: 40)),
                ],
                closed: true,
                stroke: 20,
                color: Color(0xff663366),
              ),
            ]),
  );
  static final Example rect = Example(
    title: 'Rect',
    route: '/rect',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZRect(
                width: 120,
                height: 80,
                stroke: 20,
                color: Color(0xFFEE6622),
              )
            ]),
  );
  static final Example rects = Example(
    title: 'Rects',
    route: '/rects',
    builder: (_) => Template(
      childrenBuilder: () => [
        ZGroup(
          children: [
            ZPositioned(
              translate: ZVector.only(x: -48),
              rotate: ZVector.only(y: tau / 4),
              child: ZRect(
                width: 80,
                height: 64,
                stroke: 10,
                color: Color(0xFFEE6622),
              ),
            ),
            ZPositioned(
              translate: ZVector.only(y: -48),
              rotate: ZVector.only(x: tau / 4),
              child: ZRect(
                width: 80,
                height: 64,
                stroke: 10,
                color: Color(0xFF663366),
              ),
            ),
          ],
        )
      ],
    ),
  );

  static final Example roundedRect = Example(
    title: 'Rounded Rect',
    route: '/rounded_rect',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZRoundedRect(
                width: 120,
                height: 80,
                borderRadius: 30,
                stroke: 20,
                color: Color(0xffEEAA00),
              )
            ]),
  );

  static final Example circle = Example(
    title: 'Circle',
    route: '/circle',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZCircle(
                diameter: 80,
                stroke: 20,
                color: Color(0xFFCC2255),
              ),
            ]),
  );
  static final Example ellipsis = Example(
    title: 'Ellipsis',
    route: '/ellipsis',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZEllipse(
                width: 60,
                height: 120,
                stroke: 20,
                color: Color(0xFFCC2255),
              ),
            ]),
  );

  static final Example halfCircle = Example(
    title: 'Half circle',
    route: '/half_circle',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZCircle(
                diameter: 80,
                quarters: 2,
                stroke: 20,
                color: Color(0xFFCC2255),
              ),
            ]),
  );

  static final Example polygon = Example(
    title: 'Polygon',
    route: '/polygon',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZPolygon(
                sides: 5,
                radius: 50,
                stroke: 20,
                color: Color(0xff663366),
              ),
            ]),
  );
  static final Example box = Example(
    title: 'Box',
    route: '/box',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZBox(
                height: 100,
                width: 100,
                depth: 100,
                // fill enabled by default
                // disable stroke for crisp edge
                // stroke: false,
                color: Color(0xffCC2255),
                frontColor: Color(0xffCC2255),
                topColor: Colors.yellow,
                leftColor: Colors.green,
                rightColor: Colors.blue,
                bottomColor: Colors.orange,
                rearColor: Colors.red,
              )
            ]),
  );
  static final Example widgetBox = Example(
    title: 'Widget Box',
    route: '/box_widget',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZPositioned(
                scale: ZVector.all(0.5),
                translate: ZVector.only(x: 0),
                child: ZBoxToBoxAdapter(
                  height: 200,
                  width: 200,
                  depth: 200,
                  color: Color(0xffCC2255),
                  frontChild: Container(
                    color: Color(0xffCC2255),
                    child: Center(
                      child: InkWell(
                        onTap: () => print('tapped'),
                        child: Text('😝'),
                      ),
                    ),
                  ),
                  topChild: Container(
                    color: Colors.yellow,
                    child: Center(
                      child: InkWell(
                        onTap: () => print('tapped'),
                        child: Text('😝'),
                      ),
                    ),
                  ),
                  leftChild: Container(color: Colors.green),
                  rightChild: Container(color: Colors.blue),
                  bottomChild: Container(color: Colors.orange),
                  rearChild: Container(color: Colors.red),
                ),
              )
            ]),
  );

  static final Example cylinder = Example(
    title: 'Cylinder',
    route: '/cylinder',
    builder: (_) => Template(
      childrenBuilder: () => [
        ZCylinder(
          diameter: 80,
          length: 120,
          frontface: Colors.red,
          color: Colors.orange,
          backface: Colors.green,
        ),
      ],
    ),
  );
  static final Example hemisphere = Example(
    title: 'Hemisphere',
    route: '/hemisphere',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZHemisphere(
                diameter: 120,
                // fill enabled by default
                // disable stroke for crisp edge
                // stroke: false,
                color: Color(0xffCC2255),
                backfaceColor: Color(0xffEEAA00),
              )
            ]),
  );

  static final Example cone = Example(
    title: 'Cone',
    route: '/cone',
    builder: (_) => Template(
        childrenBuilder: () => [
              ZCone(
                diameter: 30,
                length: 40,
                color: Color(0xffCC2255),
                backfaceColor: Color(0xffEEAA00),
              ),
            ]),
  );

  static final Example dude = Example(
    title: 'Dude',
    route: '/dude',
    builder: (_) => Body(),
  );

  static final Example zFighting = Example(
    title: 'ZFighting',
    route: '/z_fighting',
    builder: (_) => ZFighting(),
  );

  static List<Example> get list => [
        simpleLine,
        zPlain,
        z3d,
        ball,
        parallelLines,
        bezier,
        arc,
        openTriangle,
        closedTriangle,
        triangleColoredBack,
        rect,
        rects,
        roundedRect,
        circle,
        ellipsis,
        polygon,
        box,
        widgetBox,
        cylinder,
        hemisphere,
        cone,
        dude,
        zFighting
      ];
}

class Template extends StatelessWidget {
  final List<Widget> Function() childrenBuilder;

  const Template({Key key, this.childrenBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Spin(
      builder: (context, rotate) => ZDragDetector(
        key: key,
        builder: (context, controller) {
          return ZIllustration(
            zoom: 3,
            children: [
              ZPositioned(
                rotate: controller.rotate + rotate,
                child: ZGroup(
                  children: childrenBuilder(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

List<Widget> generateArc(ZVector start, ZVector corner, ZVector end) {
  return [
    ZShape(
      path: [
        ZMove.vector(start),
        // start at top left
        ZArc.list(
          [corner, end],
        ),
      ],
      closed: false,
      stroke: 20,
      color: Color(0xff663366),
    ),
    ZPositioned(
      translate: corner,
      child: ZShape(
        stroke: 12,
        color: Colors.orange,
      ),
    ),
    ZShape(
      path: [
        ZMove.vector(start),
        ZLine.vector(corner),
      ],
      stroke: 2,
      closed: false,
      color: Colors.orange,
    ),
    ZShape(
      path: [
        ZMove.vector(corner),
        ZLine.vector(end),
      ],
      stroke: 2,
      closed: false,
      color: Colors.orange,
    ),
  ];
}
