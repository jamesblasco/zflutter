import 'package:flutter/cupertino.dart';

class MadeWithFlutterContainer extends StatelessWidget {
  final Widget child;
  final FlutterLogoColor logoStyle;

  const MadeWithFlutterContainer(
      {Key? key,
      required this.child,
      this.logoStyle = FlutterLogoColor.original})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: child),
        Align(
          alignment: Alignment.center,
          child: Image(
            image: logoStyle.image(),
            height: 50,
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}

enum FlutterLogoColor {
  original,
  white,
  black,
}

extension FlutterLogoColorImage on FlutterLogoColor {
  ImageProvider image() {
    switch (this) {
      case FlutterLogoColor.original:
        return AssetImage(
          'assets/flutter_original.png',
        );
      case FlutterLogoColor.white:
        return AssetImage(
          'assets/flutter_white.png',
        );
      case FlutterLogoColor.black:
        return AssetImage(
          'assets/flutter_black.png',
        );
    }
  }
}
