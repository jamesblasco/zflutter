
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

class ZBoxToBoxAdapter extends StatelessWidget {
  final double width;
  final double height;
  final double depth;

  final double stroke;
  final bool fill;

  final Color color;
  final bool visible;

  final Widget frontChild;
  final Widget rearChild;
  final Widget leftChild;
  final Widget rightChild;
  final Widget topChild;
  final Widget bottomChild;

  //var front = ZVector.only(z: 1);
  ZBoxToBoxAdapter({
    this.width,
    this.height,
    this.depth,
    this.stroke = 1,
    this.fill = true,
    this.color,
    this.visible,
    this.frontChild,
    this.rearChild,
    this.leftChild,
    this.rightChild,
    this.topChild,
    this.bottomChild,
  });

  Widget get frontFace => ZPositioned(
    translate: ZVector.only(z: depth / 2),
    child: ZToBoxAdapter(
      width: width,
      height: height,
      child: frontChild,
    ),
  );

  Widget get rearFace => ZPositioned(
    translate: ZVector.only(z: -depth / 2),
    rotate: ZVector.only(y: tau / 2),
    child:  ZToBoxAdapter(
      width: width,
      height: height,
      child: rearChild,
    ),
  );

  Widget get leftFace => ZPositioned(
    translate: ZVector.only(x: -width / 2),
    rotate: ZVector.only(y: -tau / 4),
    child: ZToBoxAdapter(
      width: width,
      height: height,
      child: leftChild,
    ),
  );

  Widget get rightFace => ZPositioned(
    translate: ZVector.only(x: width / 2),
    rotate: ZVector.only(y: tau / 4),
    child: ZToBoxAdapter(
      width: width,
      height: height,
      child: rightChild,
    ),
  );

  Widget get topFace => ZPositioned(
    translate: ZVector.only(y: -height / 2),
    rotate: ZVector.only(x: -tau / 4),
    child: ZToBoxAdapter(
      width: width,
      height: height,
      child: topChild,
    ),
  );

  Widget get bottomFace => ZPositioned(
    translate: ZVector.only(y: height / 2),
    rotate: ZVector.only(x: tau / 4),
    child: ZToBoxAdapter(
      width: width,
      height: height,
      child: bottomChild,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      children: [
        frontFace,
        rearFace,
        leftFace,
        rightFace,
        topFace,
        bottomFace,
      ],
    );
  }
}
