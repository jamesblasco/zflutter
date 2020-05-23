import 'dart:ui';

import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:zflutter/zflutter.dart';

const illoSize = 128;
// ----- colors ----- //

const Color beigeDark = Color(0xFFFF9966);
const Color beigeLight = Color(0xFFFFCC99);
const Color skinDark = Color(0xFFFF6666);
const Color skinMedium = Color(0xFFFF8888);
const Color skinLight = Color(0xFFFFAAAA);
const Color navy = Color(0xFF003366);
const Color midnight = Color(0xFF000033);
const Color auburn = Color(0xFF990033);
const Color red = Color(0xFFCC3333);
const Color sky = Color(0xFF0099DD);
const Color offWhite = Color(0xFFFFFFDD);
const Color white = Color(0xFFFFFFFF);
const Color blueDark = Color(0xFF6666CC);
const Color bluePale = Color(0xFFCCCCFF);

final sceneStartRotation = ZVector.only(y: -tau / 8);

// Todo: Migrate to widget system and use StatelessWidgets instead of functions
class OnTheGo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => (_OnTheGoState());
}

class _OnTheGoState extends State<OnTheGo> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2400),
    );

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final curved =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    return Container(
      color: sky,
      child: ZDragDetector(
        builder: (context, controller) {
          return AnimatedBuilder(
              animation: animationController,
              builder: (context, _) => ZIllustration(zoom: 5, children: [
                    ZPositioned(
                      rotate: controller.rotate +
                          ZVector.only(
                              y: -tau * curved.value + sceneStartRotation.y),
                      child: ZGroup(
                        children: [
                          ZPositioned(
                            translate: ZVector.only(y: 56),
                            child: ZGroup(
                              children: [
                                Dude(),
                                Lady(),
                              ],
                            ),
                          ),
                          Cloud(),
                        ],
                      ),
                    ),
                  ]));
        },
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

final quarterTurn = math.sin(tau / 8);

// ----- dude ----- //

class Dude extends StatelessWidget {
  final hipX = (8 / quarterTurn) / 2;
  final hipsRotation = ZVector.only(x: tau / 16);
  final torsoStroke = 16.0;

  @override
  Widget build(BuildContext context) {
    var hips = ZPositioned(
        translate: ZVector.only(y: -49),
        rotate: hipsRotation,
        child: ZGroup(
          children: [
            ZPositioned(
              translate: ZVector.only(x: -hipX),
              child: rightThigh(
                beigeLight,
                white,
                legRotation: ZVector.zero,
              ),
            ),
            ZPositioned(
                translate: ZVector.only(x: hipX),
                child: rightThigh(beigeDark, beigeLight,
                    legRotation: ZVector.only(x: -tau / 4 - hipsRotation.x),
                    lineOposite: true)),
            ZShape(
              path: ZPath().move(x: -hipX).line(x: hipX),
              stroke: 8,
              color: beigeLight,
            )
          ],
        ));

    return ZPositioned(
      translate: ZVector.only(x: -24, z: -12),
      child: ZGroup(
        children: [
          hips,
          middle([head()])
        ],
      ),
    );
  }

  Widget rightThigh(Color thighColor, Color lineColor,
      {ZVector legRotation, bool lineOposite = false}) {
    Widget shoe(bool isRight) {
      final shoelace = ZShape(
        path: ZPath().move(x: -1).line(x: 1),
        color: blueDark,
        stroke: 1,
      );

      var shoeAngleX = isRight ? -tau / 16 : -hipsRotation.x;
      return ZPositioned(
        translate: ZVector.only(y: 6, z: 4),
        rotate: ZVector.only(x: -tau / 4 - shoeAngleX),
        child: ZGroup(
          children: [
            ZRoundedRect(
              width: 2,
              height: 10,
              borderRadius: 2,
              color: isRight ? white : offWhite,
              fill: true,
              stroke: 6,
            ),
            // shoelace group
            ZPositioned(
              translate: ZVector.only(z: -3),
              child: ZGroup(sortMode: SortMode.update, children: [
                ZPositioned(translate: ZVector.only(y: -2), child: shoelace),
                ZPositioned(translate: ZVector.only(y: -4), child: shoelace),
                //Hack
                ZPositioned(
                  translate: ZVector.only(y: 4),
                  child: ZShape(
                    visible: false,
                  ),
                )
              ]),
            ),
            // soles
            ZPositioned(
              translate: ZVector.only(z: 3.5),
              // rotate: { x: -TAU/4 },
              child: ZRoundedRect(
                width: 6,
                height: 13,
                borderRadius: 3,
                stroke: 1,
                fill: true,
                color: blueDark,
              ),
            ),
          ],
        ),
      );
    }

    var base = ZShape(
      path: ZPath().move(y: 0).line(y: 18),
      stroke: 8,
      color: beigeLight,
    );

    // right tight line
    var rightThighZLine = ZPositioned(
      translate: ZVector.only(x: lineOposite ? 4 : -4),
      child: ZShape(
        path: ZPath().move(y: 0).line(y: 18),
        color: lineColor,
        stroke: 0.5,
      ),
    );

    var shinEnd = ZVector.only(y: 22);

    // right shin line
    var rightShinZLine = ZPositioned(
      translate: ZVector.only(x: lineOposite ? 4 : -4),
      child: ZShape(
        stroke: 0.5,
        color: lineColor,
        path: ZPath().move().lineVector(shinEnd),
      ),
    );

    var rightAnkle = ZPositioned(
        translate: shinEnd,
        child: ZGroup(
          children: [
            ZShape(
              path: ZPath().move(y: 3).line(y: 4),
              color: skinMedium,
              stroke: 6,
            ),
            shoe(!lineOposite)
          ],
        ));

    var rightShin = ZPositioned(
      rotate: legRotation,
      translate: ZVector.only(y: 18),
      child: ZGroup(
        children: [
          ZShape(
            path: ZPath().move().lineVector(shinEnd),
            stroke: 8,
            color: thighColor,
          ),
          rightShinZLine,
          rightAnkle,
        ],
      ),
    );

    // right thigh
    return ZGroup(
      children: [
        ZShape(
          path: ZPath().move().line(y: 18),
          stroke: 8,
          color: thighColor,
        ),
        rightThighZLine,
        rightShin
      ],
    );
  }

  Widget middle(List<Widget> children) {
    var torsoX = 6 / quarterTurn;

    Widget arm(Color color, ZVector rotation) {
      var hand = ZPositioned(
        translate: ZVector.only(x: -0.5, y: 14, z: 1),
        child: ZShape(
          stroke: 10,
          color: skinMedium,
        ),
      );

      return ZPositioned(
        translate: ZVector.only(y: 16),
        rotate: rotation,
        child: ZGroup(
          children: [
            ZShape(
              path: ZPath().move().line(y: 14),
              stroke: 8,
              color: skinMedium,
            ),
            hand
          ],
        ),
      );
    }

    var shoulderX = torsoX + 1.5;
    var rightShoulder = ZPositioned(
      translate: ZVector.only(x: -shoulderX, y: -3),
      rotate: ZVector.only(x: -tau / 16, z: tau / 8),
      child: ZGroup(
        children: [
          ZShape(
            path: ZPath().move().line(y: 14),

            // addTo: torso,

            stroke: 10,
            color: navy,
          ),
          arm(skinMedium, ZVector.only(x: 2.12, z: -0))
        ],
      ),
    );

    var leftShoulder = ZPositioned(
      translate: ZVector.only(x: shoulderX, y: -3),
      rotate: ZVector.only(x: tau * 3 / 16, z: -tau / 32),
      child: ZGroup(
        children: [
          ZShape(
            path: ZPath().move().line(y: 14),
            // addTo: torso,

            stroke: 10,
            color: midnight,
          ),
          arm(skinDark, ZVector.only(x: tau / 4, z: tau / 8))
        ],
      ),
    );

    // jacketZip
    final jacketZip = ZPositioned(
      translate: ZVector.only(y: -0.1),
      rotate: ZVector.only(y: tau / 4, x: -tau / 32),
      child: ZCircle(
        diameter: torsoStroke,
        quarters: 1,
        color: sky,
        stroke: 0.5,
      ),
    );

    return ZPositioned(
        translate: ZVector.only(y: -59, z: -6),
        child: ZGroup(
          children: [
            ZShape(
              path: ZPath().move(x: -torsoX).line(x: torsoX),
              color: navy,
              stroke: torsoStroke,
            ),
            ...children,
            jacketZip,
            rightShoulder,
            leftShoulder
          ],
        ));
  }

  Widget head() {
    var neckY = -torsoStroke / 2;
    //Todo - Group udpate
    var hair = ZGroup(sortMode: SortMode.update, children: [
      // hair big
      ZPositioned(
        translate: ZVector.only(x: -2, y: -2, z: -3),
        child: ZShape(
          path: ZPath().move(y: -1).line(y: -7),
          stroke: 4,
          color: auburn,
        ),
      ),
      // hair small
      ZPositioned(
        translate: ZVector.only(x: 1.25, y: -2, z: -3),
        child: ZShape(
          path: ZPath().move().line(y: -6),
          stroke: 2.5,
          color: red,
        ),
      ),
      // hair back
      ZPositioned(
        translate: ZVector.only(y: -4, z: -4),
        child: ZCircle(
          diameter: 3,
          stroke: 4,
          color: auburn,
        ),
      )
    ]);

    // smile
    final smile = ZPositioned(
      translate: ZVector.only(y: -1.5, z: 3),
      rotate: ZVector.only(z: tau / 4),
      scale: ZVector.all(3),
      child: ZCircle(
        diameter: 1,
        quarters: 2,
        fill: true,
        stroke: 0.5,
        color: white,
        closed: true,
      ),
    );

    // eyes
    var _eye = ZCircle(
      quarters: 2,
      diameter: 1,
      closed: false,
      color: midnight,
      stroke: 0.38,
      fill: false,
    );

    var eye = ZPositioned(
        rotate: ZVector.only(z: -tau / 4),
        translate: ZVector.only(x: -1, y: 0.5, z: 2),
        child: _eye);
    var eye2 = ZPositioned(
        rotate: ZVector.only(z: -tau / 4),
        translate: ZVector.only(x: 1, y: 0.5, z: 2),
        child: _eye);

    var _ear = ZCircle(
      diameter: 1.5,
      stroke: 1,
      color: skinMedium,
      fill: true,
    );
    var ear = ZPositioned(
        translate: ZVector.only(x: 3.5, y: 1, z: -1),
        rotate: ZVector.only(y: -tau / 8),
        child: _ear);
    var ear2 = ZPositioned(
        translate: ZVector.only(x: -3.5, y: 1, z: -1),
        rotate: ZVector.only(y: tau / 8),
        child: _ear);

    // forehead
    var forehead = ZPositioned(
      translate: ZVector.only(y: -4),
      child: ZGroup(
        children: [
          ZCircle(
            diameter: 2,
            stroke: 4,
            color: skinMedium,
          ),
          eye,
          eye2,
          ear,
          ear2
        ],
      ),
    );

    // chin
    var chin = ZPositioned(
        translate: ZVector.only(y: neckY - 5, z: 2),
        child: ZGroup(
          children: [
            ZShape(
              //addTo: neck,

              stroke: 8,
              color: skinMedium,
            ),
            smile,
            forehead,
            hair,
          ],
        ));

    return ZPositioned(
        rotate: ZVector.only(x: tau / 16, y: tau * 3 / 16),
        child: ZGroup(
          children: [
            ZShape(
              path: ZPath().move(y: neckY).line(y: -4),

              // addTo: torso,
              // translate: { y: }

              stroke: 6,
              color: skinMedium,
            ),
            chin
          ],
        ));
  }
}

class Lady extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final torso = ZPositioned(
      rotate: ZVector.only(x: -tau / 8),
      child: ZPositioned(
        translate: ZVector.only(z: 9, y: -9),
        child: ZGroup(
          children: [
            ZRect(
              width: 1,
              height: 5,
              stroke: 8,
              color: beigeLight,
            ),
            leftArm(),
            rightArm(),
            head(),
          ],
        ),
      ),
    );

    return ZPositioned(
      translate: ZVector.only(x: 24, z: 12),
      child: ZPositioned(
        translate: ZVector.only(y: -38),
        child: ZGroup(
          children: [
            ZShape(
              stroke: 15,
              color: navy,
            ),
            torso,
            ...legs()
          ],
        ),
      ),
    );
  }

  Widget mobile() {
    // back phone panel
    var phonePanel = new ZRoundedRect(
      width: 4,
      height: 8,
      borderRadius: 1,
      stroke: 0.5,
      color: bluePale,
      fill: true,
    );
    // phone logo dot
    final phonelogo = ZPositioned(
      translate: ZVector.only(y: -1),
      child: ZCircle(
        diameter: 1.25,
        fill: true,
        stroke: 0,
        color: sky,
      ),
    );
    // phone camera dot
    final cameraDot = ZPositioned(
      translate: ZVector.only(x: -1, y: -3),
      child: ZShape(
        color: midnight,
        stroke: 0.5,
      ),
    );

    // z-sort hack
    final zSortHack = new ZShape(
      path: ZPath().move(y: 16),
      visible: false,
    );
//Group update
    var phoneBack = ZGroup(children: [
      phonePanel,
      phonelogo,
      cameraDot,
      zSortHack,
    ]);
//Group update
    var phoneFront = ZPositioned(
      translate: ZVector.only(z: -0.5),
      child: ZGroup(children: [
        ZRoundedRect(
          width: 4,
          height: 8,
          borderRadius: 1,
          stroke: 0.5,
          color: midnight,
          fill: true,
        )
      ]),
    );

    return ZPositioned(
      translate: ZVector.only(x: -2, y: -0, z: -4),
      rotate: ZVector.only(x: tau / 8),
      child: ZGroup(children: [
        phoneBack,
        phoneFront,
      ]),
    );
  }

  Widget leftArm() {
    // ----- lady arms ----- //

    var leftWrist = ZVector.only(z: 14, y: -14);

    // leftHand
    var leftHand = ZPositioned(
        translate: leftWrist,
        child: ZGroup(
          children: [
            ZShape(
              path: ZPath().move(y: -1, z: -0.5),
              color: skinMedium,
              stroke: 6,
            ),
            mobile()
          ],
        ));

    return ZPositioned(
        translate: ZVector.only(x: 5, y: -3),
        child: ZGroup(
          children: [
            leftHand,
            ZShape(
              //Add the last move to hack for z-sort probs
              path: ZPath()
                  .move()
                  .line(z: 12, y: -2)
                  .line(z: 12, y: -2)
                  .lineVector(leftWrist)
                  .move(x: 16, z: -16),
              closed: false, color: skinMedium, stroke: 4,
            ),
          ],
        ));
  }

  Widget rightArm() {
    Widget suitcase() {
      final suitCaseFrontPanel = ZPositioned(
        translate: ZVector.only(z: 3),
        child: ZRoundedRect(
          width: 24,
          height: 14,
          borderRadius: 2,
          color: Color(0xff884488),
          fill: true,
        ),
      );

      final suitCaseTopPanel = ZPositioned(
        translate: ZVector.only(y: -7),
        rotate: ZVector.only(x: tau / 4),
        child: ZRect(
          width: 20,
          height: 5,
          stroke: 0.5,
          fill: true,
          color: Color(0xff660066),
        ),
      );

      final suitCaseSidePanel = ZPositioned(
        translate: ZVector.only(x: 12),
        rotate: ZVector.only(y: tau / 4),
        child: ZRect(
          width: 5,
          height: 10,
          stroke: 0.5,
          fill: true,
          color: Color(0xff660066),
        ),
      );

      // suit case filler
      final suitCaseFiller = ZRect(
        width: 21,
        height: 11,
        stroke: 4,
        fill: true,
        color: Color(0xff660066),
      );
      // suit case handle
      var suitCaseHandle = ZPositioned(
        translate: ZVector.only(x: 3, y: -11),
        child: ZShape(
          path: ZPath().move().arc(
                corner: ZVector.only(x: 1, y: 0),
                end: ZVector.only(x: 1, y: 1),
              ),
          stroke: 1.5,
          color: midnight,
          closed: false,
        ),
      );

      return ZPositioned(
          translate: ZVector.only(y: 12),
          rotate: ZVector.only(y: tau / 4),
          child: ZGroup(children: [
            suitCaseFrontPanel,
            /* suitCaseFrontPanel.copyWith(
              translate: ZVector.only(z: -3),
              color: Color(0xff660066),
            ),*/
            suitCaseTopPanel,
            /*  suitCaseTopPanel.copyWith(
              translate: ZVector.only(y: -7),
            ),*/
            suitCaseSidePanel,
            /*  suitCaseSidePanel.copyWith(
              translate: ZVector.only(x: -12),
            ),*/
            suitCaseFiller,
            suitCaseHandle,
            ZPositioned(
              translate: ZVector.only(x: -3, y: -11),
              child: ZShape(
                path: ZPath()
                    .move()
                    .arc(
                      corner: ZVector.only(x: -1, y: 0),
                      end: ZVector.only(x: -1, y: 1),
                    )
                    .line(x: -1, y: 3),
                stroke: 1.5,
                color: midnight,
                closed: false,
              ),
            )
          ]));
    }

    var rightWrist = ZVector.only(y: 24);

    var rightHandPosition = rightWrist.addVector(ZVector.only(x: -0.5, z: -1));

    // leftHand
    var rightHand = ZPositioned(
      translate: rightHandPosition,
      child: ZGroup(
        children: [
          ZShape(
            path: ZPath().move(),
            color: skinLight,
            stroke: 6,
          ),
          suitcase()
        ],
      ),
    );

    return ZPositioned(
        translate: ZVector.only(x: -4, y: -3),
        rotate: ZVector.only(z: tau / 16, x: tau / 32),
        child: ZGroup(
          children: [
            rightHand,
            ZShape(path: ZPath([
              ZMove.vector(ZVector.only(y: 0)),

              ZLine.vector(rightWrist),
              // hack for z-sort probs
              ZMove.vector(ZVector.only(x: 16, z: -16)),
            ]), color: skinLight, closed: false, stroke: 4),
          ],
        ));
  }

  List<Widget> legs() {
    // ---- leg ---- //

    ZGroup rightFoot(Color color) {
      // heel
      final heel = ZPositioned(
        translate: ZVector.only(y: 5, z: -3),
        child: ZShape(
          path: ZPath().move(x:-1).line(x: 1),
          stroke: 4,
          color: beigeLight,
        ),
      );
      // sole edge
      var soleEdge = ZPositioned(
        translate: ZVector.only(y: 6),
        child: ZShape(
          path: ZPath([
            ZMove.vector(ZVector.only(x: -2, z: -2)),
            ZArc.list([
              ZVector.only(x: -2, z: -2, y: 5),
              ZVector.only(x: 0, z: 2, y: 5)
            ]),
          ],),
          stroke: 2,
          fill: false,
          closed: false,
          color: beigeLight,
        ),
      );

      var soleEdge2 = ZPositioned(
        translate: ZVector.only(y: 6),
        child: ZShape(
          path: ZPath([
            ZMove.vector(ZVector.only(x: 2, z: -2)),
            ZArc.list([
              ZVector.only(x: 2, z: 2, y: 5),
              ZVector.only(x: -0, z: 2, y: 5)
            ]),
          ],),
          stroke: 2,
          fill: false,
          closed: false,
          color: beigeLight,
        ),
      );

      // heel spike
      final heelSpike = ZPositioned(
        translate: ZVector.only(y: 6, z: -4),
        child: ZShape(
          path:  ZPath([ZMove.vector(ZVector.zero), ZLine.vector(ZVector.only(y: 5))]),
          stroke: 2,
          color: beigeLight,
        ),
      );

      // lady feet
      return ZGroup(
        children: [
          ZShape(
            path: ZPath( [
              ZMove.vector(ZVector.only(y: 2)),
              ZLine.vector(ZVector.only(y: 8))
            ]),
            stroke: 4,
            color: color,
          ),
          heelSpike,
          soleEdge2,
          soleEdge,
          heel
        ],
      );
    }

    // right thigh
    var rightKnee = ZVector.only(y: 16);

    // rightShin
    var rightAnkle = ZVector.only(y: 10);

    var rightShin = ZPositioned(
        rotate: ZVector.only(x: -tau / 8),
        translate: rightKnee,
        child: ZGroup(
          children: [
            ZShape(
              path: ZPath( [
                ZMove.vector(ZVector.only(y: 0)),
                ZLine.vector(rightAnkle)
              ]),
              stroke: 7,
              color: navy,
            ),
            ZPositioned(translate: rightAnkle, child: rightFoot(skinLight))
          ],
        ));

    var rightThigh = ZPositioned(
        translate: ZVector.only(x: -3.5, y: 4, z: 0),
        rotate: ZVector.only(x: tau / 8),
        child: ZGroup(
          children: [
            ZShape(
              path:  ZPath([ZMove.vector(ZVector.only(y: 0)), ZLine.vector(rightKnee)]),
              stroke: 7,
              color: navy,
            ),
            rightShin
          ],
        ));

    // left leg
    var leftAnkle = ZVector.only(y: 28);
    var leftLeg = ZPositioned(
        translate: ZVector.only(x: 3.5, y: 4, z: 0),
        rotate: ZVector.only(x: -tau / 8),
        child: ZGroup(
          children: [
            ZShape(
              path:  ZPath([ZMove.vector(ZVector.only(y: 0)), ZLine.vector(leftAnkle)]),
              stroke: 7,
              color: midnight,
            ),
            ZPositioned(translate: leftAnkle, child: rightFoot(skinMedium))
          ],
        ));

    return [leftLeg, rightThigh];
  }

  Widget head() {
    // ----- lady head ----- //

    var _collar = new ZRoundedRect(
      width: 3,
      height: 5,
      borderRadius: 1.5,
      color: white,
      fill: true,
    );

    var collar = ZPositioned(
      translate: ZVector.only(x: 1, y: 2, z: 0),
      rotate: ZVector.only(x: -tau / 4, z: tau / 8),
      child: _collar,
    );
    var collar2 = ZPositioned(
      translate: ZVector.only(x: -1, y: 2, z: 0),
      rotate: ZVector.only(x: -tau / 4, z: -tau / 8),
      child: _collar,
    );

    // var faceGroup = new Zdog.Group({
    //   addTo: head,
    // });
    // hair cap
    //TODO: ADD Face
    var headCap = ZPositioned(
      translate: ZVector.only(y: -1),
      rotate: ZVector.only(x: tau / 8 * 3, y: 0),
      child: ZHemisphere(
        diameter: 11,
        color: midnight,
        stroke: 1.5,
      ),
    );
    // face
    var face = ZPositioned(
      translate: ZVector.only(y: -0.95),
      rotate: ZVector.only(x: tau / 8 * 3, y: tau / 2),
      child: ZHemisphere(
        diameter: 9,
        color: skinLight,
        backfaceColor: midnight,
        stroke: 0.5,
      ),
    );
    // smile
    var smile = ZPositioned(
      translate: ZVector.only(y: 0.5, z: 4),
      rotate: ZVector.only(z: tau * 3 / 8),
      child: ZCircle(
        diameter: 3,
        quarters: 1,
        color: skinDark,
        closed: false,
        stroke: 0.5,
      ),
    );

    // hair locks
    var headLocks = ZPositioned(
      translate: ZVector.only(y: 2, x: 4.5, z: -2),
      rotate: ZVector.only(y: tau / 4),
      child: new ZRoundedRect(
        width: 6,
        height: 10,
        borderRadius: 3,
        fill: true,
        color: midnight,
        stroke: 2,
      ),
    );
    // hairLock.copy({
    //   translate: { y: 8, x: 4.5, z: -2 },
    // });

    Widget glasses() {
      // glasses

      var lens = new ZCircle(
        diameter: 4,
        stroke: 0,
        fill: true,
        color: Color(0xff660033),
      );

      var glassesRim = new ZCircle(
        diameter: 4,
        stroke: 1,
        fill: false,
        color: auburn,
      );

      return ZPositioned(
        translate: ZVector.only(y: -1, z: 5),
        child: ZGroup(
          //    mode: GroupMode.newZIndex,
          children: [
            ZPositioned(
              translate: ZVector.only(x: -2.5),
              child: lens,
            ),
            ZPositioned(
              translate: ZVector.only(x: 2.5),
              child: lens,
            ),
            ZPositioned(
              translate: ZVector.only(x: -2.5),
              child: glassesRim,
            ),
            ZPositioned(
              translate: ZVector.only(x: 2.5),
              child: glassesRim,
            ),
          ],
        ),
      );
    }

    var head = ZPositioned(
      translate: ZVector.only(y: -6),
      rotate: ZVector.only(x: tau / 8),
      child: ZGroup(children: [
        headCap,
        face,
        smile,
        headLocks,
        glasses(),
      ]),
    );

    return ZPositioned(
        translate: ZVector.only(y: -7),
        child: ZGroup(
          children: [
            ZShape(
              path:  ZPath([
                ZMove.vector(ZVector.zero),
                ZLine.vector(ZVector.only(y: -2))
              ]),
              stroke: 4,
              color: skinLight,
            ),
            head,
            collar,
            collar2
          ],
        ));
  }
}

