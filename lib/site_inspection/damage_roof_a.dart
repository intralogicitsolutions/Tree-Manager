import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class DamageRoofA extends StatefulWidget{
  

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DamageRoofAState();
  }

}

class DamageRoofAState extends State<DamageRoofA>{
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: Helper.getAppBar(context,title: "Damage", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15,right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100,),
            Text("Damage",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 50,),
            Text("Is there any roof Damage?",style: TextStyle(fontSize: 20)),
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
                              heroTag: 'dry',
                              child: SvgPicture.asset('assets/images/accept.svg'),
                              onPressed: () {
                                Navigator.of(context).pushNamed('damage_roof_b');
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
                              heroTag: 'drn',
                              child: SvgPicture.asset('assets/images/reject.svg'),
                              onPressed: () async {
                                Global.info!.roof="5";
                                Navigator.pushNamed(context, 'damage_other_a');
                              }),
                        )
                    ),
                    Text("NO",style: TextStyle(color: Themer.textGreenColor),)
                  ],
                )
              ],
            )
          ],
        ),
      )
    );
  }

  void bottomClick(int index) {
    
    Helper.bottomClickAction(index, context);
  }
}