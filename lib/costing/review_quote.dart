import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';
import 'package:tree_manager/pojo/other_item.dart';

class ReviewQuote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReviewQuoteState();
  }
}

class ReviewQuoteState extends State<ReviewQuote> {
  Map<String, dynamic>? args;
  List<CrewDetail> staffs = [];
  List<CrewDetail> equips = [];
  List<CrewDetail> others = [];

  List<Map<String, dynamic>> grids = [];

  List<Map<String, dynamic>> makeReview() {
    print('recreated');
    staffs.clear();
    equips.clear();
    others.clear();
    Global.crewDetails?.forEach((crew) {
      print('qwqwq ${crew.hour} ${crew.itemName}');
      if (crew.itemCategory == 'Staff') staffs.add(crew);
      if (crew.itemCategory == 'Equipment') equips.add(crew);
      if (crew.itemCategory == 'Others') others.add(crew);
    });

    return [
      {"label": "Staff", "items": staffs},
      {"label": "Equipment", "items": equips},
      {"label": "Others", "items": others},
    ];
  }

  void rePopulateCrewDetails(Map<String, dynamic> edited) {
    var label = edited['label'];
    Global.crewDetails?.removeWhere((citem) => citem.itemCategory == label);
    Global.crewDetails?.addAll(edited['item']);
  }

