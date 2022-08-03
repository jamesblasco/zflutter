import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

class BugFix extends StatelessWidget {
  const BugFix({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZIllustration(
      children: [
        ZGroup(
       //   sortMode: SortMode.update,
          children: [
            ZBox(width: 40, height: 40, depth: 40, color: Colors.red),
            ZGroup(
              children: [
                ZPositioned(
                  translate: ZVector(0, 0, 100),
                  child: AnimatedCircle(
                    child: ZGroup(sortMode: SortMode.update, children: [
                      ZCircle(
                        diameter: 20,
                        color: Colors.blue,
                        fill: true,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class AnimatedCircle extends StatefulWidget {
  AnimatedCircle({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<AnimatedCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller =
      AnimationController(vsync: this, duration: Duration(seconds: 4));

  @override
  void initState() {
    controller.addListener(() {
      setState(() {});
    });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZPositioned(
      rotate: ZVector(0, tau * controller.value, 0),
      child: widget.child,
    );
  }
}
