import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';

class GenInvoice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GenInvoiceState();
  }
}

class GenInvoiceState extends State<GenInvoice> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubTotal();
  }

  var subTotal = "${Helper.currencySymbol} 0.00";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
      appBar: Helper.getAppBar(context,
          title: "Invoice", sub_title: 'Job TM# ${Global.job?.jobNo??''}'),
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
            padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
            decoration: BoxDecoration(color: Colors.white),
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(
                            text: 'Invoice No: ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'OpenSams'),
                            children: [
                          TextSpan(
                              text: '13905',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Themer.textGreenColor,
                                  fontFamily: 'OpenSams'))
                        ])),
                    Text(
                        'You have successfully completed the work accept by you and you can raise the invoice now.'),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Amount (Ex.Tax)'),
                    Text(
                      subTotal,
                      style: TextStyle(
                          color: Themer.textGreenColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 70,
                          fontFamily: 'OpenSans'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'pdf_viewer', arguments: {
                          "url":
                              'generate/CostingReport?job_id=${Global.job?.jobId}&job_alloc_id=${Global.job!.jobAllocId}',
                          'title': 'Review Quote'
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/images/review_quote.svg'),
                          Text(
                            'Review Quote',
                            style: TextStyle(
                                color: Themer.textGreenColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'OpenSans'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                //Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                              height: 60.0,
                              width: 60.0,
                              margin: EdgeInsets.only(bottom: 10.0, top: 30),
                              child: FittedBox(
                                child: FloatingActionButton(
                                    heroTag: 'dialog_action_1',
                                    child: SvgPicture.asset(
                                      "assets/images/submit_button.svg",
                                      height: 60,
                                      width: 60,
                                    ),
                                    onPressed: () async {
                                      print(
                                          'invoice==>${Global.invoice?.toJson()}');
                                      Helper.showProgress(
                                          context, 'Submitting Invoice');
                                      Helper.post('jobinvoice/Create',
                                              Global.invoice!.toJson(),
                                              is_json: true)
                                          .then((value) async {
                                        Helper.hideProgress();
                                        var json = jsonDecode(value.body);
                                        if (json['success'] == 1) {
                                          await updateInvoiceNo();
                                          if (Global.base64Sign != null &&
                                              Global.invoice?.customerYn ==
                                                  "YES") {
                                            createSignRecord();
                                          } else {
                                            await Helper
                                                .updateNotificationStatus(
                                                    Global.job?.jobAllocId??'');
                                            await Helper.showSingleActionModal(
                                                context,
                                                title: 'Thank You',
                                                description:
                                                    'Thanks for completing the Job, Enviro Team will reach out if any further details are required.');
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                'dashboard',
                                                ModalRoute.withName(
                                                    'dashboard'));
                                          }
                                        }
                                      }).catchError((onError) {
                                        Helper.hideProgress();
                                      });
                                    }),
                              )),
                          Text(
                            "SUBMIT INVOICE",
                            style: TextStyle(color: Themer.textGreenColor),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                              height: 60.0,
                              width: 60.0,
                              margin: EdgeInsets.only(bottom: 10.0, top: 30),
                              child: FittedBox(
                                child: FloatingActionButton(
                                    heroTag: 'dialog_action_2',
                                    child: SvgPicture.asset(
                                      "assets/images/cancel_outline_button.svg",
                                      height: 60,
                                      width: 60,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, 'invoice');
                                    }),
                              )),
                          Text(
                            "CANCEL",
                            style: TextStyle(color: Themer.textGreenColor),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateInvoiceNo() async {
    await Helper.get(
        'costformhead/getTpInvoiceNoAndAmount?job_id=${Global.job!.jobId}&job_alloc_id=${Global.job!.jobAllocId}&process_id=${Helper.user?.processId.toString()}&user_id=${Helper.user?.id}',
        {}).then((value) async {
      var invoiceDetail = jsonDecode(value.body);
      var post = {
        "params": {
          'tp_invoice_no': (() {
            if (invoiceDetail[0]['tp_invoice_no'] == null)
              return Global.job?.jobId??'';
            else
              return invoiceDetail[0]['tp_invoice_no'].toString();
          }()),
          'job_id': Global.job?.jobId??'',
          'job_alloc_id': Global.job?.jobAllocId??''
        }
      };
      await Helper.post('costformhead/updateTpInvoiceNo', post, is_json: true)
          .then((value) {});
      var post2 = {
        "params": {
          'job_id': Global.job?.jobId??'',
          'job_alloc_id': Global.job?.jobAllocId??'',
          'inv_status': '1',
          'invDate': "${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
          'source ': '2'
        }
      };
      Helper.post('Joballocation/updateTpInvoiceStatus', post2, is_json: true)
          .then((value) {});
    });
  }

  void createSignRecord() {
    var sign = {
      "job_id": "${Global.job?.jobId??''}",
      "job_alloc_id": "${Global.job?.jobAllocId??''}",
      "company_id": "${Helper.user?.companyId??''}",
      "upload_type": 0,
      "upload_type_detail": 0,
      "inc_quote": 1,
      "id": null,
      "hide": 2,
      "file_name": "CSO_Sign.jpg",
      "file_description": '10041',
      "process_id": "${Helper.user?.processId??''}",
      "docComment": null,
      "file_path":
          "${Global.job?.jobId??''}/${Global.job?.jobAllocId??''}/CSO_Sign.jpg",
      "UploadedBy": "${Helper.user?.id??''}",
      "created_at":
          "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
      "upload_by": "${Helper.user?.id??''}",
      "upload_at":
          "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
      "file_size": 0,
      "status": 1
    };
    Helper.post('uploaddocuments/Create', sign, is_json: true).then((value) {
      saveSignFile();
    });
  }

  void saveSignFile() {
    var signFile = {
      "imgPath": "data:image/jpeg;base64,${Global.base64Sign}",
      "jobId": "${Global.job?.jobId??''}",
      "jobAllocId": "${Global.job?.jobAllocId??''}",
      "imgName": "CSO_Sign"
    };
    Helper.post('uploadimages/uploadAppDoc', signFile, is_json: true)
        .then((value) async {
      await Helper.updateNotificationStatus(Global.job?.jobAllocId??'');
      await Helper.showSingleActionModal(context,
          title: 'Thank You',
          description:
              'Thanks for completing the Job, Enviro Team will reach out if any further details are required.');
      Navigator.pushNamedAndRemoveUntil(
          context, 'dashboard', ModalRoute.withName('dashboard'));
    });
  }

  getSubTotal() {
    Helper.get(
        'nativeappservice/getTPCostforInvoice?job_alloc_id=${Global.job?.jobAllocId??''}',
        {}).then((value) {
      var json = jsonDecode(value.body) as List;
      if (json.length > 0) {
        setState(() {
          subTotal = "${Helper.currencySymbol} ${json[0]["sub_total"]}";
        });
      }
    });
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
