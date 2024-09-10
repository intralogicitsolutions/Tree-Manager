import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/equip.dart';

class EquipSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EquipSelectionState();
  }
}

class EquipSelectionState extends State<EquipSelection> {
  @override
  void initState() {
    // getStaffs();
    filtered = [];
    filtered!.addAll(Global.hzd_equips);
    print(jsonEncode(filtered));
    selected = Global.hzd_sel_equip!;
    super.initState();
  }

  var filter_ctrl = TextEditingController();
  List<Equip>? filtered = null;
  var selected = <Equip>[];

  ListView makeReviewList() {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            indent: 20,
            endIndent: 20,
          );
        },
        shrinkWrap: true,
        itemCount: filtered?.length ?? 0,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          var item = filtered![index];
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
              padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
              decoration: BoxDecoration(
                color:
                    containsThis(item) ? Themer.textGreenColor : Colors.white,
                //border: Border.all(color: Themer.textGreenColor, width: 1)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${item.itemName}",
                        style: TextStyle(
                            fontSize: 16,
                            color: containsThis(item)
                                ? Colors.white
                                : Themer.textGreenColor,
                            fontFamily: 'OpenSans'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              if (containsThis(item))
                selected.remove(item);
              else
                selected.add(item);
              setState(() {});
            },
          );
        });
  }

  Map<String, dynamic>? args;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "Equipment Selection",
          sub_title: 'Job TM# ${Global.job!.jobNo}'),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusScopeNode());
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Visibility(
                child: Image.asset(
                  'assets/images/background_image.png',
                  width: size.width,
                  height: size.height,
                  fit: BoxFit.cover,
                ),
                visible: false,
              ),
            ),
            SingleChildScrollView(
                          child: Container(
                decoration: BoxDecoration(color: Colors.white),
                width: size.width,
                height: size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: filter_ctrl,
                            onChanged: (text) {
                              if (text == '') {
                                print('len zer');
                                filtered = [];
                                filtered?.addAll(Global.hzd_equips);
                              } else {
                                print('non zero');
                                filtered = [];
                                Global.hzd_equips.forEach((job) {
                                  if (job.itemName!.contains(text))
                                    filtered!.add(job);
                                });
                              }
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                hintText: "Search/Add Equipment",
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: IconButton(
                                    icon: SvgPicture.asset(
                                        'assets/images/add_small.svg'),
                                    onPressed: () {
                                      if (filter_ctrl.text.length != 0) {
                                        var stf = Equip(
                                          itemName: filter_ctrl.text,
                                        );
                                        setState(() {
                                          filter_ctrl.text = '';
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          selected.add(stf);
                                          Global.hzd_equips.add(stf);
                                          filtered = [];
                                          filtered!.addAll(Global.hzd_equips);
                                        });
                                      }
                                    })),
                          ),
                        ),
                        Text(
                          'Select Equipment on Site',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '(${selected.map((e) => e.itemName).join(' , ')})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Themer.textGreenColor,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        // Global.hzd_equips != null
                        //     ?
                        Container(
                                child: makeReviewList(),
                                height: size.height * 0.50,
                              )
                           // : Center(child: CircularProgressIndicator()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 60,
                              width: 60,
                              child: FloatingActionButton(
                                heroTag: 'continue',
                                child: SvgPicture.asset(
                                    'assets/images/continue_button.svg'),
                                onPressed: () async {
                                  ToastContext().init(context);
                                  if (selected.length > 0) {
                                    Global.hzd_sel_equip = selected;
                                    if (args!.containsKey('from_review') &&
                                        args!['from_review'] == true) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pushNamed(context, 'tasks',
                                          arguments: {
                                            'from_review': args!['from_review']
                                          });
                                    }
                                  } else
                                    Toast.show(
                                        'Please select any item',
                                        //textStyle: context,
                                        duration: Toast.lengthLong,
                                        gravity: Toast.center);
                                },
                              ),
                            ),
                            Text(
                              "CONTINUE",
                              style: TextStyle(color: Themer.textGreenColor),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool containsThis(Equip item) {
    if (selected.contains(item))
      return true;
    else {
      return false;
    }
  }

  void getStaffs() {
    selected = [];
    Helper.get(
        "nativeappservice/getAllUsersByCompany?contractor_id=${Helper.user?.companyId??''}&job_alloc_id=${Global.job?.jobAllocId??''}&process_id=${Helper.user?.processId??''}",
        {}).then((data) {
      Global.hzd_equips = (jsonDecode(data.body) as List)
          .map((f) => Equip.fromJson(f))
          .toList();
      setState(() {});
    });
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
