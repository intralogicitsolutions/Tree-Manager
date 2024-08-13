import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/theme.dart';

class EmailDialog extends StatelessWidget {
  String title;
  Color titleTextColor;
  String? description;
  Color? descriptionTextColor;
  String? descriptionPrefixIcon;
  String? positiveButtonText;
  Color? positiveButtonTextColor;
  String? positiveButtonimage;
  Function? positiveButtonAction;
  String? negativeButtonText;
  Color? negativeButtonTextColor;
  String? negativeButtonimage;
  VoidCallback? negativeButtonAction;
  Function? dismissAction;

  EmailDialog({
    required this.title,
    this.titleTextColor = Themer.textGreenColor,
    this.description,
    this.descriptionTextColor,
    this.descriptionPrefixIcon,
    this.positiveButtonText,
    this.positiveButtonTextColor,
    this.positiveButtonimage,
    this.positiveButtonAction,
    this.negativeButtonText,
    this.negativeButtonTextColor,
    this.negativeButtonimage,
    this.negativeButtonAction,
    this.dismissAction,
  });

  var e_ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Colors.white,
                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          title,
                          style: TextStyle(
                              color: titleTextColor,
                              fontFamily: 'OpenSans',
                              fontSize: 20),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          if (descriptionPrefixIcon != null)
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                "assets/images/$descriptionPrefixIcon",
                                width: 20,
                                height: 20,
                              ),
                            ),
                          //SizedBox(width: 10,),
                          Flexible(
                            child: Text(
                              description!,
                              style: TextStyle(
                                  color: descriptionTextColor,
                                  fontFamily: 'OpenSans',
                                  fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      TextField(
                        controller: e_ctrl,
                        decoration: InputDecoration(
                          prefixIcon: SvgPicture.asset(
                            'assets/images/E-Mail.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          hintText: 'Email',
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                  height: 60.0,
                                  width: 60.0,
                                  margin:
                                      EdgeInsets.only(bottom: 10.0, top: 30),
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
                                              .pop(e_ctrl.text);
                                        }),
                                  )),
                              Text(
                                "$positiveButtonText",
                                style:
                                    TextStyle(color: positiveButtonTextColor),
                              )
                            ],
                          ),
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
                                          Navigator.of(context).pop();
                                        }),
                                  )),
                              Text(
                                "$negativeButtonText",
                                style:
                                    TextStyle(color: negativeButtonTextColor),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                      height: 60.0,
                      width: 60.0,
                      margin: EdgeInsets.only(bottom: 10.0, top: 30),
                      child: FittedBox(
                        child: FloatingActionButton(
                            heroTag: 'dialog_close',
                            child: SvgPicture.asset('assets/images/reject.svg'),
                            onPressed: () {
                              if (dismissAction != null) dismissAction!();
                              Navigator.pop(context);
                            }),
                      )),
                  Text(
                    "CLOSE",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
