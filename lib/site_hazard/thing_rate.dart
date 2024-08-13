import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/option.dart';

class ThingRate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ThingRateState();
  }
}

class ThingRateState extends State<ThingRate> {
  var rates = <Option>[];

  Map<String, dynamic>? args;
  Map<String, dynamic>? data;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        switch (args!['index']) {
          case 0:
            rates = Global.w_rate;
            print('Rate==>${jsonEncode(Global.w_rate)}');
            break;
          case 1:
            rates = Global.j_rate;
            break;
          case 2:
            rates = Global.t_rate;
            break;
          case 3:
            rates = Global.m_rate;
            break;
          default:
        }
        //print('Index==>${args['index']}');
        data = Global.hzd_triplet[args!['index']];
        //rates = data['rate'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var items = [
      {'label': 'Very Low Risk', 'color': 0xff5BEB31, 'value': rates[0].id},
      {'label': 'Low Risk', 'color': 0xffC1EB31, 'value': rates[1].id},
      {'label': 'Medium Risk', 'color': 0xffEBD831, 'value': rates[2].id},
      {'label': 'High Risk', 'color': 0xffEB8831, 'value': rates[3].id},
      {'label': 'Very High Risk', 'color': 0xffEB4A31, 'value': rates[4].id},
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: data!['rate_title'], sub_title: 'Job TM# ${Global.job!.jobNo}'),
      body: Stack(
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    data!['rate_sub_title'],
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 40,),
                  // Spacer(),
                  Container(
                    width: size.width * 0.65,
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var item = items[index];
                        var rate = item['value'];
                        return InkWell(
                          onTap: () {
                            switch (args!['index']) {
                              case 0:
                                Global.sel_w_rate = rate as String?;
                                Global.sel_w_color = Color(item['color'] as int);
                                break;
                              case 1:
                                Global.sel_j_rate = rate as String?;
                                Global.sel_j_color = Color(item['color'] as int);
                                break;
                              case 2:
                                Global.sel_t_rate = rate as String?;
                                Global.sel_t_color = Color(item['color'] as int);
                                break;
                              case 3:
                                Global.sel_m_rate = rate as String?;
                                Global.sel_m_color = Color(item['color'] as int);
                                break;
                              default:
                            }
                            Navigator.of(context)
                                .pushNamed('thing_control', arguments: args);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FloatingActionButton(
                                mini: false,
                                backgroundColor: Color(item['color'] as int),
                                onPressed: () {},
                                heroTag: '$index',
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(item['label'] as String,
                                  style: TextStyle(
                                      color: Themer.textGreenColor,
                                      fontSize: 16))
                            ],
                          ),
                        );
                      },
                      itemCount: items.length,
                    ),
                  ),
                  //Spacer(),
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 20),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       FloatingActionButton(
                  //         mini: false,
                  //         backgroundColor: Themer.textGreenColor,
                  //         child: SvgPicture.asset(
                  //             'assets/images/continue_button.svg'),
                  //         onPressed: () {},
                  //         heroTag: 'continue',
                  //       ),
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //       Text('CONTINUE',
                  //           style: TextStyle(color: Themer.textGreenColor))
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
