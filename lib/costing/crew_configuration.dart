import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/costing/crew_selection.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Job.dart';

class CrewConfiguration extends StatefulWidget{
  

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CrewConfigurationState();
  }

}

class _CrewConfigurationState extends State<CrewConfiguration>{
  @override
  void initState() {

    Helper.get("nativeappservice/jobdetailInfo?job_alloc_id=${Global.job?.jobAllocId??''}", {})
        .then((response){
      List json2=jsonDecode(response.body);
      Global.job=Job.fromJson(json2[0]);
    }).catchError((error) {
      print(error);
      return null; // Explicitly return null
    });

    super.initState();
  }


var loaded=false;
  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((Duration d){
      if(loaded==false)
      {
        loaded=true;
        Helper.showProgress(context, "Getting things ready");
      Helper.get("nativeappservice/contractorRateset?contractor_id=${Helper.user?.companyId}&process_id=${Helper.user?.companyId}", {})
          .then((response){
        var json1=json.decode(response.body);
        print(json1[0].runtimeType);
        var tmp=json1[0];
        Global.rateSet=tmp["rateset_id"].toString();
        Global.taxRate=tmp['tax_rate'];
        print('rSET ${Global.rateSet}');
//        print(Global.taxRate.toString());

        Helper.get("nativeappservice/contractorRateclass?contractor_id=${Helper.user?.companyId}&process_id=${Helper.user?.companyId}&rateset_id=${Global.rateSet}", {})
            .then((response){
          List json2=jsonDecode(response.body) as List;
          print('classId ${json2.runtimeType}');
          Global.normalClass=json2[0]["rateclass_id"];
          Global.afterClass=json2[1]["rateclass_id"];
          Helper.hideProgress();
        }).catchError((error){
          Helper.hideProgress();
          print(error);
        });
      }).catchError((error){
        Helper.hideProgress();
        print(error);
      });
      }
    });
    return Scaffold(
      appBar: Helper.getAppBar(context,title: "Job Costing"),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15,right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 70,),
            Text("Crew Configuration",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 50,),
            Text("Would you like to use Crew Configuration?",style: TextStyle(fontSize: 20)),
            SizedBox(height: 50,),
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
                              child: SvgPicture.asset('assets/images/accept.svg'),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CrewSelection()));
                              }),
                        )
                    ),
                    Text("YES",style: TextStyle(color: Themer.textGreenColor),)
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
                              child: SvgPicture.asset('assets/images/reject.svg'),
                              onPressed: () {
                                Navigator.pushNamed(context, 'manual_hours');
                              }),
                        )
                    ),
                    Text("NO",style: TextStyle(color: Themer.textGreenColor),)
                  ],
                )
              ],
            ),
            SizedBox(height: 20,)
          ],
        ),
      )
    );
  }

  void bottomClick(int index) {
    
    Helper.bottomClickAction(index, context, setState);
  }
}