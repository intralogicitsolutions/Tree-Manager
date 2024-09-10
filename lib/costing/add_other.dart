import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/other_item.dart';

class AddOther extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddOtherState();
}

class AddOtherState extends State<AddOther> {
  final TextEditingController rateController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  int hours = 1;
  late OtherItem miscItem;
  late Map<String, dynamic> args;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      miscItem = args['misc_item'] as OtherItem;
      hours = args['hour'] ?? 1;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context, title: "Job Costing"),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Stack(
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
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Hours',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          _buildFloatingActionButton(
                            icon: 'assets/images/minus_button_50px.svg',
                            heroTag: 'unique_minus_tag',
                            onPressed: () {
                              if (hours > 1) {
                                setState(() {
                                  hours--;
                                });
                              }
                            },
                          ),
                          SizedBox(width: 20),
                          Text(
                            "$hours",
                            style: TextStyle(
                              fontSize: 50,
                              color: Themer.textGreenColor,
                            ),
                          ),
                          SizedBox(width: 20),
                          _buildFloatingActionButton(
                            icon: 'assets/images/plus_button_50px.svg',
                            heroTag: 'unique_plus_tag',
                            onPressed: () {
                              setState(() {
                                hours++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Rate',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          controller: rateController,
                          style: TextStyle(fontSize: 30),
                          decoration: InputDecoration(
                            hintText: 'Rate',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      maxLines: 5,
                      minLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Description',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildActionButton(
                        icon: 'assets/images/save_button.svg',
                        heroTag: 'unique_save_tag',
                        label: "SAVE",
                        onPressed: () {
                          miscItem.subStan = messageController.text;
                          miscItem.hourlyRate = double.tryParse(rateController.text) ?? 0.0;
                          miscItem.rateClass = args['rate_class'];
                          miscItem.hours = hours;
                          Navigator.pop(context, miscItem);
                        },
                      ),
                      _buildActionButton(
                        icon: 'assets/images/back_button.svg',
                        heroTag: 'unique_back_tag',
                        label: "BACK",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton({required String icon, required VoidCallback onPressed,required String heroTag, }) {
    return Container(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        child: SvgPicture.asset(icon),
        heroTag: heroTag,
        elevation: 10,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildActionButton({required String icon, required String label, required VoidCallback onPressed,required String heroTag,}) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 60,
          width: 60,
          child: FloatingActionButton(
            heroTag: heroTag,
            child: SvgPicture.asset(icon),
            onPressed: onPressed,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Themer.textGreenColor),
        ),
      ],
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
