// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:toast/toast.dart';
// import 'package:tree_manager/helper/Global.dart';
// import 'package:tree_manager/helper/helper.dart';
// import 'package:tree_manager/helper/theme.dart';
// import 'package:tree_manager/pojo/option.dart';
//
// class Thing extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return ThingState();
//   }
// }
//
// class ThingState extends State<Thing> {
//   var selected = <Option>[];
//   var selectedOther = <Option>[];
//   var grids = <Option>[];
//   Map<String, dynamic>? args;
//   Map<String, dynamic>? data;
//
//   @override
//   void initState() {
//     Future.delayed(Duration.zero, () {
//       setState(() {
//         args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//         print('Index==>${args?['index']??''}');
//         switch (args?['index']) {
//           case 0:
//             selected = Global.sel_w_task!;
//             grids = Global.w_task!;
//             selectedOther = Global.sel_w_other_task!;
//             print('==>${jsonEncode(Global.w_task)}');
//             print('==>${jsonEncode(Global.sel_w_task)}');
//             break;
//           case 1:
//             selected = Global.sel_j_task!;
//             grids = Global.j_task!;
//             selectedOther = Global.sel_j_other_task!;
//             print('==>${jsonEncode(Global.j_task)}');
//             print('==>${jsonEncode(Global.sel_j_task)}');
//             break;
//           case 2:
//             selected = Global.sel_t_task!;
//             grids = Global.t_task!;
//             selectedOther = Global.sel_t_other_task!;
//             print('==>${jsonEncode(Global.t_task)}');
//             print('==>${jsonEncode(Global.sel_t_task)}');
//             break;
//           case 3:
//             selected = Global.sel_m_task!;
//             grids = Global.m_task!;
//             selectedOther = Global.sel_m_other_task!;
//             print('==>${jsonEncode(Global.m_task)}');
//             print('==>${jsonEncode(Global.sel_m_task)}');
//             break;
//           default:
//         }
//
//         data = Global.hzd_triplet[args!['index']];
//         // print('tasks==>${jsonEncode(data)}');
//         // grids = data['task'];
//       });
//     });
//     try {} catch (e) {}
//     print(json.encode(selected));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Helper.getAppBar(context,
//           title: data?['task_title']??'', sub_title: 'Job TM# ${Global.job?.jobNo}'),
//       bottomNavigationBar: Helper.getBottomBar(bottomClick),
//       body: SingleChildScrollView(
//               child: Container(
//             color: Colors.white,
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 SingleChildScrollView(
//                   child: Column(
//                     children: <Widget>[
//                       Text(
//                         data?['task_sub_title']??'',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       Text(
//                         (() {
//                           var tmp =
//                               selectedOther.map((e) => e.caption).toList();
//                           tmp.addAll(selected.map((e) => e.caption).toList());
//                           return '(${tmp.join(',')})';
//                         }()),
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Themer.textGreenColor,
//                           fontFamily: 'OpenSans',
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         height: MediaQuery.of(context).size.height*0.50,
//                         child: GridView.count(
//                             shrinkWrap: true,
//                             scrollDirection: Axis.vertical,
//                             physics: ScrollPhysics(),
//                             childAspectRatio: 4 / 2.5,
//                             crossAxisCount: 2,
//                             children: List.generate(grids.length, (index) {
//                               print('length---->${grids.length}');
//                               var item = grids[index];
//                               var value = item.id;
//                               return GestureDetector(
//                                 child: Container(
//                                   margin: EdgeInsets.all(0.5),
//                                   decoration: BoxDecoration(
//                                       color: containsThis(item)
//                                           ? Themer.treeInfoGridItemColor
//                                           : Colors.white,
//                                       border: Border.all(
//                                           color: Themer.textGreenColor,
//                                           width: 1)),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         item.caption??'',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             color: containsThis(item)
//                                                 ? Colors.white
//                                                 : Themer.textGreenColor),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 onTap: () {
//                                   setState(() {
//                                     if (containsThis(item))
//                                       selected.remove(item);
//                                     else
//                                       selected.add(item);
//                                   });
//                                 },
//                               );
//                             })),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20,),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             Container(
//                               margin: EdgeInsets.only(bottom: 10),
//                               height: 60,
//                               width: 60,
//                               // child: FloatingActionButton(
//                               //   heroTag: 'add_other',
//                               //   child: SvgPicture.asset(
//                               //       'assets/images/add_other_button.svg'),
//                               //   onPressed: () async {
//                               //     var sel = await Navigator.pushNamed(
//                               //         context, 'add_others', arguments: {
//                               //       'selected': selectedOther,
//                               //       'label': data!['task_sub_title']
//                               //     }) as List<Option>;
//                               //     setState(() {
//                               //       selectedOther = sel;
//                               //       selectedOther.forEach((element) {
//                               //         print('object ${element.caption}');
//                               //       });
//                               //     });
//                               //                                   },
//                               // ),
//                               child: FloatingActionButton(
//                                 heroTag: 'add_other',
//                                 child: SvgPicture.asset('assets/images/add_other_button.svg'),
//                                 onPressed: () async {
//                                   var result = await Navigator.pushNamed(
//                                     context,
//                                     'add_others',
//                                     arguments: {
//                                       'selected': selectedOther,
//                                       'label': data!['task_sub_title'],
//                                     },
//                                   );
//
//                                   // Check if the result is not null before casting
//                                   if (result != null) {
//                                     var sel = result as List<Option>;
//                                     setState(() {
//                                       selectedOther = sel;
//                                       selectedOther.forEach((element) {
//                                         print('object ${element.caption}');
//                                       });
//                                     });
//                                   } else {
//                                     // Handle the case where result is null (optional)
//                                     print('No options selected');
//                                   }
//                                 },
//                               ),
//
//                             ),
//                             Text(
//                               "ADD OTHER",
//                               style: TextStyle(color: Themer.textGreenColor),
//                             )
//                           ],
//                         ),
//                         Column(
//                           children: <Widget>[
//                             Container(
//                               margin: EdgeInsets.only(bottom: 10),
//                               height: 60,
//                               width: 60,
//                               child: FloatingActionButton(
//                                 mini: false,
//                                 backgroundColor: Themer.textGreenColor,
//                                 child: SvgPicture.asset(
//                                     'assets/images/continue_button.svg'),
//                                 onPressed: () async {
//                                   if (selected.length > 0 ||
//                                       selectedOther.length > 0) {
//                                     switch (args!['index']) {
//                                       case 0:
//                                         Global.sel_w_task = selected;
//                                         Global.sel_w_other_task =
//                                             selectedOther;
//                                         break;
//                                       case 1:
//                                         Global.sel_j_task = selected;
//                                         Global.sel_j_other_task =
//                                             selectedOther;
//                                         break;
//                                       case 2:
//                                         Global.sel_t_task = selected;
//                                         Global.sel_t_other_task =
//                                             selectedOther;
//                                         break;
//                                       case 3:
//                                         Global.sel_m_task = selected;
//                                         Global.sel_m_other_task =
//                                             selectedOther;
//                                         break;
//                                       default:
//                                     }
//                                     Navigator.of(context).pushNamed(
//                                         'thing_rate',
//                                         arguments: args);
//                                   } else
//                                     Toast.show(
//                                         'Please select any item',
//                                         //textStyle: context,
//                                         duration: Toast.lengthLong,
//                                         gravity: Toast.center);
//                                 },
//                                 heroTag: 'continue',
//                               ),
//                             ),
//                             Text('CONTINUE',
//                                 style:
//                                     TextStyle(color: Themer.textGreenColor))
//                           ],
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 )
//               ],
//             )),
//       ),
//     );
//   }
//
//   bool containsThis(Option item) {
//     if (selected.contains(item))
//       return true;
//     else {
//       var index = selected.indexWhere((element) => element.id == item.id);
//       if (index >= 0) {
//         selected[index] = item;
//         return true;
//       } else
//         return false;
//     }
//   }
//
//   void bottomClick(int index) {
//     Helper.bottomClickAction(index, context, setState);
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/option.dart';

