import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image/image.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/call_helper.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Contacts.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';
import 'package:tree_manager/pojo/FenceInfo.dart';
import 'package:tree_manager/pojo/Job.dart';
import 'package:tree_manager/pojo/detail.dart';
import 'package:tree_manager/pojo/head.dart';
import 'package:tree_manager/pojo/network_image.dart';
import 'package:tree_manager/pojo/tree_info.dart';

class SiteInspection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SiteInspectionState();
  }
}

class SiteInspectionState extends State<SiteInspection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static Job job = Global.job ?? Job();
  var contacts = <Contact>[];
  var date_string = '';
  bool isLoading = false;

  @override
  // void initState() {
  //   getAllData('init');
  //   super.initState();
  //   setState(() {});
  // }
  void initState() {
    super.initState();
    // setState(() {
    //   isLoading = true;
    // });
   getAllData('init');
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('didChangeDependencies!'),
  //         duration: Duration(seconds: 2), // Duration to show the SnackBar
  //       ),
  //     );
  //   });
  //   setState(() {
  //     isLoading = true;
  //   });
  // }



  Future<void> getAllData(String caller) async{
    setState(() {
      isLoading = true;
    });
    try{
      print('called==>$caller');
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
          "nativeappservice/JobContactDetail?job_id=${Global.job?.jobId??""}", {})
          .then((response) {
        print(response.body);
        var tmp = (jsonDecode(response.body) as List)
            .map((f) => Contact.fromJson(f))
            .toList();
        contacts = [];
        tmp.forEach((t) {
          contacts.add(new Contact(contactName: t.contactName));
          if (t.homeNumber != null) {
            // print('homeNumber--->${t.homeNumber}');
            contacts.add(Contact(mobile: t.homeNumber));
          }
          else if (t.workNumber != null) {
            // print('workNumber--->${t.workNumber}');
            contacts.add(Contact(mobile: t.workNumber));
          }
          else if (t.mobile != null) {
            // print('mobile--->${t.mobile}');
            contacts.add(Contact(mobile: t.mobile));
          }
        });
      });

      //Helper.showProgress(context, 'Getting Job Detail',dismissable: false);
      await Helper.get(
          "nativeappservice/jobdetailInfo?job_alloc_id=${Global.job?.jobAllocId??''}",
          {}).then((response) {
        // Helper.hideProgress();
        setState(() {
          print('inside state');
          job = Job.fromJson(jsonDecode(response.body)[0]);

          Global.job = job;

          //Global.site_info_update = job.treeinfoExists == 'true';

          if (job.costExists == 'true') {
            Global.costing_update = true;
            Helper.get(
                "nativeappservice/contractorRateset?contractor_id=${Helper.user?.companyId??''}&process_id=${Helper.user?.companyId??''}",
                {}).then((response) {
              var json1 = json.decode(response.body);
              print(json1[0].runtimeType);
              var tmp = json1[0];
              Global.rateSet = tmp["rateset_id"].toString();
              Global.taxRate = tmp['tax_rate'];
              Helper.get(
                  "nativeappservice/contractorRateclass?contractor_id=${Helper.user?.companyId??''}&process_id=${Helper.user?.companyId??''}&rateset_id=${Global.rateSet}",
                  {}).then((response) {
                List json2 = jsonDecode(response.body) as List;
                print('classId ${json2.runtimeType}');
                Global.normalClass = json2[0]["rateclass_id"];
                Global.afterClass = json2[1]["rateclass_id"];
              }).catchError((error) {
                print(error);
              });
            }).catchError((error) {
              print(error);
            });
            print('rSET ${Global.rateSet}');
//        print(Global.taxRate.toString());
            getCostHead();
            getCostDetails();
          } else
            Global.costing_update = false;
          print('tree info ==> ${job.treeinfoExists}');
          if (job.treeinfoExists == 'true') {
            Global.site_info_update = true;
            getTreeInfo(job);
          }
          if (job.beforeImagesExists == 'true' || job.afterImagesExists == 'true')
            getPhotos(job);
          else
            print('images failed');

          //fence info fetching
          getFenceInfo(job);
          getFencePhotos(job);
        });
        // Set loading to false once all data is fetched
        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        print('error call');
        //Helper.hideProgress();
        setState(() {
          isLoading = false;
        });
        print(error);
      });
      print('after call');
      Helper.getNotificationCount();
    }catch(error) {
      print('Error fetching data: $error');
    } finally {
      if(mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    var grids = [
      {
        "label": "RE-SCHEDULE",
        "icon": "reschedule_grid.svg",
        "action": "route",
        "goto": "schedule_date",
        'arguments': {
          'visit_type': '1',
          'msg_flow': '',
          'comm_reci': '',
          'goto': 'site_inspection'
        },
        "flag": null,
      },
      {
        "label": "PHOTOS",
        "icon": "photos_grid.svg",
        "action": "route",
        "goto": "before_photos",
        'arguments': {"asa": ''},
        "flag": job.beforeImagesExists,
      },
      {
        "label": "TREE INFO",
        "icon": "treeinfo_grid.svg",
        "action": "route",
        "goto": "number_of_tree",
        'arguments': {"asa": ''},
        "flag": job.treeinfoExists,
      },
      {
        "label": "JOB COSTING",
        "icon": Helper.countryCode == "UK"
            ? "pound_symbol_white.svg"
            : 'Dollar-Quote.svg',
        "action": "route",
        "goto": "crew_configuration",
        'arguments': {"asa": ''},
        "flag": job.costExists,
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
        key: _scaffoldKey,
        bottomNavigationBar: Helper.getBottomBar(bottomClick),
        appBar: Helper.getAppBar(context,
            title: 'Job #TM ${job.jobNo}', sub_title: '', visible: false),
        body: isLoading ? Center(
            child: CircularProgressIndicator()) : Container(
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
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SvgPicture.asset('assets/images/phone.svg'),
                              TextButton(
                                  onPressed: () {
                                    print('llll');
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
                                      if (action == false) {
                                        Helper.openDirection(job.address ?? '');
                                      } else if (action == true) {
                                        Helper.openMap(job.address ?? '');
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
                                    maxLines: 5,
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
                          ),
                          Visibility(
                              visible: true,
                              child: TextButton(
                                  onPressed: null,
                                  child: Text('Disabled Button')))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 50,),
              //Spacer(),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            child: Text(
                              'Schedule Visit',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Align(
                            child: RichText(
                                text: TextSpan(
                                    text: 'Inspection booked on',
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                  TextSpan(
                                      text: ' $date_string',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ])),
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 4 / 2.3,
                        crossAxisCount: 2,
                        children: List.generate(grids.length, (index) {
                          var item = grids[index] as Map<String, Object?>;
                          return GestureDetector(
                            onTap: () async {
                              String? goto = item['goto'] as String?;
                              dynamic arguments = item['arguments'];

                              switch (item['goto']) {
                                case 'schedule_date':
                                case 'before_photos':
                                case 'number_of_tree':
                                  await Navigator.pushNamed(context, goto!,
                                      arguments: arguments);
                                  break;
                                case 'crew_configuration':
                                  if (Global.job?.treeinfoExists == 'true' &&
                                      Global.job?.beforeImagesExists ==
                                          'true') {
                                    if (job.jobStatus?.toLowerCase() ==
                                            "cost submitted" ||
                                        job.jobStatus?.toLowerCase() ==
                                            "approve quote") {
                                      print('fuck');
                                      final sbar = SnackBar(
                                          content: Text(
                                              'Costing is already submitted.'));

                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(sbar);
                                    } else if (job.costExists == 'true') {
                                      print('bitch');
                                      await Navigator.pushNamed(
                                          context, 'review_quote', arguments: {
                                        'crew_details': Global.crewDetails
                                      });
                                    } else {
                                      print('shit');
                                      await Navigator.pushNamed(
                                          context, item['goto'] as String,
                                          arguments: item['arguments']);
                                    }
                                  } else {
                                    if (Global.job?.beforeImagesExists ==
                                        'false') {
                                      var action =
                                          await Helper.showMultiActionModal(
                                              context,
                                              title: 'Proceed to Site Photos?',
                                              description:
                                                  'before images are not yet uploaded, would you like to do it now?',
                                              negativeButtonText: 'NO',
                                              negativeButtonimage: 'reject.svg',
                                              positiveButtonText: 'YES',
                                              positiveButtonimage:
                                                  'accept.svg');
                                      if (action == true) {
                                        await Navigator.pushNamed(
                                            context, 'before_photos',
                                            arguments: item['arguments']);
                                      }
                                    } else if (Global.job?.treeinfoExists ==
                                        'false') {
                                      var action =
                                          await Helper.showMultiActionModal(
                                              context,
                                              title: 'Proceed to Tree Info?',
                                              description:
                                                  'Tree Info are not yet provided, would you like to do it now?',
                                              negativeButtonText: 'NO',
                                              negativeButtonimage: 'reject.svg',
                                              positiveButtonText: 'YES',
                                              positiveButtonimage:
                                                  'accept.svg');
                                      if (action == true) {
                                        await Navigator.pushNamed(
                                            context, 'number_of_tree',
                                            arguments: item['arguments']);
                                      }
                                    }
                                  }
                                  break;
                                default:
                              }
                              getAllData('await click');
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
                                      item['label'] as String,
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

  void getTreeInfo(Job job) {
    Helper.get(
        "WorkOperationsInfo/GetAllByJobIdAllocId?job_alloc_id=${job.jobAllocId}&job_id=${job.jobId}",
        {}).then((data) {
      try {
        print(data.body);
        var json = jsonDecode(data.body) as List;
        var tmp = json.map((f) => TreeInfo.fromJson(f)).toList();
        Global.info = tmp[0];
      } catch (e) {
        print('tree info exception');
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void getFenceInfo(Job job) {
    Helper.get(
        "AdditionalDamageInfo/getByJobIdJobAllocId?job_alloc_id=${job.jobAllocId}&job_id=${job.jobId}",
        {}).then((data) {
      try {
        print(data.body);
        var json = jsonDecode(data.body) as List;
        var tmp = json.map((f) => FenceInfo.fromJson(f)).toList();
        Global.fence = tmp[0];
        if (Global.fence != null) Global.fence_info_update = true;
      } catch (e) {
        print('fence info exception');
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void getPhotos(Job job) {
    print('getting images');
    Helper.get(
        "uploadimages/getUploadImgsByJobIdAllocId?job_alloc_id=${job?.jobAllocId}&job_id=${job?.jobId}",
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

  void getFencePhotos(Job job) {
    print('getting fence images');
    Helper.get(
        "uploadimages/getUploadFenceImgsByJobIdAllocId?job_alloc_id=${job.jobAllocId}&job_id=${job.jobId}",
        {}).then((data) {
      print(data.body);
      var images = (jsonDecode(data.body) as List)
          .map((f) => NetworkPhoto.fromJson(f))
          .toList();
      Global.standing_images = [];
      Global.damage_images = [];
      Global.standing_images
          .addAll(images.where((element) => element.imgType == '4').toList());
      Global.damage_images
          .addAll(images.where((element) => element.imgType == '5').toList());
      if (images.length > 0) Global.fence_info_update = true;
    }).catchError((onError) {
      print(onError.toString());
    });
  }

statusImage(Map<String, dynamic> item) {
    //print(jsonEncode(item));
    if (item['flag'] == null || item['flag'] == 'false') {
      return item['icon'];
    } else {
      return 'done.svg';
    }
  }

  void getCostHead() {
    Helper.get(
        "costformhead/getCostFormHeadByJobIdAllocId?job_alloc_id=${Global.job?.jobAllocId??''}&job_id=${Global.job?.jobId??''}",
        {}).then((data) {
      var json = jsonDecode(data.body) as List;
      Global.head = Head.fromJson(json[0]);
      Global.substan = Global.head!.tpJobSubstantiation!;
    });
  }

  void getCostDetails() {
    Helper.get(
        "costformhead/getCostFormDetailByJobIdAllocId?job_alloc_id=${Global.job?.jobAllocId??''}&job_id=${Global.job?.jobId??''}",
        {}).then((data) {
      Global.details = (jsonDecode(data.body) as List)
          .map((f) => Detail.fromJson(f))
          .toList();
      var cd = <CrewDetail>[];
      Global.details.forEach((f) {
        var tmp = CrewDetail();
        tmp.itemId = f.itemId;
        tmp.itemName = f.itemName;
        tmp.fixed = '';
        tmp.hourlyRate = f.itemPrice;
        tmp.count = int.parse(f.itemQty!);
        tmp.hour = f.itemHrs!;
        tmp.rateClass = f.itemRate!;
        tmp.itemCategory = f.itemCategory;
        tmp.detail = f;

        cd.add(tmp);
      });
      Global.crewDetails = cd;
    });
  }

  // PhoneCall? call;
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
                  print('jjjjccccccxxxxssss');
                  await Helper.openDialer(
                      contact.mobile ?? '');
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
                  //         arguments: {'visit_type': 2});
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
                                  contact.mobile ?? '',
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
                                                context,
                                                contact.mobile ?? ''
                                            );
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
                          contact.contactName ?? '',
                          style: TextStyle(
                              color: Themer.textGreenColor, fontSize: 20),
                        ),
                      ),
              );
            }));
  }
}
