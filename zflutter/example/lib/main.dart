import 'package:flutter/material.dart';

import 'examples/examples.dart';
import 'examples/getting_started.dart';
import 'flutter_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.grey[200],
        appBarTheme: AppBarTheme(elevation: 0),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        ...[...Examples.list, ...BasicSamples.list, ...GettingStartedSamples.list].asMap().map(
              (key, example) => MapEntry(
                example.route,
                (context) => Scaffold(
                  backgroundColor: example.backgroundColor,
                  appBar: example.route == '/logo'
                      ? null
                      : AppBar(
                          centerTitle: true,
                          title: Text(example.title),
                        ),
                  body: MadeWithFlutterContainer(
                    child: example.builder(context),
                    logoStyle: example.logoStyle ?? FlutterLogoColor.original,
                  ),
                ),
              ),
            ),
        // Demos for the website
        ...[...Examples.list, ...BasicSamples.list, ...GettingStartedSamples.list].asMap().map(
              (key, example) => MapEntry(
                  '/demo${example.route}',
                  (context) => Container(
                        color: example.backgroundColor ?? Color(0xffF5F6FA),
                        child: Transform.scale(
                          scale: 0.45,
                          child: example.builder(context),
                        ),
                      )),
            ),
      },
      home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zflutter'),
      ),
      body: GridView.builder(
        itemBuilder: (context, index) {
          final item = examples[index];
          return KeyedSubtree(
            key: Key(item.title),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(item.route);
              },
              child: Stack(
                children: [
                  Transform.scale(
                      scale: 0.2,
                      child: TickerMode(
                          enabled: false, child: item.builder(context))),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.grey[100].withOpacity(0.8),
                    child: Center(
                        child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    )),
                  )
                ],
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
          childAspectRatio: 1,
        ),
        itemCount: examples.length,
      ),
    );
  }

  List<Example> get examples => [
        ...Examples.list,
        ...BasicSamples.list,
        ...GettingStartedSamples.list
      ];
}
