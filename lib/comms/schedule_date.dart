// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
// import 'package:tree_manager/comms/Event.dart';
// import 'package:tree_manager/helper/Global.dart';
// import 'package:tree_manager/helper/helper.dart';
// import 'package:tree_manager/helper/theme.dart';
//
// class DayPickerPage extends StatefulWidget {
//   final List<Event> events;
//
//   const DayPickerPage({  Key? key,   required this.events}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _DayPickerPageState();
// }
//
// class _DayPickerPageState extends State<DayPickerPage> {
//  // var args;
//  Map<String, dynamic>? args;
//    DateTime _selectedDate = DateTime.now();
//   DateTime _firstDate = DateTime.now().subtract(Duration(minutes: 1));
//   DateTime _lastDate = DateTime.now().add(Duration(days: 365));
//   Color selectedDateStyleColor = Colors.white;
//   Color selectedSingleDateDecorationColor = Themer.textGreenColor;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _selectedDate = DateTime.now();
//     _firstDate = DateTime.now().subtract(Duration(minutes: 1));
//     _lastDate = DateTime.now().add(Duration(days: 365));
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//     print(jsonEncode(args));
//     // add selected colors to default settings
//     dp.DatePickerRangeStyles  styles = dp.DatePickerRangeStyles(
//         selectedDateStyle: Theme.of(context)
//             .textTheme
//             .bodyMedium
//             ?.copyWith(color: selectedDateStyleColor),
//         selectedSingleDateDecoration: BoxDecoration(
//             color: selectedSingleDateDecorationColor, shape: BoxShape.circle));
//
//     return Scaffold(
//         appBar: Helper.getAppBar(context,
//             title: 'Schedule Date', sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           child: Flex(
//             direction:
//                 MediaQuery.of(context).orientation == Orientation.portrait
//                     ? Axis.vertical
//                     : Axis.horizontal,
//             children: <Widget>[
//               Expanded(
//                 child: dp.DayPicker.single(
//                   selectedDate: _selectedDate,
//                   onChanged: _onSelectedDateChanged,
//                   firstDate: _firstDate,
//                   lastDate: _lastDate,
//                   datePickerStyles: styles,
//                   datePickerLayoutSettings:
//                       dp.DatePickerLayoutSettings(maxDayPickerRowCount: 2),
//                   selectableDayPredicate: _isSelectableCustom,
//                   eventDecorationBuilder: _eventDecorationBuilder,
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
//
//   void _onSelectedDateChanged(DateTime newDate) {
//     setState(() {
//       _selectedDate = newDate;
//       print('goto==>${args?['goto']}  ${newDate}');
//     });
//     Navigator.of(context).pushNamed('schedule_time', arguments: {
//       'date': newDate,
//       'msg_flow': '',
//       'comm_reci': '',
//       'visit_type': args?['visit_type'],
//       'goto': args?['goto']
//     });
//   }
//
//   bool _isSelectableCustom(DateTime day) {
//     return true;
//     return day.weekday < 6;
//   }
//
//   dp.EventDecoration? _eventDecorationBuilder(DateTime date) {
//     List<DateTime> eventsDates =
//         widget.events.map<DateTime>((Event e) => e.date).toList();
//     bool isEventDate = eventsDates.any((DateTime d) =>
//             date.year == d.year &&
//             date.month == d.month &&
//             d.day == date.day) ??
//         false;
//
//     BoxDecoration roundedBorder = BoxDecoration(
//         border: Border.all(
//           color: Colors.deepOrange,
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(3.0)));
//
//     return isEventDate
//         ? dp.EventDecoration(boxDecoration: roundedBorder)
//         : null;
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_manager/comms/Event.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class DayPickerPage extends StatefulWidget {
  final List<Event> events;

  const DayPickerPage({Key? key, required this.events}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DayPickerPageState();
}

class _DayPickerPageState extends State<DayPickerPage> {
  Map<String, dynamic>? args;
  DateTime _selectedDate = DateTime.now();
  DateTime _firstDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _lastDate = DateTime.now().add(Duration(days: 365));
  Color selectedDateStyleColor = Colors.white;
  Color selectedSingleDateDecorationColor = Themer.textGreenColor;

  @override
  void initState() {
    super.initState();
    _loadSelectedDate();
  }

  Future<void> _loadSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString('selectedDate');
    if (storedDate != null) {
      DateTime loadedDate = DateTime.parse(storedDate);
      setState(() {
        _selectedDate = (loadedDate.isBefore(_firstDate) || loadedDate.isAfter(_lastDate))
            ? _firstDate
            : loadedDate;
      });
    }
  }

  Future<void> _saveSelectedDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedDate', date.toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print(jsonEncode(args));

    dp.DatePickerRangeStyles styles = dp.DatePickerRangeStyles(
      selectedDateStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: selectedDateStyleColor),
      selectedSingleDateDecoration: BoxDecoration(
        color: selectedSingleDateDecorationColor,
        shape: BoxShape.circle,
      ),
    );

    return Scaffold(
      appBar: Helper.getAppBar(
        context,
        title: 'Schedule Date',
        sub_title: 'Job TM# ${Global.job?.jobNo ?? ''}',
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Flex(
          direction: MediaQuery.of(context).orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: dp.DayPicker.single(
                selectedDate: _selectedDate,
                onChanged: _onSelectedDateChanged,
                firstDate: _firstDate,
                lastDate: _lastDate,
                datePickerStyles: styles,
                datePickerLayoutSettings: dp.DatePickerLayoutSettings(
                  maxDayPickerRowCount: 2,
                ),
                selectableDayPredicate: _isSelectableCustom,
                eventDecorationBuilder: _eventDecorationBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectedDateChanged(DateTime newDate) {
    // if (newDate.isBefore(_firstDate) || newDate.isAfter(_lastDate)) {
    //   return;
    // }

    setState(() {
      _selectedDate = newDate;
    });
   _saveSelectedDate(newDate); // Save the selected date
    Navigator.of(context).pushNamed('schedule_time', arguments: {
      'date': newDate,
      'msg_flow': '',
      'comm_reci': '',
      'visit_type': args?['visit_type'],
      'goto': args?['goto']
    });
  }

  bool _isSelectableCustom(DateTime day) {
    return true;
  }

  dp.EventDecoration? _eventDecorationBuilder(DateTime date) {
    List<DateTime> eventsDates =
    widget.events.map<DateTime>((Event e) => e.date).toList();
    bool isEventDate = eventsDates.any((DateTime d) =>
    date.year == d.year &&
        date.month == d.month &&
        d.day == date.day);

    BoxDecoration roundedBorder = BoxDecoration(
      border: Border.all(
        color: Colors.deepOrange,
      ),
      borderRadius: BorderRadius.all(Radius.circular(3.0)),
    );

    return isEventDate
        ? dp.EventDecoration(boxDecoration: roundedBorder)
        : null;
  }
}



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tree_manager/comms/Event.dart';
// import 'package:tree_manager/helper/Global.dart';
// import 'package:tree_manager/helper/helper.dart';
// import 'package:tree_manager/helper/theme.dart';
//
// class DayPickerPage extends StatefulWidget {
//   final List<Event> events;
//
//   const DayPickerPage({Key? key, required this.events}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _DayPickerPageState();
// }
//
// class _DayPickerPageState extends State<DayPickerPage> {
//   Map<String, dynamic>? args;
//   DateTime _selectedDate = DateTime.now();
//   DateTime _firstDate = DateTime.now().subtract(Duration(minutes: 1));
//   DateTime _lastDate = DateTime.now().add(Duration(days: 365));
//   Color selectedDateStyleColor = Colors.white;
//   Color selectedSingleDateDecorationColor = Themer.textGreenColor;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedDate();
//   }
//
//   Future<void> _loadSelectedDate() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storedDate = prefs.getString('selectedDate');
//     if (storedDate != null) {
//       setState(() {
//         _selectedDate = DateTime.parse(storedDate);
//       });
//     }
//   }
//
//   Future<void> _saveSelectedDate(DateTime date) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedDate', date.toIso8601String());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//     print(jsonEncode(args));
//
//     dp.DatePickerRangeStyles styles = dp.DatePickerRangeStyles(
//       selectedDateStyle: Theme.of(context)
//           .textTheme
//           .bodyMedium
//           ?.copyWith(color: selectedDateStyleColor),
//       selectedSingleDateDecoration: BoxDecoration(
//         color: selectedSingleDateDecorationColor,
//         shape: BoxShape.circle,
//       ),
//     );
//
//     return Scaffold(
//       appBar: Helper.getAppBar(
//         context,
//         title: 'Schedule Date',
//         sub_title: 'Job TM# ${Global.job?.jobNo ?? ''}',
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         child: Flex(
//           direction: MediaQuery.of(context).orientation == Orientation.portrait
//               ? Axis.vertical
//               : Axis.horizontal,
//           children: <Widget>[
//             Expanded(
//               child: dp.DayPicker.single(
//                 selectedDate: _selectedDate,
//                 onChanged: _onSelectedDateChanged,
//                 firstDate: _firstDate,
//                 lastDate: _lastDate,
//                 datePickerStyles: styles,
//                 datePickerLayoutSettings: dp.DatePickerLayoutSettings(
//                   maxDayPickerRowCount: 2,
//                 ),
//                 selectableDayPredicate: _isSelectableCustom,
//                 eventDecorationBuilder: _eventDecorationBuilder,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _onSelectedDateChanged(DateTime newDate) {
//     setState(() {
//       _selectedDate = newDate;
//     });
//     _saveSelectedDate(newDate); // Save the selected date
//     Navigator.of(context).pushNamed('schedule_time', arguments: {
//       'date': newDate,
//       'msg_flow': '',
//       'comm_reci': '',
//       'visit_type': args?['visit_type'],
//       'goto': args?['goto']
//     });
//   }
//
//   bool _isSelectableCustom(DateTime day) {
//     return true;
//     // Uncomment this line if you want to restrict selection to weekdays only:
//     // return day.weekday < 6;
//   }
//
//   dp.EventDecoration? _eventDecorationBuilder(DateTime date) {
//     List<DateTime> eventsDates =
//     widget.events.map<DateTime>((Event e) => e.date).toList();
//     bool isEventDate = eventsDates.any((DateTime d) =>
//     date.year == d.year &&
//         date.month == d.month &&
//         d.day == date.day) ??
//         false;
//
//     BoxDecoration roundedBorder = BoxDecoration(
//       border: Border.all(
//         color: Colors.deepOrange,
//       ),
//       borderRadius: BorderRadius.all(Radius.circular(3.0)),
//     );
//
//     return isEventDate
//         ? dp.EventDecoration(boxDecoration: roundedBorder)
//         : null;
//   }
// }
