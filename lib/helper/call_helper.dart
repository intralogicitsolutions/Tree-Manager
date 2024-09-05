import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';

class CallHelper {
  static Future<bool> setMessage(BuildContext context, String number) async {
    var data = await Navigator.of(context).pushNamed('comment_box', arguments: {
      'title': 'Message',
      'option': null
    });

    if (data != null) {
      var post = {
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
        "created_at":
            "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
        "last_updated_at": null,
        "end_time": null,
        "start_time": "",
        "status": "1",
        "phoned": null,
        "sms": null,
        "email": null,
        "callback": "2",
        "PMOnly": "1",
        "phone_no": null,
        "sms_no": '6359452882',
        "emailaddress": null,
        "source": "2",
        "message_received": null,
        "message_flow": null,
        "comm_recipient": "Comm Note",
        "comm_recipient_subcatg": null,
        "version": await Helper.getAppVersion()
      };

      try {
        Helper.showProgress(context, 'Please wait..');
        await Helper.post("JobSchedule/CreateWithNewID", post, is_json: true);

        var dataJson = {
          "sms": {"to": '6359452882', "message": data},
          "email": {"from": "", "to": "", "cc": "", "bcc": "", "subject": "test", "msg": ""},
          "type": "sms",
          "selectedTpl": null,
          "sufix": null,
          "jobData": null,
          "sms_type": "AU"
        };

        await Helper.get('send/2?data=${jsonEncode(dataJson)}', {});

        Helper.hideProgress();
        await Helper.showSingleActionModal(
          context,
          title: 'Thank You',
          description: 'Confirmation saying your feedback has been forwarded to EnviroFrontier team.',
        );

        Navigator.pop(context);
        return true; // Indicate successful completion
      } catch (e) {
        // Handle any errors that occur
        Helper.hideProgress();
        print(e); // Consider logging the error in a more user-friendly way
        return false; // Indicate that an error occurred
      }
    } else {
      return false; // No data was provided
    }
  }
}
