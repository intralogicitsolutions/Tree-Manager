import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Staff.dart';
import 'package:tree_manager/pojo/Task.dart';
import 'package:tree_manager/pojo/equip.dart';
import 'package:tree_manager/pojo/hazard.dart';
import 'package:tree_manager/pojo/option.dart';

class HazardReview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HazardReviewState();
  }
}

class HazardReviewState extends State<HazardReview> {
  var selected = <String>[];

  @override
  void initState() {
    if (Global.site_hazard_update == true) {
      Global.sel_j_ctrl = [];
      Global.sel_m_ctrl = [];
      Global.sel_t_ctrl = [];
      Global.sel_w_ctrl = [];

      Global.sel_j_task = [];
      Global.sel_m_task = [];
      Global.sel_t_task = [];
      Global.sel_w_task = [];
      // Global.hazard?.criteria1?.split(',').forEach((element) {
      //   Global.sel_w_task?.add(getOption(Global.w_task!, element));
      // });
      Global.hazard?.criteria1?.split(',').forEach((element) {
        final option = getOption(Global.w_task!, element);
        if (option != null) {
          Global.sel_w_task?.add(option);
        }
      });
      // Global.hazard?.control1?.split(',').forEach((element) {
      //   Global.sel_w_ctrl?.add(getOption(Global.w_ctrl!, element));
      // });
      Global.hazard?.control1?.split(',').forEach((element) {
        final option = getOption(Global.w_ctrl!, element);
        if (option != null) {
          Global.sel_w_ctrl?.add(option);
        }
      });
      // Global.hazard?.criteria2?.split(',').forEach((element) {
      //   Global.sel_j_task?.add(getOption(Global.j_task!, element));
      // });
      Global.hazard?.criteria2?.split(',').forEach((element) {
        final option = getOption(Global.j_task!, element);
        if (option != null) {
          Global.sel_j_task?.add(option);
        }
      });
      // Global.hazard?.control2?.split(',').forEach((element) {
      //   Global.sel_j_ctrl?.add(getOption(Global.j_ctrl!, element));
      // });
      Global.hazard?.control2?.split(',').forEach((element) {
        final option = getOption(Global.j_ctrl!, element);
        if (option != null) {
          Global.sel_j_ctrl?.add(option);
        }
      });
      // Global.hazard?.criteria3?.split(',').forEach((element) {
      //   Global.sel_t_task?.add(getOption(Global.t_task!, element));
      // });
      Global.hazard?.criteria3?.split(',').forEach((element) {
        final option = getOption(Global.t_task!, element);
        if (option != null) {
          Global.sel_t_task?.add(option);
        }
      });
      // Global.hazard?.control3?.split(',').forEach((element) {
      //   Global.sel_t_ctrl?.add(getOption(Global.t_ctrl!, element));
      // });
      Global.hazard?.control3?.split(',').forEach((element) {
        final option = getOption(Global.t_ctrl!, element);
        if (option != null) {
          Global.sel_t_ctrl?.add(option);
        }
      });
      // Global.hazard?.criteria4?.split(',').forEach((element) {
      //   Global.sel_m_task?.add(getOption(Global.m_task!, element));
      // });
      Global.hazard?.criteria4?.split(',').forEach((element) {
        final option = getOption(Global.m_task!, element);
        if (option != null) {
          Global.sel_m_task?.add(option);
        }
      });
      // Global.hazard?.control4?.split(',').forEach((element) {
      //   Global.sel_m_ctrl?.add(getOption(Global.m_ctrl!, element));
      // });
      Global.hazard?.control4?.split(',').forEach((element) {
        final option = getOption(Global.m_ctrl!, element);
        if (option != null) {
          Global.sel_m_ctrl?.add(option);
        }
      });
      Global.sel_w_color = getHazardColor(Global.w_rate!, Global.sel_w_rate??'');
      Global.sel_m_color = getHazardColor(Global.m_rate!, Global.sel_m_rate??'');
      Global.sel_t_color = getHazardColor(Global.t_rate!, Global.sel_t_rate??'');
      Global.sel_j_color = getHazardColor(Global.j_rate!, Global.sel_j_rate??'');
    }
    super.initState();
  }

