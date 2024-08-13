import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Crew.dart';

class CrewSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CrewSelectionState();
}

class _CrewSelectionState extends State<CrewSelection> {
  int _selectedIndex = -1;
  List<Crew> _crews = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchCrews();
  }

  Future<void> _fetchCrews() async {
    if (_isLoaded) return;
    setState(() => _isLoaded = true);
    
    Helper.showProgress(context, 'Getting Crews..');
    
    try {
      final response = await Helper.get(
        "nativeappservice/crewSelection?process_id=${Helper.user?.processId}&contractor_id=${Helper.user?.companyId}",
        {}
      );
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _crews = data.map((json) => Crew.fromJson(json)).toList();
      });
    } catch (error) {
      print(error);
    } finally {
      Helper.hideProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Job Costing"),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: Container(
        color: Colors.white,
        child: GridView.builder(
          padding: EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 4 / 2.5,
          ),
          itemCount: _crews.length,
          itemBuilder: (context, index) {
            final crew = _crews[index];
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                Global.crew = crew;
                Navigator.of(context).pushNamed(
                  'hours_on_site',
                  arguments: {"crew": crew},
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Themer.textGreenColor : Colors.white,
                  border: Border.all(
                    color: Themer.textGreenColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      crew.crewName ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Themer.textGreenColor,
                      ),
                    ),
                    Text(
                      "(${crew.crewDesc ?? ''})",
                      style: TextStyle(
                        color: isSelected ? Colors.white : Themer.textGreenColor,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
