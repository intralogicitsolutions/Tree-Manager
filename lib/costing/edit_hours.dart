
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';

class EditHours extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditHoursState();
}

class _EditHoursState extends State<EditHours> {
  String selectedRateClass = Global.normalClass;
  bool isNormal = true;
  int hours = 1;
  Map<String, dynamic> args = {};
  List<CrewDetail> staffs = [];
  List<CrewDetail> equips = [];
  List<CrewDetail> others = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    setState(() {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      if (args.containsKey('edit')) {
        staffs = args['staffs'] ?? [];
        equips = args['equips'] ?? [];
        others = args['others'] ?? [];
      }
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
            SizedBox(height: 20),
            _buildHourSelector(),
            if (!_isEditing()) _buildRateClassSelector(),
            if (_isEditing()) _buildSubTotal(),
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
        _buildHourButton('minus', () {
          if (hours > 1) {
            setState(() => hours--);
          }
        }),
        Text(
          "$hours",
          style: TextStyle(fontSize: 50, color: Themer.textGreenColor),
        ),
        _buildHourButton('plus', () {
          setState(() => hours++);
        }),
      ],
    );
  }

  Widget _buildHourButton(String assetName, VoidCallback onPressed) {
    return Container(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        child: SvgPicture.asset('assets/images/${assetName}_button_50px.svg'),
        heroTag: assetName,
        elevation: 10,
        onPressed: onPressed,
      ),
    );
  }

  bool _isEditing() {
    return args.containsKey('edit') && args['edit'];
  }

  Widget _buildRateClassSelector() {
    return Column(
      children: <Widget>[
        Text(
          "Work hour Time",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildRateClassButton("Normal Hours", Global.normalClass, isNormal),
            SizedBox(width: 10),
            _buildRateClassButton("After Hours", Global.afterClass, !isNormal),
          ],
        ),
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
          onPressed: () {
            setState(() {
              isNormal = rateClass == Global.normalClass;
              selectedRateClass = rateClass;
            });
          },
        ),
        height: 60,
      ),
    );
  }

  Widget _buildSubTotal() {
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
            onPressed: _onContinuePressed,
          ),
        ),
        Text(
          "CONTINUE",
          style: TextStyle(color: Themer.textGreenColor),
        ),
      ],
    );
  }

  void _onContinuePressed() async {
    if (_isEditing()) {
      _updateCrewDetails();
      Navigator.pop(context, {
        'staffs': staffs,
        'equips': equips,
        'others': others,
      });
    } else {
      args['rate_class'] = selectedRateClass;
      args['hour'] = hours;
      final data = await Navigator.pushNamed(context, args['goto'], arguments: args);
      Navigator.pop(context, data);
    }
  }

  void _updateCrewDetails() {
    final updateHour = (List<CrewDetail> details) {
      for (var detail in details) {
        detail.hour = hours;
      }
    };
    updateHour(staffs);
    updateHour(equips);
    updateHour(others);
  }

  double calcTotal() {
    double total = 0.0;
    final calculateTotal = (List<CrewDetail> details) {
      for (var detail in details) {
        total += detail.hourlyRate * detail.count * hours;
      }
    };
    calculateTotal(staffs);
    calculateTotal(equips);
    calculateTotal(others);
    return total;
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
