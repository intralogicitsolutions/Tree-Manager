import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/theme.dart';

class MultiActionDialog extends StatelessWidget {
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
  //Function? dismissAction;
  final VoidCallback? dismissAction;

  MultiActionDialog({
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
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Colors.white,
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 25, 10, 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 15,
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
                        if (description != null)
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
                    SizedBox(
                      height: 30,
                    ),
                    Row(
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
                                      backgroundColor: Themer.textGreenColor,
                                      child: SvgPicture.asset(
                                        "assets/images/$positiveButtonimage",
                                        height: 60,
                                        width: 60,
                                      ),
                                      onPressed: () {
                                        if (positiveButtonAction != null)
                                          positiveButtonAction!();
                                        Navigator.of(context).pop(true);
                                      }),
                                )),
                            Text(
                              "$positiveButtonText",
                              style: TextStyle(color: positiveButtonTextColor),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                height: 60.0,
                                width: 60.0,
                                margin: EdgeInsets.only(bottom: 10.0, top: 30),
                                child: FittedBox(
                                  child: FloatingActionButton(
                                      heroTag: 'dialog_action_1',
                                      child: SvgPicture.asset(
                                        "assets/images/$negativeButtonimage",
                                        height: 60,
                                        width: 60,
                                      ),
                                      onPressed: () {
                                        if (negativeButtonAction != null)
                                          negativeButtonAction!();
                                        Navigator.of(context).pop(false);
                                      }),
                                )),
                            Text(
                              "$negativeButtonText",
                              style: TextStyle(color: negativeButtonTextColor),
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
                            if (dismissAction != null)
                              dismissAction!();
                            // Navigator.pop(context);
                            Navigator.of(context).pop();

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
    );
  }
}
