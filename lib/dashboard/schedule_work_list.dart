import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_phone_state/flutter_phone_state.dart';
// import 'package:flutter_phone_state/phone_event.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/call_helper.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Contacts.dart';
import 'package:tree_manager/pojo/Job.dart';

class ScheduleWorkList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ScheduleWorkState();
  }
}

class ScheduleWorkState extends State<ScheduleWorkList>
    with SingleTickerProviderStateMixin {
  var counter = 10;
  List<Job> quotes = [];
  bool is_fetching = false;

  late AnimationController _animationController;
  late Animation _animation;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 8.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    Global.job = null;
    print("ibiting");
    is_fetching = true;
    getJobs();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void getJobs() {
    Helper.get(
        "nativeappservice/jobinfoScheduleWorks?contractor_id=${Helper.user?.companyId}&process_id=1",
        {}).then((response) {
      setState(() {
        is_fetching = false;
      });
      quotes = (json.decode(response.body) as List)
          .map((f) => Job.fromJson(f))
          .toList();
      filtered.clear();
      filtered.addAll(quotes);

      print("type=${quotes.runtimeType}");
    }).catchError((error) {
      setState(() {
        is_fetching = false;
      });
      print(error);
    });
  }

  var filterCtrl = TextEditingController();
  var filtered = <Job>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Schedule Work"),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height - 10,
          //margin: EdgeInsets.only(left: 15.0,right: 15.0),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Search Job no, Site Address, Claim...",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              filterCtrl.clear();
                              filtered.addAll(quotes);
                            });
                          })),
                  controller: filterCtrl,
                  onChanged: (text) {
                    if (text == '' || text == null || text.length == 0) {
                      print('len zer');
                      filtered = [];
                      filtered.addAll(quotes);
                    } else {
                      print('non zero');
                      filtered = [];
                      quotes.forEach((job) {
                        if (job.jobDesc!
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            job.address!
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            job.jobNo!
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            job.siteContactName!
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            job.siteContactMobile!
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            job.jobStatus!
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                          filtered.add(job);
                      });
                    }
                    setState(() {});
                  },
                ),
              ),
              is_fetching
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
                  : Flexible(
                      child: quotes.length != 0
                          ? ListView.builder(
                              itemCount: quotes == null ? 0 : filtered.length,
                              itemBuilder: (context, index) {
                                var quote = filtered[index];
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(boxShadow: (() {
                                    if (quote.overdue == '1') {
                                      return [
                                        BoxShadow(
                                            color: Themer.jobGlowColor,
                                            blurRadius: _animation.value,
                                            spreadRadius: _animation.value)
                                      ];
                                    } else
                                      return null;
                                  })()),
                                  child: ScheduleWorkListItem(
                                    quote: quote,
                                    refreshJobs: getJobs,
                                    index: index,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                'No Data Available',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                    )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}

class ScheduleWorkListItem extends StatefulWidget {
  const ScheduleWorkListItem(
      {Key? key, required this.quote, required this.index, required this.refreshJobs})
      : super(key: key);

  final Job quote;
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
        Global.job = widget.quote;
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
                  Text("Job No: TM ${widget.quote.jobNo}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Themer.textGreenColor)),
                  Text(
                    widget.quote.address ?? ' ',
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
                                    heroTag: 'call_button_${widget.quote.jobId}',
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
                                    heroTag: 'set_eta_2x_${widget.quote.jobId}_2',
                                    child: SvgPicture.asset(
                                        'assets/images/set_eta_2x.svg'),
                                    onPressed: () async {
                                      Global.job = widget.quote;
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
  void getAndShowContacts(Job job) {
    Global.job = job;
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
                //   // if (contact.mobile != null) {
                //   //   call = FlutterPhoneState.startPhoneCall(contact.mobile);
                //   //   await call?.done;
                //   //   Navigator.pop(context);
                //   //   if (call?.status == PhoneCallStatus.disconnected) {
                //   //     print('comple');
                //   //     Navigator.of(context).pushNamed('call_status',
                //   //         arguments: {'visit_type': 3, 'goto': 'dashboard'});
                //   //   }
                //   // }
                //   if (contact.mobile != null) {
                //
                //   // Prepare call options
                //   final callId = UniqueKey().toString();
                //   final params = <String, dynamic>{
                //                       'id': callId,
                //                       'nameCaller': contact.contactName ?? 'Unknown',
                //                       'appName': 'Your App Name',
                //                       'avatar': 'assets/images/avatar.png', // Optional
                //                       'handle': contact.mobile,
                //                       'type': 0, // 0 for outgoing call
                //                       'duration': 30000, // Call duration
                //                       'textAccept': 'Accept',
                //                       'textDecline': 'Decline',
                //                       'textMissedCall': 'Missed call',
                //                       'textCallback': 'Call back',
                //                     };
                //   await FlutterCallkitIncoming.startCall(params as CallKitParams
                //     // id: callId,
                //     // nameCaller: contact.contactName ?? 'Caller',
                //     // handle: contact.mobile ?? '',
                //     // hasVideo: false, // Set to true if it's a video call
                //   );
                //   Navigator.pop(context);
                //
                //   // Listen for call events
                //   FlutterCallkitIncoming.onEvent.listen((event) {
                //     if (event!.event == 'endCall') {
                //       print('Call ended');
                //       Navigator.of(context).pushNamed('call_status',
                //           arguments: {'visit_type': 3, 'goto': 'dashboard'});
                //     }
                //   });
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
