import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Job.dart';

class ApprovalList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ApprovalState();
  }
}

class ApprovalState extends State<ApprovalList>
    with SingleTickerProviderStateMixin {
  var counter = 10;
   List<Job>? quotes = [];
  bool is_fetching = false;
  final filterCtrl = TextEditingController();

  late AnimationController _animationController;
  late Animation _animation;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 8.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    Global.job = null;
    print("ibiting");
    is_fetching = true;
    getJobs();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void getJobs() {
    Helper.get(
        "nativeappservice/jobinfoApproval?contractor_id=${Helper.user?.companyId}&process_id=1",
        {}).then((response) {
      if (!mounted) return;
      setState(() {
        is_fetching = false;
      });
      quotes = (json.decode(response.body) as List)
          .map((f) => Job.fromJson(f))
          .toList();
      filtered.clear();
      filtered.addAll(quotes!);

      print("type=${quotes.runtimeType}");
    }).catchError((error) {
      if (!mounted) return;
      setState(() {
        is_fetching = false;
      });
      print(error);
    });
  }

  List<Job> filtered = [];
  var date_string = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Not Approved"),
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
                  decoration: InputDecoration(
                      hintText: "Search Job no, Site Address, Claim...",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              filterCtrl.clear();
                              filtered.addAll(quotes!);
                            });
                          })),
                  controller: filterCtrl,
                  onChanged: (text) {
                    if (text == '' || text.length == 0) {
                      print('len zer');
                      filtered = [];
                      filtered.addAll(quotes!);
                    } else {
                      print('non zero');
                      filtered.clear();
                      quotes?.forEach((job) {
                        if (job.address!
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            job.jobNo!
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            job.jobStatus!
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                          filtered.add(job);
                      });
                    }
                    setState(() {});
                  },
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
                      child: quotes?.length != 0
                          ? ListView.builder(
                              itemCount: quotes == null ? 0 : filtered.length,
                              itemBuilder: (context, index) {
                                var quote = filtered[index];

                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(boxShadow: (() {
                                    if (quote.overdue == '1') {
                                      return [
                                        BoxShadow(
                                            color: Themer.jobGlowColor,
                                            blurRadius: _animation.value,
                                            spreadRadius: _animation.value)
                                      ];
                                    } else
                                      return null;
                                  })()),
                                  child: ApprovalListItem(
                                    quote: quote,
                                    index: index,
                                    refreshJobs: getJobs,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                'No Data Available',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                    )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context, setState);
  }
}

class ApprovalListItem extends StatefulWidget {
  const ApprovalListItem(
      { Key? key, required this.quote, required this.index, required this.refreshJobs})
      : super(key: key);

  final Job quote;
  final int index;
  final VoidCallback refreshJobs;

  @override
  _ApprovalListItemState createState() => _ApprovalListItemState();
}

class _ApprovalListItemState extends State<ApprovalListItem> {
  var date_string = "";

  @override
  void initState() {
    try {
      var date = widget.quote.quoteDate!.split("T")[0];
      var date_split = date.split("-");
      print(date_split);
      date_string =
          "${date_split[2]}th ${Helper.intToMonth(int.parse(date_split[1]))} ${date_split[0]}";
    } catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.index % 2 == 0 ? Themer.listEvenColor : Themer.listOddColor,
      child: SizedBox(
          height: 260,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Job No: TM ${widget.quote.jobNo}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Themer.textGreenColor)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset('assets/images/location_black.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        widget.quote.address ?? ' ',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: SvgPicture.asset(Helper.countryCode == "UK"
                            ? "assets/images/pound_symbol.svg"
                            : 'assets/images/dollar-symbol_black.svg',width: 18,height:18)),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(child: Text('Quoted on ' + date_string)),
                  ],
                ),
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
                                  heroTag: '${widget.quote.jobId}',
                                  child: SvgPicture.asset(
                                      'assets/images/requestupdate_button_2x.svg'),
                                  onPressed: () async {
                                    Global.job = widget.quote;
                                    var msg = await Navigator.pushNamed(
                                        context, 'comment_box', arguments: {
                                      'title': 'Envito Approval',
                                      'sub_title': '',
                                      'option': Global.approval
                                    });
                                    if (msg != null) {
                                      var post = {
                                        "id": null,
                                        "job_id": "${Global.job?.jobId??''}",
                                        "job_alloc_id":
                                            "${Global.job?.jobAllocId??''}",
                                        "visit_type": null,
                                        "sched_date": null,
                                        "sched_note": "${msg}",
                                        "process_id": "${Helper.user?.id??''}",
                                        "owner": "${Helper.user?.id??''}",
                                        "created_by": "${Helper.user?.id??''}",
                                        "last_modified_by": null,
                                        "created_at":
                                            "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
                                        "last_updated_at": null,
                                        "end_time": null,
                                        "start_time":
                                            "${DateFormat("HH:mm:ss").format(DateTime.now())}",
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
                                        "comm_recipient": "Request Update",
                                        "comm_recipient_subcatg":
                                            "From Dashboard",
                                        "version": await Helper.getAppVersion()
                                      };
                                      Helper.post('JobSchedule/Create', post,
                                              is_json: true)
                                          .then((value) async {
                                        Helper.hideProgress();
                                        var json = jsonDecode(value.body);
                                        if (json['success'] == 1) {
                                          await Helper.showSingleActionModal(
                                              context,
                                              title: 'Thank You!',
                                              description:
                                                  'Thank you for requesting update on this Job. We will get back to you with Details.');
                                        }
                                        widget.refreshJobs();
                                      }).catchError((onError) {
                                        Helper.hideProgress();
                                      });
                                    }
                                  }),
                            )),
                        Text(
                          "REQUEST UPDATE",
                          style: TextStyle(color: Themer.textGreenColor),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
