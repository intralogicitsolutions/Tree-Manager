import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:flutter_svg/svg.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/call_helper.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Contacts.dart';

class CustomerOnSite extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomerOnSiteState();
  }
}

class CustomerOnSiteState extends State<CustomerOnSite> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Helper.getAppBar(context,
            title: "Invoice", sub_title: 'Job TM# ${Global.job?.jobNo}'),
        bottomNavigationBar: Helper.getBottomBar(bottomClick),
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              StepsIndicator(
                selectedStep: 2,
                nbSteps: 4,
                selectedStepColorOut: Colors.green,
                selectedStepColorIn: Colors.green,
                doneStepColor: Colors.green,
                unselectedStepColorIn: Colors.red,
                unselectedStepColorOut: Colors.red,
                doneLineColor: Colors.blue,
                undoneLineColor: Colors.red,
                isHorizontal: true,
                //lineLength: 50,
                doneLineThickness: 5,
              undoneLineThickness: 5,
                doneStepSize: 40,
                unselectedStepSize: 40,
                selectedStepSize: 40,
                selectedStepBorderSize: 1,
              ),
              Text(
                "Customer Onsite",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Is the Customer Onsite?", style: TextStyle(fontSize: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          height: 100.0,
                          width: 100.0,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: FittedBox(
                            child: FloatingActionButton(
                                heroTag: '1',
                                child: SvgPicture.asset(
                                    'assets/images/accept.svg'),
                                onPressed: () {
                                  Global.invoice?.customerYn = "YES";
                                  Navigator.pushNamed(context, 'sign_off');
                                }),
                          )),
                      Text(
                        "YES",
                        style: TextStyle(color: Themer.textGreenColor),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                          height: 100.0,
                          width: 100.0,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: FittedBox(
                            child: FloatingActionButton(
                                heroTag: '2',
                                child: SvgPicture.asset(
                                    'assets/images/reject.svg'),
                                onPressed: () async {
                                  Global.invoice?.customerYn = "NO";
                                  if (Global.signRequired == true)
                                    await showSignRequired(context);
                                  else {
                                    Navigator.pushNamed(
                                        context, 'invoice_the_job');
                                  }
                                }),
                          )),
                      Text(
                        "NO",
                        style: TextStyle(color: Themer.textGreenColor),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  Future showSignRequired(BuildContext context) async {
    var action = await Helper.showMultiActionModal(context,
        title: 'Sign-Off Required',
        description:
            'Customer Sign-off is mandatory for this job. Please come back later to get Sign-off.',
        negativeButtonText: 'RE-SCHEDULE',
        negativeButtonimage: 'reschdule_fill_button.svg',
        positiveButtonText: 'OK',
        positiveButtonimage: 'submit_button.svg');
    if (action == true) {
      Navigator.pushReplacementNamed(context, 'invoice');
    } else if (action == false) {
      rescheduleDialog();
    }
  }

  Future<void> rescheduleDialog() async {
    var action = await Helper.showMultiActionModal(context,
        title: 'Choose an Action',
        negativeButtonText: 'CALL',
        positiveButtonText: 'BOOK ETA',
        negativeButtonimage: 'call_button_2x.svg',
        positiveButtonimage: 'set_eta_button.svg');
    if (action == true) {
      Navigator.pushNamed(context, 'schedule_date', arguments: {
        'visit_type': '3',
        'msg_flow': '',
        'comm_reci': '',
        'goto': 'invoice'
      });
    } else if (action == false) {
      if (contacts.length == 0) {
        Helper.get(
            "nativeappservice/JobContactDetail?job_id=${Global.job!.jobId}",
            {}).then((response) {
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
          showContactDialog();
        });
      } else {
        showContactDialog();
      }
    }
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }

  //PhoneCall? call;
  var contacts = <Contact>[];
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
                  // if (contact.mobile != null) {
                  //   // call = FlutterPhoneState.startPhoneCall(contact.mobile);
                  //   // await call?.done;
                  //   // Navigator.pop(context);
                  //   // if (call?.status == PhoneCallStatus.disconnected) {
                  //   //   print('comple');
                  //   //   Navigator.of(context).pushNamed('call_status',
                  //   //       arguments: {'visit_type': 3});
                  //   // }
                  //   final callId = UniqueKey().toString();
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
                  // await FlutterCallkitIncoming.startCall(params as CallKitParams
                  //   // id: callId,
                  //   // nameCaller: contact.contactName ?? 'Caller',
                  //   // handle: contact.mobile ?? '',
                  //   // hasVideo: false, // Set to true if it's a video call
                  // );
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
                                    if (Global.job?.callDialogVersion == "2")
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
}