class Thing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ThingState();
  }
}

class ThingState extends State<Thing> {
  var selected = <Option>[];
  var selectedOther = <Option>[];
  var grids = <Option>[];
  Map<String, dynamic>? args;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        print('Index==>${args?['index'] ?? ''}');
        if (args == null) {
          print('Arguments are null');
          return;
        }

        switch (args?['index']) {
          case 0:
            selected = Global.sel_w_task ?? [];
            grids = Global.w_task ?? [];
            selectedOther = Global.sel_w_other_task ?? [];
            break;
          case 1:
            selected = Global.sel_j_task ?? [];
            grids = Global.j_task ?? [];
            selectedOther = Global.sel_j_other_task ?? [];
            break;
          case 2:
            selected = Global.sel_t_task ?? [];
            grids = Global.t_task ?? [];
            selectedOther = Global.sel_t_other_task ?? [];
            break;
          case 3:
            selected = Global.sel_m_task ?? [];
            grids = Global.m_task ?? [];
            selectedOther = Global.sel_m_other_task ?? [];
            break;
          default:
            print('Invalid index: ${args?['index']}');
        }

        data = Global.hzd_triplet[args!['index']];
        print('Grids length after initialization: ${grids.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: data?['task_title'] ?? '', sub_title: 'Job TM# ${Global.job?.jobNo}'),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      data?['task_sub_title'] ?? '',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      (() {
                        var tmp = selectedOther.map((e) => e.caption).toList();
                        tmp.addAll(selected.map((e) => e.caption).toList());
                        return '(${tmp.join(', ')})';
                      }()),
                      style: TextStyle(
                        fontSize: 12,
                        color: Themer.textGreenColor,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.50,
                      child: grids.isNotEmpty
                          ? GridView.count(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        childAspectRatio: 4 / 2.5,
                        crossAxisCount: 2,
                        children: List.generate(grids.length, (index) {
                          print('Building grid item $index with length ${grids.length}');
                          var item = grids[index];
                          return GestureDetector(
                            child: Container(
                              margin: EdgeInsets.all(0.5),
                              decoration: BoxDecoration(
                                color: containsThis(item)
                                    ? Themer.treeInfoGridItemColor
                                    : Colors.white,
                                border: Border.all(
                                    color: Themer.textGreenColor,
                                    width: 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    item.caption ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: containsThis(item)
                                          ? Colors.white
                                          : Themer.textGreenColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (containsThis(item))
                                  selected.remove(item);
                                else
                                  selected.add(item);
                              });
                            },
                          );
                        }),
                      )
                          : Center(
                        child: Text('No items available'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 60,
                            width: 60,
                            child: FloatingActionButton(
                              heroTag: 'add_other',
                              child: SvgPicture.asset(
                                  'assets/images/add_other_button.svg'),
                              onPressed: () async {
                                var result = await Navigator.pushNamed(
                                  context,
                                  'add_others',
                                  arguments: {
                                    'selected': selectedOther,
                                    'label': data!['task_sub_title'],
                                  },
                                );

                                if (result != null) {
                                  var sel = result as List<Option>;
                                  setState(() {
                                    selectedOther = sel;
                                  });
                                } else {
                                  print('No options selected');
                                }
                              },
                            ),
                          ),
                          Text("ADD OTHER", style: TextStyle(color: Themer.textGreenColor))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 60,
                            width: 60,
                            child: FloatingActionButton(
                              backgroundColor: Themer.textGreenColor,
                              child: SvgPicture.asset(
                                  'assets/images/continue_button.svg'),
                              onPressed: () async {
                                ToastContext().init(context);
                                if (selected.isNotEmpty || selectedOther.isNotEmpty) {
                                  switch (args!['index']) {
                                    case 0:
                                      Global.sel_w_task = selected;
                                      Global.sel_w_other_task = selectedOther;
                                      break;
                                    case 1:
                                      Global.sel_j_task = selected;
                                      Global.sel_j_other_task = selectedOther;
                                      break;
                                    case 2:
                                      Global.sel_t_task = selected;
                                      Global.sel_t_other_task = selectedOther;
                                      break;
                                    case 3:
                                      Global.sel_m_task = selected;
                                      Global.sel_m_other_task = selectedOther;
                                      break;
                                    default:
                                  }
                                  Navigator.of(context).pushNamed('thing_rate', arguments: args);
                                } else {
                                  Toast.show(
                                    'Please select any item',
                                    duration: Toast.lengthLong,
                                    gravity: Toast.center,
                                  );
                                }
                              },
                              heroTag: 'continue',
                            ),
                          ),
                          Text('CONTINUE', style: TextStyle(color: Themer.textGreenColor))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  bool containsThis(Option item) {
    if (selected.contains(item))
      return true;
    else {
      var index = selected.indexWhere((element) => element.id == item.id);
      if (index >= 0) {
        selected[index] = item;
        return true;
      } else
        return false;
    }
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
