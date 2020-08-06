import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

class IsometricGrid extends StatefulWidget {
  final int size;
  final double height;
  final double itemSize;

  const IsometricGrid(
      {Key key, this.size = 10, this.itemSize = 20, this.height = 300})
      : super(key: key);

  @override
  _IsometricGridState createState() => _IsometricGridState();
}

class _IsometricGridState extends State<IsometricGrid>
    with SingleTickerProviderStateMixin {
  List<Box> boxes = [];

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.size; i++) {
      for (var j = 0; j < widget.size; j++) {
        boxes.add(Box(i, j, 0));
      }
    }

    animationController = AnimationController(vsync: this);
    animationController.duration = Duration(seconds: 3);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        animationController.forward(from: 0);
    });
    animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final itemSize = widget.itemSize;
    final half = itemSize * widget.size;
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) =>
         ZIllustration(
        children: <Widget>[
          ZPositioned(
            translate: ZVector(-half / 2, 0, -half / 2),
            child: ZPositioned(
              rotate: ZVector(-tau / 20, tau / 8, 0),
              child: ZGroup(
                  children: boxes
                      .map(
                        (box)  {
                          final height =  boxHeightFor(box.x, box.y);
                          return ZPositioned(
                          translate:
                              ZVector(itemSize * box.x, - height/2 + widget.height/2, itemSize * box.y),
                          child: ZBox(
                            height: height,
                            width: itemSize,
                            depth: itemSize,
                            color: Colors.red,
                            topColor: Colors.red[700],
                            rightColor: Colors.red[900],
                            stroke: 1,
                          ),
                        );}
                      )
                      .toList()),
            ),
          )
        ],
      ),
    );
  }

  double boxHeightFor(int x, int y) {
    final progress = animationController.value;
    final height = widget.height;
    final size = widget.size;
    var id = pi * progress + pi * x / size;
    var ij = pi * progress + pi * y / size;
    return (height / 2) + sin(id) * sin(ij) * height / 2;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Box {
  final int x;
  final int y;
  final double progress;

  Box(this.x, this.y, this.progress);
}
