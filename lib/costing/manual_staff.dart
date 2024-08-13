import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/comms/call_status.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';
import 'package:tree_manager/pojo/other_item.dart';

class ManualStaff extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ManualStaffState();
}

class ManualStaffState extends State<ManualStaff> {
  Map<String, dynamic>? args;
  String rateClass = "";
  final filterCtrl = TextEditingController();
  List<OtherItem> filtered = [];
  List<OtherItem> selected = [];
  double prevTotal = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      print(jsonEncode(args));
      rateClass = args?['rate_class'] ?? Global.selectedRateClass ?? Global.normalClass;
      getStaffs();
    });
  }

  // void getStaffs() {
  //   Helper.get(
  //     "nativeappservice/APPgetAllStaffForCosting?contractor_id=${Helper.user?.companyId??""}&rateset_id=${Global.rateSet}&rateclass_id=$rateClass&process_id=${Helper.user?.processId??""}",
  //     {},
  //   ).then((data) {
  //     Global.staffs = (jsonDecode(data.body) as List)
  //         .map((f) => OtherItem.fromJson(f))
  //         .toList();
  //     filtered = List.from(Global.staffs);
  //     setState(() {});
  //   });
  // }

  void getStaffs() {
    final url = "nativeappservice/APPgetAllStaffForCosting?contractor_id=${Helper.user?.companyId??""}&rateset_id=${Global.rateSet}&rateclass_id=$rateClass&process_id=${Helper.user?.processId??""}";

    Helper.get(url, {}).then((data) {
      try {
        if (data.body.startsWith('<html>')) {
          // Handle HTML error response
          print("Error Response: ${data.body}");
          return;
        }
        Global.staffs = (jsonDecode(data.body) as List)
            .map((f) => OtherItem.fromJson(f))
            .toList();
        filtered = List.from(Global.staffs);
        setState(() {});
      } catch (e) {
        print("Error parsing JSON: $e");
      }
    }).catchError((error) {
      print("Request Error: $error");
    });
  }


  double calcTotal() {
    return selected.fold(prevTotal, (total, item) => total + (item.hourlyRate ?? 0) * (item.hours ?? args?['hour']??''));
  }

  void _updateFilteredItems(String text) {
    setState(() {
      filtered = Global.staffs.where((item) => item.itemName!.contains(text)).toList();
    });
  }

  Future<void> _handleItemTap(OtherItem item) async {
    if (selected.contains(item)) {
      setState(() {
        selected.remove(item);
      });
    } else {
      item.hours = args?['hour']??'';
      item.rateClass = args?['rate_class']??'';
      setState(() {
        selected.add(item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    prevTotal = args?['prev_total'] ?? 0.0;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context, title: "Staff Selection"),
      body: GestureDetector(
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
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    _buildSearchBar(),
                    Global.staffs != null
                        ? Container(
                            height: size.height * 0.50,
                            child: Scrollbar(child: _buildItemList()),
                          )
                        : Center(child: CircularProgressIndicator()),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: filterCtrl,
        onChanged: _updateFilteredItems,
        decoration: InputDecoration(
          hintText: "Search Staff",
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              filterCtrl.clear();
              _updateFilteredItems('');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(thickness: 1, indent: 20, endIndent: 20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        var item = filtered[index];
        return GestureDetector(
          onTap: () => _handleItemTap(item),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
            decoration: BoxDecoration(
              color: selected.contains(item) ? Themer.textGreenColor : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${item.itemName}",
                  style: TextStyle(
                    fontSize: 16,
                    color: selected.contains(item) ? Colors.white : Themer.textGreenColor,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Column(
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
                    child: SvgPicture.asset('assets/images/continue_button.svg'),
                    onPressed: () async {
                      if (args!.containsKey('from_review') && args?['from_review'] == true) {
                        Navigator.pop(context, selected);
                      } else {
                        var crewDetails = selected.map((f) {
                          return CrewDetail()
                            ..itemId = f.itemId
                            ..itemName = f.itemName
                            ..fixed = ''
                            ..hourlyRate = f.hourlyRate
                            ..count = 1
                            ..hour = args?['hour']??''
                            ..rateClass = rateClass
                            ..itemCategory = 'Staff';
                        }).toList();

                        Navigator.pushNamed(
                          context,
                          'manual_equip',
                          arguments: {
                            'crew_details': crewDetails,
                            'from_review': false,
                            'rate_class': args?['rate_class']??'',
                            'hour': args?['hour']??'',
                            'prev_total': calcTotal(),
                          },
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
      ],
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
