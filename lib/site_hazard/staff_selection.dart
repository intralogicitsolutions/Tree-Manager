import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Staff.dart';

class StaffSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StaffSelectionState();
  }
}

class StaffSelectionState extends State<StaffSelection> {
  @override
  void initState() {
    // getStaffs();
    filtered = [];
    filtered!.addAll(Global.hzd_staffs!);
    selected = Global.hzd_sel_staff! ;
    print('sel sta len=${selected.length}');
    super.initState();
  }

  var filter_ctrl = TextEditingController();
  List<Staff>? filtered = null;
  var selected = <Staff>[];
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
          var item = filtered![index];
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
              padding: EdgeInsets.fromLTRB(30, 10, 5, 5),
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
                        "${item.firstName} ${item.lastName}",
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
          title: "Staff Selection", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
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
                                filtered?.addAll(Global.hzd_staffs!);
                              } else {
                                print('non zero');
                                filtered = [];
                                Global.hzd_sel_staff?.forEach((job) {
                                  if (job.firstName!.contains(text) ||
                                      job.lastName!.contains(text))
                                    filtered!.add(job);
                                });
                              }
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                hintText: "Search Staff Members",
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.clear), onPressed: () {})),
                          ),
                        ),
                        Text(
                          'Select Staff on Site',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '(${selected.map((e) => '${e.firstName??''}' + " " + '${e.lastName??''}').join(' , ')})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Themer.textGreenColor,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Global.hzd_staffs != null
                            ?
                        Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.50,
                                child: Scrollbar(child: makeReviewList()),
                              )
                           : Center(child: CircularProgressIndicator()),
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
                                  ToastContext().init(context);
                                  if (selected.length > 0) {
                                    //Global.hzd_sel_staff = selected.toSet().toList();
                                    Navigator.pushNamed(context, 'review_staff',
                                        arguments: {
                                          'selected': selected,
                                          'from_review': args!['from_review']
                                        });
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

  bool containsThis(Staff item) {
    if (selected.contains(item))
      return true;
    else {
      var index = selected.indexWhere((element) => element.id == item.id);
      if (index >= 0) {
        selected[index] = item;
        return true;
      } else
        return false;
    }
  }

  void getStaffs() {
    selected = [];
    Helper.get(
        "nativeappservice/getAllUsersByCompany?contractor_id=${Helper.user?.companyId}&job_alloc_id=${Global.job!.jobAllocId}&process_id=${Helper.user?.processId}",
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
