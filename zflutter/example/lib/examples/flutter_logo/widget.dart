import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

import 'anchors/dash.dart';
import 'anchors/flutter_logo.dart';

class FlutterAnimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => (_FlutterAnimationState());
}

class _FlutterAnimationState extends State<FlutterAnimation>
    with TickerProviderStateMixin {
  AnimationController animationController;

  AnimationController dashController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    update();
  }

  update() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted)
        animationController.forward(from: 0).whenComplete(() => update());
    });
  }

  @override
  Widget build(BuildContext context) {
    final startAnim = CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0,
        0.4,
        curve: Curves.easeInOut,
      ),
    );
    final endAnim = CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.6,
        1,
        curve: Curves.easeInOut,
      ),
    );

    List<Animation> dashAnimations = List.generate(
        20,
        (index) => Tween<double>(
              begin: 0,
              end: index.isEven ? 1 : -1,
            ).animate(
              CurvedAnimation(
                parent: animationController,
                curve: Interval(
                  index * 0.05,
                  (index + 1) * 0.05,
                  curve: Curves.ease,
                ),
              ),
            ));

    final curved =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue[50],
      child: ZDragDetector(
        builder: (context, controller) {
          return AnimatedBuilder(
            animation: animationController,
            builder: (context, _) {
              final progress = startAnim.value - endAnim.value;
              final rotationAnimation = (-tau / 2) * (progress);
              Tween(begin: 0.0, end: -tau / 2).evaluate(curved);
              final zoom = lerpDouble(0.8, 1.6, progress);
              final xrotate = -(0.5 - (progress - 0.5).abs()) * tau / 8;
              final dash = dashAnimations.fold(
                  0, (previousValue, element) => previousValue + element.value);

              return ZIllustration(
                zoom: zoom,
                children: [
                  ZPositioned(
                    rotate: ZVector.only(y: rotationAnimation, x: xrotate) +
                        controller.rotate,
                    translate: ZVector.only(y: 40),
                    child: ZGroup(
                      sortMode: SortMode.update,
                      children: [
                        ZPositioned(
                          translate: ZVector.only(x: -40),
                          scale: ZVector.all(4),
                          child: FlutterAnchor(),
                        ),
                        ZGroup(sortMode: SortMode.update, children: [
                          ZPositioned(
                            rotate: ZVector.only(y: tau / 2),
                            translate: ZVector.only(z: -50, y: 24, x: 2),
                            child: Dash(flight: dash),
                          ),
                          ZPositioned(
                            rotate: ZVector.only(
                                y: tau / 2 + tau / 40, x: -tau / 40),
                            translate: ZVector.only(z: -50, y: 70, x: 40),
                            child: Dash(flight: 1 - dash),
                          ),
                          ZPositioned(
                            rotate: ZVector.only(
                                y: tau / 2 - tau / 40, x: -tau / 40),
                            translate: ZVector.only(z: -50, y: -20, x: 40),
                            child: Dash(flight: dash),
                          ),
                        ]),
                        ZGroup(sortMode: SortMode.update, children: [
                          ZPositioned(
                            rotate: ZVector.only(
                                y: tau / 2 + tau / 40, x: -tau / 30),
                            translate: ZVector.only(z: -50, y: -45, x: -75),
                            child: Dash(flight: 1 - dash),
                          ),
                          ZPositioned(
                            rotate: ZVector.only(y: tau / 2 + tau / 45),
                            translate: ZVector.only(z: -50, y: -85, x: -35),
                            child: Dash(flight: dash),
                          ),
                          ZPositioned(
                            rotate: ZVector.only(y: tau / 2),
                            translate: ZVector.only(z: -50, y: -130, x: 5),
                            child: Dash(flight: 1 - dash),
                          ),
                          ZPositioned(
                            rotate: ZVector.only(
                                y: tau / 2 - tau / 40, x: tau / 40),
                            translate: ZVector.only(z: -50, y: -170, x: 50),
                            child: Dash(flight: dash),
                          )
                        ])
                      ],
                    ),
                  )
                ],
              );
            },
          );
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
