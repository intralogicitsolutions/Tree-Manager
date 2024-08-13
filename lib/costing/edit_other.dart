import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';

class EditOther extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditOtherState();
  }
}

class EditOtherState extends State<EditOther> {
  var args;
  CrewDetail? crewDetail;
  var is_normal = true;
  var done_callback = false;
  var total = 0.00;
  var count = 1;
  var selectedRateClass = Global.normalClass;
  int hours = 1;
  var rate_ctrl = TextEditingController();

  double calcTotal() {
    return crewDetail != null
        ? (crewDetail?.hourlyRate * hours * count).toDouble()
        : 0.0;
  }

  void getCrewDetails(CrewDetail crew) {
    total = 0.0;
    //Helper.showProgress(context, 'Getting Crew Details..');

    Helper.get(
        "nativeappservice/APPgetItemContractorRate?rate_class_id=${selectedRateClass}&rateset_id=${Global.rateSet}&item_id=${crew.itemId}&contractor_id=${Helper.user?.companyId}&process_id=${Helper.user?.processId}",
        {}).then((response) {
      print("got it1");
      var json = jsonDecode(response.body) as List;
      crew.hourlyRate = double.parse('${json[0]['contractor_rate']}');

      //Helper.hideProgress();
      setState(() {
        calcTotal();
      });
    }).catchError((error) {
      print("eeror occured1");
      //Helper.hideProgress();
      print(error);
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        crewDetail = args['item'] as CrewDetail;
        count = crewDetail?.count??1;
        hours = crewDetail?.hour??1;
        rate_ctrl.text = crewDetail!.hourlyRate.toString();
        print('Label2==>' + args['label']);
        selectedRateClass = crewDetail?.rateClass??"";
        if (selectedRateClass == Global.afterClass)
          is_normal = false;
        else
          is_normal = true;
      });
      //getCrewDetails(crewDetail);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((Duration a) {
    //   if (!done_callback) {
    //     done_callback = true;
    //   }
    //   if (crewDetail == null) ;
    // });
    return Scaffold(
        appBar: Helper.getAppBar(context, title: "Edit  Detail"),
        bottomNavigationBar: Helper.getBottomBar(bottomClick),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Quantity',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpemSans'),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: FloatingActionButton(
                      child: SvgPicture.asset(
                          'assets/images/minus_button_50px.svg'),
                      heroTag: 'minus_q',
                      elevation: 10,
                      onPressed: () {
                        if (count > 1) {
                          setState(() {
                            count--;
                          });
                        }
                      },
                    ),
                  ),
                  Text(
                    "${count}",
                    style:
                        TextStyle(fontSize: 50, color: Themer.textGreenColor),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: FloatingActionButton(
                      child: SvgPicture.asset(
                          'assets/images/plus_button_50px.svg'),
                      heroTag: 'plus_q',
                      elevation: 10,
                      onPressed: () {
                        setState(() {
                          count++;
                        });
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Hours     ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpemSans'),
                  ),
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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Rate              ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans'),
                  ),
                  Flexible(
                      child: Container(
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      controller: rate_ctrl,
                      style: TextStyle(fontSize: 30),
                      onChanged: (val) {
                        var rate = double.parse(val);
                        crewDetail?.hourlyRate = rate;
                        calcTotal();
                      },
                      decoration: InputDecoration(
                          //border: OutlineInputBorder(),
                          hintText: 'Rate.'),
                    ),
                  )),
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
                          crewDetail?.rateClass = selectedRateClass;
                          //getCrewDetails(crewDetail);
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
                          crewDetail?.rateClass = selectedRateClass;
                          //getCrewDetails(crewDetail);
                        },
                      ),
                      height: 60,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Sub Total",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "${Helper.currencySymbol} ${calcTotal().toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Themer.textGreenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  SizedBox(
                    width: 30,
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
                      child:
                          SvgPicture.asset('assets/images/continue_button.svg'),
                      onPressed: () {
                        crewDetail?.hour = hours;
                        crewDetail?.count = count;
                        crewDetail?.rateClass = selectedRateClass;
                        crewDetail?.hourlyRate = double.parse(rate_ctrl.text);
                        Navigator.pop(context);
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
