import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Invoice_data.dart';

class Accident extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AccidentState();
  }
}

class AccidentState extends State<Accident> {
  @override
  void initState() {
    Global.invoice = InvoiceData();
    Global.invoice?.jobId = Global.job?.jobId??"";
    Global.invoice?.jobAllocId = Global.job?.jobAllocId??"";
    Global.invoice?.invoiceAllowed = Global.invoiceAllowed;
    Global.invoice?.signOffReqd = Global.signRequired;
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
                selectedStep: 0,
                nbSteps: 4,
                selectedStepColorOut: Colors.green,
                selectedStepColorIn: Colors.green,
                doneStepColor: Colors.green,
                unselectedStepColorOut: Colors.red,
                unselectedStepColorIn: Colors.red,
                doneLineColor: Colors.blue,
                undoneLineColor: Colors.red,
                isHorizontal: true,
                //lineLength: 50,
                doneLineThickness: 5,
                undoneLineThickness:5,
                doneStepSize: 40,
                unselectedStepSize: 40,
                selectedStepSize: 40,
                selectedStepBorderSize: 1,
              ),
              Text(
                "Accident/Incident",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Were there any accidents or incidents onsite?",
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
                                  Global.invoice?.accidentsYn = "YES";
                                  Navigator.pushNamed(
                                      context, 'emergency_contact');
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
                                  Global.invoice?.accidentsYn = "NO";
                                  Navigator.pushNamed(
                                      context, 'work_completion');
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
    Helper.bottomClickAction(index, context);
  }
}
