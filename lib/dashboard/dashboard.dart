import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:background_locator/background_locator.dart';
// import 'package:background_locator/location_dto.dart';
// import 'package:background_locator/settings/android_settings.dart';
// import 'package:background_locator/settings/ios_settings.dart';
// import 'package:background_locator/settings/locator_settings.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/notification/NotificationCounterBloc.dart';
import 'package:tree_manager/pojo/Job.dart';
import 'package:tree_manager/pojo/dash_search.dart';
import 'package:tree_manager/pojo/dashboard.dart';
import 'package:tree_manager/pojo/notification.dart' as Noti;
import 'package:tree_manager/pojo/option.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pojo/locationDto.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard>
    with
        SingleTickerProviderStateMixin /* with WidgetsBindingObserver,RouteAware*/ {
  static List<Dash> dashData = [];
  var pending = 0;
  bool is_fetching = false;
  var distance = 5.00;

  late AnimationController _animationController;
  late Animation _animation;


//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize Firebase Messaging
//     FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//     // Request permissions on iOS
//     _firebaseMessaging.requestPermission();
//
//     // Set the default notification icon (for Android)
//     // Note: This is typically set in AndroidManifest.xml or the notification payload itself.
//     // For custom icons, you need to place your icon in the 'res/drawable' directory.
//     // Firebase doesn't directly manage this through code like Pushy.
//
//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Received foreground notification: ${message.data}');
//       // Handle the notification data and display it in the app as needed
//     });
//
//     // Handle background/terminated notification clicks
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Notification clicked: ${message.data}');
//       // Handle the notification click, navigate, or perform other actions
//     });
//
//     // For background message handling when the app is completely killed, implement a background message handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     // Initialize your other components as before
//     Helper.counter = CounterBloc(initialCount: 0);
//     _animationController =
//         AnimationController(vsync: this, duration: Duration(seconds: 2));
//     _animationController.repeat(reverse: true);
//     _animation = Tween(begin: 2.0, end: 8.0).animate(_animationController)
//       ..addListener(() {
//         setState(() {});
//       });
//
//     Future.delayed(Duration.zero, () {
//       checkForUpdate();
//     });
//     Global.job = null;
//     getDashboard();
//     getCommentPreloads();
//
//     // Uncomment if needed
//     // Timer.periodic(Duration(seconds: 30), (timer) {
//     //   Helper.getNotificationCount();
//     // });
//
//     setState(() {});
//   }
//
// // Background message handler (to handle messages when the app is in the background)
//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     print("Handling a background message: ${message.messageId}");
//     // Process the message as needed
//   }

  @override
  void initState() {
    //WidgetsBinding.instance.addObserver(this);
    // Pushy.listen();
    // Pushy.toggleNotifications(true);
    // Pushy.requestStoragePermission();
    //Pushy.setNotificationIcon('ic_launcher');
    // pushyRegister();
    // listenNotification();
    Helper.counter = CounterBloc(initialCount: 0);
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 8.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(Duration.zero, () {
      checkForUpdate();
    });
    Global.job = null;
    getDashboard();
    getCommentPreloads();
    // Timer.periodic(Duration(seconds: 30), (timer){
    //   Helper.getNotificationCount();
    // });
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  var filterCtrl = TextEditingController();
  List<DashSearch>? dashSearch = [];

  @override
  Widget build(BuildContext context) {
    Global.noti = null;
    var dash = [
      {
        'label': 'Jobs to Accept',
        'icon': 'Accept-Icon.svg',
        'count_1': getCount('Await Acceptance'),
        'count_2': getPending('Await Acceptance'),
        'data_label': 'Await Acceptance',
        'goto': 'job_list'
      },
      {
        'label': 'Jobs to Schedule',
        'icon': 'Schedule-Icon.svg',
        'count_1': getCount('To Schedule'),
        'count_2': getPending('To Schedule'),
        'data_label': 'To Schedule',
        'goto': 'schedule_list'
      },
      {
        'label': 'Jobs to Quote',
        'icon': Helper.countryCode == "UK"
            ? "pound_symbol_white.svg"
            : 'Dollar-Quote.svg',
        'count_1': getCount('To Quote'),
        'count_2': getPending('To Quote'),
        'data_label': 'To Quote',
        'goto': 'quote_list'
      },
      {
        'label': 'Await Approval',
        'icon': 'EnviroApproval.svg',
        'count_1': getCount('Waiting for Approval'),
        'count_2': getPending('Waiting for Approval'),
        'data_;abel': 'Waiting for Approval',
        'goto': 'enviro_list'
      },
      {
        'label': 'Schedule Work',
        'icon': 'ScheduleWork.svg',
        'count_1': getCount('To Schedule Works'),
        'count_2': getPending('To Schedule Works'),
        'data_label': 'To Schedule Works',
        'goto': 'schedule_work'
      },
      {
        'label': 'Complete Job',
        'icon': 'SubmitInvoice.svg',
        'count_1': getCount('To Invoice'),
        'count_2': getPending('To Invoice'),
        'data_label': 'To Invoice',
        'goto': 'send_invoice'
      }
    ];
    Size size = MediaQuery.of(context).size;
    Helper.bottom_nav_selected = 0;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "${Helper.user!.userName}", backArrow: false, counter: 2),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          filterCtrl.clear();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
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
              child: ListView(
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Search Job no, Site Address, Claim...',
                              prefixIcon: SvgPicture.asset(
                                'assets/images/Search-Icon.svg',
                                fit: BoxFit.scaleDown,
                              ),
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      filterCtrl.clear();
                                      dashSearch?.clear();
                                    });
                                  })),
                          controller: filterCtrl,
                          onChanged: (text) {
                            if (text == '' ||
                                text.length == 0) {
                              setState(() {
                                filterCtrl.clear();
                                dashSearch?.clear();
                              });
                            } else {
                              searchDash(text);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Total no. of Job Action Pending:",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "$pending",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Themer.textGreenColor),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  filterCtrl.text.length == 0
                      ? GridView.count(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          childAspectRatio: 4.8 / 2.8,
                          crossAxisCount: 2,
                          children: List.generate(dash.length, (index) {
                            var item = dash[index];
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.pushNamed(
                                    context, item['goto'].toString());
                                getDashboard();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(1),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Themer.dashBoardGridItemColor),
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: new Container(
                                          padding:
                                              EdgeInsets.fromLTRB(2, 5, 2, 2),
                                          decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: (() {
                                                if (item['count_2'] != 0) {
                                                  return [
                                                    BoxShadow(
                                                        color: Colors.white,
                                                        blurRadius:
                                                            _animation.value,
                                                        spreadRadius:
                                                            _animation.value)
                                                  ];
                                                } else
                                                  return null;
                                              })()),
                                          constraints: BoxConstraints(
                                            minWidth: 25,
                                            minHeight: 25,
                                          ),
                                          child: Text(
                                            item['count_2'].toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        heightFactor: 0.5,
                                        widthFactor: 0.5,
                                        child: SvgPicture.asset(
                                          "assets/images/${item['icon']}",
                                          height: 30,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                item['label']as String,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                item['count_1'].toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
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
                      : dashboardSearch()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getDashboard() {
    Helper.get(
        "nativeappservice/fetchDashboardData?contractor_id=${Helper.user?.companyId}",
        {}).then((data) {
      dashData =
          (jsonDecode(data.body) as List).map((f) => Dash.fromJson(f)).toList();
      pending = dashData.map((f) => f.overdueCount).reduce((a, b) => a! + b!)!;
      try {
        setState(() {});
      } catch (e) {}
    });
    Helper.getNotificationCount();
  }

  static int? getCount(String key) {
    var tmp = dashData.where((test) => test.jobstatusCons == key).toList();
    if (tmp.length > 0)
      return tmp[0].countOfJobs;
    else
      return 0;
  }

  static int? getPending(String key) {
    var tmp = dashData.where((test) => test.jobstatusCons == key).toList();
    if (tmp.length > 0)
      return tmp[0].overdueCount;
    else
      return 0;
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }

  void getCommentPreloads() {
    if (Global.substa_cost == null)
      Helper.get("nativeappservice/loadOptionDetails?workflow_step=Costing", {})
          .then((data) {
        Global.substa_cost = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });

    if (Global.eta_not == null)
      Helper.get(
          "nativeappservice/loadOptionDetails?workflow_step=ETA%20not%20Confirmed",
          {}).then((data) {
        Global.eta_not = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });

    if (Global.comment == null)
      Helper.get(
              "nativeappservice/loadOptionDetails?workflow_step=Comments", {})
          .then((data) {
        Global.comment = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });

    if (Global.emergency_contact == null)
      Helper.get(
          "nativeappservice/loadOptionDetails?workflow_step=Accident%20Options",
          {}).then((data) {
        Global.emergency_contact = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });

    if (Global.work_not_completed == null)
      Helper.get(
          "nativeappservice/loadOptionDetails?workflow_step=Work%20Options",
          {}).then((data) {
        Global.work_not_completed = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });

    if (Global.before_photos == null)
      Helper.get(
          "nativeappservice/loadOptionDetails?workflow_step=Before%20Images",
          {}).then((data) {
        Global.before_photos = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });

    if (Global.after_photos == null)
      Helper.get(
          "nativeappservice/loadOptionDetails?workflow_step=After%20Images",
          {}).then((data) {
        Global.after_photos = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });

    if (Global.approval == null)
      Helper.get(
          "nativeappservice/loadOptionDetails?workflow_step=Request%20Update",
          {}).then((data) {
        Global.approval = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });
  }

  /*@override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('LifeCycleChanged');
    if (state == AppLifecycleState.resumed) {
      print('LifeCycleChanged:Resumed');
      initState();
    }
  }

  @override
  Future<bool> didPopRoute() {
    print('poped');
    return super.didPopRoute();
  }

  @override
  void didPopNext() {
    print('poped2');
    super.didPopNext();
  }*/

  void searchDash(String val) {
    is_fetching = true;
    Helper.get(
        "nativeappservice/dashboardSearch?process_id=${Helper.user?.processId}&contractor_id=${Helper.user?.companyId}&searchValue=${val}",
        {}).then((value) {
      is_fetching = false;
      setState(() {
        dashSearch = (jsonDecode(value.body) as List)
            .map((e) => DashSearch.fromJson(e))
            .toList();
      });
    }).catchError((onError) {
      is_fetching = false;
    });
  }

  Widget dashboardSearch() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        height: MediaQuery.of(context).size.height - 10,
        //margin: EdgeInsets.only(left: 15.0,right: 15.0),
        color: Colors.white,
        child: is_fetching
            ? Center(
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.black,
                    ),
                    Text("Loading")
                  ],
                ),
              )
            : dashSearch?.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: dashSearch == null ? 0 : dashSearch?.length,
                    itemBuilder: (context, index) {
                      var quote = dashSearch![index];
                      return Container(
                        color: index % 2 == 0
                            ? Themer.listEvenColor
                            : Themer.listOddColor,
                        child: SizedBox(
                            height: 260,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text("Job No: TM ${quote.jobNo}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Themer.textGreenColor)),
                                  Text(
                                    quote.fullAddress ?? ' ',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            height: 100.0,
                                            width: 100.0,
                                            margin:
                                                EdgeInsets.only(bottom: 10.0),
                                            child: FittedBox(
                                              child: FloatingActionButton(
                                                  heroTag: '${quote.jobId}_${UniqueKey()}',
                                                 // heroTag: '${quote.jobId}',
                                                  child: SvgPicture.asset(
                                                      'assets/images/view_job.svg'),
                                                  onPressed: () {
                                                    Global.job = Job(
                                                        jobId: quote.jobId,
                                                        jobNo: quote.jobNo,
                                                        jobAllocId:
                                                            quote.allocationId);
                                                    switch (
                                                        quote.navigationStep) {
                                                      case "1":
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                'job_list',
                                                                arguments: {
                                                              'job_no':
                                                                  quote.jobNo
                                                            });
                                                        break;
                                                      case "2":
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                'job_detail');
                                                        break;
                                                      case "3":
                                                      case "4":
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                'site_inspection');
                                                        break;
                                                      case "5":
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                'schedule_detail');
                                                        break;
                                                      case "6":
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                'invoice');
                                                        break;
                                                      default:
                                                    }
                                                  }),
                                            )),
                                        Text(
                                          "VIEW JOB",
                                          style: TextStyle(
                                              color: Themer.textGreenColor),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No Data Available',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
      ),
    );
  }
  Future<bool> checkIfRealDevice() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  return !androidInfo.isPhysicalDevice; // This is a simple check
}

  void checkForUpdate() {
    print('is android==>${Platform.isAndroid}   ios==>${Platform.isIOS}');
    Helper.get(
        'nativeappservice/getappversion?company_id=${Helper.user?.companyId}',
        {}).then((value) async {
      try {
        var json = jsonDecode(value.body) as List;
        var s = Platform.isAndroid
            ? json[0]['android_version'].toString().split('.').join()
            : json[0]['apple_version'].toString().split('.').join();
             final packageInfo = await PackageInfo.fromPlatform();
             final appVersion = packageInfo.version.split('.').join();

    print('App version: $appVersion, Server version: $s');
    var l = appVersion;
        // var l = Platform.isAndroid
        //     ? (await GetVersion.projectCode)
        //     : (await GetVersion.projectVersion).split('.').join();
        print('l=$l  s=$s');
        if (s.length < 3) {
          s = s + '0';
        } else {
          s = "0";
        }
        if (l.length < 3) l = l + '0';
        var loc = int.parse(l);
        var ser = int.parse(s);
        print('loc=$loc  ser=$ser');

        if (await checkIfRealDevice()) {
          try {
            if ((json[0] as Map).containsKey('distance'))
              distance = double.parse(json[0]['distance'].toString());
          } catch (e) {
            distance = 0.00;
          }
          print("Distance= $distance");
          _checkLocationPermission(double.parse(json[0]['location_timer']));
        } else {
          print(
              'This is not a real device and hence location service wont work');
        }

        if (loc < ser) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => WillPopScope(
                    onWillPop: () async => await false,
                    child: AlertDialog(
                      title: Text('New Version found'),
                      content: Text('New version of TreeManager is available'),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                              SystemNavigator.pop();
                              exit(0);
                            },
                            child: Text('Exit')),
                        // TextButton(
                        //     onPressed: () {
                        //       StoreRedirect.redirect(iOSAppId: '1500781878');
                        //     },
                        //     child: Text('Update')),
                        // TextButton(
                        //   onPressed: () async {
                        //     const url = 'https://apps.apple.com/app/id1500781878'; // Replace with your iOS app's store link
                        //     if (await canLaunch(url)) {
                        //       await launch(url, forceSafariVC: false, forceWebView: false);
                        //     } else {
                        //       throw 'Could not launch $url';
                        //     }
                        //   },
                        //   child: Text('Update'),
                        // )
                        TextButton(
                          onPressed: () async {
                            final url = Uri.parse('https://apps.apple.com/app/id1500781878'); // Replace with your iOS app's store link
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text('Update'),
                        )

                      ],
                    ),
                  ));
        }
      } catch (e) {
        print(e);
      }
    });
  }

  //new
  // static void callback(LocationDto locationDto) async {
  //   print('lat2=${locationDto.latitude} long2=${locationDto.longitude}');
  //   if (Global.previousLocation == null ||
  //       Helper.getDistance(locationDto) > 50) {
  //     Global.previousLocation = locationDto;
  //     Helper.makeUser().then((user) {
  //       print("user from location=${user!.toJson()}");
  //       Helper.post(
  //               'GeoLocation/Create',
  //               {
  //                 'id': null,
  //                 'company_id': user.companyId.toString(),
  //                 'user_id': user.id,
  //                 'process_id': user.processId.toString(),
  //                 'location1_value': locationDto.latitude.toString(),
  //                 'location2_value': locationDto.longitude.toString(),
  //                 'created_by': user.id,
  //                 'created_at':
  //                     "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
  //                 'status': '1'
  //               },
  //               is_json: true)
  //           .then((value) {
  //         print(value.body);
  //       });
  //       // Helper.post2('http://bigopay.in/tm/gps', {'lat':locationDto.latitude.toString(),'long':locationDto.longitude.toString()});
  //     });
  //   } else {
  //     print('distance is less than 5 mtr');
  //   }
  // }

  void locationCallback(Position position) async {
    print('lat2=${position.latitude} long2=${position.longitude}');
    var locationDto = LocationDto(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    if (Global.previousLocation == null ||
        Helper.getDistance(locationDto) > 50) {
      Global.previousLocation = LocationDto(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      Helper.makeUser().then((user) {
        // print("user from location=${user.toJson()}");
        Helper.post(
          'GeoLocation/Create',
          {
            'id': null,
            'company_id': user?.companyId.toString(),
            'user_id': user?.id,
            'process_id': user?.processId.toString(),
            'location1_value': position.latitude.toString(),
            'location2_value': position.longitude.toString(),
            'created_by': user?.id,
            'created_at': "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
            'status': '1'
          },
          is_json: true,
        ).then((value) {
          print(value.body);
        });
      });
    } else {
      print('distance is less than 50 m');
    }
  }


  void _checkLocationPermission(double interval) async {
    debugPrint("Print the log");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      startLocationService(interval);
    } else {
      // Show error or prompt to request permission again
      print("Location permission not granted");
    }
  }


  Future<void> startLocationService(double interval) async {
    if (!Global.locationRunning) {
      // Start periodic location updates
      Timer.periodic(Duration(minutes: interval.toInt()), (Timer timer) async {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        locationCallback(position);
      });

      Global.locationRunning = true;
      print("Location service started");
    } else {
      print("Location service is already running");
    }
  }

// void _checkLocationPermission(double interval) async {
  //   debugPrint("Print the log");
  //   // final access = await LocationPermissions().checkPermissionStatus();
  //   // switch (access) {
  //   //   case PermissionStatus.unknown:
  //   //   case PermissionStatus.denied:
  //   //   case PermissionStatus.restricted:
  //   //     final permission = await LocationPermissions().requestPermissions(
  //   //       permissionLevel: LocationPermissionLevel.locationAlways,
  //   //     );
  //   //     if (permission == PermissionStatus.granted) {
  //   //       startLocationService(interval);
  //   //     } else {
  //   //       // show error
  //   //     }
  //   //     break;
  //   //   case PermissionStatus.granted:
  //   //     startLocationService(interval);
  //   //     break;
  //   // }
  //   // print("dssdsd $access");
  // }

  // Future<void> startLocationService(double interval) async {
  //   if (Global.locationRunning == false) {
  //     await BackgroundLocator.initialize();
  //     if (await BackgroundLocator.isRegisterLocationUpdate()) {
  //       await BackgroundLocator.unRegisterLocationUpdate();
  //     }
  //     BackgroundLocator.registerLocationUpdate(
  //       callback,
  //       autoStop: false,
  //       iosSettings: IOSSettings(
  //         showsBackgroundLocationIndicator: true,
  //         accuracy: LocationAccuracy.HIGH,
  //         distanceFilter: distance,
  //       ),
  //       androidSettings: AndroidSettings(
  //           androidNotificationSettings: AndroidNotificationSettings(
  //             notificationMsg: 'tap to open',
  //             notificationTitle: 'Background Location Service Is Active',
  //             notificationIcon: '@mipmap/ic_launcher',
  //           ),
  //           accuracy: LocationAccuracy.HIGH,
  //           wakeLockTime: 20,
  //           distanceFilter: distance,
  //           interval: (interval * 60).toInt()),
  //     );
  //     Global.locationRunning = true;
  //   } else {
  //     print("location already running in bg");
  //   }
  // }







  // Future pushyRegister() async {
  //   try {
  //     // Register the device for push notifications
  //     String deviceToken = await Pushy.register();
  //     int deviceId = 0;
  //     Helper.get(
  //         'UserNotifications/getByUser?process_id=${Helper.user?.processId}&user_id=${Helper.user?.id}&token=$deviceToken',
  //         {}).then((value) {
  //       var json = jsonDecode(value.body);
  //       try {
  //         deviceId = int.parse(json['deviceId'].toString());
  //       } catch (e) {
  //         deviceId = 0;
  //       }
  //
  //       if (json['ValueExists'] != 'true') {
  //         var post = {
  //           "id": null,
  //           "user_id": Helper.user?.id,
  //           "company_id": Helper.user?.companyId,
  //           "process_id": Helper.user?.processId.toString(),
  //           "token": deviceToken,
  //           "device_id": deviceId + 1,
  //           "created_by": Helper.user!.id,
  //           "created_at":
  //               "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
  //           "last_modified_by": null,
  //           "last_modified_at": null
  //         };
  //
  //         Helper.post('UserNotifications/Create', post, is_json: true)
  //             .then((value) {});
  //       }
  //     });
  //
  //     // Print token to console/logcat
  //     print('Device token: $deviceToken');
  //
  //     // Optionally send the token to your backend server via an HTTP GET request
  //     // ...
  //   } on PlatformException catch (error) {
  //     // Display an alert with the error message
  //     print("pushy platform error ${error.message}");
  //   }
  // }





  // Future<void> pushyRegister() async {
  //   try {
  //     FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //
  //     // Get the device token
  //     String? deviceToken = await _firebaseMessaging.getToken();
  //     if (deviceToken != null) {
  //       int deviceId = 0;
  //
  //       // Send token to your backend and handle response
  //       Helper.get(
  //         'UserNotifications/getByUser?process_id=${Helper.user?.processId}&user_id=${Helper.user?.id}&token=$deviceToken',
  //         {},
  //       ).then((value) {
  //         var json = jsonDecode(value.body);
  //         try {
  //           deviceId = int.parse(json['deviceId'].toString());
  //         } catch (e) {
  //           deviceId = 0;
  //         }
  //
  //         if (json['ValueExists'] != 'true') {
  //           var post = {
  //             "id": null,
  //             "user_id": Helper.user?.id,
  //             "company_id": Helper.user?.companyId,
  //             "process_id": Helper.user?.processId.toString(),
  //             "token": deviceToken,
  //             "device_id": deviceId + 1,
  //             "created_by": Helper.user!.id,
  //             "created_at":
  //             "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
  //             "last_modified_by": null,
  //             "last_modified_at": null
  //           };
  //
  //           Helper.post('UserNotifications/Create', post, is_json: true)
  //               .then((value) {});
  //         }
  //       });
  //
  //       // Print token to console/logcat
  //       print('Device token: $deviceToken');
  //
  //       // Optionally send the token to your backend server via an HTTP GET request
  //       // ...
  //     } else {
  //       print('Failed to get device token');
  //     }
  //   } catch (error) {
  //     // Display an alert with the error message
  //     print("Firebase registration error: $error");
  //   }
  // }




  // void listenNotification() {
  //   print('Notification got');
  //
  //   // Listen for push notifications
  //   Pushy.setNotificationListener((Map<String, dynamic> data) {
  //     // Print notification payload data
  //     print('Received notification: $data');
  //
  //     // Clear iOS app badge number
  //     Pushy.clearBadge();
  //   });
  //
  //   // Listen for notification click
  //   Pushy.setNotificationClickListener((Map<String, dynamic> data) {
  //     print('Notification clicked');
  //
  //     // Print notification payload data
  //     print('Notification click: $data');
  //
  //     // Extract notification messsage
  //     //String message = data['message'] ?? 'Hello World!';
  //
  //     var noti = Noti.Notification.fromJson(data);
  //     Global.noti = noti;
  //     print('noti=${Global.noti}');
  //     Navigator.pushNamed(context, 'notification_data');
  //
  //     // Display an alert with the "message" payload value
  //     // showDialog(
  //     //     context: context,
  //     //     builder: (BuildContext context) {
  //     //       return AlertDialog(
  //     //           title: Text('Notification click'),
  //     //           content: Text(message),
  //     //           actions: [
  //     //             TextButton(
  //     //                 child: Text('OK'),
  //     //                 onPressed: () {
  //     //                   Navigator.of(context, rootNavigator: true)
  //     //                       .pop('dialog');
  //     //                 })
  //     //           ]);
  //     //     });
  //
  //     // Clear iOS app badge number
  //     Pushy.clearBadge();
  //   });
  // }




  // void listenNotification(BuildContext context) {
  //   print('Notification listener initialized');
  //
  //   // Listen for foreground messages
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Received foreground notification: ${message.data}');
  //
  //     // Handle notification data
  //     // Example: Display a toast or an alert
  //     String messageContent = message.data['message'] ?? 'Hello World!';
  //
  //     var noti = Noti.Notification.fromJson(message.data);
  //     Global.noti = noti;
  //     print('noti=${Global.noti}');
  //     Navigator.pushNamed(context, 'notification_data');
  //   });
  //
  //   // Handle background/terminated message clicks
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('Notification clicked: ${message.data}');
  //
  //     // Handle notification click
  //     String messageContent = message.data['message'] ?? 'Hello World!';
  //
  //     var noti = Noti.Notification.fromJson(message.data);
  //     Global.noti = noti;
  //     print('noti=${Global.noti}');
  //     Navigator.pushNamed(context, 'notification_data');
  //   });
  // }

}
