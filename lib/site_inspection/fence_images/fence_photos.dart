import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/site_inspection/fence_images/damaged.dart';
import 'package:tree_manager/site_inspection/fence_images/standing.dart';

class FencePhotos extends StatefulWidget {
  FencePhotos({Key? key}) : super(key: key);

  @override
  _FencePhotosState createState() => _FencePhotosState();
}

class _FencePhotosState extends State<FencePhotos> with SingleTickerProviderStateMixin{
  Standing? standing;
  var damaged = Damaged();
  TabController? tabCtrl;

  @override
  void initState() {
    tabCtrl=TabController(length: 2, vsync: this);
    standing = Standing(changeTab: changeTab);
    super.initState();
  }
  void changeTab()
  {
    tabCtrl!.animateTo(1);
  }

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
                  "Damage(Fence)",
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
              controller: tabCtrl,
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
                      child: Text("Standing"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Damaged"),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            controller: tabCtrl,
            children: [standing!, damaged]),
        ));
  }
}
