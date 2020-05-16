import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iphonepromo/device_promo/promo.dart';
import 'package:iphonepromo/device_promo/starter_app.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zflutter/zflutter.dart';

import 'device_promo/modal_bottom_sheet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Promo - Shot on Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey[200],
        appBarTheme: AppBarTheme(elevation: 0),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AudioPlayer audioPlayer;
  AnimationController animationController;

  AnimationController buttonController;

  double get seconds => animationController.value * totalSecs;

  Animation get fadeInAnimation => CurvedAnimation(
        curve: Interval(
          0 / totalSecs,
          3.4 / totalSecs,
          curve: Curves.easeInOutCirc,
        ),
        parent: animationController,
      );

  Animation get rotationAnimation => CurvedAnimation(
        curve: Interval(
          8.1 / totalSecs,
          12.5 / totalSecs,
          curve: Curves.easeOutCirc,
        ),
        parent: animationController,
      );

  Animation get rotationAroundItselfAnimation => CurvedAnimation(
        curve: Interval(
          12 / totalSecs,
          13 / totalSecs,
          curve: Curves.easeOut,
        ),
        parent: animationController,
      );

  Animation get unlockPhone => CurvedAnimation(
        curve: Interval(
          14.0 / totalSecs,
          14.4 / totalSecs,
        ),
        parent: animationController,
      );

  Animation get lastPhone => CurvedAnimation(
        curve: Interval(
          22.3 / totalSecs,
          23.6 / totalSecs,
          curve: Curves.easeInOut,
        ),
        parent: animationController,
      );

  final totalSecs = 27;
  final bit = 1.80 / 5;
  bool loading = true;

  bool flutterPageIsVisible = false;

  @override
  void initState() {
    buttonController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animationController = AnimationController(
        vsync: this, duration: Duration(seconds: totalSecs));

    animationController.addListener(() {
      setState(() {
        if (animationController.value == 1)
          buttonController.animateBack(0);
        else
          buttonController.forward();
      });
    });

    audioPlayer = AudioPlayer();
    audioPlayer
        .setUrl(audioUrl)
        .then((value) => setState(() => loading = false));
    audioPlayer.onPlayerCompletion.listen((event) {
      if (audioPlayer.state == AudioPlayerState.COMPLETED) stop();
    });


    super.initState();
  }

  final audioUrl =
      'https://firebasestorage.googleapis.com/v0/b/flutterl10n.appspot.com/o/sound.mp3?alt=media&token=4815f752-d43e-4f25-bd26-630e49600053';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomAppBar(
        child: ClipRect(
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
                child: Container(
              height: 20,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.grey[900],
                  inactiveTrackColor: Colors.grey[200],
                  tickMarkShape: RoundSliderTickMarkShape(),
                  trackShape: RectangularSliderTrackShape(),
                  trackHeight: 6.0,
                  thumbColor: Colors.black,
                  overlayColor: Colors.black.withOpacity(0.2),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                ),
                child: Slider(
                    value: animationController.value,
                    min: 0.0,
                    max: 1,
                    onChanged: (double value) =>
                        {animationController.value = value},
                    onChangeStart: (double value) {
                      setState(() {
                        audioPlayer.pause();
                      });
                    },
                    onChangeEnd: (double value) {
                      setState(() {
                        seekToSecond(value);
                      });
                    }),
              ),
            )),
            IconButton(
                icon: Icon(
                  Icons.stop,
                ),
                onPressed: animationController.value > 0 ? stop : null),
            if (loading)
              Container(
                padding: EdgeInsets.all(12),
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                ),
              )
            else
              IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: buttonController,
                  ),
                  onPressed: updateAnimation),
          ]),
        ),
      ),
      body: RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: (event) {
            if (event.physicalKey == PhysicalKeyboardKey.space &&
                event is RawKeyDownEvent) updateAnimation();
          },
          child: Stack(
            children: [
              Center(
                child: ClipRect(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Container(
                      height: 900,
                      width: 1600,
                      color: Colors.white,
                      child: Container(
                        color: Colors.black.withOpacity(0.92),
                        child: AnimatedBuilder(
                          animation: animationController,
                          builder: (context, _) {
                            final seconds =
                                animationController.value * totalSecs;
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                if (seconds > 20.4 && seconds < 23.0)
                                  personalProjectText(),
                                AnimatedIllustration(
                                  controller: animationController,
                                  totalSecs: totalSecs,
                                ),
                                if (seconds > 26.2)
                                  Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        //   hoverColor: Colors.white.withOpacity(0.05),
                                        highlightColor:
                                            Colors.white.withOpacity(0.05),
                                        splashColor:
                                            Colors.white.withOpacity(0.05),
                                        onTap: () => setState(() {
                                          flutterPageIsVisible = true;
                                        }),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/flutter_logo.png',
                                            height: 80,
                                          ),
                                        ),
                                      )),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (flutterPageIsVisible) StarterApp(),
              AnimatedBuilder(
                animation: buttonController,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(0, 1 + 0.1 * buttonController.value),
                    child: Opacity(
                      opacity: 1 - buttonController.value,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('Press Play Button or Spacebar'),
                      ),
                    ),
                  );
                },
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    audioPlayer.stop();
    animationController.dispose();
    buttonController.dispose();
    super.dispose();
  }

  void seekToSecond(double progress) async {
    flutterPageIsVisible = false;
    await audioPlayer
        .seek(Duration(milliseconds: (progress * totalSecs * 1000).toInt()));
    if (!kIsWeb) audioPlayer.resume();
    animationController.stop();
    animationController.forward(from: progress);
    buttonController.forward();
  }

  void updateAnimation() async {
    if (animationController.value == 1) await stop();

    try {
      if (audioPlayer.state != AudioPlayerState.PLAYING) {
        audioPlayer.resume();
        animationController.forward();
        buttonController.forward();
      } else {
        animationController.stop();
        audioPlayer.pause();
        buttonController.animateBack(0);
      }
    } catch (e) {
      print(e);
    }
  }

  Future stop() async {
    flutterPageIsVisible = false;
    try {
      setState(() {
        animationController.value = 0;
      });
      audioPlayer.stop();
      buttonController.animateBack(0);
    } catch (e) {
      print(e);
    }
  }

  Widget personalProjectText() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 40),
          Text(
            'This is a personal project',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          SizedBox(height: 200),
          Opacity(
            opacity: seconds > 20.8 ? 1 : 0,
            child: Container(
                width: 400,
                child: Text(
                  'It is not endorsed by or affiliated with Apple or Flutter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.8,
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 24),
                )),
          ),
        ],
      ),
    );
  }
}

