import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class CallStatus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CallStatusState();
}

class CallStatusState extends State<CallStatus> {
  final List<Map<String, dynamic>> items = [
    {
      "icon": "eta_confirmed.svg",
      "label": "ETA Confirmed",
      "nav_type": "route",
      "goto": "schedule_date",
      'option': null
    },
    {
      "icon": "eta_not_confirmed.svg",
      "label": "ETA not Confirmed",
      "nav_type": "route",
      "goto": "comment_box",
      'option': Global.eta_not
    },
    {
      "icon": "invalid_phone_number.svg",
      "label": "Invalid Phone Number",
      "nav_type": "dialog",
      "goto": "invalid_phone",
      'option': null
    },
    {
      "icon": "invalid_phone_number.svg",
      "label": "Comment",
      "nav_type": "route",
      "goto": "comment_box",
      'option': Global.comment
    }
  ];
  
 Map<String, dynamic>? args;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    });
  }

  Future<void> _handleItemTap(Map<String, dynamic> item) async {
    if (item['nav_type'] == 'route') {
      final data = await Navigator.of(context).pushNamed(
        item['goto'],
        arguments: {
          'visit_type': args!['visit_type'],
          'msg_flow': '',
          'goto': args!['goto'],
          'comm_reci': item['label'],
          'title': item['label'],
          'option': item['option']
        },
      );
      if (data != null) {
        final post = {
          "id": null,
          "job_id": "${Global.job?.jobId??''}",
          "job_alloc_id": "${Global.job?.jobAllocId??''}",
          "visit_type": null,
          "sched_date": null,
          "sched_note": "$data",
          "process_id": "${Helper.user?.processId??''}",
          "owner": "${Helper.user?.id??''}",
          "created_by": "${Helper.user?.id??''}",
          "last_modified_by": null,
          "created_at": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
          "last_updated_at": null,
          "end_time": null,
          "start_time": "",
          "status": "1",
          "phoned": null,
          "sms": null,
          "email": null,
          "callback": "1",
          "PMOnly": "1",
          "phone_no": null,
          "sms_no": null,
          "emailaddress": null,
          "source": "2",
          "message_received": null,
          "message_flow": null,
          "comm_recipient": "${item['label']}",
          "comm_recipient_subcatg": "$data",
          "version": await Helper.getAppVersion(),
        };
        Helper.showProgress(context, 'Please wait..');
        try {
          await Helper.post("JobSchedule/CreateWithNewID", post, is_json: true);
          Helper.hideProgress();
          await Helper.showSingleActionModal(
            context,
            title: 'Thank You',
            description: 'Confirmation saying your feedback has been forwarded to EnviroFrontier team.',
          );
          Navigator.pop(context);
          Navigator.pop(context);
        } catch (e) {
          Helper.hideProgress();
        }
      }
    } else {
      final action = await Helper.showMultiActionModal(
        context,
        title: 'Invalid Phone Number',
        description: 'Are you sure the Phone number is Invalid?',
        negativeButtonText: 'NO',
        negativeButtonimage: 'reject.svg',
        positiveButtonText: 'YES',
        positiveButtonimage: 'accept.svg',
      );
      final post = {
        "id": null,
        "job_id": "${Global.job?.jobId??''}",
        "job_alloc_id": "${Global.job?.jobAllocId??''}",
        "visit_type": null,
        "sched_date": null,
        "sched_note": "",
        "process_id": "${Helper.user?.processId??''}",
        "owner": "${Helper.user?.id??''}",
        "created_by": "${Helper.user?.id??''}",
        "last_modified_by": null,
        "created_at": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
        "last_updated_at": null,
        "end_time": null,
        "start_time": "",
        "status": "1",
        "phoned": null,
        "sms": null,
        "email": null,
        "callback": "1",
        "PMOnly": "1",
        "phone_no": null,
        "sms_no": null,
        "emailaddress": null,
        "source": "2",
        "message_received": null,
        "message_flow": null,
        "comm_recipient": "${item['label']}",
        "comm_recipient_subcatg": "",
        "version": await Helper.getAppVersion(),
      };

      if (action == true) {
        Helper.showProgress(context, 'Please wait..');
        try {
          await Helper.post("JobSchedule/CreateWithNewID", post, is_json: true);
          Helper.hideProgress();
          await Helper.showSingleActionModal(
            context,
            title: 'Thank You',
            description: 'Confirmation saying your feedback has been forwarded to EnviroFrontier team.',
          );
          Navigator.pop(context);
        } catch (e) {
          Helper.hideProgress();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(
        context,
        title: "Call Status",
        sub_title: 'Job TM# ${Global.job?.jobNo??''}',
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 40),
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'What is the status of your call?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'OpenSans',
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (context, index) => SizedBox(height: 50),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () => _handleItemTap(item),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Themer.textGreenColor),
                      ),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset('assets/images/${item['icon']}'),
                          SizedBox(width: 15),
                          Text(
                            item['label'],
                            style: TextStyle(
                              color: Themer.textGreenColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
