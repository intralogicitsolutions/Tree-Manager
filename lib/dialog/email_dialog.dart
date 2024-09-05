import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/theme.dart';

class EmailDialog extends StatefulWidget {
  final String title;
  final Color titleTextColor;
  final String? description;
  final Color? descriptionTextColor;
  final String? descriptionPrefixIcon;
  final String? positiveButtonText;
  final Color? positiveButtonTextColor;
  final String? positiveButtonimage;
  final Function? positiveButtonAction;
  final String? negativeButtonText;
  final Color? negativeButtonTextColor;
  final String? negativeButtonimage;
  final VoidCallback? negativeButtonAction;
  final Function? dismissAction;

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

  @override
  State<EmailDialog> createState() => _EmailDialogState();
}

class _EmailDialogState extends State<EmailDialog> {
 // var e_ctrl = TextEditingController();
  late final TextEditingController e_ctrl;

  @override
  void initState() {
    super.initState();
    e_ctrl = TextEditingController();
  }


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
                          widget.title,
                          style: TextStyle(
                              color: widget.titleTextColor,
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
                          if (widget.descriptionPrefixIcon != null)
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                "assets/images/${widget.descriptionPrefixIcon}",
                                width: 20,
                                height: 20,
                              ),
                            ),
                          //SizedBox(width: 10,),
                          Flexible(
                            child: Text(
                              widget.description!,
                              style: TextStyle(
                                  color: widget.descriptionTextColor,
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
                                          "assets/images/${widget.positiveButtonimage}",
                                          height: 60,
                                          width: 60,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(e_ctrl.text);
                                        }),
                                  )),
                              Text(
                                "${widget.positiveButtonText}",
                                style:
                                    TextStyle(color: widget.positiveButtonTextColor),
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
                                          "assets/images/${widget.negativeButtonimage}",
                                          height: 60,
                                          width: 60,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  )),
                              Text(
                                "${widget.negativeButtonText}",
                                style:
                                    TextStyle(color: widget.negativeButtonTextColor),
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
                              if (widget.dismissAction != null) widget.dismissAction!();
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
