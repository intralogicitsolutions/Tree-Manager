import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class ConfirmSchedule extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConfirmScheduleState();
  }
}

class ConfirmScheduleState extends State<ConfirmSchedule> {
  DateTime? date;
  var hour;
  var minute;
  var am_pm;
  Map<String, dynamic>? args;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
     args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    date = args!['date'];
    hour = args!['hour'];
    minute = args!['minute'];
    am_pm = args!['am_pm'];

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "Confirm Schedule", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
      body: Stack(
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
            padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
            decoration: BoxDecoration(color: Colors.white),
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: size.height / 25,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Schedule booked on',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${date!.day}${Helper.getOrdinal(date!.day)} ${Helper.intToMonth(date!.month)} ${date!.year}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 36, color: Themer.textGreenColor),
                    ),
                    Text(
                      '(${DateFormat('EEEE').format(date!)}) at $hour:${(() {
                        if (minute == 0)
                          return '00';
                        else
                          return minute;
                      })()} $am_pm',
                      style:
                          TextStyle(fontSize: 36, color: Themer.textGreenColor),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            height: 60.0,
                            width: 60.0,
                            margin: EdgeInsets.only(bottom: 10.0, top: 30),
                            child: FittedBox(
                              child: FloatingActionButton(
                                  heroTag: 'dialog_action_2',
                                  child: SvgPicture.asset(
                                    "assets/images/submit_button.svg",
                                    height: 60,
                                    width: 60,
                                  ),
                                  onPressed: () async {
                                    try {
                                      print('goto==>${args!['goto']}');
                                      Helper.showProgress(
                                          context, 'Scheduling....');
                                      var post = {
                                        "id": null,
                                        "job_id": "${Global.job?.jobId??''}",
                                        "job_alloc_id":
                                            "${Global.job?.jobAllocId??''}",
                                        "visit_type": "${args!['visit_type']}",
                                        "sched_date":
                                            "${date?.year??''}-${date?.month??''}-${date?.day??''}",
                                        "sched_note": null,
                                        "process_id": "${Helper.user?.id??''}",
                                        "owner": "${Helper.user?.id??''}",
                                        "created_by": "${Helper.user?.id??''}",
                                        "last_modified_by": null,
                                        "created_at":
                                            "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
                                        "last_updated_at": null,
                                        "end_time": null,
                                        "start_time": '$hour:${(() {
                                          if (minute == 0)
                                            return '00';
                                          else
                                            return minute;
                                        })()}$am_pm',
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
                                        "message_flow": "${args!['msg_flow']}",
                                        "comm_recipient":
                                            "${args!['comm_reci']}",
                                        "comm_recipient_subcatg": null,
                                        "version": await Helper.getAppVersion()
                                      };
                                      print('id--------${Helper.user?.id}');
                                      // print('date1-->${date?.year??''}-${date?.month??''}-${date?.day??''}');
                                      Helper.post("JobSchedule/CreateWithNewID",
                                              post,
                                              is_json: true)
                                          .then((data) async {
                                        await Helper.updateNotificationStatus(
                                            Global.job?.jobAllocId??'');
                                        Helper.hideProgress();
                                        try {

                                          if (args!.containsKey('goto') &&
                                              args!['goto'] != null) {
                                            Navigator.pushNamed(
                                                context, args!['goto']);
                                            // Navigator.popUntil(context,
                                            //     ModalRoute.withName(args['goto']));
                                            // Navigator.popUntil(context,
                                            //     ModalRoute.withName('site_inspection'));
                                          } else {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        } catch (e) {
                                          Navigator.pushNamed(
                                              context, args!['goto']);
                                        }
                                      }).catchError((onError) {
                                        Helper.hideProgress();
                                      });
                                    } catch (e) {
                                      Helper.hideProgress();
                                    }
                                  }),
                            )),
                        Text(
                          "CONFIRM",
                          style: TextStyle(color: Themer.textGreenColor),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                            height: 60.0,
                            width: 60.0,
                            margin: EdgeInsets.only(bottom: 10.0, top: 30),
                            child: FittedBox(
                              child: FloatingActionButton(
                                  heroTag: 'dialog_action_1',
                                  child: SvgPicture.asset(
                                    "assets/images/change.svg",
                                    height: 60,
                                    width: 60,
                                  ),
                                  onPressed: () {
                                    Navigator.popUntil(context,
                                        ModalRoute.withName('schedule_date'));
                                    // Navigator.pop(context);
                                    // Navigator.pop(context);
                                  }),
                            )),
                        Text(
                          "CHANGE",
                          style: TextStyle(color: Themer.textGreenColor),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
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
