import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Staff.dart';
// import 'package:velocity_x/velocity_x.dart';

class StaffSignGrid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StaffSignGridState();
  }
}

class StaffSignGridState extends State<StaffSignGrid> {
  var selected = <String>[];
  var selected_staff = <Staff>[];
  var grids = <Staff>[];
  Map<String, dynamic>? args;

  @override
  void initState() {
    grids = Global.hzd_sel_staff;
    grids.addAll(Global.hzd_sel_other_staff);
    selected_staff.addAll(grids);
    try {} catch (e) {}
    print(json.encode(selected));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    print('args==>$args');

    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: "Confirmation", sub_title: 'Job TM# ${Global.job!.jobNo}'),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Staff Sign-Off',
                      style: TextStyle(fontSize: 20),
                    ),
                    Scrollbar(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.50,
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
                                      color: item.signed ==
                                              true //selected.contains(value)
                                          ? Themer.treeInfoGridItemColor
                                          : Colors.white,
                                      border: Border.all(
                                          color: Themer.textGreenColor,
                                          width: 1)),
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        // child:
                                        //     '${item.firstName} ${item.lastName}'
                                        //         .text
                                        //         .color(item.signed == true
                                        //             ? Colors.white
                                        //             : Themer.textGreenColor)
                                        //         .semiBold
                                        //         .fontFamily('OpenSans')
                                        //         .make()
                                        //         .pOnly(bottom: 10, left: 10),
                                        alignment: Alignment.bottomLeft,
                                      ),
                                      Center(
                                        child: SvgPicture.asset(
                                          item.signed == true
                                              ? 'assets/images/done.svg'
                                              : 'assets/images/signing-a-document.svg',
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  var stf = await Navigator.pushNamed(
                                      context, 'sign_off_hazard',
                                      arguments: item);
                                  setState(() {
                                    if (stf != null && stf is Staff) {
                                      selected.add(value??'');
                                      selected_staff.add(stf);
                                    }
                                  });
                                },
                              );
                            })),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    if (args!['from_review'] == false && 1 == 2)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                            mini: false,
                            backgroundColor: Themer.textGreenColor,
                            child: SvgPicture.asset(
                                'assets/images/submit_button.svg'),
                            onPressed: () {},
                            heroTag: 'submit',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('SUBMIT',
                              style: TextStyle(color: Themer.textGreenColor))
                        ],
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                          mini: false,
                          backgroundColor: Themer.textGreenColor,
                          child: SvgPicture.asset('assets/images/change.svg'),
                          onPressed: () {
                            print('asdf ${selected_staff.length}');
                            selected_staff.forEach((element) {
                              print(
                                  'ass ${element.checked} ${element.signed} ${element.rev_checked}');
                            });
                            var unsigned_length = selected_staff
                                .where((element) => element.signed == false)
                                .length;

                            print('unsi len=$unsigned_length');
                            if (unsigned_length == 0) {
                              Global.hzd_sel_staff = selected_staff
                                  .where((element) => element.id != null)
                                  .toSet()
                                  .toList();
                              Global.hzd_sel_other_staff = selected_staff
                                  .where((element) => element.id == null)
                                  .toSet()
                                  .toList();
                              if (args!['from_review'] == true)
                                Navigator.pop(context);
                              else
                                Navigator.pushNamed(context, 'hazard_review');
                            } else
                              Toast.show(
                                  'Please get sign from all staffs',
                                  //textStyle: context,
                                  duration: Toast.lengthLong,
                                  gravity: Toast.center);
                          },
                          heroTag: 'review',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('REVIEW',
                            style: TextStyle(color: Themer.textGreenColor))
                      ],
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
