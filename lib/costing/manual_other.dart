import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/other_item.dart';

class ManualOther extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ManualOtherState();
}

class ManualOtherState extends State<ManualOther> {
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

  void getStaffs() {
    Helper.get(
      "nativeappservice/APPgetAllOthersForCosting?contractor_id=${Helper.user?.companyId??""}&rateset_id=${Global.rateSet}&rateclass_id=$rateClass&process_id=${Helper.user?.processId??""}",
      {},
    ).then((data) {
      Global.others = (jsonDecode(data.body) as List)
          .map((f) => OtherItem.fromJson(f))
          .toList();
      filtered = List.from(Global.others as Iterable);
      setState(() {});
    });
  }

  double calcTotal() {
    return selected.fold(prevTotal, (total, item) => total + (item.hourlyRate ?? 0) * (item.hours ?? args?['hour']??''));
  }

  void _updateFilteredItems(String text) {
    setState(() {
      filtered = Global.others!.where((item) => item.itemName!.contains(text)).toList();
    });
  }

  Future<void> _handleItemTap(OtherItem item) async {
    if (selected.contains(item)) {
      setState(() {
        selected.remove(item);
      });
    } else {
      final editedItem = await Navigator.pushNamed(
        context,
        'add_other',
        arguments: {
          'misc_item': item,
          'hour': args?['hour']??'',
          'rate_class': args?['rate_class']??''
        },
      ) as OtherItem?;

      if (editedItem != null) {
        setState(() {
          selected.add(editedItem);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    prevTotal = args?['prev_total'] ?? 0.0;

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context, title: "Other Items"),
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
                    Global.others != null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.50,
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
          hintText: "Search Other",
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
                  item.itemName!,
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
                    onPressed: () {
                      Navigator.pop(context, selected);
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
    Helper.bottomClickAction(index, context, setState);
  }
}
