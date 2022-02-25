import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

class ZBox extends StatelessWidget {
  final double width;
  final double height;
  final double depth;

  final double stroke;
  final bool fill;

  final Color color;
  final bool visible;

  final Color? frontColor;
  final Color? rearColor;
  final Color? leftColor;
  final Color? rightColor;
  final Color? topColor;
  final Color? bottomColor;

  const ZBox({
    required this.width,
    required this.height,
    required this.depth,
    this.stroke = 1,
    this.fill = true,
    required this.color,
    this.visible = true,
    this.frontColor,
    this.rearColor,
    this.leftColor,
    this.rightColor,
    this.topColor,
    this.bottomColor,
  });

  Widget get frontFace => ZPositioned(
        translate: ZVector.only(z: depth / 2),
        child: ZRect(
          color: frontColor ?? color,
          fill: fill,
          stroke: 1,
          width: width,
          height: height,
        ),
      );

  Widget get rearFace => ZPositioned(
        translate: ZVector.only(z: -depth / 2),
        rotate: ZVector.only(y: tau / 2),
        child: ZRect(
          width: width,
          height: height,
          color: rearColor ?? color,
          fill: fill,
          stroke: 1,
        ),
      );

  Widget get leftFace => ZPositioned(
        translate: ZVector.only(x: -width / 2),
        rotate: ZVector.only(y: -tau / 4),
        child: ZRect(
          width: depth,
          height: height,
          stroke: 1,
          color: leftColor ?? color,
          fill: fill,
        ),
      );

  Widget get rightFace => ZPositioned(
        translate: ZVector.only(x: width / 2),
        rotate: ZVector.only(y: tau / 4),
        child: ZRect(
          width: depth,
          color: rightColor ?? color,
          height: height,
          stroke: 1,
          fill: fill,
        ),
      );

  Widget get topFace => ZPositioned(
        translate: ZVector.only(y: -height / 2),
        rotate: ZVector.only(x: -tau / 4),
        child: ZRect(
          width: width,
          color: topColor ?? color,
          height: depth,
          stroke: 1,
          fill: fill,
        ),
      );

  Widget get bottomFace => ZPositioned(
        translate: ZVector.only(y: height / 2),
        rotate: ZVector.only(x: tau / 4),
        child: ZRect(
          width: width,
          color: bottomColor ?? color,
          stroke: 1,
          fill: fill,
          height: depth,
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

class ZBoxToBoxAdapter extends StatelessWidget {
  final double width;
  final double height;
  final double depth;

  final double stroke;
  final bool fill;

  final Color color;
  final bool visible;

  final Widget? front;
  final Widget? rear;
  final Widget? left;
  final Widget? right;
  final Widget? top;
  final Widget? bottom;

  ZBoxToBoxAdapter({
    required this.width,
    required this.height,
    required this.depth,
    this.stroke = 1,
    this.fill = true,
    required this.color,
    this.visible = true,
    this.front,
    this.rear,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  Widget get frontFace => ZPositioned(
        translate: ZVector.only(z: depth / 2),
        child: front != null
            ? ZToBoxAdapter(
                height: height,
                width: width,
                child: front,
              )
            : ZRect(
                color: color,
                fill: fill,
                stroke: 1,
                width: width,
                height: height,
              ),
      );

  Widget get rearFace => ZPositioned(
        translate: ZVector.only(z: -depth / 2),
        rotate: ZVector.only(y: tau / 2),
        child: rear != null
            ? ZToBoxAdapter(
                width: width,
                height: height,
                child: rear,
              )
            : ZRect(
                width: width,
                height: height,
                color: color,
                fill: fill,
                stroke: 1,
              ),
      );

  Widget get leftFace => ZPositioned(
        translate: ZVector.only(x: -width / 2),
        rotate: ZVector.only(y: -tau / 4),
        child: left != null
            ? ZToBoxAdapter(
                width: depth,
                height: height,
                child: left,
              )
            : ZRect(
                width: depth,
                height: height,
                stroke: 1,
                color: color,
                fill: fill,
              ),
      );

  Widget get rightFace => ZPositioned(
        translate: ZVector.only(x: width / 2),
        rotate: ZVector.only(y: tau / 4),
        child: right != null
            ? ZToBoxAdapter(
                width: depth,
                height: height,
                child: right,
              )
            : ZRect(
                width: depth,
                height: height,
                color: color,
                stroke: 1,
                fill: fill,
              ),
      );

  Widget get topFace => ZPositioned(
        translate: ZVector.only(y: -height / 2),
        rotate: ZVector.only(x: -tau / 4),
        child: top != null
            ? ZToBoxAdapter(
                width: width,
                height: depth,
                child: top,
              )
            : ZRect(
                width: width,
                height: depth,
                color: color,
                stroke: 1,
                fill: fill,
              ),
      );

  Widget get bottomFace => ZPositioned(
        translate: ZVector.only(y: height / 2),
        rotate: ZVector.only(x: tau / 4),
        child: bottom != null
            ? ZToBoxAdapter(
                width: width,
                height: depth,
                child: bottom,
              )
            : ZRect(
                width: width,
                height: depth,
                color: color,
                stroke: 1,
                fill: fill,
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
