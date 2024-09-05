import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class Notes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotesState();
  }
}

class NotesState extends State<Notes> {
  var msg_ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Helper.bottom_nav_selected = 2;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        bottomNavigationBar: Helper.getBottomBar(bottomClick),
        appBar: Helper.getAppBar(context, title: 'Notes'),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 40, 40, 10),
            decoration: BoxDecoration(color: Colors.white),
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Expanded(
                      child: TextField(
                    maxLines: 100,
                    minLines: 50,
                    controller: msg_ctrl,
                    style: TextStyle(),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type your Message.'),
                  )),
                ),
                SizedBox(
                  height: 15,
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
                                  child: SvgPicture.asset(
                                    "assets/images/save_button.svg",
                                    height: 60,
                                    width: 60,
                                  ),
                                  onPressed: () async {
                                    await Helper.showSingleActionModal(context,title: 'Thank You!',description: 'The invoice will be sent to your registered E-Mail address.',);
                                  }),
                            )),
                        Text(
                          "SAVE",
                          style: TextStyle(color: Themer.textGreenColor),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }

  void bottomClick(int index) {
    
    Helper.bottomClickAction(index, context, setState);
  }
}
