import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';

class EditItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  CrewDetail? crewDetail;
  bool isNormal = true;
  int count = 1;
  int hours = 1;
  String selectedRateClass = Global.normalClass;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      crewDetail = args['item'] as CrewDetail;
      count = crewDetail?.count?? 1;
      hours = crewDetail?.hour?? 1;
      selectedRateClass = crewDetail?.rateClass??"";
      isNormal = selectedRateClass == Global.normalClass;
      getCrewDetails(crewDetail);
    });
  }

  void getCrewDetails(CrewDetail? crew) {
    Helper.get(
      "nativeappservice/APPgetItemContractorRate?rate_class_id=$selectedRateClass&rateset_id=${Global.rateSet}&item_id=${crew?.itemId??""}&contractor_id=${Helper.user?.companyId}&process_id=${Helper.user?.processId}",
      {},
    ).then((response) {
      final json = jsonDecode(response.body) as List;
      crew?.hourlyRate = double.parse('${json[0]['contractor_rate']}');
      setState(() {});
    }).catchError((error) {
      print("Error occurred: $error");
    });
  }

  double calcTotal() {
    return crewDetail != null
        ? (crewDetail?.hourlyRate * hours * count).toDouble()
        : 0.0;
  }

  void updateRateClass(String rateClass) {
    setState(() {
      isNormal = rateClass == Global.normalClass;
      selectedRateClass = rateClass;
      crewDetail?.rateClass = rateClass;
      getCrewDetails(crewDetail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Edit Detail"),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildQuantitySelector(),
            _buildHoursSelector(),
            Text(
              "Work hour Time",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            _buildRateClassSelector(),
            _buildSubTotalRow(),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          'Quantity',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        _buildFloatingActionButton(
          'minus_q',
          'assets/images/minus_button_50px.svg',
          () {
            if (count > 1) {
              setState(() {
                count--;
              });
            }
          },
        ),
        Text(
          "$count",
          style: TextStyle(fontSize: 50, color: Themer.textGreenColor),
        ),
        _buildFloatingActionButton(
          'plus_q',
          'assets/images/plus_button_50px.svg',
          () {
            setState(() {
              count++;
            });
          },
        ),
      ],
    );
  }

  Widget _buildHoursSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          'Hours',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        _buildFloatingActionButton(
          'minus',
          'assets/images/minus_button_50px.svg',
          () {
            if (hours > 1) {
              setState(() {
                hours--;
              });
            }
          },
        ),
        Text(
          "$hours",
          style: TextStyle(fontSize: 50, color: Themer.textGreenColor),
        ),
        _buildFloatingActionButton(
          'plus',
          'assets/images/plus_button_50px.svg',
          () {
            setState(() {
              hours++;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(String heroTag, String assetPath, VoidCallback onPressed) {
    return Container(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        child: SvgPicture.asset(assetPath),
        heroTag: heroTag,
        elevation: 10,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildRateClassSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildRateClassButton("Normal Hours", Global.normalClass, isNormal),
        _buildRateClassButton("After Hours", Global.afterClass, !isNormal),
      ],
    );
  }

  Widget _buildRateClassButton(String title, String rateClass, bool isActive) {
    return Expanded(
      child: Container(
        child: ElevatedButton(
          child: Text(
            title,
            style: TextStyle(color: isActive ? Colors.white : Themer.textGreenColor),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? Themer.textGreenColor : Colors.white,
            side: BorderSide(color: Themer.textGreenColor),
          ),
          onPressed: () => updateRateClass(rateClass),
        ),
        height: 60,
      ),
    );
  }

  Widget _buildSubTotalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "Sub Total",
          style: TextStyle(color: Colors.black),
        ),
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
    );
  }

  Widget _buildContinueButton() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 60,
          width: 60,
          child: FloatingActionButton(
            child: SvgPicture.asset('assets/images/continue_button.svg'),
            onPressed: () {
              crewDetail?.hour = hours;
              crewDetail?.count = count;
              Navigator.pop(context);
            },
          ),
        ),
        Text(
          "CONTINUE",
          style: TextStyle(color: Themer.textGreenColor),
        ),
      ],
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
