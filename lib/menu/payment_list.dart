import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Job.dart';

class PaymentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PaymentListState();
  }
}

class PaymentListState extends State<PaymentList> {
  var filterCtrl = TextEditingController();
  var counter = 10;
  List<Job>? quotes = null;
  List<Job>? filtered = null;
  bool is_fetching = false;

  @override
  void initState() {
    print("ibiting");
    is_fetching = true;
    Helper.get(
        "nativeappservice/jobinfoPayments?contractor_id=${Helper.user?.companyId}&process_id=1",
        {}).then((response) {
      setState(() {
        is_fetching = false;
      });
      quotes = (json.decode(response.body) as List)
          .map((f) => Job.fromJson(f))
          .toList();
      filtered = [];
      filtered!.addAll(quotes!);

      print("type=${quotes.runtimeType}");
    }).catchError((error) {
      setState(() {
        is_fetching = false;
      });
      print(error);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Payment"),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height - 10,
          //margin: EdgeInsets.only(left: 15.0,right: 15.0),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  controller: filterCtrl,
                  onChanged: (text) {
                    if (text == '' || text.length == 0) {
                      print('len zer');
                      filtered = [];
                      filtered!.addAll(quotes!);
                    } else {
                      print('non zero');
                      filtered = [];
                      quotes!.forEach((job) {
                        if (job.jobDesc!.toLowerCase().contains(text) ||
                            job.address!.toLowerCase().contains(text) ||
                            job.jobNo!.toLowerCase().contains(text) ||
                            job.jobStatus!.toLowerCase().contains(text))
                          filtered!.add(job);
                      });
                    }
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      hintText: "Search Job no, Site Address, Claim...",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              filterCtrl.clear();
                              filtered?.addAll(quotes!);
                            });
                          })),
                ),
              ),
              is_fetching
                  ? Center(
                      child: Column(
                        children: <Widget>[
                          CircularProgressIndicator(
                            backgroundColor: Colors.black,
                          ),
                          Text("Loading")
                        ],
                      ),
                    )
                  : Flexible(
                      child: ListView.builder(
                        itemCount: quotes == null ? 0 : filtered!.length,
                        itemBuilder: (context, index) {
                          var quote = filtered![index];
                          if (quote.payDate == null)
                            quote.payDate = '00/01/0000';
                          if (quote.invoiceDate == null)
                            quote.invoiceDate = '00/01/0000';
                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                          print(formattedDate);
                          var inv_date = quote.invoiceDate?.split('/');
                          var pay_date = quote.payDate?.split('/');
                          return Container(
                            color: index % 2 == 0
                                ? Themer.listEvenColor
                                : Themer.listOddColor,
                            child: SizedBox(
                                height: 260,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Job No: TM ${quote.jobNo}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Themer.textGreenColor)),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                  'assets/images/receipt.svg',
                                                  height: 18),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  "${inv_date![0]}${Helper.getOrdinal(int.parse(inv_date[0]))} ${Helper.intToMonth(int.parse(inv_date[1]))} ${inv_date[2]}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Themer
                                                          .textGreenColor))
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: SvgPicture.asset(
                                                  'assets/images/location_black.svg')),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                              child: Container(
                                            child: Text(
                                              quote.address ?? '   ',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          )),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(Helper.countryCode ==
                                                  "UK"
                                              ? 'assets/images/pound_symbol.svg'
                                              : 'assets/images/dollar-symbol_black.svg', height: 20,),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                              child: Container(
                                            child: Text(
                                              "Payment on ${pay_date![0]}${Helper.getOrdinal(int.parse(pay_date[0]))} ${Helper.intToMonth(int.parse(pay_date[1]))} ${pay_date[2]}",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          )),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                  height: 100.0,
                                                  width: 100.0,
                                                  margin: EdgeInsets.only(
                                                      bottom: 10.0),
                                                  child: FittedBox(
                                                    child: FloatingActionButton(
                                                        heroTag:
                                                            '${quote.jobId}',
                                                        child: SvgPicture.asset(
                                                            'assets/images/requestupdate_button_2x.svg'),
                                                        onPressed: () async {
                                                          Global.job = quote;
                                                          var msg = await Navigator
                                                              .pushNamed(
                                                                  context,
                                                                  'comment_box',
                                                                  arguments: {
                                                                'title':
                                                                    'Payments',
                                                                'sub_title':
                                                                    ' ',
                                                                'option': Global
                                                                    .payment,
                                                                'text': ''
                                                              });
                                                          if (msg != null) {
                                                            requestUpdate(
                                                                quote);
                                                          }
                                                        }),
                                                  )),
                                              Text(
                                                "REQUEST UPDATE",
                                                style: TextStyle(
                                                    color:
                                                        Themer.textGreenColor),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                  height: 100.0,
                                                  width: 100.0,
                                                  margin: EdgeInsets.only(
                                                      bottom: 10.0),
                                                  child: FittedBox(
                                                    child: FloatingActionButton(
                                                        heroTag:
                                                            '${quote.jobId}_2',
                                                        child: SvgPicture.asset(
                                                            'assets/images/email_button_2x.svg'),
                                                        onPressed: () async {
                                                          Global.job = quote;
                                                          var action = await Helper.showEmailModal(
                                                              context,
                                                              title:
                                                                  'Please enter the E-Mail address',
                                                              titleTextColor: Themer
                                                                  .textGreenColor,
                                                              description: '',
                                                              negativeButtonText:
                                                                  'CLOSE',
                                                              negativeButtonimage:
                                                                  'reject.svg',
                                                              positiveButtonText:
                                                                  'SEND',
                                                              positiveButtonimage:
                                                                  'send_button.svg');
                                                          // if (action != null) {
                                                          //   print(action);
                                                          //   emailInvoie(
                                                          //       quote, action);
                                                          // }
                                                          print(action);
                                                          emailInvoie(
                                                                    quote, action);
                                                        }),
                                                  )),
                                              Text(
                                                "EMAIL INVOICE",
                                                style: TextStyle(
                                                    color:
                                                        Themer.textGreenColor),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
    );
  }

  Future<void> requestUpdate(Job job) async {
    Helper.showProgress(context, 'Requesting Update');
    var post = {
      "id": null,
      "job_id": "${job.jobId}",
      "job_alloc_id": "${job.jobAllocId}",
      "visit_type": "3",
      "sched_date": "${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
      "sched_note": "Requesting payment update",
      "process_id": "${Helper.user!.id}",
      "owner": "${Helper.user!.id}",
      "created_by": "${Helper.user!.id}",
      "last_modified_by": null,
      "created_at":
          "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
      "last_updated_at": null,
      "end_time": null,
      "start_time": "${DateFormat("hh:mm aa").format(DateTime.now())}",
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
      "comm_recipient": "Request Payment Update",
      "comm_recipient_subcatg": null,
      "version": await Helper.getAppVersion()
    };
    Helper.post('JobSchedule/Create', post, is_json: true).then((data) {
      Helper.hideProgress();
      var json = jsonDecode(data.body);
      if (json['success'] == 1) {
        Helper.showSingleActionModal(
          context,
          title: 'Thank You',
          description:
              'Thank you for requesting update on this Job. We will get back to you with Details.',
        );
      }
    }).catchError((onError) {
      Helper.hideProgress();
      print(onError.toString());
    });
  }

  void emailInvoie(Job job, String email) {
    Helper.showProgress(context, 'Sending Invoice');
    var post = {
      "params": {
        "user_id": "${Helper.user!.id}",
        "job_alloc_id": "${job.jobAllocId}",
        "contractor_id": "${Helper.user!.companyId}",
        "process_id": "${Helper.user!.processId}",
        "email": "$email"
      }
    };
    Helper.post('nativeappservice/sendInvoiceToUser', post, is_json: true)
        .then((data) {
      Helper.hideProgress();
      var json = jsonDecode(data.body);
      Helper.showSingleActionModal(context,
          title: 'Thank You', description: json['msg']);
    }).catchError((onError) {
      Helper.hideProgress();
      print(onError.toString());
    });
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}
