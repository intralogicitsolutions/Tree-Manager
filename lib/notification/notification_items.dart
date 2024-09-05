import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/call_helper.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Contacts.dart';
import 'package:tree_manager/pojo/FenceInfo.dart';
import 'package:tree_manager/pojo/Job.dart';
import 'package:tree_manager/pojo/Staff.dart';
import 'package:tree_manager/pojo/Task.dart';
import 'package:tree_manager/pojo/equip.dart';
import 'package:tree_manager/pojo/network_image.dart';
import 'package:tree_manager/pojo/notification.dart' as Noti;
import 'package:tree_manager/pojo/option.dart';
import 'package:tree_manager/pojo/tree_info.dart';

class JobListItem extends StatefulWidget {
  const JobListItem(
      {Key? key, required this.quote, required this.index, required this.refreshJobs})
      : super(key: key);

  final Noti.Notification quote;
  final int index;
  final VoidCallback refreshJobs;

  @override
  _JobListItemState createState() => _JobListItemState();
}

class _JobListItemState extends State<JobListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.index % 2 == 0 ? Themer.listEvenColor : Themer.listOddColor,
      child: SizedBox(
          height: 260,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(widget.quote.summaryMessage??'',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Themer.textGreenColor)),
                Text(
                  widget.quote.notificationMessage??'',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                widget.quote.accepted == false
                    ? Row(
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
                                        heroTag: '${widget.quote.jobId}',
                                        child: SvgPicture.asset(
                                            'assets/images/accept.svg'),
                                        onPressed: () {
                                          Helper.showProgress(
                                              context, 'Accepting job');
                                          Helper.post(
                                              "nativeappservice/acceptRejectjob?status=1&job_id=${widget.quote.jobId}&job_alloc_id=${widget.quote.jobAllocId}",
                                              {}).then((response) async {
                                            await Helper
                                                .updateNotificationStatus(
                                                    widget.quote.jobAllocId??'');
                                            Helper.hideProgress();
                                            print(response.body);
                                            setState(() {
                                              widget.quote.accepted = true;
                                            });
                                          }).catchError((error) {
                                            Helper.hideProgress();
                                            print(error.toString());
                                          });
                                        }),
                                  )),
                              Text(
                                "ACCEPT",
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
                                        heroTag: '${widget.quote.jobId}_2',
                                        child: SvgPicture.asset(
                                            'assets/images/reject.svg'),
                                        onPressed: () async {
                                          Global.job = Job(
                                              jobId: widget.quote.jobId,
                                              jobAllocId:
                                                  widget.quote.jobAllocId,
                                              jobNo: widget.quote.jobNo);
                                          /*Navigator.pushNamed(
                                                  context,
                                                  'site_inspection');*/
                                          var action =
                                              await Helper.showMultiActionModal(
                                                  context,
                                                  title: 'Reject Job',
                                                  description:
                                                      'Are you sure you want to Reject this Job?',
                                                  negativeButtonimage:
                                                      'reject.svg',
                                                  negativeButtonText: 'NO',
                                                  positiveButtonText: 'YES',
                                                  positiveButtonimage:
                                                      'accept.svg');
                                          if (action == true) {
                                            Helper.showProgress(
                                                context, 'Please wait...');
                                            Helper.post(
                                                "nativeappservice/acceptRejectjob?status=2&job_id=${widget.quote.jobId}&job_alloc_id=${widget.quote.jobAllocId}",
                                                {}).then((response) async {
                                              await Helper
                                                  .updateNotificationStatus(
                                                      widget.quote.jobAllocId??'');
                                              Helper.hideProgress();
                                              print(response.body);
                                              widget.refreshJobs();
                                            }).catchError((onError) {
                                              Helper.hideProgress();
                                            });
                                          }
                                        }),
                                  )),
                              Text(
                                "REJECT",
                                style: TextStyle(color: Themer.textGreenColor),
                              )
                            ],
                          )
                        ],
                      )
                    : Visibility(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 100.0,
                                  width: 100.0,
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  child: FittedBox(
                                    child: FloatingActionButton(
                                        heroTag: '${widget.quote.jobId}',
                                        child: SvgPicture.asset(
                                            'assets/images/view_job.svg'),
                                        onPressed: () {
                                          setState(() async {
                                            Global.job = Job(
                                                jobId: widget.quote.jobId,
                                                jobAllocId:
                                                    widget.quote.jobAllocId,
                                                jobNo: widget.quote.jobNo);
                                            await Navigator.of(context)
                                                .pushNamed('job_detail');
                                            widget.refreshJobs();
                                          });
                                        }),
                                  )),
                              Text(
                                "VIEW JOB",
                                style: TextStyle(color: Themer.textGreenColor),
                              )
                            ],
                          ),
                        ),
                        visible: true,
                      )
              ],
            ),
          )),
    );
  }
}

