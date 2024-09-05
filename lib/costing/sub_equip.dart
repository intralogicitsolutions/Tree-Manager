import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart'; // Ensure you're using the correct toast library
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/other_item.dart';

class SubEquip extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubEquipState();
  }
}

class _SubEquipState extends State<SubEquip> {
  Map<String, dynamic>? args;
  var selectedRateClass = Global.normalClass;
  var selected = <OtherItem>[];
  double prevTotal = 0.0;
  int hours = 1;
  bool isNormal = true;

  @override
  void initState() {
    super.initState();
    Global.sub_equips = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      hours = args?['hour'] ?? 1;
      if (args!.containsKey('rate_class')) {
        selectedRateClass = args?['rate_class']??'';
        isNormal = selectedRateClass == Global.normalClass;
      }
      getEquips();
      if (args?['selected'] != null) selected.addAll(args?['selected']??'');
      setState(() {});
    });
  }

  double calcTotal() {
    double total = 0.0;
    for (var item in selected) {
      total += item.hourlyRate! * (item.hours ?? hours);
    }
    return total + prevTotal;
  }

  @override
  Widget build(BuildContext context) {
    prevTotal = args?['prev_total'] ?? 0.0;
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Equipment"),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 10),
            Column(
              children: [
                Text(args?['name'] ?? '', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Global.sub_equips != null
                    ? Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 80,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: Global.sub_equips?.length ?? 0,
                            itemBuilder: (context, index) {
                              var item = Global.sub_equips![index];
                              item.parent_id = args?['id']??'';
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (containsItem(item.getId())) {
                                      removeItem(item.getId());
                                    } else {
                                      item.parent_id = args?['id']??'';
                                      item.rateClass = selectedRateClass;
                                      item.hours = hours;
                                      selected.add(item);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: containsItem(item.getId())
                                        ? Themer.textGreenColor
                                        : Colors.white,
                                    border: Border.all(
                                      color: Themer.textGreenColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.itemName??'',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: containsItem(item.getId())
                                            ? Colors.white
                                            : Themer.textGreenColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Hours',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'OpenSans',
                  ),
                ),
                FloatingActionButton(
                  child: SvgPicture.asset('assets/images/minus_button_50px.svg'),
                  heroTag: 'minus',
                  elevation: 10,
                  onPressed: () {
                    if (hours > 1) {
                      setState(() {
                        hours--;
                        updateHour();
                      });
                    }
                  },
                ),
                Text(
                  "$hours",
                  style: TextStyle(fontSize: 50, color: Themer.textGreenColor),
                ),
                FloatingActionButton(
                  child: SvgPicture.asset('assets/images/plus_button_50px.svg'),
                  heroTag: 'plus',
                  elevation: 10,
                  onPressed: () {
                    setState(() {
                      hours++;
                      updateHour();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    child: Text(
                      "Normal Hours",
                      style: TextStyle(
                        color: isNormal ? Colors.white : Themer.textGreenColor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isNormal ? Themer.textGreenColor : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isNormal = true;
                        selectedRateClass = Global.normalClass;
                        getEquips();
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    child: Text(
                      "After Hours",
                      style: TextStyle(
                        color: isNormal ? Themer.textGreenColor : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isNormal ? Colors.white : Themer.textGreenColor,
                    ),
                    onPressed: () {
                      setState(() {
                        isNormal = false;
                        selectedRateClass = Global.afterClass;
                        getEquips();
                      });
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Sub Total", style: TextStyle(color: Colors.black)),
                    SizedBox(width: 20),
                    Text(
                      "${Helper.currencySymbol} ${calcTotal().toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Themer.textGreenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 60,
                  width: 60,
                  child: FloatingActionButton(
                    child: SvgPicture.asset('assets/images/continue_button.svg'),
                    onPressed: () {
                      ToastContext().init(context);
                      if (selected.isNotEmpty) {
                        Navigator.pop(context, selected);
                      } else {
                        Toast.show(
                          'Please select any Equipment',
                          //textStyle: context,
                          gravity: Toast.center, 
                          duration: Toast.lengthLong, 
                          backgroundColor: Themer.textGreenColor,
                        );
                      }
                    },
                  ),
                ),
                Text(
                  "CONTINUE",
                  style: TextStyle(color: Themer.textGreenColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateHour() {
    for (var item in selected) {
      item.hours = hours;
    }
  }

  void getEquips() {
    Helper.get(
      "nativeappservice/APPgetAllEquipmentDetailForCosting?contractor_id=${Helper.user?.companyId??''}&rateset_id=${Global.rateSet}&rateclass_id=$selectedRateClass&process_id=${Helper.user?.processId??''}&head_id=${args?['id']??''}",
      {},
    ).then((data) {
      Global.sub_equips = (jsonDecode(data.body) as List)
          .map((f) => OtherItem.fromJson(f))
          .toList();
      setState(() {
        selected.clear();
        if (args?['selected'] != null) selected.addAll(args?['selected']??'');
      });
    });
  }

  bool containsItem(String id) {
    return selected.any((item) => item.getId() == id);
  }

  void removeItem(String id) {
    selected.removeWhere((item) => item.getId() == id);
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