class AnimatedIllustration extends StatelessWidget {
  final AnimationController controller;

  final int totalSecs;

  const AnimatedIllustration({
    Key key,
    this.controller,
    this.totalSecs,
  }) : super(key: key);

  double get seconds => controller.value * totalSecs;

  Animation get fadeInAnimation => CurvedAnimation(
        curve: Interval(
          0 / totalSecs,
          3.4 / totalSecs,
          curve: Curves.easeInOutCirc,
        ),
        parent: controller,
      );

  Animation get rotationAnimation => CurvedAnimation(
        curve: Interval(
          8.1 / totalSecs,
          12.5 / totalSecs,
          curve: Curves.easeOutCirc,
        ),
        parent: controller,
      );

  Animation get rotationAroundItselfAnimation => CurvedAnimation(
        curve: Interval(
          12 / totalSecs,
          13 / totalSecs,
          curve: Curves.easeOut,
        ),
        parent: controller,
      );

  Animation get unlockPhone => CurvedAnimation(
        curve: Interval(
          14.0 / totalSecs,
          14.4 / totalSecs,
        ),
        parent: controller,
      );

  Animation get lastPhone => CurvedAnimation(
        curve: Interval(
          22.3 / totalSecs,
          23.6 / totalSecs,
          curve: Curves.easeInOut,
        ),
        parent: controller,
      );

  final bit = 1.80 / 5;

