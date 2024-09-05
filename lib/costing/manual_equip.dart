import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';
import 'package:tree_manager/pojo/other_item.dart';

class ManualEquip extends StatefulWidget {
  @override
  _ManualEquipState createState() => _ManualEquipState();
}

class _ManualEquipState extends State<ManualEquip> {
  Map<String, dynamic>? args;
  String rateClass = "";
  TextEditingController filterCtrl = TextEditingController();
  List<OtherItem> filtered = [];
  List<OtherItem> selected = [];
  List<int> selectedIndex = [];
  double prevTotal = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      rateClass = args?['rate_class'] ?? Global.selectedRateClass ?? Global.normalClass;
      Global.sub_equips = null;
      getStaffs();
    });
  }

  void getStaffs() {
    Helper.get(
      "nativeappservice/APPgetAllEquipmentForCosting?contractor_id=${Helper.user?.companyId??""}&rateset_id=${Global.rateSet}&rateclass_id=$rateClass&process_id=${Helper.user?.processId??""}",
      {},
    ).then((data) {
      print('gcvghv--->${data.body}');
      Global.equips = (jsonDecode(data.body) as List)
        .map((f) => OtherItem.fromJson(f))
        .toList();
      filtered = List.from(Global.equips as Iterable);
      setState(() {});
    });
  }

  double calcTotal() {
    return selected.fold(prevTotal, (total, item) => total + (item.hourlyRate! * (item.hours ?? args?['hour'] ?? 0)));
  }

  void _updateFilteredItems(String query) {
    setState(() {
      filtered = Global.equips.where((item) => item.itemName!.contains(query)).toList();
    });
  }

  Widget _buildItemList() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(thickness: 1, indent: 20, endIndent: 20),
      shrinkWrap: true,
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        var item = filtered[index];
        item.parent_id = args?['id'];
        return GestureDetector(
          onTap: () => _handleItemTap(item, index),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
            decoration: BoxDecoration(
              color: selectedIndex.contains(index) ? Themer.textGreenColor : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: TextSpan(
                            text: item.itemName,
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedIndex.contains(index) ? Colors.white : Themer.textGreenColor,
                              fontFamily: 'OpenSans',
                            ),
                            children: [
                              TextSpan(
                                text: " ${getSubItemNames(item.getId())}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: selectedIndex.contains(index) ? Colors.white : Themer.textGreenColor,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleItemTap(OtherItem item, int index) async {
    if (item.detail == '2') {
      setState(() {
        if (selectedIndex.contains(index)) {
          selectedIndex.remove(index);
          selected.remove(item);
        } else {
          item.hours = args?['hour'];
          item.rateClass = args?['rate_class'];
          selected.add(item);
          selectedIndex.add(index);
        }
      });
    } else {
      var sel = await Navigator.of(context).pushNamed(
        'sub_equip',
        arguments: {
          'id': item.getId(),
          'name': item.itemName,
          'hour': args?['hour'],
          'prev_total': calcTotal(),
          'rate_class': args?['rate_class'],
          'selected': getSubItems(item.getId()),
        },
      ) as List<OtherItem>?;

      if (sel != null) {
        setState(() {
          selectedIndex.remove(index);
          if (sel.isNotEmpty) selectedIndex.add(index);
          selected.removeWhere((test) => test.parent_id == item.getId());
          selected.addAll(sel);
        });
      }
    }
  }

  String getSubItemNames(String id) {
    var itemNames = selected.where((item) => item.parent_id == id).map((item) => item.itemName).join(',');
    return itemNames.isNotEmpty ? '($itemNames)' : '';
  }

  List<OtherItem> getSubItems(String id) {
    return selected.where((item) => item.parent_id == id).toList();
  }

  @override
  Widget build(BuildContext context) {
    prevTotal = args?['prev_total'] ?? 0.0;

    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Equipment on site"),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Center(
              child: Visibility(
                child: Image.asset(
                  'assets/images/background_image.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                    Global.equips.isNotEmpty
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.50,
                            child: _buildItemList(),
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
    return Container(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: filterCtrl,
        onChanged: _updateFilteredItems,
        decoration: InputDecoration(
          hintText: "Search Equipment",
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                filterCtrl.clear();
                filtered = List.from(Global.equips);
              });
            },
          ),
        ),
      ),
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
                      if (args?['from_review'] == true) {
                        Navigator.pop(context, selected);
                      } else {
                        var crewDetails = args?['crew_details'] as List<CrewDetail>? ?? [];
                        selected.forEach((item) {
                          var cd = CrewDetail()
                            ..itemId = item.itemId ?? item.headItemId
                            ..itemName = item.itemName
                            ..fixed = ''
                            ..hourlyRate = item.hourlyRate
                            ..count = 1
                            ..hour = item.hours!
                            ..rateClass = Global.selectedRateClass ?? ""
                            ..itemCategory = 'Equipment';
                          crewDetails.add(cd);
                        });
                        Navigator.pushNamed(context, 'review_quote', arguments: {'crew_details': crewDetails});
                      }
                    },
                  ),
                ),
                Text("CONTINUE", style: TextStyle(color: Themer.textGreenColor)),
              ],
            ),
         

          ],
        ),
      ],
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
