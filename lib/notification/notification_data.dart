import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/notification/notification_items.dart';
import 'package:tree_manager/pojo/notification.dart' as Noti;

class NotificationData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotificationDataState();
  }
}

class _NotificationDataState extends State<NotificationData> {
  var counter = 10;
  List<Noti.Notification>? quotes = [];
  List<Noti.Notification> filtered = [];
  bool is_fetching = false;

  @override
  void initState() {
    print("ibiting");
    is_fetching = true;
    getJobs();
    super.initState();
  }

  void getJobs() {
    Helper.get(
        "nativeappservice/getNotificationDetail?contractor_id=${Helper.user?.companyId}&process_id=${Helper.user?.processId}&job_alloc_id=${Global.noti!.jobAllocId}",
        {}).then((response) {
      setState(() {
        is_fetching = false;
      });
      quotes = (json.decode(response.body) as List)
          .map((f) => Noti.Notification.fromJson(f))
          .toList();

      filtered.clear();
      filtered.addAll(quotes!);
      print("type=${quotes.runtimeType}");
    }).catchError((error) {
      setState(() {
        is_fetching = false;
      });
      print(error);
    });
  }

  var filterCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "${Global.noti?.notificationHeading??" "}"),
      body: Container(
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
                            filtered.addAll(quotes!);
                          });
                        })),
                controller: filterCtrl,
                onChanged: (text) {
                  searchNotification(text);
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
                    child: filtered.length != 0
                        ? ListView.builder(
                            itemCount: quotes == null ? 0 : filtered.length,
                            itemBuilder: (context, index) {
                              var quote = filtered[index];
                              return showItemBasedOnJob(quote, index, getJobs);
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
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
    );
  }

  void searchNotification(String text) {
    if (text == '' || text.length == 0) {
      print('len zer');
      filtered = [];
      filtered.addAll(quotes!);
    } else {
      is_fetching = true;
      Helper.get(
          "nativeappservice/getNotificationSearchDetail?contractor_id=${Helper.user?.companyId}&searchValue=${text}&process_id=${Helper.user?.processId}",
          {}).then((response) {
        setState(() {
          is_fetching = false;
          filtered = (json.decode(response.body) as List)
              .map((f) => Noti.Notification.fromJson(f))
              .toList();
        });

        print("type=${quotes.runtimeType}");
      }).catchError((error) {
        setState(() {
          is_fetching = false;
        });
        print(error);
      });
    }
    setState(() {});
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }

  
  Widget showItemBasedOnJob(
  Noti.Notification job,
  int index,
  void Function() refresh,
) {
  var type = int.parse(job.workflowStepId??'');
  
  // Ensure that the function always returns a Widget
  switch (type) {
    case 1:
      return JobListItem(quote: job, index: index, refreshJobs: refresh);
    case 2:
      return ScheduleListItem(
        quote: job,
        index: index,
        refreshJobs: () {},
      );
    case 3:
    case 4:
    case 5:
      return QuoteListItem(
        quote: job,
        index: index,
        refreshJobs: () {},
      );
    case 6:
      return ApprovalListItem(
        quote: job,
        index: index,
        refreshJobs: () {},
      );
    case 7:
      return ScheduleWorkListItem(
        quote: job,
        index: index,
        refreshJobs: () {},
      );
    case 8:
    case 9:
    case 10:
      return InvoiceListItem(
        quote: job,
        index: index,
        refreshJobs: () {},
      );
    default:
      // Provide a default widget or handle the case where the type is unexpected
      return Center(
        child: Text('Unknown type: $type'),
      );
  }
}

}
