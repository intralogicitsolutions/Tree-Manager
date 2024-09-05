import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Crew.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';

class HoursOnSite extends StatefulWidget {
  @override
  _HoursOnSiteState createState() => _HoursOnSiteState();
}

class _HoursOnSiteState extends State<HoursOnSite> {
  Crew? crew;
  List<CrewDetail>? crewDetails;
  double total = 0.0;
  String selectedRateClass = Global.normalClass;
  bool isNormal = true;
  int hours = 1;

  @override
  void initState() {
    super.initState();
    // final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    // crew = args['crew'] as Crew;
    // getCrewDetails();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access ModalRoute and any other inherited widgets here
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    crew = args['crew'] as Crew;
    getCrewDetails();
  }

  void getCrewDetails() {
    final url = "nativeappservice/crewDetail?contractor_id=${Helper.user?.companyId}&crew_id=${crew?.id}&rateset_id=${Global.rateSet}&rateclass_id=${selectedRateClass}&process_id=${Helper.user?.processId}";
    
    Helper.get(url, {}).then((response) {
      crewDetails = (jsonDecode(response.body) as List)
          .map((f) => CrewDetail.fromJson(f))
          .toList();
      setState(() {
        calcTotal();
      });
    }).catchError((error) {
      print("Error occurred: $error");
    });
  }

  double calcTotal() {
    if (crewDetails == null || crewDetails!.isEmpty) {
      return 0.0;
    }
    total = crewDetails!.fold(0.0, (sum, detail) {
      detail.hour = hours;
      detail.rateClass = selectedRateClass;
      return sum + detail.hourlyRate * hours;
    });
    return total;
  }

  void updateRateClass(String rateClass) {
    setState(() {
      isNormal = rateClass == Global.normalClass;
      selectedRateClass = rateClass;
      getCrewDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Job Costing"),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Select Hours On Site",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            _buildHourSelector(),
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

  Widget _buildHourSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildFloatingActionButton(
          'minus',
          'assets/images/minus_button_50px.svg',
          () {
            if (hours > 1) {
              setState(() {
                hours--;
                calcTotal();
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
              calcTotal();
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
        SizedBox(width: 10),
        _buildRateClassButton("After Hours", Global.afterClass, !isNormal),
      ],
    );
  }

  Widget _buildRateClassButton(String title, String rateClass, bool isActive) {
    return Expanded(
      child: Container(
        height: 60,
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
              Global.crewDetails = crewDetails;
              Global.selectedRateClass = selectedRateClass;
              Navigator.pushReplacementNamed(context, 'review_quote', arguments: {
                'hours': hours,
                'rate_class': selectedRateClass,
              });
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
    Helper.bottomClickAction(index, context, setState);
  }
}