//quote item

class QuoteListItem extends StatefulWidget {
  const QuoteListItem(
      {required this.quote, required this.index, required this.refreshJobs});

  final Noti.Notification quote;
  final int index;
  final VoidCallback refreshJobs;

  @override
  _QuoteListItemState createState() => _QuoteListItemState();
}

class _QuoteListItemState extends State<QuoteListItem> {
  var date_string = "";

  @override
  void initState() {
    // var time = widget.quote.schedTime.replaceAll("pm", " pm").replaceAll("am", " am");

    // var date_split = widget.quote.schedDate.split('T')[0].split('-');
    // date_string =
    //     "${date_split[2]}th ${Helper.intToMonth(int.parse(date_split[1]))} ${time.toLowerCase()}";
    // print(date_split);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Global.job = Job(
            jobId: widget.quote.jobId,
            jobAllocId: widget.quote.jobAllocId,
            jobNo: widget.quote.jobNo);
        print(widget.quote.jobNo);
        await Navigator.of(context).pushNamed('site_inspection');
        widget.refreshJobs();
      },
      child: Container(
        color:
            widget.index % 2 == 0 ? Themer.listEvenColor : Themer.listOddColor,
        child: SizedBox(
            height: 260,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.quote.summaryMessage??'',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Themer.textGreenColor)),
                    ],
                  ),
                  Text(widget.quote.notificationMessage??'',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Themer.textGreenColor)),
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
                                    heroTag: '${widget.quote.jobId}',
                                    child:
                                        SvgPicture.asset('assets/images/${(() {
                                      if (widget.quote.workflowStepId == '3')
                                        return 'photo_button_2x.svg';
                                      else if (widget.quote.workflowStepId ==
                                          '4')
                                        return 'treeinfo_button_2x.svg';
                                      else if (widget.quote.workflowStepId ==
                                          '5')
                                        return 'costing_button_2x.svg';
                                      else
                                        return 'view_job.svg';
                                    }())}'),
                                    onPressed: () async {
                                      Global.crewDetails = null;
                                      Global.info = null;
                                      Global.info = TreeInfo();
                                      Global.fence = FenceInfo();
                                      Global.substan = '';
                                      Global.head = null;
                                      Global.site_info_update = false;
                                      Global.fence_info_update = false;
                                      Global.costing_update = false;
                                      Global.before_images = [];
                                      Global.after_images = [];
                                      Global.fence = null;
                                      Global.standing_images = [];
                                      Global.damage_images = [];

                                      await Helper.get(
                                          "nativeappservice/jobdetailInfo?job_alloc_id=${widget.quote.jobAllocId}",
                                          {}).then((response) async {
                                        Helper.hideProgress();
                                        Global.job = Job.fromJson(
                                            jsonDecode(response.body)[0]);
                                        Global.fence = FenceInfo();
                                        if (widget.quote.workflowStepId == '3')
                                          await Navigator.pushNamed(
                                              context, 'before_photos');
                                        else if (widget.quote.workflowStepId ==
                                            '4')
                                          await Navigator.pushNamed(
                                              context, 'number_of_tree');
                                        else if (widget.quote.workflowStepId ==
                                            '5')
                                          await Navigator.pushNamed(
                                              context, 'crew_configuration');
                                        else
                                          await Navigator.pushNamed(
                                              context, 'site_inspection');
                                        widget.refreshJobs();
                                      }).catchError((error) {
                                        Helper.hideProgress();
                                      });
                                      Helper.hideProgress();
                                    }),
                              )),
                          Text(
                            (() {
                              if (widget.quote.workflowStepId == '3')
                                return 'PHOTOS';
                              else if (widget.quote.workflowStepId == '4')
                                return 'TREE INFO';
                              else if (widget.quote.workflowStepId == '5')
                                return 'JOB COSTING';
                              else
                                return 'VIEW JOB';
                            }()),
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
                                    heroTag: '${widget.quote.jobId}_2',
                                    child: SvgPicture.asset(
                                        'assets/images/location_button_2x.svg'),
                                    onPressed: () async {
                                      var action =
                                          await Helper.showMultiActionModal(
                                              context,
                                              title: 'Site Address',
                                              description:
                                                  widget.quote.address ?? ' ',
                                              negativeButtonText:
                                                  'GET DIRECION',
                                              negativeButtonimage:
                                                  'get_direction.svg',
                                              positiveButtonText: 'VIEW ON MAP',
                                              positiveButtonimage:
                                                  'view_on_map.svg');
                                      if (action == true) {
                                        Helper.openDirection(
                                            widget.quote.address??'');
                                      } else if (action == false) {
                                        Helper.openMap(widget.quote.address??'');
                                      }
                                    }),
                              )),
                          Text(
                            "LOCATION",
                            style: TextStyle(color: Themer.textGreenColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}

//schedule visit item

class ScheduleListItem extends StatefulWidget {
  const ScheduleListItem(
      {Key? key, required this.quote, required this.index, required this.refreshJobs})
      : super(key: key);

  final Noti.Notification quote;
  final int index;
  final VoidCallback refreshJobs;

  @override
  _ScheduleListItemState createState() => _ScheduleListItemState();
}

class _ScheduleListItemState extends State<ScheduleListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Global.job = Job(
            jobId: widget.quote.jobId,
            jobAllocId: widget.quote.jobAllocId,
            jobNo: widget.quote.jobNo);
        await Navigator.pushNamed(context, 'job_detail');
        widget.refreshJobs();
      },
      child: Container(
        color:
            widget.index % 2 == 0 ? Themer.listEvenColor : Themer.listOddColor,
        child: SizedBox(
            height: 260,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(widget.quote.summaryMessage??'',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Themer.textGreenColor)),
                  Flexible(
                      child: Text(
                    widget.quote.notificationMessage??'',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )),
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
                                    heroTag: '${widget.quote.jobId}',
                                    child: SvgPicture.asset(
                                        'assets/images/call_button_2x.svg'),
                                    onPressed: () {
                                      getAndShowContacts(widget.quote);
                                    }),
                              )),
                          Text(
                            "CALL",
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
                                    heroTag: '${widget.quote.jobId}_2',
                                    child: SvgPicture.asset(
                                        'assets/images/set_eta_2x.svg'),
                                    onPressed: () async {
                                      Global.job = Job(
                                          jobId: widget.quote.jobId,
                                          jobAllocId: widget.quote.jobAllocId,
                                          jobNo: widget.quote.jobNo);
                                      await Navigator.of(context).pushNamed(
                                          'schedule_date',
                                          arguments: {
                                            'visit_type': '1',
                                            'msg_flow': '',
                                            'comm_reci': '',
                                            'goto': 'dashboard'
                                          });
                                      widget.refreshJobs();
                                    }),
                              )),
                          Text(
                            "BOOK ETA",
                            style: TextStyle(color: Themer.textGreenColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  var contacts = <Contact>[];
  void getAndShowContacts(Noti.Notification job) {
    Global.job = Job(
        jobId: widget.quote.jobId,
        jobAllocId: widget.quote.jobAllocId,
        jobNo: widget.quote.jobNo);
    Helper.showProgress(context, 'Getting contacts');
    Helper.get("nativeappservice/JobContactDetail?job_id=${job.jobId}", {})
        .then((response) {
      Helper.hideProgress();
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
  }

 // PhoneCall? call;
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
                  height: 30,
                  indent: 30,
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
                  await Helper.openDialer(
                      contact.mobile ?? '');
                  // if (contact.mobile != null) {
                  //   // call = FlutterPhoneState.startPhoneCall(contact.mobile);
                  //   // await call!.done;
                  //   // Navigator.pop(context);
                  //   // if (call!.status == PhoneCallStatus.disconnected) {
                  //   //   print('comple');
                  //   //   await Navigator.of(context).pushNamed('call_status',
                  //   //       arguments: {'visit_type': 1, 'goto': 'dashboard'});
                  //   //   widget?.refreshJobs();
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
                  //         arguments: {'visit_type': 1, 'goto': 'dashboard'});
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
                                            widget.refreshJobs();
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

//schedule work item

class ScheduleWorkListItem extends StatefulWidget {
  const ScheduleWorkListItem(
      {Key? key, required this.quote, required this.index, required this.refreshJobs})
      : super(key: key);

  final Noti.Notification quote;
  final int index;
  final VoidCallback refreshJobs;

  @override
  _ScheduleWorkListItemState createState() => _ScheduleWorkListItemState();
}

class _ScheduleWorkListItemState extends State<ScheduleWorkListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Global.job = null;
        Global.job = Job(
            jobId: widget.quote.jobId,
            jobAllocId: widget.quote.jobAllocId,
            jobNo: widget.quote.jobNo);
        print(widget.quote.jobNo);
        await Navigator.of(context).pushNamed('schedule_detail');
        widget.refreshJobs();
      },
      child: Container(
        color:
            widget.index % 2 == 0 ? Themer.listEvenColor : Themer.listOddColor,
        child: SizedBox(
            height: 260,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(widget.quote.summaryMessage??'',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Themer.textGreenColor)),
                  Text(
                    widget.quote.notificationMessage??'',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                                    heroTag: '${widget.quote.jobId}',
                                    child: SvgPicture.asset(
                                        'assets/images/call_button_2x.svg'),
                                    onPressed: () {
                                      getAndShowContacts(widget.quote);
                                    }),
                              )),
                          Text(
                            "CALL",
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
                                    heroTag: '${widget.quote.jobId}_2',
                                    child: SvgPicture.asset(
                                        'assets/images/set_eta_2x.svg'),
                                    onPressed: () async {
                                      Global.job = Job(
                                          jobId: widget.quote.jobId,
                                          jobAllocId: widget.quote.jobAllocId,
                                          jobNo: widget.quote.jobNo);
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
                            "BOOK ETA",
                            style: TextStyle(color: Themer.textGreenColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  var contacts = <Contact>[];
  void getAndShowContacts(Noti.Notification job) {
    Global.job = Job(
        jobId: widget.quote.jobId,
        jobAllocId: widget.quote.jobAllocId,
        jobNo: widget.quote.jobNo);
    Helper.showProgress(context, 'Getting contacts');
    Helper.get("nativeappservice/JobContactDetail?job_id=${job.jobId}", {})
        .then((response) {
      Helper.hideProgress();
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
                  await Helper.openDialer(contact.mobile ?? '');
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
                                          await Helper.openDialer(contact.mobile ?? '');
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
                  //                           //         'visit_type': 3,
                  //                           //         'goto': 'dashboard'
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
                  //         arguments: {'visit_type': 3, 'goto': 'dashboard'});
                  //   }
                  // });
                  //                         }
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

//approval item

class ApprovalListItem extends StatefulWidget {
  const ApprovalListItem(
      {Key? key, required this.quote, required this.index, required this.refreshJobs})
      : super(key: key);

  final Noti.Notification quote;
  final int index;
  final VoidCallback refreshJobs;

  @override
  _ApprovalListItemState createState() => _ApprovalListItemState();
}

class _ApprovalListItemState extends State<ApprovalListItem> {
  var date_string = " ";

  @override
  void initState() {
    try {
      // var date = widget.quote.quoteDate?.split("T")[0];
      // var date_split = date.split("-");
      // print(date_split);
      // date_string =
      //     "${date_split[2]}th ${Helper.intToMonth(int.parse(date_split[1]))} ${date_split[0]}";
    } catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.index % 2 == 0 ? Themer.listEvenColor : Themer.listOddColor,
      child: SizedBox(
          height: 260,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(widget.quote.summaryMessage??'',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Themer.textGreenColor)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset('assets/images/location_black.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        widget.quote.address ?? ' ',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: false,
                      child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: SvgPicture.asset(Helper.countryCode == "UK"
                              ? 'assets/images/pound_symbol.svg'
                              : 'assets/images/dollar-symbol_black.svg',height:20)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                        child: Text(
                            widget.quote.notificationDetailMessage ?? '   ')),
                  ],
                ),
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
                                  heroTag: '${widget.quote.jobId}',
                                  child: SvgPicture.asset(
                                      'assets/images/requestupdate_button_2x.svg'),
                                  onPressed: () async {
                                    Global.job = Job(
                                        jobId: widget.quote.jobId,
                                        jobAllocId: widget.quote.jobAllocId,
                                        jobNo: widget.quote.jobNo);
                                    var msg = await Navigator.pushNamed(
                                        context, 'comment_box', arguments: {
                                      'title': 'Envito Approval',
                                      'sub_title': '',
                                      'option': Global.approval
                                    });
                                    if (msg != null) {
                                      var post = {
                                        "id": null,
                                        "job_id": "${Global.job?.jobId}",
                                        "job_alloc_id":
                                            "${Global.job?.jobAllocId}",
                                        "visit_type": null,
                                        "sched_date": null,
                                        "sched_note": "${msg}",
                                        "process_id": "${Helper.user?.id}",
                                        "owner": "${Helper.user?.id}",
                                        "created_by": "${Helper.user?.id}",
                                        "last_modified_by": null,
                                        "created_at":
                                            "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
                                        "last_updated_at": null,
                                        "end_time": null,
                                        "start_time":
                                            "${DateFormat("HH:mm:ss").format(DateTime.now())}",
                                        "status": "1",
                                        "phoned": null,
                                        "sms": null,
                                        "email": null,
                                        "callback": "2",
                                        "PMOnly": "1",
                                        "phone_no": null,
                                        "sms_no": null,
                                        "emailaddress": null,
                                        "source": "2",
                                        "message_received": null,
                                        "message_flow": null,
                                        "comm_recipient": "Request Update",
                                        "comm_recipient_subcatg":
                                            "From Dashboard",
                                        "version": await Helper.getAppVersion()
                                      };
                                      Helper.post('JobSchedule/Create', post,
                                              is_json: true)
                                          .then((value) async {
                                        Helper.hideProgress();
                                        var json = jsonDecode(value.body);
                                        if (json['success'] == 1) {
                                          await Helper.showSingleActionModal(
                                              context,
                                              title: 'Thank You!',
                                              description:
                                                  'Thank you for requesting update on this Job. We will get back to you with Details.');
                                        }
                                        widget.refreshJobs();
                                      }).catchError((onError) {
                                        Helper.hideProgress();
                                      });
                                    }
                                  }),
                            )),
                        Text(
                          "REQUEST UPDATE",
                          style: TextStyle(color: Themer.textGreenColor),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}

//invoice list

class InvoiceListItem extends StatefulWidget {
  const InvoiceListItem(
      {Key? key,
      required this.quote,
      required this.index,
      required this.refreshJobs})
      : super(key: key);

  final Noti.Notification quote;
  final int index;
  final VoidCallback refreshJobs;

  @override
  _InvoiceListItemState createState() => _InvoiceListItemState();
}

class _InvoiceListItemState extends State<InvoiceListItem> {
  var date_string = "";
  @override
  void initState() {
    // var time =
    //     widget.quote.schedTime?.replaceAll("pm", " pm")?.replaceAll("am", " am");

    // var date_split = widget.quote.quoteDate?.split('T')[0]?.split('-');
    // date_string =
    //     "${date_split[2]}th ${Helper.intToMonth(int.parse(date_split[1]))} ${time?.toLowerCase()}";
    // print(date_split);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Global.job = Job(
            jobId: widget.quote.jobId,
            jobAllocId: widget.quote.jobAllocId,
            jobNo: widget.quote.jobNo);
        await Navigator.pushNamed(context, 'invoice');
        widget.refreshJobs();
      },
      child: Container(
        color:
            widget.index % 2 == 0 ? Themer.listEvenColor : Themer.listOddColor,
        child: SizedBox(
            height: 260,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.quote.summaryMessage??'',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Themer.textGreenColor)),
                    ],
                  ),
                  Text("${widget.quote.notificationMessage}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Themer.textGreenColor)),
                  Text(
                    widget.quote.address ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                                    heroTag: '${widget.quote.jobId}',
                                    child: SvgPicture.asset(
                                        'assets/images/${actionIcon(widget.quote)}'),
                                    onPressed: () {
                                      Global.job = Job(
                                          jobId: widget.quote.jobId,
                                          jobAllocId: widget.quote.jobAllocId,
                                          jobNo: widget.quote.jobNo);
                                      doAction(widget.quote);
                                    }),
                              )),
                          Text(
                            actionString(widget.quote),
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
                                    heroTag: '${widget.quote.jobId}_2',
                                    child: SvgPicture.asset(
                                        'assets/images/location_button_2x.svg'),
                                    onPressed: () async {
                                      var action =
                                          await Helper.showMultiActionModal(
                                              context,
                                              title: 'Site Address',
                                              description:
                                                  widget.quote.address ?? ' ',
                                              negativeButtonText:
                                                  'GET DIRECION',
                                              negativeButtonimage:
                                                  'get_direction.svg',
                                              positiveButtonText: 'VIEW ON MAP',
                                              positiveButtonimage:
                                                  'view_on_map.svg');
                                      if (action == true) {
                                        Helper.openDirection(
                                            widget.quote.address??'');
                                      } else if (action == false) {
                                        Helper.openMap(widget.quote.address??'');
                                      }
                                    }),
                              )),
                          Text(
                            "LOCATION",
                            style: TextStyle(color: Themer.textGreenColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  String actionIcon(Noti.Notification job) {
    if (job.workflowStepId == '8')
      return 'sitehazard_button_2x.svg';
    else if (job.workflowStepId == '9')
      return 'photo_button_2x.svg';
    else if (job.workflowStepId == '10')
      return 'completejob_button_2x.svg';
    else
      return 'view_job.svg';
  }

  String actionString(Noti.Notification job) {
    if (job.workflowStepId == '8')
      return 'SITE HAZARD';
    else if (job.workflowStepId == '9')
      return 'AFTER PHOTOS';
    else if (job.workflowStepId == '10')
      return 'COMPLETE JOB';
    else
      return 'VIEW JOB';
  }

  Future<void> doAction(Noti.Notification job) async {
    Global.before_images = null;
    Global.before_images = null;
    Global.after_images = null;
    Global.hazard = null;
    Global.site_hazard_update = false;
    Global.base64Sign = null;
    Global.signs = null;
    Global.signRequired = false;
    Global.invoiceAllowed = false;
    Global.sel_j_color = null;
    Global.sel_t_color = null;
    Global.sel_m_color = null;
    Global.sel_w_color = null;

    Global.sel_j_other_ctrl = [];
    Global.sel_t_other_ctrl = [];
    Global.sel_m_other_ctrl = [];
    Global.sel_w_other_ctrl = [];

    Global.sel_j_other_task = [];
    Global.sel_t_other_task = [];
    Global.sel_m_other_task = [];
    Global.sel_w_other_task = [];

    Global.sel_j_task = [];
    Global.sel_t_task = [];
    Global.sel_m_task = [];
    Global.sel_w_task = [];

    Global.sel_j_ctrl = [];
    Global.sel_t_ctrl = [];
    Global.sel_m_ctrl = [];
    Global.sel_w_ctrl = [];

    Global.hzd_sel_staff = [];
    Global.hzd_sel_equip = [];
    Global.hzd_sel_task = [];

    Global.hzd_sel_other_staff = [];
    Global.hzd_sel_other_equip = [];

    Helper.showProgress(context, 'Getting job details');
    await Helper.get(
            "nativeappservice/jobdetailInfo?job_alloc_id=${job.jobAllocId}", {})
        .then((response) async {
      Helper.hideProgress();
      Global.job = Job.fromJson(jsonDecode(response.body)[0]);
      if (job.workflowStepId == '8') {
        var action = await Helper.showMultiActionModal(context,
            title: 'Choose an Action',
            positiveButtonText: 'ENVIRO FORM',
            negativeButtonText: 'UPLOAD',
            negativeButtonimage: 'enviro_form.svg',
            positiveButtonimage: 'gallery_button.svg');
        if (action == true) {
          getAllData(job);
        } else if (action == false) {
          await Navigator.pushNamed(context, 'hazard_upload',
              arguments: {"from_review": false});
        }
      } else if (job.workflowStepId == '9')
        await gotoHazardUploads(job);
      else if (job.workflowStepId == '10')
        await Navigator.pushNamed(context, 'accident');
      else
        await Navigator.pushNamed(context, 'invoice');
      widget.refreshJobs();
    }).catchError((error) {
      Helper.hideProgress();
    });
  }

  Future<void> gotoHazardUploads(Noti.Notification job) async {
    Global.before_images = [];
    Global.after_images = [];
    Global.hazard_images = [];

    await Helper.get(
        "uploadimages/getUploadImgsByJobIdAllocId?job_alloc_id=${job.jobAllocId}&job_id=${job.jobId}",
        {}).then((data) async {
      print(data.body);
      var images = (jsonDecode(data.body) as List)
          .map((f) => NetworkPhoto.fromJson(f))
          .toList();

      images.forEach((f) {
        if (f.imgType == '1') Global.before_images!.add(f);
        if (f.imgType == '2') Global.after_images!.add(f);
        if (f.imgType == '3') Global.hazard_images!.add(f);
      });
      await Navigator.pushNamed(context, 'hazard_photos');
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void getAllData(Noti.Notification job) {
    Helper.showProgress(context, 'Caching dependencies..');
    Helper.get(
        'nativeappservice/chkSignOff?job_id=${job.jobId}&job_alloc_id=${job.jobAllocId}&process_id=${Helper.user!.processId}',
        {}).then((data) {
      Global.signRequired = jsonDecode(data.body)['signOffRequired'] == 'true';
    });

    Helper.get(
        'nativeappservice/chkInvoice?job_id=${job.jobId}&job_alloc_id=${job.jobAllocId}&process_id=${Helper.user!.processId}',
        {}).then((data) {
      Global.invoiceAllowed = jsonDecode(data.body)['invoiceAllowed'] == 'true';
    });
    Helper.get(
        'nativeappservice/getAllUsersByCompany?contractor_id=${Helper.user?.companyId}&job_alloc_id=${job.jobAllocId}&process_id=${Helper.user?.processId}',
        {}).then((value) {
      Global.hzd_staffs = (jsonDecode(value.body) as List)
          .map((e) => Staff.fromJson(e))
          .toList();
      Helper.get(
          'nativeappservice/getAllEquipmentForSHF?contractor_id=${Helper.user?.companyId}&job_alloc_id=${job.jobAllocId}&process_id=${Helper.user?.processId}',
          {}).then((value) {
        Helper.hideProgress();
        Global.hzd_equips = (jsonDecode(value.body) as List)
            .map((e) => Equip.fromJson(e))
            .toList();
        Navigator.pushNamed(context, 'staff_selection',
            arguments: {"from_review": false});
      }).catchError((onError) => Helper.hideProgress());
    }).catchError((onError) => Helper.hideProgress());

    Helper.get(
        'nativeappservice/getAllTasksForSHF?contractor_id=${Helper.user?.companyId}&job_alloc_id=${job.jobAllocId}&process_id=${Helper.user?.processId}',
        {}).then((value) {
      var json = (jsonDecode(value.body) as List)[0] as Map<String, dynamic>;
      Global.hzd_task = [];
      for (var i = 0; i < 10; i++) {
        if (json.containsKey("Label$i")) {
          Global.hzd_task?.add(Task(
            label: json["Label$i"],
            value: json["Value$i"],
            caption: json["Label$i"],
          ));
        }
      }
    });

    //if (Global.w_task == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Weather%20Hazards',
          {}).then((value) {
        Global.w_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

   // if (Global.w_rate == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Weather%20Risk',
          {}).then((value) {
        Global.w_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    //if (Global.w_ctrl == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Weather%20Control',
          {}).then((value) {
        Global.w_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    ////
    //if (Global.j_task == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Job%20Site%20Hazards',
          {}).then((value) {
        Global.j_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    //if (Global.j_rate == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Job%20Site%20Risk',
          {}).then((value) {
        Global.j_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    //if (Global.j_ctrl == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Job%20Site%20Control',
          {}).then((value) {
        Global.j_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    //if (Global.t_task == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Tree%20Hazards',
          {}).then((value) {
        Global.t_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

   // if (Global.t_rate == null)
      Helper.get('nativeappservice/loadOptionDetails?workflow_step=Tree%20Risk',
          {}).then((value) {
        Global.t_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    //if (Global.t_ctrl == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Tree%20Control',
          {}).then((value) {
        Global.t_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    //if (Global.m_task == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Manual%20Tasks%20Hazards',
          {}).then((value) {
        Global.m_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

   // if (Global.m_rate == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Manual%20Tasks%20Risk',
          {}).then((value) {
        Global.m_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    //if (Global.m_ctrl == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Manual%20Tasks%20Control',
          {}).then((value) {
        Global.m_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });
  }
}