  @override
  Widget build(BuildContext context) {
    return ZIllustration(
      zoom: 2,
      children: [
        if (seconds > 20.0 && seconds < 23.0)
          SceneSide(style: DeviceStyles.white),
        if (seconds < 1.80)
          IPhonePromo(
              progress: fadeInAnimation.value, style: DeviceStyles.white)
        else if (seconds < 3.0)
          IPhonePromo(progress: fadeInAnimation.value, style: DeviceStyles.red)
        else if (seconds < 3.8)
          IPhonePromo(
            progress: fadeInAnimation.value,
            style: DeviceStyles.black,
          )
        else if (seconds < (3.8 + bit))
          IPhonePromo(style: DeviceStyles.white)
        else if (seconds < (3.8 + 2 * bit))
          IPhonePromo(style: DeviceStyles.red)
        else if (seconds < (3.8 + 3 * bit))
          IPhonePromo(style: DeviceStyles.black)
        else if (seconds < (3.8 + 4 * bit))
          IPhonePromo(style: DeviceStyles.red)
        else if (seconds < (3.8 + 5 * bit))
          IPhonePromo(
            style: DeviceStyles.white,
          )
        else if (seconds < 8.1)
          ZToBoxAdapter(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'iPhone',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: seconds < 7.0 ? 0 : 1,
                            child: Text('Made '),
                          ),
                          Opacity(
                            opacity: seconds < 7.3 ? 0 : 1,
                            child: Text('with '),
                          ),
                          Opacity(
                            opacity: seconds < 7.5 ? 0 : 1,
                            child: Text('Flutter'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        else if (seconds < 8.86)
          IPhonePromoRotate(
            progress: rotationAnimation.value,
            style: DeviceStyles.black,
          )
        else if (seconds < 9.24)
          IPhonePromoRotate(
            progress: rotationAnimation.value,
            style: DeviceStyles.white,
          )
        else if (seconds < 12)
          IPhonePromoRotate(
            progress: rotationAnimation.value,
            style: DeviceStyles.red,
            backgroundColor: DeviceStyles.white.backgroundColor,
          )
        else if (seconds < 12.9)
          IPhonePromoRotateItself(
            progress: rotationAroundItselfAnimation.value,
            style: DeviceStyles.black,
            // child: Image.asset('assets/lock_screen.png'),
            child: Container(color: Colors.black),
          )
        else if (seconds < 15.6)
          IPhonePromoRotateItself(
              progress: rotationAroundItselfAnimation.value,
              style: DeviceStyles.black,
              child: Builder(
                builder: (context) => Stack(
                  fit: StackFit.expand,
                  children: [
                    CupertinoTabView(
                      onGenerateRoute: (settings) {
                        return MaterialWithModalsPageRoute(
                            settings: settings,
                            builder: (context) => ModalBottomSheetExample());
                      },
                    ),
                    if (seconds < 14) Container(color: Colors.black),
                    Positioned(
                      bottom: unlockPhone.value *
                          MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Image.asset('assets/lock_screen.png'),
                    ),
                  ],
                ),
              ))
        else if (seconds < 15.8)
          ZPositioned(
            translate: ZVector.only(x: 0),
            child: IPhonePromoFlick(
              progress: fadeInAnimation.value,
              style: DeviceStyles.red,
            ),
          )
        else if (seconds < 16.0)
          ZPositioned(
            translate: ZVector.only(x: 0),
            child: IPhonePromoFlick(
              progress: fadeInAnimation.value,
              style: DeviceStyles.white,
            ),
          )
        else if (seconds < 16.2)
          ZPositioned(
            translate: ZVector.only(x: 0),
            child: IPhonePromoFlick(
              progress: fadeInAnimation.value,
              style: DeviceStyles.black,
            ),
          )
        else if (seconds < 16.6)
          ZPositioned(
            translate: ZVector.only(x: -150),
            child: IPhonePromoFlick(
              progress: fadeInAnimation.value,
              style: DeviceStyles.red,
            ),
          )
        else if (seconds < 17.0)
          ZPositioned(
            translate: ZVector.only(x: 0),
            child: IPhonePromoFlick(
              progress: fadeInAnimation.value,
              style: DeviceStyles.white,
            ),
          )
        else if (seconds < 17.4)
          ZPositioned(
            translate: ZVector.only(x: 150),
            child: IPhonePromoFlick(
              progress: fadeInAnimation.value,
              style: DeviceStyles.black,
            ),
          )
        else if (seconds < 19)
          ZGroup(
            sortMode: SortMode.update,
            children: [
              if (seconds > 18.0)
                ZPositioned(
                  translate: ZVector.only(x: -180),
                  child: IPhonePromoFlick(
                    progress: fadeInAnimation.value,
                    style: DeviceStyles.red,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              if (seconds > 18.4)
                ZPositioned(
                  translate: ZVector.only(x: 0),
                  child: IPhonePromoFlick(
                    progress: fadeInAnimation.value,
                    style: DeviceStyles.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              if (seconds > 18.8)
                ZPositioned(
                  translate: ZVector.only(x: 180),
                  child: IPhonePromoFlick(
                    progress: fadeInAnimation.value,
                    style: DeviceStyles.black,
                    backgroundColor: Colors.transparent,
                  ),
                )
            ],
          )
        else if (seconds < 23.6)
          IPhonePromoFinal(
            progress: lastPhone.value,
            backgroundColor: Colors.transparent,
            style: DeviceStyles.black,
          )
        else if (seconds < (23.6 + bit))
          IPhonePromoFinal(style: DeviceStyles.white)
        else if (seconds < (23.6 + 2 * bit + 0.1))
          IPhonePromoFinal(style: DeviceStyles.red)
        else if (seconds < (23.6 + 3 * bit))
          IPhonePromoFinal(style: DeviceStyles.black)
        else if (seconds < (23.6 + 4 * bit))
          IPhonePromoFinal(style: DeviceStyles.red)
        else if (seconds < (23.6 + 5 * bit))
          IPhonePromoFinal(style: DeviceStyles.white),
      ],
    );
  }
}
