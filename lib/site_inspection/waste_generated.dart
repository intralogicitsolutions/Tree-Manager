
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class WasteGenerated extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WasteGeneratedState();
  }
}

class WasteGeneratedState extends State<WasteGenerated> {
  var selected = <String>[];
  var grids = [
    {"label": "0-3", "value": "1"},
    {"label": "4-6", "value": "2"},
    {"label": "7-10", "value": "3"},
    {"label": "11-15", "value": "4"},
    {"label": ">15", "value": "5"},
    {"label": "N/A", "value": "6"},
  ];

  @override
  void initState() {
    try {
      if (Global.site_info_update == true)
        selected = Global.info!.waste!.split(',');
    } catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Waste Generated"),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: SingleChildScrollView(
              child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    Text(
                  'Waste (cubic meters)',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                GridView.count(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    childAspectRatio: 4 / 2.5,
                    crossAxisCount: 2,
                    children: List.generate(grids.length, (index) {
                      var item = grids[index];
                      var value = item['value'];
                      return GestureDetector(
                        child: Container(
                          margin: EdgeInsets.all(0.5),
                          decoration: BoxDecoration(
                              color: selected.contains(value)
                                  ? Themer.treeInfoGridItemColor
                                  : Colors.white,
                              border: Border.all(
                                  color: Themer.textGreenColor, width: 1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                item['label']??'',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: selected.contains(value)
                                        ? Colors.white
                                        : Themer.textGreenColor),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (selected.contains(value))
                              selected.remove(value);
                            else
                              selected.add(value!);
                          });
                        },
                      );
                    })),
                  ],
                ),
                //Spacer(),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        mini: false,
                        backgroundColor: Themer.textGreenColor,
                        child:
                            SvgPicture.asset('assets/images/continue_button.svg'),
                        onPressed: () {
                          ToastContext().init(context);
                          if (selected.length != 0) {
                            Global.info!.waste = selected.join(',');
                            Navigator.of(context).pushNamed('damage_check');
                          }
                          else
                            Toast.show('please select any item',
                            gravity: Toast.center,
                            duration: Toast.lengthLong,
                            backgroundColor: Themer.textGreenColor);
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
