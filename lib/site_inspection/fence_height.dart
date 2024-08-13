import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/option.dart';

class FenceHeight extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FenceHeightState();
  }
}

class FenceHeightState extends State<FenceHeight> {
  var _scrolCtrl = ScrollController();
  var selected = <String>[];
  List<Option> grids = Global.fence_height;

  @override
  void initState() {
    try {
      if (Global.fence != null) {
        selected = Global.fence!.value1!.split(',');
      }
    } catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: "Tree Detail", sub_title: 'Job TM# ${Global.job!.jobNo}'),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: SingleChildScrollView(
              child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Fence Height (m)',
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
                          var value = item.id;
                          return GestureDetector(
                            child: Container(
                              margin: EdgeInsets.all(0.5),
                              decoration: BoxDecoration(
                                  color: selected.contains(value)
                                      ? Themer.textGreenColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: Themer.textGreenColor, width: 1)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    item.caption??'',
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
                        child: SvgPicture.asset(
                            'assets/images/continue_button.svg'),
                        onPressed: () {
                          if (selected.length != 0) {
                            Global.fence?.value1 = selected.join(',');
                            Navigator.pushNamed(context, 'fence_width');
                          } else
                            Toast.show('please select any item',
                                //textStyle: context,
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
    Helper.bottomClickAction(index, context);
  }
}
