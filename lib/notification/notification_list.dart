import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/notification.dart' as Noti;

class NotificationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotificationListState();
  }
}
class NotificationListState extends State<NotificationList> {
  var filterCtrl = TextEditingController();
  var counter = 10;
  List<Noti.Notification> quotes = [];
  List<Noti.Notification> filtered = [];
  bool is_fetching = true;
  Map<String, dynamic>? args;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      Global.job = null;
      is_fetching = true;
      getJobs();
    });
  }

  void getJobs() {
    Global.noti = null;
    Helper.get(
        "nativeappservice/getNotificationList?contractor_id=${Helper.user?.companyId ?? ''}&process_id=${Helper.user?.processId ?? ''}",
        {}).then((response) {
      setState(() {
        is_fetching = false;
      });
      quotes = (json.decode(response.body) as List)
          .map((f) => Noti.Notification.fromJson(f))
          .toList();
      filtered.clear();
      filtered.addAll(quotes);

      // Check if args is not null before accessing it
      if (args != null && args!.containsKey('job_no')) {
        print('has key job no');
        // Uncomment and use the filter if needed
        // filterCtrl.text = args!['job_no'];
      } else {
        print('hasnt key job no');
      }

      print("type=${quotes.runtimeType}");
    }).catchError((error) {
      setState(() {
        is_fetching = false;
      });
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    Helper.bottom_nav_selected = 1;

    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Notifications", showNotification: false),
      body: Container(
        height: MediaQuery.of(context).size.height - 10,
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
                    },
                  ),
                ),
                controller: filterCtrl,
                onChanged: (text) {
                  if (text.isEmpty) {
                    filtered = [];
                    filtered.addAll(quotes);
                  } else {
                    filtered.clear();
                    quotes.forEach((job) {
                      if (job.summaryMessage!
                          .toLowerCase()
                          .contains(text.toLowerCase()) ||
                          job.notificationDetailMessage!
                              .toLowerCase()
                              .contains(text.toLowerCase())) filtered.add(job);
                    });
                  }
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 20,
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
              child: filtered.isNotEmpty
                  ? ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.white,
                    height: 20,
                  );
                },
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  var quote = filtered[index];
                  return GestureDetector(
                    onTap: () async {
                      Global.noti = quote;
                      await Navigator.pushNamed(
                          context, 'notification_data');
                      getJobs();
                    },
                    child: Container(
                      color: Themer.listEvenColor,
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                  'assets/images/${getDashBoardIcon(quote)}',
                                  //color: Themer.gridItemColor,
                                  colorFilter: ColorFilter.mode(Themer.gridItemColor, BlendMode.srcIn),
                                  height: 25,
                                ),
                              ),
                              Flexible(
                                child: RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: "${quote.summaryMessage}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(text: '  '),
                                      TextSpan(
                                        text:
                                        "${quote.notificationDetailMessage ?? ''}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  'No Notification Available',
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

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }

  String getDashBoardIcon(Noti.Notification job) {
    var type = job.workflowStepId;
    if (type == '1') return 'Accept-Icon.svg';
    if (type == '2') return 'Schedule-Icon.svg';
    if (type == '3' || type == '4' || type == '5') {
      return Helper.countryCode == "UK" ? "pound_symbol_white.svg" : 'Dollar-Quote.svg';
    }
    if (type == '6') return 'EnviroApproval.svg';
    if (type == '7') return 'ScheduleWork.svg';
    return 'SubmitInvoice.svg';
  }
}


