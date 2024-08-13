import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Job.dart';
import 'package:tree_manager/pojo/Job_Mock.dart';

class JobList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return JobListState();
  }
}

class JobListState extends State<JobList> with SingleTickerProviderStateMixin{
  var filterCtrl = TextEditingController();
  var counter = 10;
  List<Job> quotes = [];
  List<Job> filtered = [];
  bool is_fetching = false;
  Map<String, dynamic>? args;

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
    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      Global.job = null;
      print("ibiting");
      is_fetching = true;
      getJobs();
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void getJobs() {
    Helper.get(
        "nativeappservice/jobinfoAllocate?contractor_id=${Helper.user?.companyId??""}&process_id=1",
        {}).then((response) {
      setState(() {
        is_fetching = false;
      });
      print('lllllll -=---===?  ${mockJsonList}');
      // // quotes = (json.decode(mockJsonList as String) as List)
      // //     .map((f) => Job.fromJson(mockJsonList as Map<String, dynamic>))
      // //     .toList();
      // // List<Job> quotes = mockJsonList.map((item) => Job.fromJson(item)).toList();
      // List<Job> quotes = mockJsonList
      //     .map((jobMap) => Job.fromJson(jobMap))
      //     .toList();

      quotes = (json.decode(response.body) as List)
          .map((f) => Job.fromJson(f))
          .toList();

      filtered.clear();
      filtered.addAll(quotes);
      if (args != null && args!.containsKey('job_no')) {
        print('has key job no');
        //filterCtrl.text = args['job_no'];
      } else {
        print('hasnt key job no');
      }

      print("type=${quotes.runtimeType}");
    }).catchError((error) {
      if (mounted) {
        setState(() {
          is_fetching = false;
        });
      }
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    Helper.bottom_nav_selected = 1;

    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Job Offers"),
      body: Container(
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
                            filtered.addAll(quotes);
                          });
                        })),
                controller: filterCtrl,
                onChanged: (text) {
                  if (text == '' || text == null || text.length == 0) {
                    print('len zer');
                    filtered = [];
                    filtered.addAll(quotes);
                  } else {
                    filtered.clear();
                    quotes.forEach((job) {
                      if ((job.jobNo?.toLowerCase().contains(text.toLowerCase())?? false ) ||
                          (job.suburb?.toLowerCase().contains(text.toLowerCase()) ?? false))
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
                    child: filtered.length != 0
                        ? ListView.builder(
                            itemCount: filtered == null ? 0 : filtered.length,
                            itemBuilder: (context, index) {
                              var quote = filtered[index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(boxShadow: (() {
                                  if (quote.overdue=='1') {
                                    return [
                                      BoxShadow(
                                          color: Themer.jobGlowColor,
                                          blurRadius: _animation.value,
                                          spreadRadius: _animation.value)
                                    ];
                                  } else
                                    return null;
                                })()),
                                child: JobListItem(
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
      bottomNavigationBar: Helper.getBottomBar(bottomClick),
    );
  }

  void bottomClick(int index) {
    Helper.bottomClickAction(index, context);
  }
}

class JobListItem extends StatefulWidget {
  const JobListItem(
      {Key? key, required this.quote, required this.index, required this.refreshJobs})
      : super(key: key);

  final Job quote;
  final int index;
  final VoidCallback refreshJobs;

  @override
  _JobListItemState createState() => _JobListItemState();
}

class _JobListItemState extends State<JobListItem> {
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
                Text(
                  "You have been offered a job at ${widget.quote.suburb}. Attendance is required within ${widget.quote.timeframe}",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                widget.quote.accepted == false
                    ? Row(
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
                                        heroTag: 'accept_${widget.quote.jobId}',
                                        child: SvgPicture.asset(
                                            'assets/images/accept.svg'),
                                        onPressed: () {
                                          Helper.showProgress(
                                              context, 'Accepting job');
                                          Helper.post(
                                              "nativeappservice/acceptRejectjob?status=1&job_id=${widget.quote.jobId}&job_alloc_id=${widget.quote.jobAllocId}",
                                              {}).then((response) {
                                            Helper.hideProgress();
                                            print(response.body);
                                            setState(() {
                                              widget.quote.accepted = true;
                                            });
                                          }).catchError((error) {
                                            Helper.hideProgress();
                                            print(error.toString());
                                          });
                                        }),
                                  )),
                              Text(
                                "ACCEPT",
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
                                        heroTag: 'reject_${widget.quote.jobId}',
                                        child: SvgPicture.asset(
                                            'assets/images/reject.svg'),
                                        onPressed: () async {
                                          Global.job = widget.quote;
                                          /*Navigator.pushNamed(
                                                  context,
                                                  'site_inspection');*/
                                          var action =
                                              await Helper.showMultiActionModal(
                                                  context,
                                                  title: 'Reject Job',
                                                  description:
                                                      'Are you sure you want to Reject this Job?',
                                                  negativeButtonimage:
                                                      'reject.svg',
                                                  negativeButtonText: 'NO',
                                                  positiveButtonText: 'YES',
                                                  positiveButtonimage:
                                                      'accept.svg');
                                          if (action == true) {
                                            Helper.showProgress(
                                                context, 'Please wait...');
                                            Helper.post(
                                                "nativeappservice/acceptRejectjob?status=2&job_id=${widget.quote.jobId}&job_alloc_id=${widget.quote.jobAllocId}",
                                                {}).then((response) {
                                              Helper.hideProgress();
                                              print(response.body);
                                              widget.refreshJobs();
                                            }).catchError((onError) {
                                              Helper.hideProgress();
                                            });
                                          }
                                        }),
                                  )),
                              Text(
                                "REJECT",
                                style: TextStyle(color: Themer.textGreenColor),
                              )
                            ],
                          )
                        ],
                      )
                    : Visibility(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 100.0,
                                  width: 100.0,
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  child: FittedBox(
                                    child: FloatingActionButton(
                                        heroTag: 'view_job_${widget.quote.jobId}',
                                        child: SvgPicture.asset(
                                            'assets/images/view_job.svg'),
                                        onPressed: () async{
                                          // setState(()
                                          // async {
                                          //   Global.job = widget.quote;
                                          //   await Navigator.of(context)
                                          //       .pushNamed('job_detail');
                                          //   widget.refreshJobs();
                                          // });
                                          Global.job = widget.quote;
                                          await Navigator.of(context).pushNamed('job_detail');
                                          widget.refreshJobs();
                                        }),
                                  )),
                              Text(
                                "VIEW JOB",
                                style: TextStyle(color: Themer.textGreenColor),
                              )
                            ],
                          ),
                        ),
                        visible: true,
                      )
              ],
            ),
          )),
    );
  }
}
