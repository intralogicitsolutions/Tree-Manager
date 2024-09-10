import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/chat.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatViewState();
  }
}

class ChatViewState extends State<ChatView> {
  Chat? chat;
  Map<String, dynamic>? args;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        chat = args!['chat'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context, title: "Communication", sub_title: 'Job TM# ${Global.job!.jobNo}'),
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
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          onPressed: null,
                          elevation: 1,
                          backgroundColor: Themer.chatAvatarColor,
                          heroTag: 'chat_avatar',
                          child: Helper.makeTextAvatar(chat?.username??'')
                             .text
                              .color(Themer.textGreenColor)
                              .size(20)
                              .bold
                             .fontFamily('OpenSans')
                              .make(),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // chat!.schedNote!.text
                            (chat?.schedNote ?? '').text
                                .color(Themer.textGreenColor)
                                .size(20)
                                .bold
                                .fontFamily('OpenSans')
                                .make(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // chat!.schedNote!.text
                  (chat?.schedNote ?? '').text
                      .color(Colors.black)
                      .size(16)
                      .fontFamily('OpenSans')
                      .start
                      .make(),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // chat!.createdAt!.text
                      (chat?.createdAt ?? '').text
                          .color(Themer.textGreenColor)
                          .size(16)
                          .fontFamily('OpenSans')
                          .start
                          .make()
                    ],
                  ),
                 // Spacer(),
                  SizedBox(
                    height: 20, // Adjust as needed for spacing
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      if (args != null && args!['update'] == true)
                        Column(
                          children: <Widget>[
                            Container(
                                height: 60.0,
                                width: 60.0,
                                margin: EdgeInsets.only(bottom: 10.0, top: 30),
                                child: FittedBox(
                                  child: FloatingActionButton(
                                      heroTag: 'reply',
                                      child: SvgPicture.asset(
                                        "assets/images/reply_button.svg",
                                        height: 60,
                                        width: 60,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, 'reply');
                                      }),
                                )),
                            Text(
                              "REPLY",
                              style: TextStyle(color: Themer.textGreenColor),
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
                                    heroTag: 'back',
                                    child: SvgPicture.asset(
                                      "assets/images/back_button.svg",
                                      height: 60,
                                      width: 60,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              )),
                          Text(
                            "BACK",
                            style: TextStyle(color: Themer.textGreenColor),
                          )
                        ],
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
