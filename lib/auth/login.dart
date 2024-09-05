import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login> {
  var u_ctrl = TextEditingController();
  var p_ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // u_ctrl.text = "Divakar";
    // p_ctrl.text = "Enviro@1";
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //bottomNavigationBar: Helper.getBottomBar(bottomClick),
      body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text('Tap back again to exit'),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
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
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
                            // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
                              // crossAxisAlignment: CrossAxisAlignment.center, // Centers content horizontally
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
                                  TextField(
                                    controller: u_ctrl,
                                    decoration: InputDecoration(
                                        prefixIcon: SvgPicture.asset(
                                          'assets/images/Person-Username.svg',
                                          fit: BoxFit.scaleDown,
                                        ),
                                        hintText: 'Username'),
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  TextField(
                                    controller: p_ctrl,
                                    decoration: InputDecoration(
                                      prefixIcon: SvgPicture.asset(
                                        'assets/images/Password-Lock.svg',
                                        fit: BoxFit.scaleDown,
                                      ),
                                      hintText: 'Password',
                                    ),
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  MaterialButton(
                                    minWidth: size.width,
                                    onPressed: () {
                                      Helper.bottom_nav_selected = 0;
                                      Helper.showProgress(context, 'Authenticating...');
                                      Helper.get(
                                          "nativeappservice/validateLogin?username=${u_ctrl.text.toString()}&password=${p_ctrl.text.toString()}",
                                          {}).then((response) {
                                        Helper.hideProgress();
                                        var json =
                                            jsonDecode(response.body) as List<dynamic>;
                                        if (json.length == 1) {
                                          Helper.setUser(json[0]);
                                          print(Helper.user?.userName);
                                          Navigator.pushReplacementNamed(
                                              context, 'dashboard');
                                        } else {
                                          Helper.showSingleActionModal(context,
                                              title: 'OOPS',
                                              description:
                                                  'Invalid Username/Password. Try Again.');
                                        }
                                        print(json.runtimeType);
                                      }).catchError((error) {
                                        Helper.hideProgress();
                                        print(error);
                                      });
                                    },
                                    padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                                    color: Themer.textGreenColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0)),
                                    child: Text(
                                      'SIGN IN >',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Can't sign in?",
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, 'forgot_password');
                                        },
                                        child: Text(
                                          "Forgot Password",
                                          maxLines: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, 'help_center');
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/images/HelpCenter.svg'),
                                      label: Text("Help Center"),
                                    ),
                                  )
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
