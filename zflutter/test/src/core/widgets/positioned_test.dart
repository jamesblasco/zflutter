import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zflutter/zflutter.dart';

void main() {
  group('Positioned', () {
    goldenTest(
      'positions correctly',
      fileName: 'positioned',
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
      widget: GoldenTestGroup(
        columnWidthBuilder: (_) => const FixedColumnWidth(200),
        children: [
          GoldenTestScenario(
            name: 'zero',
            child: GoldenIllustration(
              child: ZPositioned(
                child: ZSphere(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'translated x',
            child: GoldenIllustration(
              child: ZPositioned(
                translate: ZVector.only(x: 20),
                child: ZSphere(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'translated y',
            child: GoldenIllustration(
              child: ZPositioned(
                translate: ZVector.only(y: 20),
                child: ZSphere(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'translated z',
            child: GoldenIllustration(
              child: ZPositioned(
                translate: ZVector.only(z: 20),
                child: ZSphere(),
              ),
            ),
          ),
        ],
      ),
    );
  });
}

class ZSphere extends StatelessWidget {
  const ZSphere({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZBox(
      width: 20,
      height: 20,
      depth: 20,
      color: Colors.green.withOpacity(0.5),
      frontColor: Colors.red,
      leftColor: Colors.blue,
      rightColor: Colors.green,
      rearColor: Colors.yellow,
      bottomColor: Colors.pink,
      topColor: Colors.purple,
      fill: true,
    );
  }
}

class GoldenIllustration extends StatelessWidget {
  const GoldenIllustration({Key? key, this.size = 200, required this.child})
      : super(key: key);

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Container(
        color: Colors.white,
        child: ZIllustration(
          children: [
            child,
            ZCircle(
              diameter: 4,
              color: Colors.blue,
              fill: true,
            ),
          ],
        ),
      ),
    );
  }
}
