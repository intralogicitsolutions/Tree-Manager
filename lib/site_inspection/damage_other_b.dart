import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class DamageOtherB extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DamageOtherBState();
  }
}

class DamageOtherBState extends State<DamageOtherB> {
  var selected = <String>[];
  var grids = [
    {"label": "Gutter", "value": "1"},
    {"label": "Clothesline/\nPlay Equipment", "value": "2"},
    {"label": "Pool", "value": "3"},
    {"label": "Car Port/Garage", "value": "4"},
    {
      "label": Helper.countryCode == "UK" ? "Blocked Access" : "House",
      "value": "5"
    },
    {"label": "Shed", "value": "6"},
    {"label": "Other", "value": "7"},
    {"label": "NA", "value": "8"},
  ];

  @override
  void initState() {
    if (Global.site_info_update == true)
      selected = Global.info!.other!.split(',');
    super.initState();
  }

  var _scrolCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context,
          title: "Damage(Other)", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  controller: _scrolCtrl,
                  child: Column(
                    children: <Widget>[
                      GridView.count(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          childAspectRatio: 4 / 2.5,
                          crossAxisCount: 2,
                          children: List.generate(grids.length, (index) {
                            var item = grids[index];
                            var value = item['value'];
                            return GestureDetector(
                              child: Container(
                                margin: EdgeInsets.all(0.5),
                                decoration: BoxDecoration(
                                    color: selected.contains(value)
                                        ? Themer.treeInfoGridItemColor
                                        : Colors.white,
                                    border: Border.all(
                                        color: Themer.textGreenColor,
                                        width: 1)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      item['label']??'',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: selected.contains(value)
                                              ? Colors.white
                                              : Themer.textGreenColor),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  if (selected.contains(value))
                                    selected.remove(value);
                                  else
                                    selected.add(value!);
                                  _scrolCtrl.jumpTo(
                                      _scrolCtrl.position.maxScrollExtent);
                                });
                              },
                            );
                          }))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      mini: false,
                      backgroundColor: Themer.textGreenColor,
                      child:
                          SvgPicture.asset('assets/images/continue_button.svg'),
                      onPressed: () async {
                        ToastContext().init(context);
                        print('Selected items: ${selected.length}');
                        //change code this selected.length by default 1
                        if (selected.length != 0) {
                          Global.info?.other = selected.join(',');
                          var updated = Global.site_info_update == true
                              ? await Helper.updateTreeInfo(context)
                              : await Helper.setTreeInfo(context);
                          print('updated data--->${updated}');
                          if (updated) {
                            if (Global.job!.costExists == "false" &&
                                Global.job!.beforeImagesExists == "true") {
                              var action = await Helper.showMultiActionModal(
                                  context,
                                  title: 'Confirmation!',
                                  description:
                                      'Tree Info loaded Successfully. Do you want to proceed to Job Costing?',
                                  negativeButtonText: 'NO',
                                  negativeButtonimage: 'reject.svg',
                                  positiveButtonText: 'YES',
                                  positiveButtonimage: 'accept.svg');
                              if (action == true) {
                                Navigator.pushNamed(
                                    context, 'crew_configuration');
                              } else {
                                try {
                                  //Navigator.pushNamedAndRemoveUntil(context,'site_inspection',ModalRoute.withName('number_of_tree'));
                                  Navigator.pushReplacementNamed(
                                      context, 'site_inspection');
                                  print('Navigator.pushReplacementNamed Error----------:::::>}');
                                } catch (e) {
                                  print('Navigator.pushReplacementNamed Error---->}');
                                  Navigator.pushNamed(
                                      context, 'site_inspection');
                                }
                              }
                            } else {
                              print('Navigator.pushReplacementNamed Error::::;::;----------:::::>}');
                              // Navigator.pushNamedAndRemoveUntil(context, 'site_inspection',
                              //       (Route<dynamic> route) => route.settings.name == 'dashboard' || route.settings.name == 'quote_list', // Keep only specific routes
                              // );
                              Navigator.popUntil(context,
                                  ModalRoute.withName('site_inspection'));
                            }
                          }
                        } else
                          Toast.show('please select any item',
                              gravity: Toast.center,
                              duration: Toast.lengthLong,
                              backgroundColor: Themer.textGreenColor);
                      },
                      heroTag: 'continue',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('CONTINUE',
                        style: TextStyle(color: Themer.textGreenColor))
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
