import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/option.dart';

class DamageFenceB extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DamageFenceBState();
  }
}

class DamageFenceBState extends State<DamageFenceB> {
  var selected = <String>[];
  List<Option> grids = Global.fence_damage;

  @override
  void initState() {
    if (Global.fence != null) {
      selected = Global.fence!.value4?.split(',') ?? [];
    }
    if (Global.site_info_update == true || selected.length <= 0) {
      selected = Global.info!.fence!.split(',');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: "Damage(Fence)", sub_title: 'Job TM# ${Global.job?.jobNo??""}'),
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
                  '',
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
                      var value = item.id;
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
                    }))
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
                          print('Selected items: ${selected.length}');
                          //change code this selected.length by default 1
                          if (selected.length != 0) {
                            Global.info?.fence = selected.join(',');
                            Global.fence?.value4 = selected.join(',');
                            saveFenceData();
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

  Future<void> saveFenceData() async {
    if (Global.job?.fenceRequired == 'true') {
      Global.fence?.jobId = Global.job?.jobId??'';
      Global.fence?.jobAllocId = Global.job?.jobAllocId??'';
      Global.fence?.processId = '${Helper.user?.processId??''}';
      Global.fence?.createdBy = Helper.user?.id??'';
      Global.fence?.createdAt =
          "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}";
      var updated = Global.fence_info_update == true
          ? await Helper.setFenceInfo(context)
          : await Helper.setFenceInfo(context);
      if (updated) {
        Navigator.pushNamed(context, 'fence_photos');
      }
    } else {
      Navigator.pushNamed(context, 'damage_roof_a');
    }
  }
}