  GridView makeReviewGrid() {
    if (args?.containsKey('crew_details') == true) {
      print('object 123');
      Global.crewDetails = args!['crew_details'];
    }
    print('no args  ${grids.length}');
    if (grids.length <= 0) grids = makeReview();
    return GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        childAspectRatio: 4 / 2.5,
        crossAxisCount: 2,
        children: List.generate(grids.length, (index) {
          var item = grids[index];
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                  color: Themer.textGreenColor,
                  border: Border.all(color: Themer.textGreenColor, width: 1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${item['label'].toString().toUpperCase()} (${(item['items'] as List).length})",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      (item['items'] as List<CrewDetail>).map((f) {
                        return f.itemName! + " ${f.hour}";
                      }).join(','),
                      style: TextStyle(fontSize: 13, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  )
                ],
              ),
            ),
            onTap: () async {
              var editedItem =
                  await Navigator.pushNamed(context, 'review_item', arguments: {
                "index": index,
                "item": item['items'],
                'label': item['label'],
                'prev_total': (() {
                  var total = 0.0;
                  if (item['label'] == 'Staff') {
                    equips.forEach((f) {
                      total += f.hourlyRate * f.count * f.hour;
                    });
                    others.forEach((f) {
                      total += f.hourlyRate * f.count * f.hour;
                    });
                    return total;
                  } else if (item['label'] == 'Equipment') {
                    staffs.forEach((f) {
                      total += f.hourlyRate * f.count * f.hour;
                    });
                    others.forEach((f) {
                      total += f.hourlyRate * f.count * f.hour;
                    });
                    return total;
                  } else {
                    staffs.forEach((f) {
                      total += f.hourlyRate * f.count * f.hour;
                    });
                    equips.forEach((f) {
                      total += f.hourlyRate * f.count * f.hour;
                    });
                    return total;
                  }
                })(),
              });
              print('edited item=>$editedItem');
              if (editedItem != null && editedItem is Map<String, dynamic>) {
                print('re pop');
                rePopulateCrewDetails(editedItem);
                print('tot calc');
                calcTotal();
                if (mounted) {
                setState(() {});}
              }
            },
          );
        }));
  }

  double? total;
  double calcTotal() {
    var total = 0.0;

    staffs.forEach((f) {
      print(f);
      total += f.hourlyRate * f.count * f.hour;
    });
    equips.forEach((f) {
      total += f.hourlyRate * f.count * f.hour;
    });
    others.forEach((f) {
      total += f.hourlyRate * f.count * f.hour;
    });

    this.total = total;
    return total;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          args =
          ModalRoute
              .of(context)
              ?.settings
              .arguments as Map<String, dynamic>?;
        });
      }
    });
    // super.initState();
    // setState(() {});
  }
  @override
  void dispose() {
   // _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (Global.costing_update == true &&
        (Global.crewDetails == null || Global.crewDetails?.length == 0) &&
        staffs.length == 0 &&
        equips.length == 0 &&
        others.length == 0 &&
        Global.head != null) {
      //deleteHead();
    }
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "Review Quote", sub_title: 'Job TM# ${Global.job?.jobNo}'),
      body: SingleChildScrollView(
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
            Container(
              decoration: BoxDecoration(color: Colors.white),
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Review Quote',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                            onPressed: () async {
                              var edited = await Navigator.pushNamed(
                                  context, 'edit_hours', arguments: {
                                'edit': true,
                                'staffs': staffs,
                                'equips': equips,
                                'others': others
                              }) as Map<String, dynamic>?;

                              staffs = edited?['staffs'];
                              equips = edited?['equips'];
                              others = edited?['others'];
                              Global.crewDetails = null;
                              Global.crewDetails = [];
                              Global.crewDetails?.addAll(staffs);
                              Global.crewDetails?.addAll(equips);
                              Global.crewDetails?.addAll(others);
                              staffs.forEach((f) {
                                print('${f.itemName}--${f.hour}');
                              });
                             if (mounted) {
                               setState(() {});
                             }
                            },
                            child: Text('Edit all')),
                        TextButton(
                          onPressed: () {
                            showOtherItemDialog();
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: BorderSide(color: Themer.textGreenColor)),
                          ),
                          child: Text('+ Add item'),
                        )
                      ],
                    ),
                  ),
                  makeReviewGrid(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Sub Total",
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${Helper.currencySymbol} ${calcTotal().toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Themer.textGreenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  //Spacer(),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 60,
                        width: 60,
                        child: FloatingActionButton(
                          child: SvgPicture.asset(
                              'assets/images/continue_button.svg'),
                          onPressed: () async {
                            print('eq le0.1');
                            var substa = await Navigator.pushNamed(
                                context, 'comment_box',
                                arguments: {
                                  'title': 'Job Costing',
                                  'sub_title': 'Substantiate Quote',
                                  'option': Global.substa_cost,
                                  'text': Global.substan,
                                  'append_mode': true
                                });
                            print('eq le0');
                            print('eq len${equips.length}');
                            if (substa is String) {
                              Global.substan = substa;
                            } else {
                              // Handle the case where substa is not a String, if necessary
                              Global.substan = '';
                            }
                            //Global.substan = substa;
                            Global.crewDetails = [];
                            Global.crewDetails!.addAll(staffs);
                            Global.crewDetails!.addAll(equips);
                            Global.crewDetails!.addAll(others);

                            equips.forEach((f) {
                              print('RQ  =${f.itemName}');
                            });
                            if (substa != null)
                              Navigator.of(context).pushNamed('total_amount',
                                  arguments: Global.crewDetails);
                          },
                        ),
                      ),
                      Text(
                        "CONTINUE",
                        style: TextStyle(color: Themer.textGreenColor),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showOtherItemDialog() {
    Helper.showSingleActionModal(
      context,
      title: 'Add Item',
      description: '  ',
      custom: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                'edit_hours',
                arguments: {
                  'from_review': true,
                  'prev_total': total,
                  'goto': 'manual_staff',
                },
              );

              // Check if the result is not null and is of type List<OtherItem>
              if (result != null && result is List<OtherItem>) {
                List<OtherItem> sel = result;

                sel.forEach((f) {
                  print('ID DEBUG==>ITEM ID=${f.itemId} HEAD ID=${f.headItemId}');
                  var tmp = CrewDetail();
                  tmp.itemId = f.itemId ?? f.headItemId;
                  tmp.itemName = f.itemName;
                  tmp.fixed = '';
                  tmp.hourlyRate = f.hourlyRate;
                  tmp.count = 1;
                  tmp.hour = f.hours ?? 1;
                  tmp.rateClass = f.rateClass ?? '';
                  tmp.itemCategory = 'Staff';
                  tmp.desc = f.subStan ?? '';
                  staffs.add(tmp);
                });
                if (mounted) {
                  setState(() {
                    calcTotal();
                  });
                }
              } else {
                print('No items were selected or the result is not a List<OtherItem>');
              }

              Navigator.pop(context);
            },
            child: Text(
              'Staff',
              style: TextStyle(color: Themer.textGreenColor, fontSize: 18),
            ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              height: 1,
              color: Colors.grey.withOpacity(0.6),
              margin: EdgeInsets.only(left: 50, right: 50),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                'edit_hours',
                arguments: {
                  'from_review': true,
                  'prev_total': total,
                  'goto': 'manual_equip',
                },
              );

              if (result != null && result is List<OtherItem>) {
                List<OtherItem> sel = result;

                sel.forEach((f) {
                  print('ID DEBUG==>ITEM ID=${f.itemId} HEAD ID=${f.headItemId}');
                  var tmp = CrewDetail();
                  tmp.itemId = f.itemId ?? f.headItemId;
                  tmp.itemName = f.itemName;
                  tmp.fixed = '';
                  tmp.hourlyRate = f.hourlyRate;
                  tmp.count = 1;
                  tmp.hour = f.hours ?? 1;
                  tmp.rateClass = f.rateClass ?? '';
                  tmp.itemCategory = 'Equipment';
                  equips.add(tmp);
                });
            if (mounted) {
              setState(() {
                calcTotal();
              });
            }
              } else {
                print('No items were selected or the result is not a List<OtherItem>');
              }

              Navigator.pop(context);
            },
            child: Text(
              'Equipment',
              style: TextStyle(color: Themer.textGreenColor, fontSize: 18),
            ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              height: 1,
              color: Colors.grey.withOpacity(0.6),
              margin: EdgeInsets.only(left: 50, right: 50),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                'edit_hours',
                arguments: {
                  'from_review': true,
                  'prev_total': total,
                  'goto': 'manual_others',
                },
              );

              if (result != null && result is List<OtherItem>) {
                List<OtherItem> sel = result;

                sel.forEach((f) {
                  print('ID DEBUGO==>ITEM ID=${f.itemId} HEAD ID=${f.headItemId}');
                  var tmp = CrewDetail();
                  tmp.itemId = f.itemId ?? f.headItemId;
                  tmp.itemName = f.itemName;
                  tmp.fixed = '';
                  tmp.hourlyRate = f.hourlyRate;
                  tmp.count = 1;
                  tmp.hour = f.hours ?? 1;
                  tmp.rateClass = f.rateClass ?? '';
                  tmp.itemCategory = 'Others';
                  others.add(tmp);
                });
              if (mounted) {
                setState(() {
                  calcTotal();
                });
              }
              } else {
                print('No items were selected or the result is not a List<OtherItem>');
              }

              Navigator.pop(context);
            },
            child: Text(
              'Others',
              style: TextStyle(color: Themer.textGreenColor, fontSize: 18),
            ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              height: 1,
              color: Colors.grey.withOpacity(0.6),
              margin: EdgeInsets.only(left: 50, right: 50),
            ),
          ),
        ],
      ),
    );
  }

  void deleteHead() {
    var post = {
      "params": {"id": "${Global.head!.id}"}
    };
    Helper.post("costformhead/delete", post, is_json: true).then((data) {
      var json = jsonDecode(data.body);
      if (json['success'] == 1) {
        Global.costing_update = false;
        Global.crewDetails = null;
        try {
          Navigator.pushReplacementNamed(context, 'site_inspection');
        } catch (e) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'site_inspection', ModalRoute.withName('quote_list'));
        }
      }
    });
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
