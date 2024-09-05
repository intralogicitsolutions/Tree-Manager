import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/call_helper.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Contacts.dart';
import 'package:tree_manager/pojo/Job.dart';
import 'package:tree_manager/pojo/network_image.dart';

class ReportView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReportViewState();
  }
}

class ReportViewState extends State<ReportView> {
  static Job job = Global.job ?? Job();
  var contacts = <Contact>[];
  var date_string = '';

  @override
  void initState() {
    getAllData('init');
    super.initState();
    setState(() {});
  }

  void getAllData(String caller) {
    Global.before_images = null;
    Global.after_images = null;

    Helper.get(
            "nativeappservice/JobContactDetail?job_id=${Global.job?.jobId??''}", {})
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
        else if (t.workNumber != null) {
          contacts.add(Contact(mobile: t.workNumber));
        }
        else if (t.mobile != null) {
          contacts.add(Contact(mobile: t.mobile));
        }
      });
    });

    //Helper.showProgress(context, 'Getting Job Detail',dismissable: false);
    Helper.get(
        "nativeappservice/jobdetailInfo?job_alloc_id=${Global.job?.jobAllocId??''}",
        {}).then((response) {
      // Helper.hideProgress();
      setState(() {
        print('inside state');
        job = Job.fromJson(jsonDecode(response.body)[0]);
        Global.job = job;
        //getPhotos(job);
        getWorkflow();
      });
    }).catchError((error) {
      print('error call');
      //Helper.hideProgress();
      print(error);
    });
    print('after call');
  }

  @override
  Widget build(BuildContext context) {
    var grids = [
      {
        "label": "COMMUNICATION",
        "icon": "communication_grid.svg",
        "action": "route",
        "goto": "chats",
        'arguments': {'update': false},
      },
      {
        "label": "PHOTOS",
        "icon": "photos_grid.svg",
        "action": "route",
        "goto": 'pdf_viewer',
        'arguments': {
          "url":
              'generate/PhotosReport?job_id=${Global.job!.jobId}&job_alloc_id=${Global.job!.jobAllocId}',
          'title': 'Site Photos'
        },
      },
      {
        "label": "JOB COSTING",
        "icon": Helper.countryCode == "UK"
            ? "pound_symbol_white.svg"
            : 'Dollar-Quote.svg',
        "action": "route",
        "goto": 'pdf_viewer',
        'arguments': {
          "url":
              'generate/CostingReport?job_id=${Global.job!.jobId}&job_alloc_id=${Global.job!.jobAllocId}',
          'title': 'Review Quote'
        },
      },
      {
        "label": "SITE HAZARD",
        "icon": "sitehazard_grid.svg",
        "action": "route",
        "goto": 'pdf_viewer',
        'arguments': {
          "url":
              'generate/SiteHazardReport?job_id=${Global.job!.jobId}&job_alloc_id=${Global.job!.jobAllocId}',
          'title': 'Hazard Review'
        },
      },
    ];
    Size size = MediaQuery.of(context).size;
    try {
      var date = job.schedDate?.split("T")[0];
      var time = job.schedDate?.split("T")[1];
      var date_split = date!.split("-");
      var time_split = time!.split(":");
      print(date_split);
      print(time_split);
      date_string =
          "${date_split[2]}th ${Helper.intToMonth(int.parse(date_split[1]))} ${date_split[0]} at ${time_split[0]}:${time_split[1]}";
    } catch (e) {}
    return Scaffold(
        bottomNavigationBar: Helper.getBottomBar(bottomClick),
        appBar: Helper.getAppBar(context,
            title: 'Job #TM ${job.jobNo}',
            sub_title: 'Job TM# ${Global.job!.jobNo}'),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
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
                                    '${job.siteContactName}',
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
                                              description: job.address ?? ' ',
                                              negativeButtonText:
                                                  'GET DIRECION',
                                              negativeButtonimage:
                                                  'get_direction.svg',
                                              positiveButtonText: 'VIEW ON MAP',
                                              positiveButtonimage:
                                                  'view_on_map.svg');
                                      if (action == true) {
                                        Helper.openDirection(job.address??'');
                                      } else if (action == false) {
                                        Helper.openMap(job.address??'');
                                      }
                                    },
                                    child: Text(
                                      '${job.address}',
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
                                    job.jobDesc ?? ' ',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Themer.textGreenColor,
                                        fontSize: 18,
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    Helper.showSingleActionModal(context,
                                        title: 'Work Description',
                                        description: job.jobDesc ?? ' ',
                                        subTitle: 'Special Description',
                                        subDescription: job.jobSpDesc ?? ' ');
                                  },
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // if (Global.flow != null) {
                        //   Navigator.pushNamed(context, 'work_flow');
                        // }
                        Navigator.pushNamed(context, 'work_flow');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/images/view_details.svg'),
                          Text(
                            'View Details',
                            style: TextStyle(
                                color: Themer.textGreenColor,
                                fontSize: 20,
                                fontFamily: 'OpenSans'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Align(
                          child: Text(
                            'Reports',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          child: RichText(
                              text: TextSpan(
                                  text: 'Work performed at',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                TextSpan(
                                    text: ' $date_string',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ])),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GridView.count(
                              shrinkWrap: true,
                              childAspectRatio: 4 / 2.5,
                              crossAxisCount: 2,
                              children: List.generate(grids.length, (index) {
                                var item = grids[index];
                                final goto = item['goto'] as String?;
                                 final label = item['label'] as String?;
                                return GestureDetector(
                                  onTap: () async {
                                    if (item['goto'] != null) {
                                      await Navigator.pushNamed(
                                          context, goto!,
                                          arguments: item['arguments']);
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Themer.textGreenColor),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                              "assets/images/${statusImage(item)}",
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                          Text(
                                            label!,
                                            style:
                                                TextStyle(color: Colors.white),
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
                )
              ],
            ),
          ),
        ));
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }

  void getPhotos(Job job) {
    print('getting images');
    Helper.get(
        "uploadimages/getUploadImgsByJobIdAllocId?job_alloc_id=${job.jobAllocId}&job_id=${job.jobId}",
        {}).then((data) {
      print(data.body);
      var images = (jsonDecode(data.body) as List)
          .map((f) => NetworkPhoto.fromJson(f))
          .toList();
      Global.before_images = [];
      images.forEach((f) {
        if (f.imgType == '1') Global.before_images!.add(f);
      });
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void getWorkflow() {
    Helper.get(
        'nativeappservice/ReportWorkflowDetails?job_alloc_id=${Global.job?.jobAllocId}&process_id=${Helper.user?.processId}',
        {}).then((value) {
      var json = jsonDecode(value.body) as List;
      Global.flow = json.first;
    });
  }

  String statusImage(Map<String, dynamic> item) {
    return item['icon'];
  }

  //PhoneCall? call;
  Future<void> showContactDialog() async {
     await Helper.showSingleActionModal(context,
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
                contacts.where((element) => element.mobile != null).length,
            itemBuilder: (context, index) {
              var contact = contacts
                  .where((element) => element.mobile != null)
                  .toList()[index];
              return GestureDetector(
                onTap: () async {
                  // if (contact.mobile != null) {
                  //   // call = FlutterPhoneState.startPhoneCall(contact.mobile);
                  //   // await call!.done;
                  //   // Navigator.pop(context);
                  //   // if (call!.status == PhoneCallStatus.disconnected) {
                  //   //   print('comple');
                  //   //   Navigator.of(context).pushNamed('call_status',
                  //   //       arguments: {'visit_type': 2});
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
                  //         arguments: {'visit_type': 2,});
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
                  //                         if (contact.mobile != null) {
                  //                           // call = FlutterPhoneState
                  //                           //     .startPhoneCall(contact.mobile);
                  //                           // await call!.done;
                  //                           // Navigator.pop(context);
                  //                           // if (call!.status ==
                  //                           //     PhoneCallStatus.disconnected) {
                  //                           //   print('comple');
                  //                           //   Navigator.of(context).pushNamed(
                  //                           //       'call_status',
                  //                           //       arguments: {
                  //                           //         'visit_type': 1,
                  //                           //         'goto': 'site_inspection'
                  //                           //       });
                  //                           // }
                  //                            final callId = UniqueKey().toString();
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
                  //         arguments: {'visit_type': 1, 'goto': 'site_inspection'});
                  //   }
                  // });
                  //                         }
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
}
