import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/option.dart';

class CommentBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CommentBoxState();
  }
}

class CommentBoxState extends State<CommentBox> {
  var msg_ctrl = TextEditingController();
  Map<String, dynamic>? args;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if(args != null){
        if (args!.containsKey('positiveButtonText'))
          positiveButtonText = args?['positiveButtonText'];
        if (args!.containsKey('positiveButtonimage'))
          positiveButtonimage = args?['positiveButtonimage'];
        if (args!.containsKey('negativeButtonText'))
          negativeButtonText = args?['negativeButtonText'];
        if (args!.containsKey('negativeButtonimage'))
          negativeButtonimage = args?['negativeButtonimage'];
        if (args!.containsKey('option')) option = args?['option'] as List<Option>?;
        if (args!.containsKey('text')) msg_ctrl.text = args?['text']??'';
      }
          setState(() {});
    });
    super.initState();
  }

  var positiveButtonText = 'SUBMIT';
  var positiveButtonimage = 'submit_button.svg';
  var negativeButtonimage;
  var negativeButtonText;
   List<Option>? option;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        bottomNavigationBar: Helper.getBottomBar(bottomClick),
        appBar: Helper.getAppBar(context,
            title: args?['title']??'', sub_title: 'Job TM# ${Global.job!.jobNo}'),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(color: Colors.white),
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (args != null && args!.containsKey('sub_title') &&
                      args!['sub_title'] != '')
                    Text(
                      args!['sub_title'],
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600),
                    ),
                  TextField(
                    maxLines: 10,
                    minLines: 7,
                    controller: msg_ctrl,
                    style: TextStyle(),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type your comments.'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () {
                          if (option != null && option!.isNotEmpty){
                            if (args!.containsKey("append_mode")) {
                              msg_ctrl.text =
                                  msg_ctrl.text + (option?[0].prefillText??'');
                            } else {
                              msg_ctrl.text = option?[0].prefillText?? '';
                            }
                          }
                          },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                        ),
                        child: Text(
                          option != null && option!.isNotEmpty
                              ? option![0].caption ?? 'OPTION A'
                              : 'OPTION A',
                          style: TextStyle(color: Themer.textGreenColor),
                        ),
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () {
                          if (option != null && option!.length > 1){
                            if (args!.containsKey("append_mode")) {
                              msg_ctrl.text =
                                  msg_ctrl.text + (option?[1].prefillText??"");
                            } else {
                              msg_ctrl.text = option?[1].prefillText??"";
                            }
                          }
                          },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                        ),
                        child: Text(
                          option != null && option!.length > 1
                              ? option![1].caption ?? 'OPTION B'
                              : 'OPTION B',
                          style: TextStyle(color: Themer.textGreenColor),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: OutlinedButton(
                        //borderSide: BorderSide(color: Themer.textGreenColor),
                        onPressed: () {
                          if (option != null && option!.length > 2){
                            if (args!.containsKey("append_mode")) {
                              msg_ctrl.text =
                                  msg_ctrl.text + (option?[2].prefillText??"");
                            } else {
                              msg_ctrl.text = (option?[2].prefillText??"");
                            }

                          }
                          },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                        ),
                        child: Text(
                          option != null && option!.length > 2
                              ? option![2].caption ?? 'OPTION C'
                              : 'OPTION C',
                          style: TextStyle(color: Themer.textGreenColor),
                        ),
                      ))
                    ],
                  ),
                  Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
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
                                        "assets/images/$positiveButtonimage",
                                        height: 60,
                                        width: 60,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(msg_ctrl.text);
                                      }),
                                )),
                            Text(
                              "$positiveButtonText",
                              style: TextStyle(color: Themer.textGreenColor),
                            )
                          ],
                        ),
                        if (negativeButtonText != null)
                          Column(
                            children: <Widget>[
                              Container(
                                  height: 60.0,
                                  width: 60.0,
                                  margin:
                                      EdgeInsets.only(bottom: 10.0, top: 30),
                                  child: FittedBox(
                                    child: FloatingActionButton(
                                        heroTag: 'dialog_action_1',
                                        child: SvgPicture.asset(
                                          "assets/images/$negativeButtonimage",
                                          height: 60,
                                          width: 60,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop({'text': msg_ctrl.text});
                                        }),
                                  )),
                              Text(
                                "$negativeButtonText",
                                style: TextStyle(color: Themer.textGreenColor),
                              )
                            ],
                          )
                      ],
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}
