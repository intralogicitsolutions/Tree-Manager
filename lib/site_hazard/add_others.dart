import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/option.dart';

class AddOthers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddOthersState();
  }
}

class AddOthersState extends State<AddOthers> {
  Map<String, dynamic>? args;
  @override
  void initState() {
    //getStaffs();
    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      setState(() {
        filtered = [];
        filtered.addAll(args!['selected']);
        selected = [];
        selected.addAll(args!['selected']);
        selectedOption.addAll(selected);
        print('sel sta len=${selected.length}');
      });
    });

    super.initState();
    setState(() {});
  }
  var filter_ctrl = TextEditingController();
  List<Option> filtered = [];
  var selected = <Option>[];
  var selectedOption = <Option>[];

  ListView makeReviewList() {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            indent: 20,
            endIndent: 20,
          );
        },
        shrinkWrap: true,
        itemCount: filtered.length,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          var item = filtered[index];
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
              padding: EdgeInsets.fromLTRB(30, 10, 5, 5),
              decoration: BoxDecoration(
                color: containsThis(item, index)
                    ? Themer.textGreenColor
                    : Colors.white,
                //border: Border.all(color: Themer.textGreenColor, width: 1)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${item.caption}",
                        style: TextStyle(
                            fontSize: 16,
                            color: containsThis(item, index)
                                ? Colors.white
                                : Themer.textGreenColor,
                            fontFamily: 'OpenSans'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                if (containsThis(item, index)) {
                  {
                    selectedOption.remove(item);
                    filtered.clear();
                    filtered.addAll(selected);
                  }
                } else
                  selectedOption.add(item);
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "Hazard identified", sub_title: 'Job TM# ${Global.job!.jobNo}'),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
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
                decoration: BoxDecoration(color: Colors.white),
                width: size.width,
                height: size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: filter_ctrl,
                            onChanged: (text) {
                              if (text == '') {
                                print('len zer');
                                filtered = [];
                                filtered.addAll(selected);
                              } else {
                                print('non zero');
                                filtered = [];
                                selected.forEach((job) {
                                  if (job.caption!.contains(text))
                                    filtered.add(job);
                                });
                              }
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                hintText: "Search/Add Hazard",
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: IconButton(
                                    icon: SvgPicture.asset(
                                        'assets/images/add_small.svg'),
                                    onPressed: () {
                                      if (filter_ctrl.text.length != 0) {
                                        var stf = Option(
                                          caption: filter_ctrl.text,
                                        );
                                        setState(() {
                                          filter_ctrl.text = '';
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          selected.add(stf);
                                          selectedOption.add(stf);
                                          filtered = [];
                                          filtered.addAll(selected);
                                        });
                                      }
                                    })),
                          ),
                        ),
                        Text(
                          args?['label']??'',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: size.height*0.45,
                          child: makeReviewList(),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 60,
                              width: 60,
                              child: FloatingActionButton(
                                heroTag: 'continue',
                                child: SvgPicture.asset(
                                    'assets/images/continue_button.svg'),
                                onPressed: () async {
                                  Navigator.pop(context, selectedOption);
                                },
                              ),
                            ),
                            Text(
                              "CONTINUE",
                              style: TextStyle(color: Themer.textGreenColor),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool containsThis(Option item, int index) {
    if (selectedOption.contains(item)) {
      print('if works');
      return true;
    } else {
      return false;
    }
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