// class NotificationListState extends State<NotificationList> {
//   var filterCtrl = TextEditingController();
//   var counter = 10;
//   List<Noti.Notification> quotes = [];
//   List<Noti.Notification> filtered = [];
//   bool is_fetching = true;
//   Map<String, dynamic>? args;
//   @override
//   void initState() {
//     Future.delayed(Duration.zero, () {
//       args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//       Global.job = null;
//       is_fetching = true;
//       getJobs();
//     });
//
//     super.initState();
//   }
//
//   void getJobs() {
//     Global.noti = null;
//     Helper.get(
//         "nativeappservice/getNotificationList?contractor_id=${Helper.user?.companyId??''}&process_id=${Helper.user?.processId??''}",
//         {}).then((response) {
//       setState(() {
//         is_fetching = false;
//       });
//       quotes = (json.decode(response.body) as List)
//           .map((f) => Noti.Notification.fromJson(f))
//           .toList();
//       filtered.clear();
//       filtered.addAll(quotes);
//       if (args!.containsKey('job_no')) {
//         print('has key job no');
//         //filterCtrl.text = args['job_no'];
//       } else {
//         print('hasnt key job no');
//       }
//
//       print("type=${quotes.runtimeType}");
//     }).catchError((error) {
//       setState(() {
//         is_fetching = false;
//       });
//       print(error);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Helper.bottom_nav_selected = 1;
//
//     return Scaffold(
//       appBar: Helper.getAppBar(context, title: "Notifications",showNotification: false),
//       body: Container(
//         height: MediaQuery.of(context).size.height - 10,
//         //margin: EdgeInsets.only(left: 15.0,right: 15.0),
//         color: Colors.white,
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: TextField(
//                 decoration: InputDecoration(
//                     hintText: "Search Job no, Site Address, Claim...",
//                     prefixIcon: Icon(Icons.search),
//                     suffixIcon: IconButton(
//                         icon: Icon(Icons.clear),
//                         onPressed: () {
//                           setState(() {
//                             filterCtrl.clear();
//                             filtered.addAll(quotes);
//                           });
//                         })),
//                 controller: filterCtrl,
//                 onChanged: (text) {
//                   if (text == '' || text == null || text.length == 0) {
//                     print('len zer');
//                     filtered = [];
//                     filtered.addAll(quotes);
//                   } else {
//                     filtered.clear();
//                     quotes.forEach((job) {
//                       if (job.summaryMessage!
//                               .toLowerCase()
//                               .contains(text.toLowerCase()) ||
//                           job.notificationDetailMessage!
//                               .toLowerCase()
//                               .contains(text.toLowerCase())) filtered.add(job);
//                     });
//                   }
//                   setState(() {});
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             is_fetching
//                 ? Center(
//                     child: Column(
//                       children: <Widget>[
//                         CircularProgressIndicator(
//                           backgroundColor: Colors.black,
//                         ),
//                         Text("Loading")
//                       ],
//                     ),
//                   )
//                 : Flexible(
//                     child: filtered.length != 0
//                         ? ListView.separated(
//                             separatorBuilder: (context, index) {
//                               return Divider(
//                                 color: Colors.white,
//                                 height: 20,
//                               );
//                             },
//                             itemCount: filtered == null ? 0 : filtered.length,
//                             itemBuilder: (context, index) {
//                               var quote = filtered[index];
//                               return GestureDetector(
//                                 onTap: () async {
//                                   Global.noti = quote;
//                                   await Navigator.pushNamed(
//                                       context, 'notification_data');
//                                   getJobs();
//                                 },
//                                 child: Container(
//                                   color: Themer.listEvenColor,
//                                   child: SizedBox(
//                                       height: 60,
//                                       width: MediaQuery.of(context).size.width,
//                                       child: Container(
//                                         padding:
//                                             EdgeInsets.fromLTRB(15, 5, 15, 5),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: <Widget>[
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   right: 10),
//                                               child: SvgPicture.asset(
//                                                 'assets/images/${getDashBoardIcon(quote)}',
//                                                 color: Themer.gridItemColor,
//                                                 height: 25,
//                                               ),
//                                             ),
//                                             Flexible(
//                                               child: RichText(
//                                                 maxLines: 2,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 text: TextSpan(
//                                                     text:
//                                                         "${quote.summaryMessage}",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                     children: [
//                                                       TextSpan(text: '  '),
//                                                       TextSpan(
//                                                           text:
//                                                               "${quote.notificationDetailMessage ?? 'aaaaaa aaaaaaaaa aaaaaaaaaaaaa bbbbbb bbbbb bbbbbb\nasasasa sadsfsdf sfasasf gbgftnty'}",
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal))
//                                                     ]),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       )),
//                                 ),
//                               );
//                             },
//                           )
//                         : Center(
//                             child: Text(
//                               'No Notification Available',
//                               style: TextStyle(fontSize: 20),
//                             ),
//                           ),
//                   )
//           ],
//         ),
//       ),
//       bottomNavigationBar: Helper.getBottomBar(bottomClick),
//     );
//   }
//
//   void bottomClick(int index) {
//     Helper.bottomClickAction(index, context);
//   }
//
//   String getDashBoardIcon(Noti.Notification job) {
//     var type = job.workflowStepId;
//     if (type == '1')
//       return 'Accept-Icon.svg';
//     else if (type == '2')
//       return 'Schedule-Icon.svg';
//     else if (type == '3' || type == '4' || type == '5')
//       return Helper.countryCode == "UK"
//           ? "pound_symbol_white.svg"
//           : 'Dollar-Quote.svg';
//     else if (type == '6')
//       return 'EnviroApproval.svg';
//     else if (type == '7')
//       return 'ScheduleWork.svg';
//     else
//       return 'SubmitInvoice.svg';
//   }
// }
