import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ForgotPasswordState();
  }
}

class ForgotPasswordState extends State<ForgotPassword> {
  var e_ctrl=TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Forgot Password",showNotification: false),
      //bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/background_image.png',
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Align(
                      child: Image.asset(Helper.AppImage),
                      alignment: Alignment.center,
                    ),
                  ),
                  Form(
                      child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SvgPicture.asset("assets/images/Unlock-Icon.svg"),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Forgot Password",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Please enter your registered email address and we will send link to reset your password. ",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10.0,
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
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      MaterialButton(
                        minWidth: size.width,
                        onPressed: () {
                          Helper.showProgress(context, 'Please Wait...');
                          var json={'params':{'email':e_ctrl.text}};
                          Helper.post("User/resetPassword", json,is_json: true).then((response){
                            Helper.hideProgress();
                            var json=jsonDecode(response.body);
                            Helper.showSingleActionModal(context,title: json['success']==true?'PASSWORD RESET INFO':'OOPS',
                            description: json['msg']);
                          }).catchError((onError){
                            Helper.hideProgress();
                          });
                        },
                        padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                        color: Themer.textGreenColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Text(
                          'SEND LINK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed('help_center');
                          },
                          icon: SvgPicture.asset('assets/images/HelpCenter.svg'),
                          label: Text("Help Center"),
                        ),
                      )
                    ],
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void bottomClick(int index) {
    
    Helper.bottomClickAction(index, context, setState);
  }
}