  // Option? getOption(List<Option> staffs, String id) {
  //   return staffs.firstWhere((element) => element.id == id);
  // }

  Option? getOption(List<Option?> options, String id) {
    try {
      return options.firstWhere((option) => option?.id == id);
    } catch (e) {
      return null;
    }
  }

  // Color getHazardColor(List<Option> risks, String risk_id) {
  //   var index =
  //       risks.indexOf(risks.firstWhere((element) => element.id == risk_id));
  //   switch (index) {
  //     case 0:
  //       return Color(0xff3AB517);
  //     case 1:
  //       return Color(0xffFFC400);
  //     case 2:
  //       return Color(0xffDEDE00);
  //     case 3:
  //       return Color(0xffF15D3F);
  //     case 4:
  //       return Color(0xffF53838);
  //   }
  //   return Colors.transparent;
  // }

  Color getHazardColor(List<Option> risks, String risk_id) {
    Option? risk = risks.firstWhereOrNull((element) => element.id == risk_id);
    if (risk != null) {
      var index = risks.indexOf(risk);
      switch (index) {
        case 0:
         // return Color(0xff3AB517);
          return Color(0xff5BEB31);
        case 1:
          return Color(0xffC1EB31);
         // return Color(0xffFFC400);
        case 2:
          return Color(0xffEBD831);
          //return Color(0xffDEDE00);
        case 3:
          return Color(0xffEB8831);
          //return Color(0xffF15D3F);
        case 4:
          return Color(0xffEB4A31);
         // return Color(0xffF53838);
        default:
          return Colors.transparent; // return a default color
      }
    }
    return Colors.transparent; // return a default color
  }

