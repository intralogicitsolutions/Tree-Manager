import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class TreeAccess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TreeAccessState();
  }
}

class TreeAccessState extends State<TreeAccess> {
  var selected = <String>[];
  var selected_list = <String>[];
  var grids = [
    {"label": "Good", "value": "1"},
    {"label": "Average", "value": "2"},
    {"label": "Poor", "value": "3"},
  ];
  var lists = [
    {"label": "Juvenile", "value": "1"},
    {"label": "Semi Mature", "value": "2"},
    {"label": "Mature", "value": "3"},
  ];

  @override
  void initState() {
    try {
      if (Global.site_info_update == true) {
        selected = Global.info!.access!.split(',');
        selected_list = Global.info!.age!.split(',');
      }
    } catch (e) {}
    super.initState();
    print('selected_list length---->${selected_list.length}');
    print('selected length---->${selected.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: "Tree Information", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Access',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      var item = grids[index];
                      var value = item['value'];
                      return GestureDetector(
                        child: Container(
                          height: 80,
                          width: 80,
                          margin: EdgeInsets.all(5),
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
                                textAlign: TextAlign.center,
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
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Tree Age',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      var item = lists[index];
                      var value = item['value']??'';
                      return GestureDetector(
                        child: Container(
                          height: 80,
                          width: 80,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: selected_list.contains(value)
                                  ? Themer.textGreenColor
                                  : Colors.white,
                              border: Border.all(
                                  color: Themer.textGreenColor, width: 1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                item['label']??'',
                                textAlign: TextAlign.center,
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
                         if (value.isNotEmpty) {
                           if (selected_list.contains(value))
                             selected_list.remove(value);
                           else
                             selected_list.add(value);
                         }
                          });
                        },
                      );
                    }),
              ),
              Spacer(),
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
                        if (Global.info != null && selected_list.isNotEmpty && selected.isNotEmpty) {
                          // Global.info!.access = selected_list.join(',');
                          // Global.info!.age = selected.join(',');
                          Global.info?.age = selected_list.join(',');
                          Global.info?.access = selected.join(',');
                          Navigator.pushNamed(context, 'work_required');
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
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
