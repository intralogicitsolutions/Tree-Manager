// import 'package:background_locator/background_locator.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
// import 'package:pushy_flutter/pushy_flutter.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class MoreOption extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MoreOptionState();
  }
}

class MoreOptionState extends State<MoreOption> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> dash = [
      {
        'label': 'Help',
        'icon': 'Help_Center.svg',
        'action': 'route',
        'goto': 'help_center'
      },
      {
        'label': 'Reports',
        'icon': 'round-bar_chart-24px.svg',
        'action': 'route',
        'goto': 'reports'
      },
      {
        'label': 'Payments',
        'icon': 'round-payment-24px.svg',
        'action': 'route',
        'goto': 'payment_list'
      },
      {
        'label': 'Availability',
        'icon': 'Schedule-Icon.svg',
        'action': 'dialog',
        'goto': comingSoonDialog
      },
      {
        'label': 'Setting',
        'icon': 'round-settings-24px.svg',
        'action': 'dialog',
        'goto': comingSoonDialog
      },
      {
        'label': 'Logout',
        'icon': 'logout.svg',
        'action': 'dialog',
        'goto': signoutDialog
      }
    ];

    print("dae = ${DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now())}");
    print('Lngth-${dash.length}');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context, title: "More"),
      body: Stack(
        children: <Widget>[
          Center(
            child: Visibility(
              child: Image.asset(
                'assets/images/background_image.png',
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
              ),
              visible: false,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 4 / 3,
                    crossAxisCount: 2,
                    children: List.generate(dash.length, (index) {
                      var item = dash[index];
                      return GestureDetector(
                        onTap: () async {
                          if (item['action'] == 'route')
                            Navigator.pushNamed(context, item['goto']);
                          else {
                            if (item['goto'] is Function) item['goto']();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: Container(
                            decoration:
                                BoxDecoration(color: Themer.textGreenColor),
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    "assets/images/${item['icon']}",
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        item['label'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }))
              ],
            ),
          )
        ],
      ),
    );
  }
  // Future signoutDialog() async {
  //   var action = await Helper.showMultiActionModal(
  //     context,
  //     title: 'Logout!',
  //     description: 'Are you sure to logout?',
  //     negativeButtonText: 'NO',
  //     negativeButtonimage: 'reject.svg',
  //     positiveButtonText: 'LOGOUT',
  //     positiveButtonimage: 'accept.svg',
  //   );
  //
  //   if (action != null) {
  //     if (action) {
  //       SharedPreferences.getInstance().then((sp) async {
  //         sp.remove('user');
  //         Global.locationRunning = false;
  //
  //         if (await BackgroundLocator.isRegisterLocationUpdate()) {
  //           print('registered');
  //
  //           // Since Firebase Cloud Messaging (FCM) doesn't have a direct toggle method,
  //           // You can stop processing messages based on the app state or a custom condition.
  //
  //
  //           // await FirebaseMessaging.instance.unsubscribeFromTopic('all_users'); // Example: Unsubscribe from a topic
  //
  //           await BackgroundLocator.unRegisterLocationUpdate();
  //         }
  //
  //         Navigator.pushReplacementNamed(context, 'login');
  //       });
  //     }
  //   }
  // }


  Timer? _locationUpdateTimer;

  void startLocationUpdates(double intervalMinutes) {
    var intervalSeconds = intervalMinutes * 60;

    _locationUpdateTimer = Timer.periodic(Duration(seconds: intervalSeconds.toInt()), (Timer timer) async {
      // Fetch location using Geolocator
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Handle the location update
      print('Lat: ${position.latitude}, Long: ${position.longitude}');

      // Example of sending location data to a server
      sendLocationToServer(position);
    });
  }

  void stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
  }

  Future<void> sendLocationToServer(Position position) async {
    // Replace with your actual implementation
    print('Sending location to server: ${position.latitude}, ${position.longitude}');
  }

  void signoutDialog() async {
    var action = await Helper.showMultiActionModal(
        context,
        title: 'Logout!',
        description: 'Are you sure to logout?',
        negativeButtonText: 'NO',
       negativeButtonimage: 'reject.svg',
        positiveButtonText: 'LOGOUT',
        positiveButtonimage: 'accept.svg'
    );

    if (action != null && action) {
      SharedPreferences.getInstance().then((sp) async {
        // Remove user data from SharedPreferences
        sp.remove('user');
        Global.locationRunning = false;

        // Stop periodic location updates
        stopLocationUpdates();

        // Optionally, handle Pushy notifications here if needed
        // Pushy.toggleNotifications(false);

        // Navigate to login screen
        Navigator.pushReplacementNamed(context, 'login');
      });
    }
  }



  // Future signoutDialog() async {
  //   var action = await Helper.showMultiActionModal(context,
  //       title: 'Logout!',
  //       description: 'Are you sure to logout?',
  //       negativeButtonText: 'NO',
  //       negativeButtonimage: 'reject.svg',
  //       positiveButtonText: 'LOGOUT',
  //       positiveButtonimage: 'accept.svg');
  //   if (action != null) {
  //     if (action) {
  //       SharedPreferences.getInstance().then((sp) async {
  //         sp.remove('user');
  //         Global.locationRunning=false;
  //         if(await BackgroundLocator.isRegisterLocationUpdate())
  //         {
  //           print('registered');
  //           //Pushy.toggleNotifications(false);
  //           BackgroundLocator.unRegisterLocationUpdate();
  //
  //         }
  //         Navigator.pushReplacementNamed(context, 'login');
  //       });
  //     }
  //   }
  // }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }

  comingSoonDialog() {
    Helper.showSingleActionModal(context,
        description: 'This option will be available soon.',
        title: 'Coming Soon!');
  }
}