class Cloud extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // left small puff
    var smallPuff = ZPositioned(
      translate: ZVector.only(x: -9, y: 4, z: 4),
      child: ZShape(stroke: 8, color: white),
    );
    var smallPuff2 = ZPositioned(
      translate: ZVector.only(x: 9, y: 5, z: 5),
      child: ZShape(stroke: 10, color: white),
    );

    var disk = ZPositioned(
      translate: ZVector.only(x: -6, y: 7, z: 4),
      rotate: ZVector.only(x: tau / 4),
      child: ZRoundedRect(
        width: 26,
        height: 12,
        borderRadius: 6,
        stroke: 3,
        color: white,
        fill: true,
      ),
    );
    var disk2 = ZPositioned(
      translate: ZVector.only(x: 6, y: 9, z: 8),
      rotate: ZVector.only(x: tau / 4),
      child: ZRoundedRect(
        width: 26,
        height: 12,
        borderRadius: 6,
        stroke: 3,
        color: white,
        fill: true,
      ),
    );

    // sun
    final sun = ZPositioned(
      translate: ZVector.only(x: -13, y: 0, z: -14),
      child: ZShape(
        stroke: 8,
        color: beigeLight,
      ),
    );

    // big puff

    return ZPositioned(
      translate: ZVector.only(x: 34, y: -26, z: -20),
      rotate: ZVector.only(y: -sceneStartRotation.y),
      child: ZGroup(
        children: [
          // big puff
          ZShape(
            stroke: 16,
            color: white,
          ),
          smallPuff,
          smallPuff2,
          disk,
          disk2,
          sun
        ],
      ),
    );
  }
}
