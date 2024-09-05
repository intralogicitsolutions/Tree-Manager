import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';

class TotalAmount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TotalAmountState();
  }
}

class TotalAmountState extends State<TotalAmount> {
  List<CrewDetail> crewDetails = [];

  @override
  void initState() {
    print('tax rate= ${Global.taxRate}');
    Future.delayed(Duration.zero, () {
      setState(() {
        crewDetails =
            ModalRoute.of(context)?.settings.arguments as List<CrewDetail>;
        getContractorDetails();
        calcTotal();
        getApprovalLimit();
      });
    });

    super.initState();
  }

  var total;
  var approval_limit = -1.0;
  String? name;
  String? mobile;

  double calcTotal() {
    total = 0.0;
    crewDetails.forEach((f) {
      print('crew_detail==>${jsonEncode(f)}');
      total += double.parse(f.count.toString()) * f.hourlyRate * f.hour;
    });
    print(total);
    return total;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "Job Costing",
          sub_title: 'Job TM# ${Global.job?.jobNo ?? ''}'),
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
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Substantiate Quote',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Amount (Ex.Tax)',
                        style: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${Helper.currencySymbol} ${calcTotal().toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: Themer.textGreenColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.popUntil(
                              context, ModalRoute.withName('review_quote'));
                        },
                        icon:
                            SvgPicture.asset('assets/images/review_quote.svg'),
                        label: Text(
                          'Review Quote',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              color: Themer.textGreenColor),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 60,
                              width: 60,
                              child: FloatingActionButton(
                                heroTag: 'save',
                                child: SvgPicture.asset(
                                    'assets/images/save_button.svg'),
                                onPressed: () async {
                                  saveCosting();
                                },
                              ),
                            ),
                            Text(
                              "SAVE",
                              style: TextStyle(color: Themer.textGreenColor),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 60,
                              width: 60,
                              child: FloatingActionButton(
                                heroTag: 'submit',
                                child: SvgPicture.asset(
                                    'assets/images/submit_button.svg'),
                                onPressed: () async {
                                  submitCosting();
                                },
                              ),
                            ),
                            Text(
                              "SUBMIT",
                              style: TextStyle(color: Themer.textGreenColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> saveCosting() async {
    var action = await Helper.showMultiActionModal(context,
        title: 'Confirmation!',
        description: 'Are you sure to save quote?',
        negativeButtonText: 'NO',
        negativeButtonimage: 'reject.svg',
        positiveButtonText: 'YES',
        positiveButtonimage: 'accept.svg');
    if (action == true) {
      if (Global.costing_update == true) {
        updateMode(4);
      } else {
        createHeadAndDetail(4);
      }
    }
  }

  Future<void> submitCosting() async {
    var action = await Helper.showMultiActionModal(context,
        title: 'Confirmation!',
        description:
            'Please note! Once submitted costing cannot be changed. Would you like to submit the quote?',
        negativeButtonText: 'NO',
        negativeButtonimage: 'reject.svg',
        positiveButtonText: 'YES',
        positiveButtonimage: 'accept.svg');
    if (action == true) {
      if (Global.costing_update == true) {
        updateMode(1);
      } else {
        createHeadAndDetail(1);
      }
    }
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }

  void getApprovalLimit() {
    Helper.get(
        "nativeappservice/getApprovalLimitDetails?wpcompanyId=${Global.job?.wpcompanyid??''}&reqId=${Global.job?.reqid??''}",
        {}).then((data) {
      var json = jsonDecode(data.body);
      try {
        approval_limit = double.parse(json[0]["approval_limit"].toString());
      } catch (e) {
        approval_limit = -1.0;
      }
    });
  }

  Future<void> createSchedule() async {
    var post = {
      "id": null,
      "job_id": "${Global.job?.jobId??''}",
      "job_alloc_id": "${Global.job?.jobAllocId??''}",
      "visit_type": "3",
      "sched_date": "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
      "sched_note": null,
      "process_id": "${Helper.user?.processId??''}",
      "owner": "${Helper.user?.id??''}",
      "created_by": "${Helper.user?.id??''}",
      "last_modified_by": null,
      "created_at":
          "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
      "last_updated_at": null,
      "end_time": null,
      "start_time": "${DateFormat('hh:mm aa').format(DateTime.now())}",
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
      "comm_recipient": "",
      "comm_recipient_subcatg": null,
      "version": await Helper.getAppVersion()
    };
    Helper.post("JobSchedule/CreateWithNewID", post, is_json: true)
        .then((data) {
      var json = jsonDecode(data.body);
      if (json['success'] == 1) {
        //goto dashboard
      }
    }).catchError((onError) {});
  }

  void updateMode(int status) {
    crewDetails.forEach((f) {
      print('${f.itemName} ');
    });
    //return;
    var tax = (total * Global.taxRate) / 100;
    print('tax=$tax  total=$total  rate=${Global.taxRate}');
    //return;
    var head = {
      "id": "${Global.head?.id ?? ''}",
      "rate_set_id": "${Global.rateSet}",
      "job_id": "${Global.job?.jobId ?? ''}",
      "job_alloc_id": "${Global.job?.jobAllocId ?? ''}",
      "cost_refno": "${Global.head!.costRefno ?? ''}",
      "sub_total": "$total",
      "tax_rate": "${Global.taxRate}",
      "tp_tax_total": "$tax",
      "tp_grand_total": "${total + tax}",
      "process_id": "${Global.head?.processId ?? ''}",
      "job_manager": "${Global.head?.jobManager ?? ''}",
      "job_contact": "${Global.head?.jobContact ?? ''}",
      "job_notes": "${Global.head?.jobNotes ?? ''}",
      "wp_pm_notes": "${Global.head?.wpPmNotes ?? ''}",
      "wp_pm_substantiation": "${Global.head?.wpPmSubstantiation ?? ''}",
      "tp_job_substantiation": "${Global.substan}",
      "wp_grand_total": "${Global.head?.wpGrandTotal ?? ''}",
      "wp_tax_total": "${Global.head?.wpTaxTotal ?? ''}",
      "date": "${Global.head?.date ?? ''}",
      "wp_rate_set_id": "${Global.head?.wpRateSetId ?? ''}",
      "quote_date": "${Global.head?.quoteDate ?? ''}",
      "quote_no": "${Global.head?.quoteNo ?? ''}",
      "wp_sub_total": "${Global.head?.wpSubTotal ?? ''}",
      "tp_invoice_no": "${Global.head?.tpInvoiceNo ?? ''}",
      "source": "${Global.head?.source ?? ''}",
      "status": "$status",
      "rebate_total": "${Global.head?.rebateTotal ?? ''}",
      "mark_complete": "${Global.head?.markComplete ?? ''}",
      "tp_pay_dt": "${Global.head?.tpPayDt ?? ''}",
      "Upload_by": "${Helper.user?.id ?? ''}",
      "tp_invoice_dt": "${Global.head?.tpInvoiceDt ?? ''}",
      "owner": "${Helper.user?.id ?? ''}",
      "created_by": "${Helper.user?.id ?? ''}",
      "last_modified_by": "${Helper.user?.id ?? ''}",
      "created_at": "${Global.head?.createdAt ?? ''}",
      "last_updated_at":
          "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}"
    };
    Helper.showProgress(context, 'Updating HEAD');
    Helper.put("costformhead/Edit", head, is_json: true).then((data) {
      Helper.hideProgress();
      print('update head==>${data.body}');
     // var json = jsonDecode(data.body);
      var dets = crewDetails.where((test) => test.detail != null).toList();
      if (dets.length > 0) Helper.showProgress(context, 'Updating Details');
      dets.asMap().forEach((index, it) async {
        var detail = {
          "id": "${it.detail?.id ?? ''}",
          "head_id": "${it.detail?.headId ?? ''}",
          "job_id": "${it.detail?.jobId ?? ''}",
          "job_alloc_id": "${it.detail?.jobAllocId ?? ''}",
          "cost_refno": "${Global.head?.costRefno ?? ''}",
          "item_desc": "${it.detail?.itemDesc ?? " "}",
          "item_id": "${it.detail?.itemId ?? ''}",
          "item_qty": "${it.count}",
          "item_hrs": "${it.hour}",
          "item_price": "${it.hourlyRate}",
          "item_total":
              "${it.count * it.hour * double.parse(it.hourlyRate.toString())}",
          "item_rate": "${it.rateClass}",
          "quote_inc": "${it.detail?.quoteInc ?? ''}",
          "entry_point": "${it.detail?.entryPoint ?? ''}",
          "wp_qty": "${it.detail?.wpQty ?? ''}",
          "wp_desc": "${it.detail?.wpDesc ?? ''}",
          "wp_rate": "${it.detail?.wpRate ?? ''}",
          "wp_hrs": "${it.detail?.wpHrs ?? ''}",
          "wp_total": "${it.detail?.wpTotal ?? ''}",
          "process_id": "${Helper.user?.processId ?? ''}",
          "owner": "${Helper.user?.id ?? ''}",
          "created_by": "${Helper.user?.id ?? ''}",
          "last_modifies_by": "${Helper.user?.id ?? ''}}",
          "created_at":
              "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
          "last_updated_at":
              "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}"
        };

        await Helper.put("costformdetail/Edit", detail, is_json: true)
            .then((data) {
          if (index == dets.length - 1) Helper.hideProgress();
          print('update detail==>${data.body}');
        });
      });
      createDetail(status, Global.head?.id ?? '');
    });
  }

  Future<void> createHeadAndDetail(int status) async {
    var tax = (total * Global.taxRate) / 100;
    print('tax=$tax  total=$total  rate=${Global.taxRate}');
    //return;
    if (Global.costing_update == false) {
      var dateTime = DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now());
      print('date time= $dateTime');
      var head = {
        "id": null,
        "rate_set_id": "${Global.rateSet}",
        "job_id": "${Global.job?.jobId ?? ''}",
        "job_alloc_id": "${Global.job?.jobAllocId ?? ''}",
        "cost_refno": null,
        "sub_total": "$total",
        "tax_rate": "${Global.taxRate}",
        "tp_tax_total": "$tax",
        "tp_grand_total": "${total + tax}",
        "process_id": "${Helper.user?.processId}",
        "job_manager": "$name",
        "job_contact": "$mobile",
        "job_notes": "${Global.substan}",
        "wp_pm_notes": null,
        "wp_pm_substantiation": null,
        "tp_job_substantiation": "${Global.substan}",
        "wp_grand_total": null,
        "wp_tax_total": null,
        "date": "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        "wp_rate_set_id": null,
        "quote_date": "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        "quote_no": null,
        "wp_sub_total": null,
        "tp_invoice_no": null,
        "source": "2",
        "status": "$status",
        "rebate_total": null,
        "mark_complete": null,
        "tp_pay_dt": null,
        "Upload_by": "${Helper.user?.id ?? ''}",
        "tp_invoice_dt": null,
        "owner": "${Helper.user?.id ?? ''}",
        "created_by": "${Helper.user?.id ?? ''}",
        "last_modified_by": null,
        "created_at": "${dateTime}",
        "last_updated_at": null
      };

      print('head data----->${head}');
      //return;

      await Helper.post("costformhead/CreateWithNewID", head, is_json: true)
          .then((data) {
        print('create head ==> ${data.body}');
        getHeadId().then((headId) {
          createDetail(status, headId);
        });
      });
    }
  }

  // void createDetail(int status, String headId) {
  //   var dets = crewDetails.where((test) => test.detail == null).toList();
  //
  //   if (dets.length > 0) Helper.showProgress(context, 'Creating Detail');
  //   dets.asMap().forEach((index, it) async {
  //     var detail = {
  //       "id": null,
  //       "head_id": "$headId",
  //       "job_id": "${Global.job?.jobId ?? ''}",
  //       "job_alloc_id": "${Global.job?.jobAllocId ?? ''}",
  //       "cost_refno": null,
  //       "item_desc": " ",
  //       "item_id": "${it.itemId}",
  //       "item_qty": "${it.count}",
  //       "item_hrs": "${it.hour}",
  //       "item_price": "${it.hourlyRate}",
  //       "item_total":
  //           "${it.count * it.hour * double.parse(it.hourlyRate.toString())}",
  //       "item_rate": "${it.rateClass}",
  //       "quote_inc": "1",
  //       "entry_point": "1",
  //       "wp_qty": null,
  //       "wp_desc": null,
  //       "wp_rate": null,
  //       "wp_hrs": null,
  //       "wp_total": null,
  //       "process_id": "${Helper.user?.processId ?? ''}",
  //       "owner": "${Helper.user?.id ?? ''}",
  //       "created_by": "${Helper.user?.id ?? ''}",
  //       "last_modifies_by": "",
  //       "created_at":
  //           "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
  //       "last_updated_at": ""
  //     };
  //     await Helper.post("costformdetail/CreateWithNewID", detail, is_json: true)
  //         .then((data) {
  //       if (index == dets.length - 1) Helper.hideProgress();
  //       print('create detail ==> $detail \n ${data.body}');
  //     });
  //   });
  //   updateHeadStatus(status);
  // }

  void createDetail(int status, String headId) async {
    var dets = crewDetails.where((test) => test.detail == null).toList();

    if (dets.isNotEmpty) {
      Helper.showProgress(context, 'Creating Detail');
    }

    try {
      for (var index = 0; index < dets.length; index++) {
        var it = dets[index];
        var detail = {
          "id": null,
          "head_id": "$headId",
          "job_id": "${Global.job?.jobId ?? ''}",
          "job_alloc_id": "${Global.job?.jobAllocId ?? ''}",
          "cost_refno": null,
          "item_desc": " ",
          "item_id": "${it.itemId}",
          "item_qty": "${it.count}",
          "item_hrs": "${it.hour}",
          "item_price": "${it.hourlyRate}",
          "item_total":
          "${it.count * it.hour * double.parse(it.hourlyRate.toString())}",
          "item_rate": "${it.rateClass}",
          "quote_inc": "1",
          "entry_point": "1",
          "wp_qty": null,
          "wp_desc": null,
          "wp_rate": null,
          "wp_hrs": null,
          "wp_total": null,
          "process_id": "${Helper.user?.processId ?? ''}",
          "owner": "${Helper.user?.id ?? ''}",
          "created_by": "${Helper.user?.id ?? ''}",
          "last_modifies_by": "",
          "created_at":
          "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
          "last_updated_at": ""
        };

        try {
          var response = await Helper.post("costformdetail/CreateWithNewID", detail, is_json: true);
          print('create detail ==> $detail \n ${response.body}');
        } catch (e) {
          print('Error creating detail: $e');
        }

        if (index == dets.length - 1) {
          Helper.hideProgress();
        }
      }
    } finally {
      // Ensure progress is hidden even if there is an error
      if (dets.isNotEmpty) {
        Helper.hideProgress();
      }
    }

    updateHeadStatus(status);
  }


  void updateHeadStatus(int status) {
    if (status == 4) {
      status = 4;
    } else {
      if (total < approval_limit) {
        status = 2;
      } else {
        status = 1;
      }
    }
    // if ((total < approval_limit ) && status != 4) {
    //   status = 2; //Approve
    // } else {
    //   status = 1; //submit
    // }
    print('head update stst=$status');
    //status =4 save
    Helper.showProgress(context, 'Updaing Head Status');
    Helper.get(
        "nativeappservice/updateCostFormHeadStatus?job_alloc_id=${Global.job?.jobAllocId??''}&job_id=${Global.job?.jobId??''}&status=$status",
        {}).then((data) async {
      Helper.hideProgress();
      print('update head status==>${data.body}');
      var json = jsonDecode(data.body);
      if (json['success'] == 1) {
        switch (status) {
          case 1:
            await Helper.updateNotificationStatus(Global.job?.jobAllocId ?? '');
            await Helper.showSingleActionModal(
              context,
              title: 'Costing Info',
              description:
                  'Your quote has been submitted successfully.Enviro will let you know once the quote is Approved.',
            );
            try {
              Navigator.of(context).popUntil(ModalRoute.withName('dashboard'));
            } catch (e) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'site_inspection', ModalRoute.withName('dashboard'));
            }
            break;
          case 2:
            await Helper.updateNotificationStatus(Global.job!.jobAllocId ?? '');
            await Helper.showSingleActionModal(
              context,
              title: 'Costing Approved',
              description:
                  'Your quote has been approved subject to an audit. You can proceed to complete the job. ',
            );
            var action = await Helper.showMultiActionModal(context,
                title: 'Confirmation!',
                description: 'Would you like to complete the Job?',
                negativeButtonText: 'NO',
                negativeButtonimage: 'reject.svg',
                positiveButtonText: 'YES',
                positiveButtonimage: 'accept.svg');
            if (action!) {
              var sched = {
                "id": null,
                "job_id": "${Global.job?.jobId ?? ''}",
                "job_alloc_id": "${Global.job?.jobAllocId ?? ''}",
                "visit_type": "3",
                "sched_date":
                    "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                "sched_note": null,
                "process_id": "${Helper.user?.id ?? ''}",
                "owner": "${Helper.user?.id ?? ''}",
                "created_by": "${Helper.user?.id ?? ''}",
                "last_modified_by": null,
                "created_at":
                    "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
                "last_updated_at": null,
                "end_time": null,
                "start_time":
                    "${DateFormat('hh:mm aa').format(DateTime.now())}",
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
                "comm_recipient": "",
                "comm_recipient_subcatg": null,
                "version": await Helper.getAppVersion()
              };
              Helper.showProgress(context, 'Creating Schedule');
              Helper.post("JobSchedule/CreateWithNewID", sched, is_json: true)
                  .then((data) {
                Helper.hideProgress();
                print('schedule ==>${data.body}');
                try {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'invoice', ModalRoute.withName('dashboard'));
                } catch (e) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'invoice', ModalRoute.withName('dashboard'));
                }
              }).catchError((onError) {
                Helper.hideProgress();
              });
            } else {
              Navigator.of(context).popUntil(ModalRoute.withName('dashboard'));
            }
            break;
          case 4:
            await Helper.showSingleActionModal(
              context,
              title: 'Costing Info',
              description:
                  'Your costing has been saved.Please submit for quote to be processed.',
            );
            try {
              print('trying this');
              // Navigator.pushReplacementNamed(context, 'site_inspection');
              Navigator.popUntil(context,
                  ModalRoute.withName('site_inspection'));
            } catch (e) {
              print('this is $e');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'site_inspection', ModalRoute.withName('dashboard'));
            }
            break;
          default:
        }
      }
    }).catchError((onError) {
      Helper.hideProgress();
    });
  }

  Future<dynamic> getHeadId() async {
    var id;
    Helper.showProgress(context, 'Getting Head Id');
    await Helper.get(
        "costformhead/getLastInsertedId?job_id=${Global.job?.jobId ?? ''}&job_alloc_id=${Global.job?.jobAllocId ?? ''}",
        {}).then((data) {
      Helper.hideProgress();
      id = data.body;
    }).catchError((onError) {
      Helper.hideProgress();
    });
    id = id.toString().replaceAll('"', '');
    return await id;
  }

  void getContractorDetails() {
    Helper.get(
        "nativeappservice/getJobManagerAndContactNoForApp?user_id=${Helper.user?.id ?? ''}",
        {}).then((data) {
      var json = jsonDecode(data.body) as List;
      mobile = json[0]['mobile'];
      name = json[0]['fullname'];
    });
  }
}
