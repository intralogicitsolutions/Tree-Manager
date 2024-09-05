import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class TreeDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TreeDetailState();
  }
}

class TreeDetailState extends State<TreeDetail> {
  var _scrolCtrl = ScrollController();
  var selected = <String>[];
  var selected_list = <String>[];
  var grids = [
    {"label": "Good", "value": "1"},
    {"label": "Average", "value": "2"},
    {"label": "Poor", "value": "3"},
    {"label": "N/A", "value": "4"},
  ];
  var lists = [
    {"label": "0-400", "value": "1"},
    {"label": "401-1000", "value": "2"},
    {"label": ">1000", "value": "3"},
    {"label": "N/A", "value": "4"},
  ];

  @override
  void initState() {
    try {
      if (Global.site_info_update == true) {
        selected = Global.info!.health!.split(',');
        selected_list = Global.info!.trunk!.split(',');
      }
    } catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: "Tree Detail", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Tree Diameter (mm)',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: ScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            var item = lists[index];
                            var value = item['value'];
                            return GestureDetector(
                              child: Container(
                                height: 80,
                                width: 80,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: selected_list.contains(value)
                                        ? Themer.treeInfoGridItemColor
                                        : Colors.white,
                                    border: Border.all(
                                        color: Themer.textGreenColor,
                                        width: 1)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      item['label']??'',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: selected_list.contains(value)
                                              ? Colors.white
                                              : Themer.textGreenColor),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  if (selected_list.contains(value))
                                    selected_list.remove(value);
                                  else
                                    selected_list.add(value!);
                                });
                              },
                            );
                          }),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      'Tree Health',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20,),
                    GridView.count(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        childAspectRatio: 4 / 2.5,
                        crossAxisCount: 2,
                        children: List.generate(grids.length, (index) {
                          var item = grids[index];
                          var value = item['value'] ?? '';
                          return GestureDetector(
                            child: Container(
                              margin: EdgeInsets.all(0.5),
                              decoration: BoxDecoration(
                                  color: selected.contains(value)
                                      ? Themer.textGreenColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: Themer.textGreenColor,
                                      width: 1)),
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
                                if (value.isNotEmpty) {
                                  if (selected.contains(value))
                                    selected.remove(value);
                                  else
                                    selected.add(value);
                                }
                              });
                            },
                          );
                        })),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        mini: false,
                        backgroundColor: Themer.textGreenColor,
                        child: SvgPicture.asset(
                            'assets/images/continue_button.svg'),
                        onPressed: () {
                          ToastContext().init(context);
                          if (Global.info != null && selected_list.isNotEmpty && selected.isNotEmpty) {
                            Global.info?.trunk = selected_list.join(',');
                            Global.info?.health = selected.join(',');
                            Navigator.pushNamed(context, 'tree_location');
                          } else
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
              ],
            )),
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
