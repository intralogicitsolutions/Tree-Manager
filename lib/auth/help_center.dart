import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/HelpData.dart';

class HelpCenter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HelpCenterState();
  }
}

class HelpCenterState extends State<HelpCenter> {
  HelpData help = HelpData();

  @override
  void initState() {
    super.initState();
    Helper.get("nativeappservice/helpData", {}).then((data) {
      var json = (jsonDecode(data.body) as List).map((f) => HelpData.fromJson(f));
      help = json.first;
      setState(() {});
    }).catchError((error) {
      print(error.toString());
    });
  }

  // Future<void> startCall(String number) async {
  //   var params = <String, dynamic>{
  //     'id': 'unique_call_id',
  //     'nameCaller': 'Caller Name',
  //     'appName': 'MyApp',
  //     'avatar': 'https://i.pravatar.cc/100', // default avatar
  //     'handle': number,
  //     'type': 0, // 0 for outgoing, 1 for incoming
  //     'extra': <String, dynamic>{},
  //     'ios': <String, dynamic>{
  //       'iconName': 'CallKitIcon',
  //       'handleType': 'number',
  //       'supportsVideo': false,
  //       'maximumCallGroups': 2,
  //       'maximumCallsPerCallGroup': 1,
  //     },
  //     'android': <String, dynamic>{
  //       'isCustomNotification': true,
  //       'isShowLogo': false,
  //       'isShowCallback': true,
  //       'isShowMissedCallNotification': true,
  //       'ringtonePath': 'system_ringtone_default',
  //       'backgroundColor': '#0955fa',
  //       'background': 'assets/test.png',
  //       'actionColor': '#4CAF50',
  //     },
  //   };
  //   // await FlutterCallkitIncoming.startCall(params as CallKitParams);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Help Center", showNotification: false),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/background_image.png',
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Align(
                    child: Image.asset(Helper.AppImage),
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  child: Text(
                    "Help Center",
                    style: TextStyle(fontFamily: "OpenSans", fontSize: 16),
                  ),
                  alignment: Alignment.center,
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      child: Text(
                        "Contact",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 10),
                    (Helper.countryCode == "AUS"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Align(
                                  child: Text(
                                    "Enviro - Australia",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: "OpenSans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                                SizedBox(height: 10.0),
                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SvgPicture.asset("assets/images/phone.svg"),
                                      SizedBox(width: 15),
                                      Text(
                                        "${help.aUPhone}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            decoration: TextDecoration.underline,
                                            color: Themer.textGreenColor),
                                      )
                                    ],
                                  ),
                                  onTap: () async {
                                    // await startCall(help.aUPhone??'');
                                    await Helper.openDialer(
                                        help.aUPhone??'');
                                  },
                                ),
                                SizedBox(height: 10.0),
                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SvgPicture.asset("assets/images/E-Mail24px.svg"),
                                      SizedBox(width: 10),
                                      Text("${help.aUEmail}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              decoration: TextDecoration.underline,
                                              color: Themer.textGreenColor))
                                    ],
                                  ),
                                  onTap: () {
                                     Helper.openEmail(help.aUEmail ?? '');
                                  },
                                ),
                                SizedBox(height: 20.0),
                                Align(
                                  child: Text(
                                    "Enviro - New Zealand",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: "OpenSans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                                SizedBox(height: 10.0),
                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SvgPicture.asset("assets/images/phone.svg"),
                                      SizedBox(width: 15),
                                      Text("${help.nZPhone}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              decoration: TextDecoration.underline,
                                              color: Themer.textGreenColor))
                                    ],
                                  ),
                                  onTap: () async {
                                    // await startCall(help.nZPhone??'');
                                    await Helper.openDialer(
                                        help.nZPhone??'');
                                  },
                                ),
                                SizedBox(height: 10.0),
                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SvgPicture.asset("assets/images/E-Mail24px.svg"),
                                      SizedBox(width: 10),
                                      Text("${help.nZEmail}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              decoration: TextDecoration.underline,
                                              color: Themer.textGreenColor))
                                    ],
                                  ),
                                  onTap: () {
                                    Helper.openEmail(help.nZEmail ?? '');
                                  },
                                ),
                              ])
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Align(
                                  child: Text(
                                    jsonDecode(Helper().contactDetails)["title"],
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: "OpenSans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                                SizedBox(height: 10.0),
                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SvgPicture.asset("assets/images/phone.svg"),
                                      SizedBox(width: 15),
                                      Text(
                                        jsonDecode(Helper().contactDetails)["phone"],
                                        style: TextStyle(
                                            fontSize: 18,
                                            decoration: TextDecoration.underline,
                                            color: Themer.textGreenColor),
                                      )
                                    ],
                                  ),
                                  onTap: () async {
                                    // await startCall(jsonDecode(Helper().contactDetails)["phone"]);
                                    await Helper.openDialer(jsonDecode(Helper().contactDetails)["phone"]);
                                  },
                                ),
                                SizedBox(height: 10.0),
                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SvgPicture.asset("assets/images/E-Mail24px.svg"),
                                      SizedBox(width: 10),
                                      Text(
                                          jsonDecode(Helper().contactDetails)["email"],
                                          style: TextStyle(
                                              fontSize: 18,
                                              decoration: TextDecoration.underline,
                                              color: Themer.textGreenColor))
                                    ],
                                  ),
                                  onTap: () {
                                    Helper.openEmail(jsonDecode(Helper().contactDetails)["email"]);
                                  },
                                ),
                              ])),
                  ],
                )
              ],
            ),
          )
        ],
     

      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