  @override
  Widget build(BuildContext context) {
    var grids = [
      {
        'label': 'STAFF',
        'color': Themer.gridItemColor,
        'text_color': Colors.white,
        'item': Global.hzd_sel_staff,
        'other': Global.hzd_sel_other_staff ?? [],
        'goto': 'staff_selection',
        'args': {'from_review': true}
      },
      {
        'label': 'EQUIPMENT',
        'color': Themer.gridItemColor,
        'text_color': Colors.white,
        'item': Global.hzd_sel_equip,
        'other': [],
        'goto': 'equip_selection',
        'args': {'from_review': true}
      },
      {
        'label': 'TASK',
        'color': Themer.gridItemColor,
        'text_color': Colors.white,
        'item': Global.hzd_sel_task,
        'other': Global.hzd_sel_other_task,
        'goto': 'tasks',
        'args': {'from_review': true}
      },
      {
        'label': 'QUESTIONS',
        'color': Themer.gridItemColor,
        'text_color': Colors.white,
        'item': Global.hzd_sel_answr,
        'other': [],
        'goto': 'q1',
        'args': {'from': 1, 'from_review': true}
      },
      {
        'label': 'WEATHER',
        'color': Global.sel_w_color,
        'text_color': Colors.black,
        'item': {
          'task': Global.sel_w_task,
          'other_task': Global.sel_w_other_task ?? [],
          'rate': Global.sel_w_rate,
          'ctrl': Global.sel_w_ctrl,
          'other_ctrl': Global.sel_w_other_ctrl ?? [],
        },
        'goto': 'thing',
        'args': {'index': 0, 'from_review': true}
      },
      {
        'label': 'JOB SITE',
        'color': Global.sel_j_color,
        'text_color': Colors.black,
        'item': {
          'task': Global.sel_j_task,
          'other_task': Global.sel_j_other_task ?? [],
          'rate': Global.sel_j_rate,
          'ctrl': Global.sel_j_ctrl,
          'other_ctrl': Global.sel_j_other_ctrl ?? [],
        },
        'goto': 'thing',
        'args': {'index': 1, 'from_review': true}
      },
      {
        'label': 'TREE HAZARD',
        'color': Global.sel_t_color,
        'text_color': Colors.black,
        'item': {
          'task': Global.sel_t_task,
          'other_task': Global.sel_t_other_task ?? [],
          'rate': Global.sel_t_rate,
          'ctrl': Global.sel_t_ctrl,
          'other_ctrl': Global.sel_t_other_ctrl ?? []
        },
        'goto': 'thing',
        'args': {'index': 2, 'from_review': true}
      },
      {
        'label': 'MANUAL TASK',
        'color': Global.sel_m_color,
        'text_color': Colors.black,
        'item': {
          'task': Global.sel_m_task,
          'other_task': Global.sel_m_other_task ?? [],
          'rate': Global.sel_m_rate,
          'ctrl': Global.sel_m_ctrl,
          'other_ctrl': Global.sel_m_other_ctrl ?? []
        },
        'goto': 'thing',
        'args': {'index': 3, 'from_review': true}
      },
    ];
    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: "Hazard Review", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                GridView.count(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    childAspectRatio: 4 / 2.3,
                    crossAxisCount: 2,
                    children: List.generate(grids.length, (index) {
                      var item = grids[index];
                       Color color = item['color'] as Color? ?? Colors.transparent; // Default color if null
                       Color textColor = item['text_color'] as Color? ?? Colors.black; // Default text color if null
                       String label = item['label'] as String? ?? '';
                      // String args = item['args'] as String? ?? '';
                      return GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(0.8),
                          decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                  color: Themer.textGreenColor, width: 1)),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      label,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: textColor),
                                    ),
                                    Text(
                                      getControl(item['item'], item['other'],
                                          'task', label),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: textColor),
                                    )
                                  ],
                                ),
                              ),
                              if (index >= 4)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    getControl(item['item'], item['other'],
                                        'ctrl', label),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        onTap: () async {
                          await Navigator.pushNamed(context, item['goto'] as String,
                              arguments: item['args']);
                          setState(() {});
                        },
                      );
                    })),
                //Spacer(),
                Container(
                    margin: EdgeInsets.only(bottom: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton(
                              mini: false,
                              backgroundColor: Themer.textGreenColor,
                              child: SvgPicture.asset(
                                  'assets/images/save_button.svg'),
                              onPressed: () async {
                                var action = await Helper.showMultiActionModal(
                                    context,
                                    title: 'Save!',
                                    description:
                                        'I hereby confirm that all necessary precautions have been taken for the safety of the personnel on site.',
                                    positiveButtonText: 'SAVE',
                                    positiveButtonimage: 'save_button.svg',
                                    negativeButtonText: 'DON\'T SAVE',
                                    negativeButtonimage:
                                        'cancel_outline_button.svg');
                                if (action == true) {
                                  if (Global.site_hazard_update == true) {
                                    updateHazard(1);
                                  } else {
                                    saveHazard(1);
                                  }
                                }
                              },
                              heroTag: 'save',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('SAVE',
                                style: TextStyle(color: Themer.textGreenColor))
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton(
                              mini: false,
                              backgroundColor: Themer.textGreenColor,
                              child: SvgPicture.asset(
                                  'assets/images/submit_button.svg'),
                              onPressed: () async {
                                var action = await Helper.showSingleActionModal(
                                    context,
                                    title: 'Confirmation',
                                    description:
                                        'I hereby confirm that all necessary precautions have been taken for the safety of the personnel on site.',
                                    buttonimage: 'submit_button.svg',
                                    buttonText: 'SUBMIT');
                                if (action == true) {
                                  if (Global.site_hazard_update == true) {
                                    updateHazard(2);
                                  } else {
                                    saveHazard(2);
                                  }
                                }
                              },
                              heroTag: 'submit',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('SUBMIT',
                                style: TextStyle(color: Themer.textGreenColor))
                          ],
                        ),
                      ],
                    )),
              ],
            )),
      ),
    );
  }

  String getControl(var item, var other, String index, String label) {
    print('Run ==>${item.runtimeType} $label');
    if (item is List<Equip>) {
      return item.map((e) => e.itemName).join(',');
    } else if (item is List<Staff>) {
      var tmp =
          item.map((e) => '${e.firstName}' + ' ' + '${e.lastName}').toSet().toList();
      // if(Global.hazard?.customStaffName != '')
      tmp.addAll(
          (other as List<Staff>).map((e) => e.firstName!).toSet().toList()
    );
      return tmp.join(',');
    } else if (item is List<String>) {
      return item.map((e) {
        if (e == '1')
          return 'YES';
        else if (e == '2')
          return 'NO';
        else
          return 'NA';
      }).join(',');
    } else if (item is List<Task>) {
      print('item--->${item}');
      var tmp = item.map((e) => e.label).toList();
      tmp.addAll((other as List<Task>).map((e) => e.label).toList());
      print('temp==>${tmp}');
      return tmp.join(',');
    } else {
      var map = item as Map<String, dynamic>;
      var tmp = (map[index] as List<Option>).map((e) => e.caption).toList();
      // if(Global.hazard?.otherHazard1 != ''
      //     && Global.hazard?.otherControl1 != '' &&
      //     Global.hazard?.otherHazard2 != '' && Global.hazard?.otherControl2 != '' &&
      //     Global.hazard?.otherHazard3 != '' && Global.hazard?.otherControl3 != '' &&
      //     Global.hazard?.otherHazard4 != '' && Global.hazard?.otherControl4 != ''
      // )
      tmp.addAll(
          (map['other_$index'] as List<Option>).map((e) => e.caption).toList());
      return tmp.join(',');
    }
  }

  Future<void> saveHazard(int status) async {
    print('save');
    //return;
    Global.hazard = Hazard();
    Global.hazard?.completedBy = Helper.user?.id;
    Global.hazard?.lastUpdatedAt =
        "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}";
    Global.hazard?.createdAt =
        "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}";
    Global.hazard?.createdBy = Helper.user?.id;
    Global.hazard?.jobId = Global.job?.jobId;
    Global.hazard?.jobAllocId = Global.job?.jobAllocId;
    Global.hazard?.processId = '${Helper.user?.processId}';

    Global.hazard?.personsOnSite =
        (Global.hzd_sel_staff!.length + Global.hzd_sel_other_staff!.length);
    Global.hazard?.otherStaffDetails =
        Global.hzd_sel_staff?.map((e) => e.id).join(',');
    Global.hazard?.customStaffName =
        Global.hzd_sel_other_staff?.map((e) => e.firstName).join(',');

    Global.hazard?.completionTime =
        "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}";
    Global.hazard?.equipment =
        Global.hzd_sel_equip?.map((e) => e.headItemId).join(',');

    Global.hazard?.task = Global.hzd_sel_task?.map((e) => e.value).join(',');
    Global.hazard?.taskOther =
        Global.hzd_sel_other_task?.map((e) => e.label).join(',');

    Global.hazard?.questionnaire = Global.hzd_sel_answr?.join(',');
    Global.hazard?.status = '$status';

    Global.hazard?.criteria1 = Global.sel_w_task?.map((e) => e.id).join(',');
    Global.hazard?.otherHazard1 =
        Global.sel_w_other_task?.map((e) => e.caption).join(',');
    Global.hazard?.riskRating1 = Global.sel_w_rate;
    Global.hazard?.control1 = Global.sel_w_ctrl?.map((e) => e.id).join(',');
    Global.hazard?.otherControl1 =
        Global.sel_w_other_ctrl?.map((e) => e.caption).join(',');

    Global.hazard?.criteria2 = Global.sel_j_task?.map((e) => e.id).join(',');
    Global.hazard?.otherHazard2 =
        Global.sel_j_other_task?.map((e) => e.caption).join(',');
    Global.hazard?.riskRating2 = Global.sel_j_rate;
    Global.hazard?.control2 = Global.sel_j_ctrl?.map((e) => e.id).join(',');
    Global.hazard?.otherControl2 =
        Global.sel_j_other_ctrl?.map((e) => e.caption).join(',');

    Global.hazard?.criteria3 = Global.sel_t_task?.map((e) => e.id).join(',');
    Global.hazard?.otherHazard3 =
        Global.sel_t_other_task?.map((e) => e.caption).join(',');
    Global.hazard?.riskRating3 = Global.sel_t_rate;
    Global.hazard?.control3 = Global.sel_t_ctrl?.map((e) => e.id).join(',');
    Global.hazard?.otherControl3 =
        Global.sel_t_other_ctrl?.map((e) => e.caption).join(',');

    Global.hazard?.criteria4 = Global.sel_m_task?.map((e) => e.id).join(',');
    Global.hazard?.otherHazard4 =
        Global.sel_m_other_task?.map((e) => e.caption).join(',');
    Global.hazard?.riskRating4 = Global.sel_m_rate;
    Global.hazard?.control4 = Global.sel_m_ctrl?.map((e) => e.id).join(',');
    Global.hazard?.otherControl4 =
        Global.sel_m_other_ctrl?.map((e) => e.caption).join(',');
    Helper.showProgress(context,
        status == 1 ? 'Saving Hazard Details' : 'Submitting Hazard Details');
    print('Hazard==>${Global.hazard?.toJson()}');
    Helper.post('jobsitehazard/Create', Global.hazard!.toJson(), is_json: true)
        .then((value) async {
      Helper.hideProgress();
      var json = jsonDecode(value.body);

      if (json['success'] == 1) {
        try {
          await Helper.updateNotificationStatus(Global.job?.jobAllocId??'');
          saveSignFile();
        } catch (e) {
          print(e);
        }
      }
    });
  }

  Future<void> updateHazard(int status) async {
    print('update');
    //return;
    Global.hazard?.completedBy = Helper.user?.id??'';
    Global.hazard?.lastUpdatedAt =
        "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}";

    Global.hazard?.personsOnSite =
        Global.hzd_sel_staff!.length + Global.hzd_sel_other_staff!.length;
    Global.hazard?.otherStaffDetails =
        Global.hzd_sel_staff?.map((e) => e.id).join(',');
    Global.hazard?.customStaffName =
        Global.hzd_sel_other_staff?.map((e) => e.firstName).join(',');

    Global.hazard?.completionTime =
        "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}";
    Global.hazard?.equipment =
        Global.hzd_sel_equip?.map((e) => e.headItemId).join(',');

    Global.hazard?.task = Global.hzd_sel_task?.map((e) => e.value).join(',');
    Global.hazard?.taskOther =
        Global.hzd_sel_other_task?.map((e) => e.label).join(',');
    Global.hazard?.questionnaire = Global.hzd_sel_answr?.join(',');
    Global.hazard?.status = '$status';

    Global.hazard?.criteria1 = Global.sel_w_task?.map((e) => e.id).join(',');
    Global.hazard?.otherHazard1 =
        Global.sel_w_other_task?.map((e) => e.caption).join(',');
    Global.hazard?.riskRating1 = Global.sel_w_rate;
    Global.hazard?.control1 = Global.sel_w_ctrl?.map((e) => e.id).join(',');
    Global.hazard?.otherControl1 =
        Global.sel_w_other_ctrl?.map((e) => e.caption).join(',');

    Global.hazard?.criteria2 = Global.sel_j_task?.map((e) => e.id).join(',');
    Global.hazard?.otherHazard2 =
        Global.sel_j_other_task?.map((e) => e.caption).join(',');
    Global.hazard?.riskRating2 = Global.sel_j_rate;
    Global.hazard?.control2 = Global.sel_j_ctrl?.map((e) => e.id).join(',');
    Global.hazard?.otherControl2 =
        Global.sel_j_other_ctrl?.map((e) => e.caption).join(',');

    Global.hazard?.criteria3 = Global.sel_t_task?.map((e) => e.id).join(',');
    Global.hazard?.otherHazard3 =
        Global.sel_t_other_task?.map((e) => e.caption).join(',');
    Global.hazard?.riskRating3 = Global.sel_t_rate;
    Global.hazard?.control3 = Global.sel_t_ctrl?.map((e) => e.id).join(',');
    Global.hazard?.otherControl3 =
        Global.sel_t_other_ctrl?.map((e) => e.caption).join(',');

    Global.hazard?.criteria4 = Global.sel_m_task?.map((e) => e.id).join(',');
    Global.hazard?.otherHazard4 =
        Global.sel_m_other_task?.map((e) => e.caption).join(',');
    Global.hazard?.riskRating4 = Global.sel_m_rate;
    Global.hazard?.control4 = Global.sel_m_ctrl?.map((e) => e.id).join(',');
    Global.hazard?.otherControl4 =
        Global.sel_m_other_ctrl?.map((e) => e.caption).join(',');

    Helper.showProgress(context, 'Updating Hazard');
    print('Hazard==>${Global.hazard?.toJson()}');
    Helper.put('jobsitehazard/edit', Global.hazard!.toJson(), is_json: true)
        .then((value) async {
      Helper.hideProgress();
      var json = jsonDecode(value.body);

      if (json['success'] == 1) {
        try {
          await Helper.updateNotificationStatus(Global.job?.jobAllocId??'');
          saveSignFile();
        } catch (e) {
          print(e);
        }
      }
    }).catchError((onError) {
      Helper.hideProgress();
    });
  }

  // String saveSignFile() {
  //   //Helper.showProgress(context, 'Getting Hazard Id');
  //   Helper.get(
  //       'nativeappservice/getSiteHazardId?job_alloc_id=${Global.job?.jobAllocId}',
  //       {}).then((value) {
  //     Helper.hideProgress();
  //     var json = jsonDecode(value.body);
  //     var id = json['siteHazardId'];
  //     List<Staff> users = Global.hzd_sel_staff;
  //     users.addAll(Global.hzd_sel_other_staff);

  //     if (users.where((element) => element.uploaded == false).toList().length >
  //         0) {
  //       Helper.showProgress(context, 'Saving Signatures');
  //       users
  //           .where((element) => element.uploaded == false)
  //           .toList()
  //           .asMap()
  //           .forEach((index, staff) {
  //         var sign = {
  //           "id": (() {
  //             if (staff.sign_id == null)
  //               return null;
  //             else
  //               return staff.sign_id;
  //           }()),
  //           "site_hazard_id": "$id",
  //           "user_id": '${staff.id}',
  //           "signature":
  //               "${Global.job?.jobId}/${Global.job?.jobAllocId}/signature_${(() {
  //             if (staff.id != null)
  //               return staff.id;
  //             else
  //               return staff.firstName;
  //           }())}.jpg.jpg",
  //           "owner": "${staff.id}",
  //           "custom_staff_name": "${(() {
  //             if (staff.id != null)
  //               return '';
  //             else
  //               return staff.firstName;
  //           }())}",
  //           "created_by": "${Helper.user?.id}",
  //           "last_modified_by": (() {
  //             if (staff.sign_id == null)
  //               return null;
  //             else
  //               return Helper.user?.id;
  //           }()),
  //           "created_at": "${(() {
  //             if (staff.sign_id == null)
  //               return DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
  //             else
  //               return staff.created_at;
  //           }())}",
  //           "last_updated_at": (() {
  //             if (staff.sign_id == null)
  //               return null;
  //             else
  //               return DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
  //           }()),
  //         };
  //         var url = staff.sign_id == null
  //             ? "jobsitehazardsignature/Create"
  //             : "jobsitehazardsignature/Edit";
  //         (staff.sign_id == null
  //                 ? Helper.post(url, sign, is_json: true)
  //                 : Helper.put(url, sign, is_json: true))
  //             .then((value) {
  //           var signFile = {
  //             "custom_staff_name": "${(() {
  //               if (staff.id != null)
  //                 return '';
  //               else
  //                 return staff.firstName;
  //             }())}",
  //             "imgPath": "data:image/jpeg;base64,${staff.base64}",
  //             "jobId": "${Global.job?.jobId}",
  //             "jobAllocId": "${Global.job?.jobAllocId}",
  //             "imgName": "signature_${(() {
  //               if (staff.id != null)
  //                 return staff.id;
  //               else
  //                 return staff.firstName;
  //             }())}.jpg"
  //           };
  //           var sec_url = "uploadimages/uploadAppPic";
  //           Helper.post(sec_url, signFile, is_json: true).then((fileData) {
  //             if (index ==
  //                 Global.hzd_sel_staff
  //                         .where((element) => element.uploaded == false)
  //                         .toList()
  //                         .length -
  //                     1) {
  //               Helper.hideProgress();
  //               //var json = jsonDecode(value.body);
  //               //if (json['success'] == 1)
  //               try {
  //                 Navigator.pushNamedAndRemoveUntil(
  //                     context, 'invoice', ModalRoute.withName('send_invoice'));
  //               } catch (e) {
  //                 Navigator.pushNamedAndRemoveUntil(
  //                     context, 'invoice', ModalRoute.withName('send_invoice'));
  //               }
  //             }
  //           }).catchError((onError) {
  //             Helper.hideProgress();
  //           });
  //         }).catchError((onError) {
  //           Helper.hideProgress();
  //         });
  //       });
  //     } else {
  //       try {
  //         Navigator.pushNamedAndRemoveUntil(
  //             context, 'invoice', ModalRoute.withName('send_invoice'));
  //       } catch (e) {
  //         Navigator.pushNamedAndRemoveUntil(
  //             context, 'invoice', ModalRoute.withName('send_invoice'));
  //       }
  //     }
  //   }).catchError((onError) {
  //     Helper.hideProgress();
  //   });
  // }

