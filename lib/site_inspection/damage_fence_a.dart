import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/FenceInfo.dart';
import 'package:tree_manager/pojo/option.dart';

class DamageFenceA extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DamageFenceAState();
  }
}

class DamageFenceAState extends State<DamageFenceA> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getAllData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Helper.getAppBar(context,
            title: "Damage", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
        bottomNavigationBar: Helper.getBottomBar(bottomClick),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Text(
                "Damage",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              Text("Is there any fence Damage?",
                  style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          height: 100.0,
                          width: 100.0,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: FittedBox(
                            child: FloatingActionButton(
                                heroTag: '1',
                                child: SvgPicture.asset(
                                    'assets/images/accept.svg'),
                                onPressed: () {
                                  if (Global.job!.fenceRequired == 'true') {
                                    Navigator.of(context)
                                        .pushNamed('fence_height');
                                  } else {
                                    Navigator.of(context)
                                        .pushNamed('damage_fence_b');
                                  }
                                }),
                          )),
                      Text(
                        "YES",
                        style: TextStyle(color: Themer.textGreenColor),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                          height: 100.0,
                          width: 100.0,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: FittedBox(
                            child: FloatingActionButton(
                                heroTag: '2',
                                child: SvgPicture.asset(
                                    'assets/images/reject.svg'),
                                onPressed: () async {
                                  Global.info!.fence = "6";
                                  Navigator.pushNamed(context, 'damage_roof_a');
                                }),
                          )),
                      Text(
                        "NO",
                        style: TextStyle(color: Themer.textGreenColor),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }

  Future<void> getAllData() async {
    if (Global.fence == null) Global.fence = FenceInfo();
    Helper.showProgress(context, 'Getting dependencies');

    await Helper.get(
        "nativeappservice/loadOptionDetails?workflow_step=Fence%20Level%204",
        {}).then((data) {
      Global.fence_damage = (jsonDecode(data.body) as List)
          .map((f) => Option.fromJson(f))
          .toList();
    });
    if (Global.job != null && Global.job?.fenceRequired == 'true') {
      await Helper.get(
          "nativeappservice/loadOptionDetails?workflow_step=Fence%20Level%201",
          {}).then((data) {
        Global.fence_height = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });
      await Helper.get(
          "nativeappservice/loadOptionDetails?workflow_step=Fence%20Level%202",
          {}).then((data) {
        Global.fence_length = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });
      await Helper.get(
          "nativeappservice/loadOptionDetails?workflow_step=Fence%20Level%203",
          {}).then((data) {
        Global.fence_type = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });
      await Helper.get(
          "nativeappservice/loadOptionDetails?workflow_step=Fence%20Comments",
          {}).then((data) {
        Global.fence_comments = (jsonDecode(data.body) as List)
            .map((f) => Option.fromJson(f))
            .toList();
      });
    }
    Helper.hideProgress();
  }
}
