import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';

class ReviewItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReviewItemState();
  }
}

class ReviewItemState extends State<ReviewItem> {
  List<CrewDetail> items = []; // Updated to use List<CrewDetail> directly
  int selected = -1;
  double prevTotal = 0;
  Map<String, dynamic>? args;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
        items = args?['item']??'' as List<CrewDetail>? ?? [];
        prevTotal = args?['prev_total']?.toDouble() ?? 0.0;
        print('prev total=$prevTotal');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(jsonEncode(items));
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context, title: "Review ${args?['label']??''}"),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            selected = -1;
          });
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
            Container(
              decoration: BoxDecoration(color: Colors.white),
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      child: makeReviewList(),
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
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
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 60,
                                    width: 60,
                                    child: FloatingActionButton(
                                      heroTag: 'back',
                                      child: SvgPicture.asset(
                                          'assets/images/back_button.svg'),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  Text(
                                    "BACK",
                                    style: TextStyle(
                                      color: Themer.textGreenColor,
                                    ),
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
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  Text(
                                    "CONTINUE",
                                    style: TextStyle(
                                      color: Themer.textGreenColor,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView makeReviewList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        var item = items[index];
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
            decoration: BoxDecoration(
              color: selected == index ? Themer.textGreenColor : Colors.white,
              // border: Border.all(color: Themer.textGreenColor, width: 1)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${item.itemName} - (${item.count})",
                        style: TextStyle(
                          fontSize: 16,
                          color: selected == index
                              ? Colors.white
                              : Themer.textGreenColor,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${item.hour} hours x ${Helper.currencySymbol} ${item.hourlyRate}",
                        style: TextStyle(
                          fontSize: 13,
                          color: selected == index
                              ? Colors.white
                              : Themer.textGreenColor,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  child: Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              Helper.getRateClassName(item.rateClass),
                              style: TextStyle(color: Themer.textGreenColor),
                            ),
                            Text(
                              "${Helper.currencySymbol} ${(item.count * item.hour * double.parse('${item.hourlyRate}')).toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Themer.textGreenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  visible: selected != index,
                ),
                Visibility(
                  child: Expanded(
                    flex: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 40,
                              width: 40,
                              child: FloatingActionButton(
                                heroTag: "edit ${item.itemId}",
                                child: SvgPicture.asset(
                                    'assets/images/edit_button.svg'),
                                onPressed: () async {
                                  if (item.itemCategory == 'Others') {
                                    await Navigator.pushNamed(
                                        context, 'edit_other', arguments: {
                                      "label": args?['label']??'',
                                      "item": item,
                                      "index": index
                                    });
                                  } else {
                                    await Navigator.pushNamed(
                                        context, 'edit_item', arguments: {
                                      "label": args?['label']??'',
                                      "item": item,
                                      "index": index
                                    });
                                  }

                                  setState(() {
                                    calcTotal();
                                  });
                                },
                              ),
                            ),
                            Text(
                              "Edit",
                              style: TextStyle(
                                color: selected == index
                                    ? Colors.white
                                    : Themer.textGreenColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 40,
                              width: 40,
                              child: FloatingActionButton(
                                heroTag: "delete ${item.itemId}",
                                child: SvgPicture.asset(
                                    'assets/images/delete_button_1x.svg'),
                                onPressed: () async {

                                  var action = await Helper.showMultiActionModal(
                                      context,
                                      title: 'Delete',
                                      description:
                                          'Do you want to Delete the selected staff/equipment?',
                                      negativeButtonText: 'NO',
                                      negativeButtonimage: 'reject.svg',
                                      positiveButtonText: 'YES',
                                      positiveButtonimage: 'accept.svg');
                                  if (action != null && action) {
                                    deleteDetail(item, index);
                                  }
                                },
                              ),
                            ),
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: selected == index
                                    ? Colors.white
                                    : Themer.textGreenColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  visible: selected == index,
                ),
              ],
            ),
          ),
          onTap: () {
            selected = index;
            setState(() {});
          },
        );
      },
    );
  }

  double calcTotal() {
    var total = 0.0;
    for (var f in items) {
      total += f.count * f.hour * double.parse('${f.hourlyRate}');
    }
    return total + prevTotal;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     setState(() {
  //       args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
  //       items = args['item'] as List<CrewDetail>? ?? [];
  //       prevTotal = args['prev_total']?.toDouble() ?? 0.0;
  //       print('prev total=$prevTotal');
  //     });
  //   });
  // }

  void deleteDetail(CrewDetail item, int index) {
    print(jsonEncode(item));
    if (item.detail == null) {
      setState(() {
        items.removeAt(index);
      });
    } else {
      var post = {
        "params": {"id": "${item.detail!.id}"}
      };

      Helper.post("costformdetail/delete", post, is_json: true).then((data) {
        var json = jsonDecode(data.body);
        if (json['success'] == 1) {
          setState(() {
            items.removeAt(index);
          });
        }
      });
    }
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
