import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/option.dart';

class ThingControl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ThingControlState();
  }
}

class ThingControlState extends State<ThingControl> {
  var selected = <Option>[];
  var selectedOther = <Option>[];
  var grids = <Option>[];

  Map<String, dynamic>? args;
  Map<String, dynamic>? data;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        switch (args!['index']) {
          case 0:
            selected = Global.sel_w_ctrl;
            grids = Global.w_ctrl;
            selectedOther = Global.sel_w_other_ctrl ?? [];
            break;
          case 1:
            selected = Global.sel_j_ctrl;
            grids = Global.j_ctrl;
            selectedOther = Global.sel_j_other_ctrl ?? [];
            break;
          case 2:
            selected = Global.sel_t_ctrl;
            grids = Global.t_ctrl;
            selectedOther = Global.sel_t_other_ctrl ?? [];
            break;
          case 3:
            selected = Global.sel_m_ctrl;
            grids = Global.m_ctrl;
            selectedOther = Global.sel_m_other_ctrl ?? [];
            break;
          default:
        }
        print('ctrl==>${jsonEncode(selected)}');
        // print('Index==>${args['index']}');
        data = Global.hzd_triplet[args!['index']];
        // grids = data['ctrl'];
      });
    });
    try {} catch (e) {}
    print(json.encode(selected));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: data!['ctrl_title'], sub_title: 'Job TM# ${Global.job?.jobNo}'),
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
                        data!['ctrl_sub_title'],
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        (() {
                          var tmp =
                              selectedOther.map((e) => e.caption).toList();
                          tmp.addAll(selected.map((e) => e.caption).toList());
                          return '(${tmp.join(',')})';
                        }()),
                        style: TextStyle(
                          fontSize: 12,
                          color: Themer.textGreenColor,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: GridView.count(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            childAspectRatio: 4 / 2.5,
                            crossAxisCount: 2,
                            children: List.generate(grids.length, (index) {
                              var item = grids[index];
                              var value = item.id;
                              return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.all(0.5),
                                  decoration: BoxDecoration(
                                      color: containsThis(item)
                                          ? Themer.treeInfoGridItemColor
                                          : Colors.white,
                                      border: Border.all(
                                          color: Themer.textGreenColor,
                                          width: 1)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        item.caption??'',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: containsThis(item)
                                                ? Colors.white
                                                : Themer.textGreenColor),
                                      )
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
                            })),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
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
                                  var sel = await Navigator.pushNamed(
                                      context, 'add_others', arguments: {
                                    'selected': selectedOther,
                                    'label': data!['task_sub_title']
                                  }) as List<Option>;
                                  setState(() {
                                    selectedOther = sel;
                                    selectedOther.forEach((element) {
                                      print('object ${element.caption}');
                                    });
                                                                    });
                                },
                              ),
                            ),
                            Text(
                              "ADD OTHER",
                              style: TextStyle(color: Themer.textGreenColor),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 60,
                              width: 60,
                              child: FloatingActionButton(
                                mini: false,
                                backgroundColor: Themer.textGreenColor,
                                child: SvgPicture.asset(
                                    'assets/images/continue_button.svg'),
                                onPressed: () {
                                  if (selected.length > 0 ||
                                      selectedOther.length > 0) {
                                    switch (args!['index']) {
                                      case 0:
                                        Global.sel_w_ctrl = selected;
                                        Global.sel_w_other_ctrl = selectedOther;
                                        break;
                                      case 1:
                                        Global.sel_j_ctrl = selected;
                                        Global.sel_j_other_ctrl = selectedOther;
                                        break;
                                      case 2:
                                        Global.sel_t_ctrl = selected;
                                        Global.sel_t_other_ctrl = selectedOther;
                                        break;
                                      case 3:
                                        Global.sel_m_ctrl = selected;
                                        Global.sel_m_other_ctrl = selectedOther;
                                        break;
                                      default:
                                    }
                                    if (args!['from_review'] == true) {
                                      Navigator.popUntil(context,
                                          ModalRoute.withName('hazard_review'));
                                    } else {
                                      if (args!['index'] < 3) {
                                        Navigator.pushNamed(context, 'thing',
                                            arguments: {
                                              'index': args!['index'] + 1,
                                              'from_review': args!['from_review']
                                            });
                                      } else {
                                        Navigator.pushNamed(
                                            context, 'staff_sign_grid',
                                            arguments: {
                                              'from_review': args!['from_review']
                                            });
                                      }
                                    }
                                  } else
                                    Toast.show(
                                        'Please select any Control ',
                                        //textStyle: context,
                                        duration: Toast.lengthLong,
                                        gravity: Toast.center);
                                },
                                heroTag: 'continue',
                              ),
                            ),
                            Text('CONTINUE',
                                style: TextStyle(color: Themer.textGreenColor))
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            )),
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
    Helper.bottomClickAction(index, context);
  }
}