String saveSignFile() {
  String resultMessage = "Operation failed"; // Default message

  Helper.get(
    'nativeappservice/getSiteHazardId?job_alloc_id=${Global.job?.jobAllocId??''}',
    {},
  ).then((value) {
    Helper.hideProgress();
    var json = jsonDecode(value.body);
    var id = json['siteHazardId'];
    List<Staff>? users = Global.hzd_sel_staff!;
    users.addAll(Global.hzd_sel_other_staff!);

    if (users.where((element) => element.uploaded == false).toList().length > 0) {
      Helper.showProgress(context, 'Saving Signatures');
      users.where((element) => element.uploaded == false).toList().asMap().forEach((index, staff) {
        var sign = {
          "id": staff.sign_id ?? null,
          "site_hazard_id": "$id",
          "user_id": '${staff.id}',
          "signature": "${Global.job?.jobId??''}/${Global.job?.jobAllocId??''}/signature_${staff.id ?? staff.firstName}.jpg.jpg",
          "owner": "${staff.id}",
          "custom_staff_name": "${staff.id != null ? '' : staff.firstName}",
          "created_by": "${Helper.user?.id??''}",
          "last_modified_by": staff.sign_id == null ? null : Helper.user?.id??'',
          "created_at": staff.sign_id == null ? DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()) : staff.created_at,
          "last_updated_at": staff.sign_id == null ? null : DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
        };

        var url = staff.sign_id == null ? "jobsitehazardsignature/Create" : "jobsitehazardsignature/Edit";
        (staff.sign_id == null
            ? Helper.post(url, sign, is_json: true)
            : Helper.put(url, sign, is_json: true))
          .then((value) {
            var signFile = {
              "custom_staff_name": "${staff.id != null ? '' : staff.firstName}",
              "imgPath": "data:image/jpeg;base64,${staff.base64}",
              "jobId": "${Global.job?.jobId??''}",
              "jobAllocId": "${Global.job?.jobAllocId??''}",
              "imgName": "signature_${staff.id ?? staff.firstName}.jpg"
            };

            var sec_url = "uploadimages/uploadAppPic";
            Helper.post(sec_url, signFile, is_json: true).then((fileData) {
              if (index == Global.hzd_sel_staff!.where((element) => element.uploaded == false).toList().length - 1) {
                Helper.hideProgress();
                resultMessage = "Operation successful";
                Navigator.pushNamedAndRemoveUntil(context, 'invoice', ModalRoute.withName('send_invoice'));
              }
            }).catchError((onError) {
              Helper.hideProgress();
              resultMessage = "Error uploading signature image";
            });
          }).catchError((onError) {
            Helper.hideProgress();
            resultMessage = "Error saving signature data";
          });
      });
    } else {
      resultMessage = "Operation successful";
      Navigator.pushNamedAndRemoveUntil(context, 'invoice', ModalRoute.withName('send_invoice'));
    }
  }).catchError((onError) {
    Helper.hideProgress();
    resultMessage = "Error fetching site hazard ID";
  });

  return resultMessage; // Ensure that the method always returns a string
}


  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
