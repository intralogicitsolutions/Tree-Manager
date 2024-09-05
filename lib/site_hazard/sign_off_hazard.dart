import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Staff.dart';
import 'dart:ui' as ui;

class SignOffHazard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignOffHazardState();
  }
}

class SignOffHazardState extends State<SignOffHazard> {
  final _sign = GlobalKey<SignatureState>();
  //ByteData _img = ByteData(0);
  Staff? stf;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        stf = ModalRoute.of(context)?.settings.arguments as Staff?;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context, title: "Sign-Off"),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: Colors.white),
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${stf?.firstName} ${stf?.lastName}',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                          'I hereby confirm all the hazard list and documents are agreed and Submitted'),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Container(
                            color: Color(0xffD7FFBA),
                            child: Signature(
                              color: Colors.black,
                              key: _sign,
                              onSign: () {
                                final sign = _sign.currentState;
                                debugPrint(
                                    '${sign?.points.length} points in the signature');
                              },
                              strokeWidth: 5,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('Draw your Signature on the Screen'),
                          TextButton(
                              onPressed: () {
                                _sign.currentState?.clear();
                              },
                              child: Text(
                                'CLEAR',
                                style: TextStyle(color: Colors.green),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 60.0,
                          width: 60.0,
                          margin: EdgeInsets.only(bottom: 10.0, top: 0),
                          child: FittedBox(
                            child: FloatingActionButton(
                                heroTag: 'dialog_action_2',
                                child: SvgPicture.asset(
                                  "assets/images/continue_button.svg",
                                  height: 60,
                                  width: 60,
                                ),
                                onPressed: () async {
                                  if (_sign.currentState!.hasPoints) {
                                    stf!.signed = true;
                                    stf!.uploaded=false;
                                    final image = await _sign.currentState!.getData();
                                    var data = await image.toByteData(format: ui.ImageByteFormat.png);
                                    _sign.currentState!.clear();
                                    final encoded = base64.encode(data!.buffer.asUint8List());
                                    stf!.base64=encoded;
                                    Navigator.pop(context, stf);
                                  } else
                                    Toast.show(
                                        'Please sign and continue',
                                        //textStyle: context,
                                        duration: Toast.lengthLong,
                                        gravity: Toast.center);
                                }),
                          )),
                      Text(
                        "'CONTINUE",
                        style: TextStyle(color: Themer.textGreenColor),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
