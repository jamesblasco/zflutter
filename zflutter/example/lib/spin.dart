import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

class Spin extends StatefulWidget {
  final Widget Function(BuildContext context, ZVector controller) builder;

  const Spin({Key key, this.builder}) : super(key: key);

  @override
  State<StatefulWidget> createState() => (_SpinState());
}

class _SpinState extends State<Spin> with TickerProviderStateMixin {
  AnimationController animationController;

  Timer timer;
  bool spin = true;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animate();
  }

  animate({double from= 0}) {
    spin =  true;
    animationController.forward(from: from).then(
      (value) {
        if (mounted && spin) animate();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final curved =
        CurvedAnimation(parent: animationController, curve: Curves.linear);
    return GestureDetector(
        onTap: () {
          setState(() {
           /* timer?.cancel();
            timer = Timer(Duration(seconds: 5), () => animate(from: animationController.value));*/
            spin = false;
          });
          animationController.stop();
        },
        onPanDown: (_) {
          setState(() {
          /*  timer?.cancel();
            timer = Timer(Duration(seconds: 5), () => animate(from: animationController.value));*/
            spin = false;
          });
          animationController.stop();
        },
        onPanUpdate: (_) {
          setState(() {
            spin = false;
           /* timer?.cancel();
            timer = Timer(Duration(seconds: 5), () => animate(from: animationController.value));*/
          });
        },
        behavior: HitTestBehavior.translucent,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) => widget.builder(
            context,
            ZVector(0, curved.value * tau, 0),
          ),
        ));
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    animationController.dispose();
    super.dispose();
  }
}
