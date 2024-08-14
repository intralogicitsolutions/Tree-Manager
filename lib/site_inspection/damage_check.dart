import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class DamageCheck extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DamageCheckState();
  }
}

class DamageCheckState extends State<DamageCheck> {
  @override
  void initState() {
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
              Text("Is there any damages to property due to Tree Impact?",
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
                                  Navigator.of(context)
                                      .pushNamed('damage_fence_a');
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
                                  Global.info?.fence = "6";
                                  Global.info?.roof = "5";
                                  Global.info?.other = "9";
                                  var updated = Global.site_info_update == true
                                      ? await Helper.updateTreeInfo(context)
                                      : await Helper.setTreeInfo(context);
                                  Helper.hideProgress();
                                  if (updated) {
                                    if (Global.job?.costExists == "false" &&
                                        Global.job?.beforeImagesExists ==
                                            "true") {
                                      var action =
                                          await Helper.showMultiActionModal(
                                              context,
                                              title: 'Confirmation!',
                                              description:
                                                  'Tree Info loaded Successfully. Do you want to proceed to Job Costing?',
                                              negativeButtonText: 'NO',
                                              negativeButtonimage: 'reject.svg',
                                              positiveButtonText: 'YES',
                                              positiveButtonimage:
                                                  'accept.svg');
                                      if (action == true) {
                                        Navigator.pushNamed(
                                            context, 'crew_configuration');
                                      } else {
                                        Navigator.pushNamed(
                                            context, 'site_inspection');
                                      }
                                    } else {
                                      Navigator.pushNamed(
                                          context, 'site_inspection');
                                    }
                                  }
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
}
