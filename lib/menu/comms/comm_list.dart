import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/chat.dart';
import 'package:velocity_x/velocity_x.dart';

class CommList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CommListState();
  }
}

class CommListState extends State<CommList> {
  List<Chat>? chats;
  Map<String, dynamic>? args;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      });
    });
    getChats();
    super.initState();
  }

  getChats() {
    Helper.get(
        'nativeappservice/getCommunicationByJobIdAllocId?job_id=${Global.job?.jobId}&job_alloc_id=${Global.job?.jobAllocId}&process_id=${Helper.user?.processId}&contractor_id=${Helper.user?.companyId}',
        {}).then((value) {
      chats = (jsonDecode(value.body) as List)
          .map((e) => Chat.fromJson(e))
          .toList();
      try {
        setState(() {});
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    Helper.bottom_nav_selected = 3;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "Communication", sub_title: 'Job TM# ${Global.job?.jobNo}'),
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
            // padding: EdgeInsets.fromLTRB(40, 20, 10, 10),
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(
                            indent: 50,
                            endIndent: 20,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: chats == null ? 0 : chats!.length,
                        itemBuilder: (BuildContext context, int index) {
                          var chat = chats![index];
                          return GestureDetector(
                            onTap: () async {
                              var action = await Navigator.pushNamed(
                                  context, 'chat_view', arguments: {
                                'update': args!['update'],
                                'chat': chat
                              });
                              if (action == 'reply') {
                                createMessage();
                              }
                            },
                            child: Container(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FloatingActionButton(
                                        onPressed: null,
                                        elevation: 1,
                                        backgroundColor: Themer.chatAvatarColor,
                                        heroTag: index,
                                        child: Helper.makeTextAvatar(chat.username??'')
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Flexible(
                                            child: chat.username!.text
                                                .color(Themer.textGreenColor)
                                                .size(20)
                                                .bold
                                                .fontFamily('OpenSans')
                                                .make(),
                                          ),
                                          Flexible(
                                            child: chat.schedNote!.text
                                                .size(16)
                                                .fontFamily('OpenSans')
                                                .make(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    chat.createdAt!.text
                                        .size(17)
                                        .color(Themer.textGreenColor)
                                        .make(),
                                  ],
                                )
                              ],
                            )),
                          );
                        }),
                  ),
                ),
                if (args != null && args!['update'] == true)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          height: 60.0,
                          width: 60.0,
                          margin: EdgeInsets.only(bottom: 10.0, top: 30),
                          child: FittedBox(
                            child: FloatingActionButton(
                                heroTag: 'plus',
                                child: SvgPicture.asset(
                                  "assets/images/create_new_button.svg",
                                  height: 60,
                                  width: 60,
                                ),
                                onPressed: () async {
                                  createMessage();
                                }),
                          )),
                      Text(
                        "CREATE NEW",
                        style: TextStyle(color: Themer.textGreenColor),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> createMessage() async {
    var msg = await Navigator.pushNamed(context, 'comment_box', arguments: {
      'title': 'Communication',
      'positiveButtonText': 'SEND',
      'positiveButtonimage': 'send_button_small.svg',
    });
    print('messgae=$msg');
    if (msg != null) {
      var post = {
        "id": null,
        "job_id": "${Global.job?.jobId}",
        "job_alloc_id": "${Global.job?.jobAllocId}",
        "visit_type": null,
        "sched_date": "${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
        "sched_note": "$msg",
        "process_id": "${Helper.user?.id}",
        "owner": "${Helper.user?.id}",
        "created_by": "${Helper.user?.id}",
        "last_modified_by": null,
        "created_at":
            "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
        "last_updated_at": null,
        "end_time": null,
        "start_time": null,
        "status": "1",
        "phoned": null,
        "sms": null,
        "email": null,
        "callback": "2",
        "PMOnly": "1",
        "phone_no": null,
        "sms_no": null,
        "emailaddress": null,
        "source": "2",
        "message_received": null,
        "message_flow": null,
        "comm_recipient": "Comm Note",
        "comm_recipient_subcatg": null,
        "version": await Helper.getAppVersion()
      };
      Helper.showProgress(context, 'Please wait..');
      Helper.post('JobSchedule/Create', post, is_json: true).then((value) {
        Helper.hideProgress();
        var json = jsonDecode(value.body);
        if (json['success'] == 1) {
          getChats();
        }
      });
    }
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
