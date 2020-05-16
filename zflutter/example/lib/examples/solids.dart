/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

var eggplant = Color(0xff663366);
var garnet = Color(0xffCC2255);
var orange = Color(0xffEE6622);
var gold = Color(0xffEEAA00);
var yellow = Color(0xffEEDD00);


///  Hour Glass
///
///
class HourGlass extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final stroke = 0.0;
    final diameter = 2.0;

    return ZGroup(children: [
      ZPositioned(
        translate: ZVector.only(z: -1),
        child: ZHemisphere(
          diameter: diameter,
          stroke: stroke,

          color: garnet,
          backfaceColor: orange,
        ),),
      ZPositioned(
          translate: ZVector.only(z: 1),
          rotate: ZVector.only(y: tau / 2),
          child: ZHemisphere(
            diameter: diameter,
            stroke: stroke,
            color: eggplant,
            backfaceColor: gold,
          ))
    ]);
  }
}


///  Sphere
///
class Sphere extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final stroke = 0.0;
    final diameter = 2.0;

    return ZGroup(children: [
      ZHemisphere(
        diameter: diameter,
        stroke: stroke,
        color: orange,
        // backface: orange,
      ),
      ZPositioned(
        rotate: ZVector.only(y: tau / 2),
        child: ZHemisphere(
        diameter: diameter,
        stroke: stroke,

        color: eggplant,
        //  backface: gold,
      ),)
    ]);
  }
}


///  Sphere
///
class Cylinder extends StatelessAnchor {
  final Vector translate;
  final Vector rotate;
  final Vector scale;

  Cylinder({this.translate, this.rotate, this.scale})
      : super(
    translate: translate,
    rotate: rotate,
    scale: scale,
  );

  @override
  Anchor build() {
    return ZCylinder(
      diameter: 2,
      length: 2,
      // rotate: { x: TAU/4 },
      color: gold,
      backface: garnet,
      stroke: 0,
    );
  }
}


///  Sphere
///
class Cone extends StatelessAnchor {
  final Vector translate;
  final Vector rotate;
  final Vector scale;

  Cone({this.translate, this.rotate, this.scale})
      : super(
    translate: translate,
    rotate: rotate,
    scale: scale,
  );

  @override
  Anchor build() {
    return ZCone(
      diameter: 2,
      length: 2,
      translate: Vector(z: 1),
      rotate: Vector(y: tau / 2),
      color: garnet,
      backface: gold,
      stroke: 0,
    );
  }
}


class Tetrahedron extends StatelessAnchor {
  @override
  Anchor build() {
    return
    var tetrahedron = new Zdog.Anchor({
      addTo: illo,
      translate: { x: 0, y: 0},
      scale: 2.5,
    });

    var radius = 0.5;
    var inradius = Math.cos(TAU / 6) * radius;
    var height = radius + inradius;

    solids.push(tetrahedron);

    var triangle = new Zdog.Polygon({
      sides: 3,
      radius: radius,
      addTo: tetrahedron,
      translate: { y: height / 2},
      fill: true,
      stroke: false,
      color: eggplant,
      // backface: false,
    });


    for (var i = 0; i < 3; i++) {
      var rotor1 = new Zdog.Anchor({
        addTo: tetrahedron,
        rotate: { y: TAU / 3 * -i},
      });
      var rotor2 = new Zdog.Anchor({
        addTo: rotor1,
        translate: { z: inradius, y: height / 2},
        rotate: { x: Math.acos(1 / 3) * -1 + TAU / 4},
      });
      triangle.copy({
        addTo: rotor2,
        translate: { y: -inradius},
        color: [ gold, garnet, orange][i],
      });
    }

    triangle.rotate.set({ x: -TAU / 4, z: -TAU / 2});
  }

  )

  (

  );

}

}*
/
*/
