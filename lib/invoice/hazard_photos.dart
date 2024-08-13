import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/invoice/after_photos.dart';
import 'package:tree_manager/site_inspection/site_before_photos.dart';

class HazardPhotos extends StatefulWidget {
  HazardPhotos({Key? key}) : super(key: key);

  @override
  _HazardPhotosState createState() => _HazardPhotosState();
}

class _HazardPhotosState extends State<HazardPhotos> {
  var before = BeforePhoto(
    showAppbar: false,
    showBottomButtons: true,
  );
  var after = AfterPhoto();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: Visibility(
                visible: true,
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/images/ios-back-arrow.svg",
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    print("back pressed");
                    Navigator.of(context).pop();
                  },
                )),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Site Photos",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'Job TM# ${Global.job!.jobNo}',
                  style: TextStyle(color: Colors.lightGreen, fontSize: 13.0),
                )
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Themer.textGreenColor,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(10),
                        // topRight: Radius.circular(10)
                        ),
                    color: Themer.textGreenColor),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("BEFORE"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("AFTER"),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [before, after]),
        ));
  }
}
