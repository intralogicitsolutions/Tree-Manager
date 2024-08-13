import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/theme.dart';

class SingleActionDialog extends StatelessWidget {
  final String title; 
  final String? description, buttonText;
  final String? buttonimage;
  final Color? buttonTextColor;
  final Color? titleTextColor;
  final Color? descriptionTextColor;
  final String? descriptionPrefixIcon;
  final Function? dismissAction;
  final Function? buttonAction;
  final String? subDescription;
  final String? subTitle;
  final Widget custom;

  SingleActionDialog({
    required this.title,
    this.titleTextColor = Themer.textGreenColor,
    this.description,
    this.descriptionTextColor,
    this.descriptionPrefixIcon,
    this.buttonText,
    this.buttonTextColor,
    this.buttonimage,
    this.dismissAction,
    this.buttonAction,
    this.subDescription,
    this.subTitle,
    required this.custom,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              color: Colors.white,
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 15),
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
                      if (description != null)
                        SizedBox(
                          height: 15,
                        ),
                      if (description != null)
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
                      SizedBox(
                        height: 30,
                      ),
                      if (buttonText != null)
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
                                        "assets/images/$buttonimage",
                                        height: 60,
                                        width: 60,
                                      ),
                                      onPressed: () {
                                        if (buttonAction != null)
                                          buttonAction!();
                                        Navigator.of(context).pop(true);
                                      }),
                                )),
                            Text(
                              "$buttonText",
                              style: TextStyle(color: buttonTextColor),
                            )
                          ],
                        ),
                      if (subTitle != null)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                subTitle!,
                                style: TextStyle(
                                    color: titleTextColor,
                                    fontFamily: 'OpenSans',
                                    fontSize: 18),
                              ),
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
                                Flexible(
                                  child: Text(
                                    subDescription!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: descriptionTextColor,
                                        fontFamily: 'OpenSans',
                                        fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      if (custom != null) custom
                    ],
                  ),
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
    );
  }
}
