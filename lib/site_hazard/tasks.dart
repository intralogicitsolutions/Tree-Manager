import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Task.dart';

class Tasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TasksState();
  }
}

class TasksState extends State<Tasks> {
  var selected = <Task>[];
  var selectedOther = <Task>[];
  var grids = <Task>[];
  Map<String, dynamic>? args;

  @override
  void initState() {
    super.initState();
    grids.addAll(Global.hzd_task!);
      selected = Global.hzd_sel_task ?? [];
      selectedOther=Global.hzd_sel_other_task ?? [];
    print('task len=${selected.length}');
  //  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: "Site Hazard Checklist",
          sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
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
                      'Task',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      (() {
                        var tmp = selectedOther.map((e) => e.label).toList();
                        tmp.addAll(selected.map((e) => e.label).toList());
                        return '(${tmp.join(',')})';
                      }()),
                      style: TextStyle(
                        fontSize: 12,
                        color: Themer.textGreenColor,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GridView.count(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        childAspectRatio: 4 / 2.5,
                        crossAxisCount: 2,
                        children: List.generate(grids.length, (index) {
                          print('length---->${grids.length}');
                          var item = grids[index];
                          return GestureDetector(
                            child: Container(
                              margin: EdgeInsets.all(0.5),
                              decoration: BoxDecoration(
                                  color: containsThis(item)
                                      ? Themer.treeInfoGridItemColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: Themer.textGreenColor,
                                      width: 1)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    item.label??'',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: containsThis(item)
                                            ? Colors.white
                                            : Themer.textGreenColor),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (containsThis(item))
                                  selected.remove(item);
                                else
                                  selected.add(item);
                              });
                            },
                          );
                        })),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          height: 60,
                          width: 60,
                          child: FloatingActionButton(
                            heroTag: 'add_other',
                            child: SvgPicture.asset(
                                'assets/images/add_other_button.svg'),
                            onPressed: () async {
                              var sel = await Navigator.pushNamed(
                                  context, 'add_other_task', arguments: {
                                'selected': selectedOther,
                                'label': 'Task'
                              }) as List<Task>?;

                              setState(() {
                                selectedOther = sel!;
                                selectedOther.forEach((element) {
                                  print('object ${element.label}');
                                });
                              });
                            },
                          ),
                        ),
                        Text(
                          "ADD OTHER",
                          style: TextStyle(color: Themer.textGreenColor),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          child: FloatingActionButton(
                            mini: false,
                            backgroundColor: Themer.textGreenColor,
                            child: SvgPicture.asset(
                                'assets/images/continue_button.svg'),
                            onPressed: () {
                              ToastContext().init(context);
                              // if (selected.isNotEmpty || selectedOther.isNotEmpty) {
                              if (selected.length > 0 ||
                                  selectedOther.length > 0) {
                                Global.hzd_sel_task = selected;
                                Global.hzd_sel_other_task = selectedOther;
                                if (args!['from_review'] == true)
                                  Navigator.pop(context);
                                else {
                                  Navigator.of(context).pushNamed('q1',
                                      arguments: {
                                        'from': 1,
                                        'from_review': args!['from_review']
                                      });
                                }
                              } else
                                Toast.show('Please select any Task',
                                    //textStyle: context,
                                    duration: Toast.lengthLong,
                                    gravity: Toast.center);
                            },
                            heroTag: 'continue',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('CONTINUE',
                            style: TextStyle(color: Themer.textGreenColor))
                      ],
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  bool containsThis(Task item) {
    print('task id=${item.value}');
    if (selected.contains(item))
      return true;
    else {
      var index = selected.indexWhere((element) => element.value == item.value);
      if (index >= 0) {
        selected[index] = item;
        return true;
      } else
        return false;
    }
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
