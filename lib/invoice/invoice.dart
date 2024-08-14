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
import 'package:tree_manager/pojo/Staff.dart';
import 'package:tree_manager/pojo/Task.dart';
import 'package:tree_manager/pojo/equip.dart';
import 'package:tree_manager/pojo/hazard.dart';
import 'package:tree_manager/pojo/network_image.dart';
import 'package:tree_manager/pojo/option.dart';
import 'package:tree_manager/pojo/signature.dart';
import 'package:tree_manager/pojo/tree_info.dart';

class Invoice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InvoiceState();
  }
}

class InvoiceState extends State<Invoice> {
  static Job job = Global.job ?? Job();
  var contacts = <Contact>[];
  var date_string = '';
  Map<String, dynamic>? args;

  @override
  void initState() {
    //Global.job = Job(jobAllocId: '6200', jobId: '14833', jobNo: '4378');
    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args!.containsKey('show_reschedule'))
        rescheduleDialog();
    });
    getAllData('init');
    super.initState();
    setState(() {});
  }

  void getAllData(String caller) {
    print('called==>$caller');
    Global.before_images = [];
    Global.before_images = [];
    Global.after_images = [];
    Global.hazard = null;
    Global.site_hazard_update = false;
    Global.base64Sign = null;
    Global.signs = [];
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
    Helper.get(
            "nativeappservice/JobContactDetail?job_id=${Global.job!.jobId}", {})
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

    //Helper.showProgress(context, 'Getting Job Detail',dismissable: false);
    Helper.get(
        "nativeappservice/jobdetailInfo?job_alloc_id=${Global.job!.jobAllocId}",
        {}).then((response) {
      // Helper.hideProgress();
      setState(() {
        print('inside state');
        job = Job.fromJson(jsonDecode(response.body)[0]);
        job.siteHazardFormExists = "true";
        job.siteHazardUploadExists = "false";
        job.afterImagesExists = "false";
        Global.job = job;
        Global.site_hazard_update = job.siteHazardFormExists == 'true';

        if (job.beforeImagesExists == 'true' || job.afterImagesExists == 'true')
          getPhotos(job);
        else
          print('images failed');
      });
    }).catchError((error) {
      print('error call');
      //Helper.hideProgress();
      print(error);
    });
    print('after call');
    getHazard();
    getPreloads();
    Helper.getNotificationCount();
  }

  @override
  Widget build(BuildContext context) {
    var grids = [
      {
        "label": "RE-SCHEDULE",
        "icon": "reschedule_grid.svg",
        "action": "dialog",
        "goto": "schedule_date",
        'arguments': {
          'visit_type': '3',
          'msg_flow': '',
          'comm_reci': '',
          'goto': 'invoice'
        },
        "flag": null,
      },
      {
        "label": "SITE HAZARD",
        "icon": "sitehazard_grid.svg",
        "action": "dialog",
        "goto": "site_hazard",
        'arguments': {"from_review": false},
        "flag": (job.siteHazardFormExists == 'true' ||
                job.siteHazardUploadExists == 'true')
            .toString(),
      },
      {
        "label": "PHOTOS",
        "icon": "photos_grid.svg",
        "action": "route",
        "goto": "hazard_photos",
        'arguments': {"asa": ''},
        "flag": job.afterImagesExists,
      },
      {
        "label": "COMPLETE JOB",
        "icon": "completejob_grid.svg",
        "action": "route",
        "goto": "accident",
        'arguments': {"asa": ''},
        "flag": job.invoiceComplete,
      }
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
          "${date_split[2]}th ${Helper.intToMonth(int.parse(date_split[1]))} ${date_split[0]} at ${job.schedTime ?? '0:0AM'}";
    } catch (e) {}
    return Scaffold(
        bottomNavigationBar: Helper.getBottomBar(bottomClick),
        appBar: Helper.getAppBar(context,
            title: 'Job #TM ${job.jobNo}', sub_title: ''),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
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
                                      '${job.addressDisplay}',
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
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, 'pdf_viewer', arguments: {
                          "url":
                              'generate/CostingReport?job_id=${Global.job!.jobId}&job_alloc_id=${Global.job!.jobAllocId}',
                          'title': 'Review Quote'
                        });
                      },
                      icon: SvgPicture.asset(
                        Helper.countryCode == "UK"
                            ? 'assets/images/pound_symbol_white.svg'
                            : 'assets/images/Dollar-Quote.svg',
                        color: Themer.gridItemColor,
                        height: 20,
                      ),
                      label: Text(
                        'View Costing',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 20,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            color: Themer.textGreenColor),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Align(
                          child: Text(
                            'Scheduled to Perform Work',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisAlignment: MainAxisAlignment.center,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(' On',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                              Text(' $date_string',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                      ],
                    ),
                    GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 4 / 2.5,
                        crossAxisCount: 2,
                        children: List.generate(grids.length, (index) {
                          var item = grids[index] as Map<String, Object?>;
                          return GestureDetector(
                            onTap: () async {
                              String goto = item['goto'] as String? ?? ''; // Handle null case
                          Map<String, Object?> arguments = item['arguments'] as Map<String, Object?>? ?? {};
                              if (item['action'] == 'route') {
                                if (goto == 'hazard_photos') {
                                  await Navigator.pushNamed(
                                      context, goto,
                                      arguments: item['arguments']);
                                } //ok till here
                                else {
                                  if (Global.job!.afterImagesExists == 'true' &&
                                      (Global.job!.siteHazardFormExists ==
                                              'true' ||
                                          Global.job!.siteHazardUploadExists ==
                                              'true')) {
                                    await Navigator.pushNamed(
                                        context, goto,
                                        arguments: item['arguments']);
                                  } else {
                                    if (Global.job!.siteHazardFormExists ==
                                            'false' &&
                                        Global.job!.siteHazardUploadExists ==
                                            'false') {
                                      var action =
                                          await Helper.showMultiActionModal(
                                              context,
                                              title:
                                                  'Site Hazard not completed',
                                              description:
                                                  'would you like to do Site Hazard now?',
                                              positiveButtonText: 'YES',
                                              negativeButtonText: 'NO',
                                              positiveButtonimage: 'accept.svg',
                                              negativeButtonimage:
                                                  'reject.svg');
                                      if (action == true) {
                                        showHazardDialog(
                                          {
                                            "label": "SITE HAZARD",
                                            "icon": "sitehazard_grid.svg",
                                            "action": "dialog",
                                            "goto": "site_hazard",
                                            'arguments': {"from_review": false},
                                            "flag": (job.siteHazardFormExists ==
                                                        'true' ||
                                                    job.siteHazardUploadExists ==
                                                        'true')
                                                .toString(),
                                          },
                                        );
                                      }
                                    } else {
                                      var action =
                                          await Helper.showMultiActionModal(
                                              context,
                                              title:
                                                  'After Images Not completed',
                                              description:
                                                  'would you like to do After Images now?',
                                              positiveButtonText: 'YES',
                                              negativeButtonText: 'NO',
                                              positiveButtonimage: 'accept.svg',
                                              negativeButtonimage:
                                                  'reject.svg');
                                      if (action == true) {
                                        var item = {
                                          "label": "PHOTOS",
                                          "icon": "photos_grid.svg",
                                          "action": "route",
                                          "goto": "hazard_photos",
                                          'arguments': {"asa": ''},
                                          "flag": job.afterImagesExists,
                                        };
                                        await Navigator.pushNamed(
                                            context, item['goto'] as String,
                                            arguments: item['arguments']);
                                      }
                                    }
                                  }
                                }
                                getAllData('await click');
                              } else {
                                if (item['goto'] == 'schedule_date') {
                                  rescheduleDialog();
                                } else if (item['goto'] == 'site_hazard') {
                                  showHazardDialog(item);
                                } else {}
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(1),
                              child: Container(
                                decoration:
                                    BoxDecoration(color: Themer.textGreenColor),
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
                                      item['label'] as String ?? '',
                                      style: TextStyle(color: Colors.white),
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
        ));
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }

  void getPhotos(Job job) {
    Global.before_images = [];
    Global.after_images = [];
    Global.hazard_images = [];
    print('getting images');
    Helper.get(
        "uploadimages/getUploadImgsByJobIdAllocId?job_alloc_id=${job?.jobAllocId}&job_id=${job?.jobId}",
        {}).then((data) {
      print(data.body);
      var images = (jsonDecode(data.body) as List)
          .map((f) => NetworkPhoto.fromJson(f))
          .toList();

      images.forEach((f) {
        if (f.imgType == '1') Global.before_images!.add(f);
        if (f.imgType == '2') Global.after_images!.add(f);
        if (f.imgType == '3') Global.hazard_images.add(f);
      });
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  String statusImage(Map<String, dynamic> item) {
    //print(jsonEncode(item));
    if (item['flag'] == null || item['flag'] == 'false') {
      return item['icon'];
    } else {
      return 'done.svg';
    }
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
                  // if (contact.mobile != null) {
                  //   // call = FlutterPhoneState.startPhoneCall(contact.mobile);
                  //   // await call!.done;
                  //   // Navigator.pop(context);
                  //   // if (call!.status == PhoneCallStatus.disconnected) {
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
                  // await FlutterCallkitIncoming.startCall(params as CallKitParams );
                  // Navigator.pop(context);
                  //
                  // // Listen for call events
                  // FlutterCallkitIncoming.onEvent.listen((event) {
                  //   if (event!.event == 'endCall') {
                  //     print('Call ended');
                  //     Navigator.of(context).pushNamed('call_status',
                  //         arguments: {'visit_type': 3, });
                  //   }
                  // });
                  //
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

  Future<void> rescheduleDialog() async {
    var action = await Helper.showMultiActionModal(context,
        title: 'Choose an Action',
        negativeButtonText: 'CALL',
        positiveButtonText: 'BOOK ETA',
        negativeButtonimage: 'call_button_2x.svg',
        positiveButtonimage: 'set_eta_button.svg');
    if (action == true) {
      await Navigator.pushNamed(context, 'schedule_date', arguments: {
        'visit_type': '3',
        'msg_flow': '',
        'comm_reci': '',
        'goto': 'invoice'
      });
      getAllData('await click');
    } else if (action == false) {
      showContactDialog();
    }
  }

  getPreloads() {
    Helper.get(
        'nativeappservice/chkSignOff?job_id=${Global.job!.jobId}&job_alloc_id=${Global.job!.jobAllocId}&process_id=${Helper.user!.processId}',
        {}).then((data) {
      Global.signRequired = jsonDecode(data.body)['signOffRequired'] == 'true';
    });

    Helper.get(
        'nativeappservice/chkInvoice?job_id=${Global.job!.jobId}&job_alloc_id=${Global.job!.jobAllocId}&process_id=${Helper.user!.processId}',
        {}).then((data) {
      Global.invoiceAllowed = jsonDecode(data.body)['invoiceAllowed'] == 'true';
    });

    Helper.get(
        'nativeappservice/loadOptionDetails?workflow_step=Hazard%20Upload%20Options',
        {}).then((value) {
      Global.hazard_uploads = (jsonDecode(value.body) as List)
          .map((e) => Option.fromJson(e))
          .toList();
    });
  }

  Future<void> getHazard() async {
    //selected hazard items

    Global.signs = null;

    Global.sel_j_rate = null;
    Global.sel_m_rate = null;
    Global.sel_t_rate = null;
    Global.sel_w_rate = null;

    //options for hazard
    if (Global.j_ctrl == null) Global.j_ctrl = [];
    if (Global.m_ctrl == null) Global.m_ctrl = [];
    if (Global.t_ctrl == null) Global.t_ctrl = [];
    if (Global.w_ctrl == null) Global.w_ctrl = [];

    if (Global.j_task == null) Global.j_task = [];
    if (Global.m_task == null) Global.m_task = [];
    if (Global.t_task == null) Global.t_task = [];
    if (Global.w_task == null) Global.w_task = [];

    if (Global.j_rate == null) Global.j_rate = <Option>[];
    if (Global.m_rate == null) Global.m_rate = <Option>[];
    if (Global.t_rate == null) Global.t_rate = <Option>[];
    if (Global.w_rate == null) Global.w_rate = <Option>[];

    await Helper.get(
        'jobsitehazard/getAllSHFData?job_alloc_id=${Global.job?.jobAllocId}&job_id=${Global.job?.jobId}',
        {}).then((data) async {
      var json = (jsonDecode(data.body) as List)
          .map((e) => Hazard.fromJson(e))
          .toList();
      if (json.length > 0 && json.first != null) {
        Global.hazard = json.first;

        var hzd = json.first;
        if (hzd != null) {
          await Helper.get(
              'jobsitehazardsignature/getSignatureBySiteHazardId?site_hazard_id=${hzd.id}',
              {}).then((value) {
            print('signature');
            print('${value}');
            Global.signs = (jsonDecode(value.body) as List)
                .map((e) => Signature.fromJson(e))
                .toList();
          });
        }

        Global.sel_w_rate = hzd.riskRating1;
        Global.sel_j_rate = hzd.riskRating2;
        Global.sel_t_rate = hzd.riskRating3;
        Global.sel_m_rate = hzd.riskRating4;

        Global.sel_w_color = Themer.gridItemColor;
        Global.sel_m_color = Themer.gridItemColor;
        Global.sel_t_color = Themer.gridItemColor;
        Global.sel_j_color = Themer.gridItemColor;

        hzd.otherControl1?.split(',')?.forEach((element) {
          Global.sel_w_other_ctrl.add(Option(caption: element));
        });

        hzd.otherControl2?.split(',')?.forEach((element) {
          Global.sel_j_other_ctrl.add(Option(caption: element));
        });

        hzd.otherControl3?.split(',')?.forEach((element) {
          Global.sel_t_other_ctrl.add(Option(caption: element));
        });

        hzd.otherControl4?.split(',')?.forEach((element) {
          Global.sel_m_other_ctrl.add(Option(caption: element));
        });

        hzd.otherHazard1?.split(',')?.forEach((element) {
          Global.sel_w_other_task.add(Option(caption: element));
        });

        hzd.otherHazard2?.split(',')?.forEach((element) {
          Global.sel_j_other_task.add(Option(caption: element));
        });

        hzd.otherHazard3?.split(',')?.forEach((element) {
          Global.sel_t_other_task.add(Option(caption: element));
        });

        hzd.otherHazard4?.split(',')?.forEach((element) {
          Global.sel_m_other_task.add(Option(caption: element));
        });

        Global.hzd_sel_answr = [];
        hzd.questionnaire?.split(',')?.forEach((element) {
          Global.hzd_sel_answr.add(element);
        });
      }
    });

    Helper.get(
        'nativeappservice/getAllUsersByCompany?contractor_id=${Helper.user?.companyId}&job_alloc_id=${Global.job?.jobAllocId}&process_id=${Helper.user?.processId}',
        {}).then((value) {
      Global.hzd_staffs = (jsonDecode(value.body) as List)
          .map((e) => Staff.fromJson(e))
          .toList();
      if (Global.hazard != null) {
        Global.hzd_sel_staff = [];
        Global.hazard!.otherStaffDetails?.split(',')?.forEach((value) {
          if (value != 'null')
            Global.hzd_sel_staff.add(getStaff(Global.hzd_staffs, value));
        });
        Global.hzd_sel_staff = Global.hzd_sel_staff.toSet().toList();

        Global.hzd_sel_other_staff = [];
        Global.hazard!.customStaffName?.split(',')?.forEach((element) {
          var stf = Staff(firstName: element, lastName: '');
          stf.rev_checked = true;
          stf.checked = true;
          stf.signed = true;
          stf.uploaded = true;
          var sign = Global.signs!.firstWhere(
              (element) => element.signature!.contains('_${stf.firstName}'));
          stf.sign_id = sign.id!;
          stf.created_at = sign.createdAt!;
          Global.hzd_sel_other_staff.add(stf);
        });
      }
    });
    //return;

    Helper.get(
        'nativeappservice/getAllEquipmentForSHF?contractor_id=${Helper.user?.companyId}&job_alloc_id=${Global.job?.jobAllocId}&process_id=${Helper.user?.processId}',
        {}).then((value) {
      Global.hzd_equips = (jsonDecode(value.body) as List)
          .map((e) => Equip.fromJson(e))
          .toList();
      print("manu ${Global.hazard?.toJson()}");
      if (Global.hazard != null) {
        Global.hzd_sel_equip = [];
        Global.hazard!.equipment!.split(',').forEach((value) {
          if (value != 'null')
            Global.hzd_sel_equip.add(getEquip(Global.hzd_equips, value));
        });
      }
    });

    if (Global.hzd_qstn == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=SHF%20Questions',
          {}).then((value) {
        Global.hzd_qstn = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
        if (Global.hazard != null) {
          Global.hzd_sel_answr =
              Global.hazard!.questionnaire!.split(',').toList();
        }
      });

    Helper.get(
        'nativeappservice/getAllTasksForSHF?contractor_id=${Helper.user?.companyId}&job_alloc_id=${Global.job?.jobAllocId}&process_id=${Helper.user?.processId}',
        {}).then((value) {
      var json = (jsonDecode(value.body) as List)[0] as Map<String, dynamic>;
      Global.hzd_task = [];
      for (var i = 0; i < 10; i++) {
        if (json.containsKey("Label$i")) {
          Global.hzd_task.add(Task(
              label: json["Label$i"],
              value: json["Value$i"],
              caption: json["Label$i"]));
        }
      }
      if (Global.hazard != null) {
        Global.hzd_sel_task = [];
        Global.hazard!.task!.split(',').asMap().forEach((key, value) {
          Global.hzd_sel_task.add(getTask(Global.hzd_task, value));
        });

        Global.hzd_sel_other_task = [];
        Global.hazard!.taskOther!.split(',').forEach((element) {
          Global.hzd_sel_other_task.add(Task(label: element, caption: element));
        });
      }
    });

    if (Global.w_task.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Weather%20Hazards',
          {}).then((value) {
        Global.w_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.w_rate.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Weather%20Risk',
          {}).then((value) {
        Global.w_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.w_ctrl.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Weather%20Control',
          {}).then((value) {
        Global.w_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    ////
    if (Global.j_task.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Job%20Site%20Hazards',
          {}).then((value) {
        Global.j_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.j_rate.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Job%20Site%20Risk',
          {}).then((value) {
        Global.j_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.j_ctrl.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Job%20Site%20Control',
          {}).then((value) {
        Global.j_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    ////
    if (Global.t_task.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Tree%20Hazards',
          {}).then((value) {
        Global.t_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.t_rate.length == 0)
      Helper.get('nativeappservice/loadOptionDetails?workflow_step=Tree%20Risk',
          {}).then((value) {
        Global.t_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.t_ctrl.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Tree%20Control',
          {}).then((value) {
        Global.t_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    ////
    if (Global.m_task.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Manual%20Tasks%20Hazards',
          {}).then((value) {
        Global.m_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.m_rate.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Manual%20Tasks%20Risk',
          {}).then((value) {
        Global.m_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.m_ctrl.length == 0)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Manual%20Tasks%20Control',
          {}).then((value) {
        Global.m_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });
  }

  Color getHazardColor(List<Option> risks, String risk_id) {
    var index =
        risks.indexOf(risks.firstWhere((element) => element.id == risk_id));
    switch (index) {
      case 0:
        return Color(0xff5BEB31);
      case 1:
        return Color(0xffC1EB31);
      case 2:
        return Color(0xffEBD831);
      case 3:
        return Color(0xffEB8831);
      case 4:
        return Color(0xffEB4A31);
    }return Colors.transparent; 
  }

  String getAnswer(String value) {
    if (value == "1")
      return "Yes";
    else if (value == "2")
      return "No";
    else
      return "NA";
  }

  Option getOption(List<Option> staffs, String id) {
    return staffs.firstWhere((element) => element.id == id);
  }

  Task getTask(List<Task> tasks, String id) {
    return tasks.firstWhere((element) => element.value == id);
  }

  Equip getEquip(List<Equip> staffs, String id) {
    print("getEquip $id");
    return staffs.firstWhere((element) => element.headItemId == id);
  }

  Staff getStaff(List<Staff> staffs, String id) {
    staffs.forEach((element) {
      print('staff=${element.id} == ${id}');
    });
    var stf = staffs.firstWhere((element) => element.id == id);
    stf?.checked = true;
    stf?.rev_checked = true;
    stf?.signed = true;
    stf?.uploaded = true;
    var sign = Global.signs!
        .firstWhere((element) => element.signature!.contains('_${id}'));
    stf?.created_at = sign.createdAt!;
    stf?.sign_id = sign.id!;
    return stf;
  }

  void showGateDialog({String? title, String? msg, Function? call}) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      call!.call();
                    },
                    child: Text('Yes')),
              ],
              title: Text(title!),
              content: Text(msg!),
            ));
  }

  Future<void> showHazardDialog(Map<String, dynamic> item) async {
    var action = await Helper.showMultiActionModal(context,
        title: 'Choose an Action',
        positiveButtonText: 'ENVIRO FORM',
        negativeButtonText: 'UPLOAD',
        negativeButtonimage: 'enviro_form.svg',
        positiveButtonimage: 'gallery_button.svg');
    if (action == true) {
      if (Global.site_hazard_update) {
        await Navigator.pushNamed(context, 'hazard_review',
            arguments: item['arguments']);
        getAllData('await click');
      } else {
        await Navigator.pushNamed(context, 'staff_selection',
            arguments: item['arguments']);
        getAllData('await click');
      }
    } else if (action == false) {
      await Navigator.pushNamed(context, 'hazard_upload',
          arguments: item['arguments']);
      getAllData('await click');
    } else
      getAllData('await click');
  }
}
