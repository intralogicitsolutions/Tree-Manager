import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'dart:ui' as ui;

class SignOff extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignOffState();
  }
}

class SignOffState extends State<SignOff> {
  final _sign = GlobalKey<SignatureState>();
  //ByteData _img = ByteData(0);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context, title: "Invoice"),
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
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(color: Colors.white),
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Customer Sign-Off',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      'I hereby confirm that the performed in my property was professional and complete'),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
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
                                '${sign!.points.length} points in the signature');
                          },
                          strokeWidth: 5,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Draw your Signature on the Screen'),
                      Flexible(
                        child: TextButton(
                            onPressed: () {
                              _sign.currentState!.clear();
                            },
                            child: Text(
                              'CLEAR',
                              style: TextStyle(color: Colors.green),
                            )),
                      )
                    ],
                  ),
                  //Spacer(),
                  Column(
                    children: <Widget>[
                      Container(
                          height: 60.0,
                          width: 60.0,
                          margin: EdgeInsets.only(bottom: 10.0, top: 30),
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
                                    final image =
                                        await _sign.currentState!.getData();
                                    var data = await image.toByteData(
                                        format: ui.ImageByteFormat.png);
                                    _sign.currentState!.clear();
                                    final encoded = base64
                                        .encode(data!.buffer.asUint8List());
                                    Global.base64Sign = encoded;
                                    Navigator.pushNamed(
                                        context, 'invoice_the_job');
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
    Helper.bottomClickAction(index, context, setState);
  }
}
