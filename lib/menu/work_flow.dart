import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';

import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class WorkFlow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WorkFlowState();
  }
}

class WorkFlowState extends State<WorkFlow> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "Work Detail", sub_title: 'Job TM# ${Global.job!.jobNo}'),
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: size.width,
            height: size.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var label = Global.flow["Step${index + 1}Text"];
                      var date = Global.flow["Step${index + 1}Date"];
                      ;
                      var time = Global.flow["Step${index + 1}Time"];
                      ;
                      return Container(
                        child: Row(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    color: Colors.green,
                                    width: 1.5,
                                    height: 40,
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              label,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              '$date $time',
                              style: TextStyle(
                                  fontSize: 12.0, color: Themer.textGreenColor),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 7,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 60.0,
                          width: 60.0,
                          margin: EdgeInsets.only(bottom: 10.0, top: 30),
                          child: FittedBox(
                            child: FloatingActionButton(
                                heroTag: 'back',
                                child: SvgPicture.asset(
                                  "assets/images/back_fill_button.svg",
                                  height: 60,
                                  width: 60,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          )),
                      Text(
                        "BACK",
                        style: TextStyle(color: Themer.textGreenColor),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context,setState);
  }
}
