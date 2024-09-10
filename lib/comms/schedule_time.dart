// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tree_manager/helper/Global.dart';
// import 'package:tree_manager/helper/helper.dart';
// import 'package:tree_manager/helper/theme.dart';
// import 'package:tree_manager/main.dart';
//
// class ScheduleTime extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return ScheduleTimeState();
//   }
// }
//
// class ScheduleTimeState extends State<ScheduleTime> {
//   var args;
//   int selected_hour = 1;
//   int selected_minute = 00;
//   var is_am = true;
//   late DateTime date;
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     args=ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
//     date=args['date'];
//     return Scaffold(
//       bottomNavigationBar: Helper.getBottomBar(bottomClick),
//       appBar: Helper.getAppBar(context, title: "Schedule Time", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
//       body: Stack(
//         children: <Widget>[
//           Center(
//             child: Visibility(
//               child: Image.asset(
//                 'assets/images/background_image.png',
//                 width: size.width,
//                 height: size.height,
//                 fit: BoxFit.cover,
//               ),
//               visible: false,
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(color: Colors.white),
//             padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
//             width: size.width,
//             height: size.height,
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   'Hours',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'OpenSans'),
//                 ),
//                 GridView.count(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 40,
//                   mainAxisSpacing: 15,
//                   shrinkWrap: true,
//                   //childAspectRatio: 1 / 1,
//                   children: List.generate(12, (index) {
//                     return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selected_hour = index;
//                           });
//                         },
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: selected_hour == index
//                                     ? Themer.textGreenColor
//                                     : Colors.white),
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 '${index + 1}',
//                                 style: TextStyle(
//                                     color: selected_hour == index
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 20,
//                                     fontFamily: 'OpenSans'),
//                               ),
//                             )));
//                   }),
//                 ),
//                 Text(
//                   'Minutes',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'OpenSans'),
//                 ),
//                 GridView.count(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 40,
//                   mainAxisSpacing: 20,
//                   shrinkWrap: true,
//                   //childAspectRatio: 1 / 1,
//                   children: List.generate(4, (index) {
//                     return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selected_minute = index * 15;
//                           });
//                         },
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: selected_minute == (index * 15)
//                                     ? Themer.textGreenColor
//                                     : Colors.white),
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 '${(index * 15).toString().padRight(2,'0')}',
//                                 style: TextStyle(
//                                     color: selected_minute == index * 15
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 20,
//                                     fontFamily: 'OpenSans'),
//                               ),
//                             )));
//                   }),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           is_am = true;
//                         });
//                       },
//                       child: Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: is_am == true ? Themer.textGreenColor : Colors.white,
//                           border: Border.all(width: 1, color: Themer.textGreenColor),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Align(
//                           child: Text(
//                             'AM',
//                             style: TextStyle(
//                               color: is_am ? Colors.white : Colors.black,
//                             ),
//                           ),
//                           alignment: Alignment.center,
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           is_am = false;
//                         });
//                       },
//                       child: Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: is_am == false ? Themer.textGreenColor : Colors.white,
//                           border: Border.all(width: 1, color: Themer.textGreenColor),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Align(
//                           child: Text(
//                             'PM',
//                             style: TextStyle(
//                               color:
//                                   is_am == false ? Colors.white : Colors.black,
//                             ),
//                           ),
//                           alignment: Alignment.center,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Container(
//                         height: 60.0,
//                         width: 60.0,
//                         margin: EdgeInsets.only(bottom: 10.0, top: 30),
//                         child: FittedBox(
//                           child: FloatingActionButton(
//                               heroTag: 'continue',
//                               child: SvgPicture.asset(
//                                   'assets/images/continue_button.svg'),
//                               onPressed: () {
//                                 print('goto==>${args['goto']}');
//                                 Navigator.of(context).pushNamed('confirm_schedule',arguments: {"date":date,"hour":selected_hour+1,"minute":selected_minute,"am_pm":is_am?'AM':'PM',
//                                 'msg_flow':args['msg_flow'],'comm_reci':args['comm_reci'],'visit_type':args['visit_type'],'goto':args['goto']});
//                               }),
//                         )),
//                     Text(
//                       "CONTINUE",
//                       style: TextStyle(color: Themer.textGreenColor),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   void bottomClick(int index) {
//
//     Helper.bottomClickAction(index, context);
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class ScheduleTime extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleTimeState();
  }
}

class ScheduleTimeState extends State<ScheduleTime> {
  //var args;
  Map<String, dynamic>? args;
  int selectedHour = 1;
  int selectedMinute = 0;
  bool isAM = true;
  late DateTime date;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedHour = prefs.getInt('selectedHour') ?? 1;
      selectedMinute = prefs.getInt('selectedMinute') ?? 0;
      isAM = prefs.getBool('isAM') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedHour', selectedHour);
    await prefs.setInt('selectedMinute', selectedMinute);
    await prefs.setBool('isAM', isAM);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    date = args!['date'];

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(
          context,
          title: "Schedule Time",
          sub_title: 'Job TM# ${Global.job?.jobNo ?? ''}'),
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
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Hours',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'OpenSans'),
                ),
                GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 15,
                  shrinkWrap: true,
                  children: List.generate(12, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedHour = index + 1;
                        });
                        _savePreferences();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedHour == (index + 1)
                              ? Themer.textGreenColor
                              : Colors.white,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                                color: selectedHour == (index + 1)
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Text(
                  'Minutes',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'OpenSans'),
                ),
                GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  children: List.generate(4, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMinute = index * 15;
                        });
                        _savePreferences();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedMinute == (index * 15)
                              ? Themer.textGreenColor
                              : Colors.white,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${(index * 15).toString().padLeft(2, '0')}',
                            style: TextStyle(
                                color: selectedMinute == (index * 15)
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAM = true;
                        });
                        _savePreferences();
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isAM ? Themer.textGreenColor : Colors.white,
                          border: Border.all(width: 1, color: Themer.textGreenColor),
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          child: Text(
                            'AM',
                            style: TextStyle(
                              color: isAM ? Colors.white : Colors.black,
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAM = false;
                        });
                        _savePreferences();
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: !isAM ? Themer.textGreenColor : Colors.white,
                          border: Border.all(width: 1, color: Themer.textGreenColor),
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          child: Text(
                            'PM',
                            style: TextStyle(
                              color: !isAM ? Colors.white : Colors.black,
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 60.0,
                      width: 60.0,
                      margin: EdgeInsets.only(bottom: 10.0, top: 30),
                      child: FittedBox(
                        child: FloatingActionButton(
                            heroTag: 'continue',
                            child: SvgPicture.asset('assets/images/continue_button.svg'),
                            onPressed: () {
                              print('goto==>${args!['goto']}');
                              Navigator.of(context).pushNamed('confirm_schedule', arguments: {
                                "date": date,
                                "hour": selectedHour,
                                "minute": selectedMinute,
                                "am_pm": isAM ? 'AM' : 'PM',
                                'msg_flow': args!['msg_flow'],
                                'comm_reci': args!['comm_reci'],
                                'visit_type': args!['visit_type'],
                                'goto': args!['goto']
                              });
                            }
                        ),
                      ),
                    ),
                    Text(
                      "CONTINUE",
                      style: TextStyle(color: Themer.textGreenColor),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
