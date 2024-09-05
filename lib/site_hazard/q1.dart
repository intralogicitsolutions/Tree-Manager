import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class Q1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Q1State();
  }
}

class Q1State extends State<Q1> {
  Map<String, dynamic>? args;
  var selected1 = null;
  var selected2 = null;
  var selected3 = null;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args!['from'] == 1 && args!['from_review'] != true) {
          Global.hzd_sel_answr = [];
        }
        try {
          var tmp = Global.hzd_sel_answr;
          selected1 = tmp?[args!['from'] - 1];
          selected2 = tmp?[args!['from']];
          selected3 = tmp?[args!['from'] + 1];
        } catch (e) {}
        print('name==>${ Global.hzd_qstn!.isNotEmpty
            ? Global.hzd_qstn![args?['from'] != null && args!['from'] > 0 ? args!['from'] - 1 : 0].caption ?? ''
            : ''}');
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var grids = [
      {"label": "YES", "value": '1'},
      {"label": "NO", "value": '2'},
      {"label": "NA", "value": '3'},
    ];


    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: "Questionaire", sub_title: 'Job TM# ${Global.job?.jobNo}'),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: SingleChildScrollView(
              child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      //Global.hzd_qstn?[args?['from'] - 1].caption??'',
                      Global.hzd_qstn!.isNotEmpty
                          ? Global.hzd_qstn![args?['from'] != null && args!['from'] > 0 ? args!['from'] - 1 : 0].caption ?? ''
                          : '',
                      // Global.hzd_qstn?[(args?['from'] != null ? args!['from'] - 1 : 0)].caption ?? '',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: ScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            var item = grids[index];
                            var value = item['value'];
                            return GestureDetector(
                              child: Container(
                                height: 80,
                                width: 80,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: selected1 == value
                                        ? Themer.treeInfoGridItemColor
                                        : Colors.white,
                                    border: Border.all(
                                        color: Themer.textGreenColor,
                                        width: 1)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      item['label'] ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: selected1 == value
                                              ? Colors.white
                                              : Themer.textGreenColor),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selected1 = value;
                                });
                              },
                            );
                          }),
                    ),
                    Text(
                     // Global.hzd_qstn![args!['from']].caption??'',
                      args != null && args!['from'] != null  && Global.hzd_qstn!.length > args!['from']
                          ? Global.hzd_qstn![args!['from']].caption ?? ''
                          : '',
                      // args != null && args?['from'] != null
                      //     ? Global.hzd_qstn![args?['from']].caption ?? ''
                      //     : '',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: ScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            var item = grids[index];
                            var value = item['value'];
                            return GestureDetector(
                              child: Container(
                                height: 80,
                                width: 80,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: selected2 == value
                                        ? Themer.treeInfoGridItemColor
                                        : Colors.white,
                                    border: Border.all(
                                        color: Themer.textGreenColor,
                                        width: 1)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      item['label']??'',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: selected2 == value
                                              ? Colors.white
                                              : Themer.textGreenColor),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selected2 = value;
                                });
                              },
                            );
                          }),
                    ),
                    Text(
                      //Global.hzd_qstn![args!['from'] + 1].caption??'',
                      args != null && args!['from'] != null &&  args!['from'] + 1 < Global.hzd_qstn!.length
                          ? Global.hzd_qstn![args!['from'] + 1].caption ?? ''
                          : '',
                      // args != null && args?['from'] != null && args?['from'] + 1 < Global.hzd_qstn?.length
                      //     ? Global.hzd_qstn![args?['from'] + 1].caption ?? ''
                      //     : 'Default Caption',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: ScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            var item = grids[index];
                            var value = item['value'];
                            return GestureDetector(
                              child: Container(
                                height: 80,
                                width: 80,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: selected3 == value
                                        ? Themer.treeInfoGridItemColor
                                        : Colors.white,
                                    border: Border.all(
                                        color: Themer.textGreenColor,
                                        width: 1)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      item['label']??'',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: selected3 == value
                                              ? Colors.white
                                              : Themer.textGreenColor),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selected3 = value;
                                });
                              },
                            );
                          }),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      mini: false,
                      backgroundColor: Themer.textGreenColor,
                      child:
                          SvgPicture.asset('assets/images/continue_button.svg'),
                      onPressed: () {
                        print('args $args');
                        if (selected1 != null &&
                            selected2 != null &&
                            selected3 != null) {
                          if (args!['from'] == 1) {
                            if (args!['from_review'] == true) {
                              Global.hzd_sel_answr?[0] = selected1;
                              Global.hzd_sel_answr?[1] = selected2;
                              Global.hzd_sel_answr?[2] = selected3;
                            } else {
                              Global.hzd_sel_answr?.add(selected1);
                              Global.hzd_sel_answr?.add(selected2);
                              Global.hzd_sel_answr?.add(selected3);
                            }
                          } else {
                            if (args!['from_review'] == true) {
                              Global.hzd_sel_answr?[3] = selected1;
                              Global.hzd_sel_answr?[4] = selected2;
                              Global.hzd_sel_answr?[5] = selected3;
                            } else {
                              Global.hzd_sel_answr?.add(selected1);
                              Global.hzd_sel_answr?.add(selected2);
                              Global.hzd_sel_answr?.add(selected3);
                            }
                          }
                          if (args!['from'] == 4) {
                            if (args!['from_review'] == true) {
                              Navigator.popUntil(context,
                                  ModalRoute.withName('hazard_review'));
                            } else {
                              Navigator.pushNamed(context, 'thing', arguments: {
                                'index': 0,
                                'from_review': args!['from_review']
                              });
                            }
                          } else {
                            Navigator.of(context).pushNamed('q1', arguments: {
                              'from': 4,
                              'from_review': args!['from_review']
                            });
                          }
                        } else
                          Toast.show('Please select any item',
                              //textStyle: context,
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                      },
                      heroTag: 'continue',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('CONTINUE',
                        style: TextStyle(color: Themer.textGreenColor))
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

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
