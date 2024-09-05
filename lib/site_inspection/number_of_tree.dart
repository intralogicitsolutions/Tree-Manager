import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class NumberOfTrees extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NumberOfTreesState();
  }
}

class NumberOfTreesState extends State<NumberOfTrees> {
  int count = 1;
  @override
  void initState() {
    print('==>Info==>' + json.encode(Global.info));
    try {
      if (Global.site_info_update == true)
        count = int.parse(Global.info!.noTree??'');
    } catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "Number of Trees", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
      body: Stack(
        children: <Widget>[
          Align(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    height: 60.0,
                    width: 60.0,
                    margin: EdgeInsets.only(bottom: 10.0, top: 30),
                    child: FittedBox(
                      child: FloatingActionButton(
                          heroTag: 'continue',
                          child: SvgPicture.asset(
                            "assets/images/continue_button.svg",
                            height: 60,
                            width: 60,
                          ),
                          onPressed: () {
                            if (count != 0) {
                              Global.info!.noTree = count.toString();
                              Global.info!.jobNo = Global.job?.jobNo??'';
                              Global.info!.jobId = Global.job?.jobId??'';
                              Global.info!.jobAllocId = Global.job?.jobAllocId??'';
                              Navigator.of(context).pushNamed('tree_height');
                            }
                            else
                              Toast.show('please select any item',
                                  //textStyle: context,
                              gravity: Toast.center,
                              duration: Toast.lengthLong,
                              backgroundColor: Themer.textGreenColor);
                          })
                    )),
                Text(
                  "CONTINUE",
                  style: TextStyle(color: Themer.textGreenColor),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            alignment: Alignment.bottomCenter,
          ),
          Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$count',
                style: TextStyle(
                    color: Themer.textGreenColor,
                    fontSize: 110,
                    fontFamily: 'OpenSans'),
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
                                heroTag: 'minus',
                                child: SvgPicture.asset(
                                  "assets/images/minus_button.svg",
                                  height: 60,
                                  width: 60,
                                ),
                                onPressed: () {
                                  if (count > 0) {
                                    setState(() {
                                      count--;
                                    });
                                  }
                                }),
                          )),
                      Text(
                        "",
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
                                heroTag: 'plus',
                                child: SvgPicture.asset(
                                  "assets/images/plus_button.svg",
                                  height: 60,
                                  width: 60,
                                ),
                                onPressed: () {
                                  count++;
                                  setState(() {
                                    print(count);
                                  });
                                }),
                          )),
                      Text(
                        "",
                        style: TextStyle(color: Themer.textGreenColor),
                      )
                    ],
                  )
                ],
              )
            ],
          )),
        ],
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
