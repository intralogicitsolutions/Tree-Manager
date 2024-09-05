import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class InvoiceTheJob extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InvoiceTheJobState();
  }
}

class InvoiceTheJobState extends State<InvoiceTheJob> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Helper.getAppBar(context,
            title: "Invoice", sub_title: 'Job TM# ${Global.job!.jobNo}'),
        bottomNavigationBar: Helper.getBottomBar(bottomClick),
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              StepsIndicator(
                selectedStep: 3,
                nbSteps: 4,
                selectedStepColorOut: Colors.green,
                selectedStepColorIn: Colors.green,
                doneStepColor: Colors.green,
                unselectedStepColorIn: Colors.red,
                unselectedStepColorOut: Colors.red,
                doneLineColor: Colors.blue,
                undoneLineColor: Colors.red,
                isHorizontal: true,
                //lineLength: 50,
                doneLineThickness: 5,
                undoneLineThickness: 5,
                doneStepSize: 40,
                unselectedStepSize: 40,
                selectedStepSize: 40,
                selectedStepBorderSize: 1,
              ),
              Text(
                "Invoice",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Would you like to Invoice the Job?",
                  style: TextStyle(fontSize: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          height: 100.0,
                          width: 100.0,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: FittedBox(
                            child: FloatingActionButton(
                                heroTag: '1',
                                child: SvgPicture.asset(
                                    'assets/images/accept.svg'),
                                onPressed: () {
                                  Global.invoice?.invoiceYn = "YES";
                                  Navigator.pushNamed(context, 'gen_invoice');
                                }),
                          )),
                      Text(
                        "YES",
                        style: TextStyle(color: Themer.textGreenColor),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                          height: 100.0,
                          width: 100.0,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: FittedBox(
                            child: FloatingActionButton(
                                heroTag: '2',
                                child: SvgPicture.asset(
                                    'assets/images/reject.svg'),
                                onPressed: () async {
                                  Global.invoice?.invoiceYn = "NO";
                                  Navigator.pushReplacementNamed(
                                      context, 'invoice');
                                }),
                          )),
                      Text(
                        "NO",
                        style: TextStyle(color: Themer.textGreenColor),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
