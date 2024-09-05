import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class WorkCompletion extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WorkCompletionState();
  }
}

class WorkCompletionState extends State<WorkCompletion> {
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
                selectedStep: 1,
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
                "Work Completion",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Is the work completed properly?",
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
                                  Global.invoice?.completedYn = "YES";
                                  Navigator.pushNamed(
                                      context, 'customer_on_site');
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
                                  var data = await Navigator.pushNamed(
                                      context, 'comment_box',
                                      arguments: {
                                        'title': 'Reason',
                                        'positiveButtonText':
                                            'SAVE & RESCHEDULE',
                                        'positiveButtonImage':
                                            'save_button.svg',
                                        'negativeButtonText':
                                            'SAVE & RESCHEDULE LATER',
                                        'negativeButtonimage':
                                            'reschedule_button.svg',
                                        'option': Global.work_not_completed
                                      });
                                  Global.invoice?.completedYn = "NO";
                                  Helper.showProgress(context, 'Saving ...');
                                  Helper.post('jobinvoice/Create',
                                          Global.invoice!.toJson(),
                                          is_json: true)
                                      .then((value) async {
                                    Helper.hideProgress();
                                    var json = jsonDecode(value.body);
                                    if (json['success'] == 1) {
                                      if (data is Map) {
                                        Global.invoice?.completedText =
                                            data['text'];
                                        //save and re sched later
                                        await Helper.showSingleActionModal(
                                            context,
                                            title: 'Re-Schedule',
                                            description:
                                                'Please Re-Schedule later to complete work');
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          'invoice',
                                          ModalRoute.withName('invoice_list'),
                                        );
                                      } else {
                                        //save and re sched now
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            'invoice',
                                            ModalRoute.withName('invoice_list'),
                                            arguments: {
                                              'show_reschedule': true
                                            });
                                      }
                                    }
                                  }).catchError((onError) {
                                    Helper.hideProgress();
                                  });
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
