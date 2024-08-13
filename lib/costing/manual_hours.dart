import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class ManualHoursOnSite extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ManualHoursOnSiteState();
  }
}

class _ManualHoursOnSiteState extends State<ManualHoursOnSite> {
  var selectedRateClass = Global.selectedRateClass ?? Global.normalClass;
  var args;

  var done_callback = false;
  var is_normal = true;

  int hours = 1;

  @override
  void initState() {
    selectedRateClass = Global.selectedRateClass ?? Global.normalClass;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    /*WidgetsBinding.instance.addPostFrameCallback((Duration a) {
      if (!done_callback) {
        done_callback = true;
      }
      getCrewDetails();
    });*/
    return Scaffold(
        appBar: Helper.getAppBar(context, title: "Job Costing"),
        bottomNavigationBar: Helper.getBottomBar(bottomClick),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Select Hours On Site",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    child: FloatingActionButton(
                      child: SvgPicture.asset(
                          'assets/images/minus_button_50px.svg'),
                      heroTag: 'minus',
                      elevation: 10,
                      onPressed: () {
                        if (hours > 1) {
                          setState(() {
                            hours--;
                          });
                        }
                      },
                    ),
                  ),
                  Text(
                    "${hours}",
                    style:
                        TextStyle(fontSize: 50, color: Themer.textGreenColor),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: FloatingActionButton(
                      child: SvgPicture.asset(
                          'assets/images/plus_button_50px.svg'),
                      heroTag: 'plus',
                      elevation: 10,
                      onPressed: () {
                        setState(() {
                          hours++;
                        });
                      },
                    ),
                  )
                ],
              ),

              Text(
                "Work hour Time",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: ElevatedButton(
                        child: Text(
                          "Normal Hours",
                          style: TextStyle(
                              color: is_normal
                                  ? Colors.white
                                  : Themer.textGreenColor),
                        ),
                        style: ElevatedButton.styleFrom(
                            // backgroundColor:
                            //     is_normal ? Themer.textGreenColor : Colors.white,
                            ),
                        onPressed: () {
                          setState(() {
                            is_normal = true;
                          });
                          selectedRateClass = Global.normalClass;
                        },
                      ),
                      height: 60,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: ElevatedButton(
                        child: Text(
                          "After Hours",
                          style: TextStyle(
                              color: is_normal
                                  ? Themer.textGreenColor
                                  : Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            // backgroundColor:
                            //     is_normal ? Colors.white : Themer.textGreenColor,
                            ),
                        onPressed: () {
                          setState(() {
                            is_normal = false;
                          });
                          print("after works");
                          selectedRateClass = Global.afterClass;
                        },
                      ),
                      height: 60,
                    ),
                  )
                ],
              ),

              //Spacer(),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 60,
                    width: 60,
                    child: FloatingActionButton(
                      child:
                          SvgPicture.asset('assets/images/continue_button.svg'),
                      onPressed: () {
                        Global.selectedRateClass = selectedRateClass;
                        Navigator.pushNamed(context, 'manual_staff',
                            arguments: {
                              'from_review': false,
                              'hour': hours,
                              'rate_class': selectedRateClass
                            });
                      },
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
        ));
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
