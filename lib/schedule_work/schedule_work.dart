import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/call_helper.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Contacts.dart';
import 'package:tree_manager/pojo/Job.dart';

class ScheduleWork extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleWorkState();
  }
}

class ScheduleWorkState extends State<ScheduleWork> {
  Job? job = Global.job;
  var contacts = <Contact>[];
  //PhoneCall? call;
  @override
  void initState() {
    job = Global.job;
    //Helper.showProgress(context, 'Getting Job Detail',dismissable: false);
    Helper.get(
            "nativeappservice/jobdetailInfo?job_alloc_id=${job!.jobAllocId}", {})
        .then((response) {
      //Helper.hideProgress();
      setState(() {
        job = Job.fromJson(jsonDecode(response.body)[0]);
        Global.job = job;
      });
    }).catchError((error) {
      //Helper.hideProgress();
      print(error);
    });

    Helper.get("nativeappservice/JobContactDetail?job_id=${job!.jobId}", {})
        .then((response) {
      print(response.body);
      var tmp = (jsonDecode(response.body) as List)
          .map((f) => Contact.fromJson(f))
          .toList();
      contacts = [];
      tmp.forEach((t) {
        contacts.add(new Contact(contactName: t.contactName));
        if (t.homeNumber != null) {
          contacts.add(Contact(mobile: t.homeNumber));
        }
        if (t.workNumber != null) {
          contacts.add(Contact(mobile: t.workNumber));
        }
        if (t.mobile != null) {
          contacts.add(Contact(mobile: t.mobile));
        }
      });
    });

    Helper.getNotificationCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: 'Job #TM ${job!.jobNo}', sub_title: ''),
      body: Stack(
        children: <Widget>[
          Visibility(
            child: Center(
              child: Image.asset(
                'assets/images/background_image.png',
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
              ),
            ),
            visible: false,
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SvgPicture.asset('assets/images/phone.svg'),
                            TextButton(
                                onPressed: () {
                                  showContactDialog();
                                },
                                child: Text(
                                  '${job!.siteContactName}',
                                  style: TextStyle(
                                      color: Themer.textGreenColor,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline),
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SvgPicture.asset('assets/images/location.svg'),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: Container(
                              child: GestureDetector(
                                  onTap: () async {
                                    var action =
                                        await Helper.showMultiActionModal(
                                            context,
                                            title: 'Site Address',
                                            description: job!.address ?? ' ',
                                            negativeButtonText: 'GET DIRECION',
                                            negativeButtonimage:
                                                'get_direction.svg',
                                            positiveButtonText: 'VIEW ON MAP',
                                            positiveButtonimage:
                                                'view_on_map.svg');
                                    if (action == true) {
                                      Helper.openDirection(job!.address??'');
                                    } else if (action == false) {
                                      Helper.openMap(job!.address??'');
                                    }
                                  },
                                  child: Text(
                                    '${job!.addressDisplay??''}',
                                    style: TextStyle(
                                        color: Themer.textGreenColor,
                                        fontSize: 18,
                                        decoration: TextDecoration.underline),
                                  )),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SvgPicture.asset('assets/images/work.svg'),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: Container(
                              child: GestureDetector(
                                child: Text(
                                  job!.jobDesc ?? '  ',
                                  maxLines: 5,
                                  //overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Themer.textGreenColor,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline),
                                ),
                                onTap: () {
                                  Helper.showSingleActionModal(context,
                                      title: 'Work Description',
                                      description: job!.jobDesc ?? '  ',
                                      subTitle: 'Special Description',
                                      subDescription: job!.jobSpDesc ?? '  ');
                                },
                              ),
                            ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, 'pdf_viewer',
                                    arguments: {
                                      "url":
                                          'generate/CostingReport?job_id=${Global.job!.jobId}&job_alloc_id=${Global.job!.jobAllocId}',
                                      'title': 'Review Quote'
                                    });
                              },
                              icon: SvgPicture.asset(
                                Helper.countryCode == "UK"
                                    ? 'assets/images/pound_symbol.svg'
                                    : 'assets/images/dollar-symbol_black.svg',
                                color: Themer.gridItemColor,
                                height: 20,
                              ),
                              label: Text(
                                'View Costing',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 17,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600,
                                    color: Themer.textGreenColor),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, 'pdf_viewer',
                                    arguments: {
                                      "url":
                                          'generate/PhotosReport?job_id=${Global.job!.jobId}&job_alloc_id=${Global.job!.jobAllocId}',
                                      'title': 'Site Photos'
                                    });
                              },
                              icon: SvgPicture.asset(
                                Helper.countryCode == "UK"
                                    ? 'assets/images/pound_symbol.svg'
                                    : 'assets/images/dollar-symbol_black.svg',
                                color: Themer.gridItemColor,
                                height: 20,
                              ),
                              label: Text(
                                'View Photo',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 17,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600,
                                    color: Themer.textGreenColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
                  decoration: BoxDecoration(color: Themer.textGreenColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Align(
                        child: Text(
                          'Schedule Work',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        child: Text(
                          'Call homeowner & fix a schedule for site visit Call homeowner & fix schedule...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Align(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: 80.0,
                                      width: 80.0,
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      child: FittedBox(
                                        child: FloatingActionButton(
                                            heroTag: 'call',
                                            child: SvgPicture.asset(
                                                'assets/images/call_button.svg'),
                                            onPressed: () {
                                              showContactDialog();
                                            }),
                                      )),
                                  Text(
                                    "CALL",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              alignment: Alignment.centerRight,
                            ),
                          ),
                          Expanded(
                              child: Align(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    height: 60.0,
                                    width: 60.0,
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    child: FittedBox(
                                      child: FloatingActionButton(
                                          heroTag: 'eta',
                                          child: SvgPicture.asset(
                                              'assets/images/set_eta.svg'),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                'schedule_date',
                                                arguments: {
                                                  'visit_type': '3',
                                                  'msg_flow': '',
                                                  'comm_reci': '',
                                                  'goto': 'dashboard'
                                                });
                                          }),
                                    )),
                                Text(
                                  "SET ETA",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            alignment: Alignment.centerRight,
                          ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> showContactDialog() async {
    var action = await Helper.showSingleActionModal(context,
        title: 'Tap to Make a Call',
        custom: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              var contact = contacts
                  .where((element) => element.mobile != null)
                  .toList()[index];
              if (contact.contactName == null) {
                return Divider(
                  color: Colors.grey,
                  height: 1,
                  indent: 20,
                  endIndent: 35,
                );
              } else {
                return SizedBox(
                  height: 25,
                );
              }
            },
            itemCount:
                contacts.where((element) => element.mobile != null).length ?? 0,
            itemBuilder: (context, index) {
              var contact = contacts
                  .where((element) => element.mobile != null)
                  .toList()[index];
              return GestureDetector(
                onTap: () async {
                  await Helper.openDialer(
                      contact.mobile ?? '');
                  // if (contact.mobile != null) {
                  //   // call = FlutterPhoneState.startPhoneCall(contact.mobile);
                  //   // await call!.done;
                  //   // Navigator.pop(context);
                  //   // if (call!.status == PhoneCallStatus.disconnected) {
                  //   //   print('comple');
                  //   //   Navigator.of(context).pushNamed('call_status',
                  //   //       arguments: {'visit_type': 3, 'goto': 'dashboard'});
                  //   // }
                  //    final callId = UniqueKey().toString();
                  // final params = <String, dynamic>{
                  //                     'id': callId,
                  //                     'nameCaller': contact.contactName ?? 'Unknown',
                  //                     'appName': 'Your App Name',
                  //                     'avatar': 'assets/images/avatar.png', // Optional
                  //                     'handle': contact.mobile,
                  //                     'type': 0, // 0 for outgoing call
                  //                     'duration': 30000, // Call duration
                  //                     'textAccept': 'Accept',
                  //                     'textDecline': 'Decline',
                  //                     'textMissedCall': 'Missed call',
                  //                     'textCallback': 'Call back',
                  //                   };
                  // await FlutterCallkitIncoming.startCall(params as CallKitParams );
                  // Navigator.pop(context);
                  //
                  // // Listen for call events
                  // FlutterCallkitIncoming.onEvent.listen((event) {
                  //   if (event!.event == 'endCall') {
                  //     print('Call ended');
                  //     Navigator.of(context).pushNamed('call_status',
                  //         arguments: {'visit_type': 3, 'goto': 'dashboard'});
                  //   }
                  // });
                  // }
                },
                child: contact.contactName == null
                    ? Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Home',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  contact.mobile??'',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: FloatingActionButton(
                                        onPressed: () async {
                                          await Helper.openDialer(
                                              contact.mobile ?? '');
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/call.svg',
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    if (Global.job!.callDialogVersion == "2")
                                      Container(
                                        height: 50,
                                        width: 50,
                                        child: FloatingActionButton(
                                          onPressed: () async {
                                            await CallHelper.setMessage(
                                                context, contact.mobile??'');
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/message.svg',
                                            height: 50,
                                          ),
                                        ),
                                      )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(
                        child: Text(
                          contact.contactName??'',
                          style: TextStyle(
                              color: Themer.textGreenColor, fontSize: 20),
                        ),
                      ),
              );
            }));
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
