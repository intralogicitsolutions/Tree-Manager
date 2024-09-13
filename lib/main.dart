// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_manager/helper/helper.dart';
import 'dialog/splashscreen.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride, kDebugMode;

void main() async{

  // debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  if (kDebugMode) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  }
  WidgetsFlutterBinding.ensureInitialized();
 // await Firebase.initializeApp();
  // CatcherOptions debugOptions = CatcherOptions(PageReportMode(), [
  //   ConsoleHandler(
  //       enableApplicationParameters: true,
  //       enableDeviceParameters: true,
  //       enableCustomParameters: true,
  //       enableStackTrace: true),
  //   ToastHandler()
  // ]);
  // CatcherOptions releaseOptions = CatcherOptions(NotificationReportMode(), [
  //   EmailManualHandler(["manu.abaft@email.com"])
  // ]);

  // Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);

  runApp(new MaterialApp(
    home: new MyApp(),
    debugShowCheckedModeBanner: false,
    routes: Helper.routes,
    //initialRoute: Helper.user.id!=''?'dashboard':'login',
  ));
  //  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    // Start the Pushy service
    Helper.makeUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 2,
      navigateAfterSeconds: () async {
        if (Helper.user != null && Helper.user!.id != null ||
            (await SharedPreferences.getInstance()).containsKey('user')) {
          Navigator.pushReplacementNamed(context, 'dashboard');
          //Navigator.pushReplacementNamed(context, 'dashboard');
          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SiteInspection()));
        } else
          Navigator.pushReplacementNamed(context, 'login');
      },
      title: new Text(
        'Welcome To TreeManager',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.asset(Helper.AppImage),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Colors.red,
    );
  }
}

/*class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Tree Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Themer.textGreenColor and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: QuoteList(),
      debugShowCheckedModeBanner: false,
      routes: Helper.routes,
      initialRoute: Helper.user.id!=''?'dashboard':'login',
    );
  }
}*/
