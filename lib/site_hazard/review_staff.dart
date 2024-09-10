import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Staff.dart';

class ReviewStaff extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReviewStaffState();
  }
}

class ReviewStaffState extends State<ReviewStaff> {
  Map<String, dynamic>? args;
  @override
  void initState() {
    // getStaffs();
    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      setState(() {
        filtered = [];
        filtered?.addAll(args!['selected']);
        if (Global.hzd_sel_other_staff != null)
          filtered?.addAll(Global.hzd_sel_other_staff!);
        filtered = filtered?.toSet().toList();

        selected = [];
        if (Global.hzd_sel_other_staff != null)
          selected.addAll(Global.hzd_sel_other_staff!);
        selected.addAll(args!['selected']);
        selected = selected.toSet().toList();
        selectedStaff.addAll(selected);
        if (Global.hzd_sel_other_staff != null)
          selectedStaff.addAll(Global.hzd_sel_other_staff!);
        selectedStaff = selectedStaff.toSet().toList();
        print('sel sta len=${selected.length}');
        print('filter length = ${filtered?.length}');
      });
    });

    super.initState();
    setState(() {});
  }

  var filter_ctrl = TextEditingController();
  List<Staff>? filtered = [];
  var selected = <Staff>[];
  var selectedStaff = <Staff>[];

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
        itemCount: filtered!.length,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          var item = filtered?[index];
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
              padding: EdgeInsets.fromLTRB(30, 10, 5, 5),
              decoration: BoxDecoration(
                color: containsThis(item!, index)
                    ? Themer.textGreenColor
                    : Colors.white,
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
                        "${item.firstName} ${item.lastName}",
                        style: TextStyle(
                            fontSize: 16,
                            color: containsThis(item, index)
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
              if (containsThis(item, index)) {
                selectedStaff.remove(item);
                filtered?.clear();
                filtered?.addAll(selected);
              } else
                selectedStaff.add(item);
              setState(() {});
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "Staff Selection", sub_title: 'Job TM# ${Global.job!.jobNo}'),
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Column(
                          children: [
                            Container(
                              child: TextField(
                                controller: filter_ctrl,
                                onChanged: (text) {
                                  if (text == '') {
                                    print('len zer');
                                    filtered = [];
                                    filtered?.addAll(selected);
                                  } else {
                                    print('non zero');
                                    filtered = [];
                                    selected.forEach((job) {
                                      if (job.firstName!.contains(text) ||
                                          job.lastName!.contains(text))
                                        filtered?.add(job);
                                    });
                                  }
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    hintText: "Search/Add Staff Members",
                                    prefixIcon: Icon(Icons.search),
                                    suffixIcon: IconButton(
                                        icon: SvgPicture.asset(
                                            'assets/images/add_small.svg'),
                                        onPressed: () {
                                          print('filter_ctr_text_length---->${filter_ctrl.text.length}');
                                          if (filter_ctrl.text.length != 0) {
                                            var stf = Staff(
                                                firstName: filter_ctrl.text,
                                                lastName: '');
                                            setState(() {
                                              filter_ctrl.text = '';
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              selected.add(stf);
                                              filtered?.clear();
                                              filtered?.addAll(selected);
                                              selectedStaff.add(stf);
                                            });
                                          }
                                        })),
                              ),
                            ),
                            Text(
                              'Review Staff',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Global.hzd_staffs != null
                                ?
                            Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.50,
                                    child: Scrollbar(child: makeReviewList()),
                                  )
                                : Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        if (1 == 2)
                          Column(
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
                                    if (selected.length > 0) {
                                      Global.hzd_sel_staff =
                                          selected.toSet().toList();
                                      if (args!['from_review'] == true) {
                                        await Navigator.pushNamed(
                                            context, 'staff_sign_grid',
                                            arguments: args);
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.popAndPushNamed(
                                            context, 'equip_selection',
                                            arguments: {
                                              'from_review': args!['from_review']
                                            });
                                      }
                                    } else
                                      Toast.show(
                                          'Please select staffs',
                                          //textStyle: context,
                                          duration: Toast.lengthLong,
                                          gravity: Toast.center);
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
                                  if (selectedStaff.length > 0) {
                                    Global.hzd_sel_staff = selectedStaff
                                        .where((element) => element.id != null)
                                        .toList();
                                    Global.hzd_sel_other_staff = selectedStaff
                                        .where((element) => element.id == null)
                                        .toList();

                                    Global.hzd_sel_staff?.forEach((element) {
                                      print("sel staff=${element.firstName}");
                                    });
                                    if (args!['from_review'] == true) {
                                      await Navigator.pushNamed(
                                          context, 'staff_sign_grid',
                                          arguments: args);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.popAndPushNamed(
                                          context, 'equip_selection',
                                          arguments: {
                                            'from_review': args!['from_review']
                                          });
                                    }
                                  } else
                                    Toast.show('Please select staffs',
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

  bool containsThis(Staff item, int index) {
    if (selectedStaff.contains(item)) {
      print('if works');
      return true;
    } else {
      return false;
    }
  }

  void getStaffs() {
    selected = [];
    Helper.get(
        "nativeappservice/getAllUsersByCompany?contractor_id=${Helper.user?.companyId??''}&job_alloc_id=${Global.job!.jobAllocId}&process_id=${Helper.user?.processId??''}",
        {}).then((data) {
      Global.hzd_staffs = (jsonDecode(data.body) as List)
          .map((f) => Staff.fromJson(f))
          .toList();
      setState(() {});
    });
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
