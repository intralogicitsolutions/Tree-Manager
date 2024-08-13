import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/FenceInfo.dart';
import 'package:tree_manager/pojo/Job.dart';
import 'package:tree_manager/pojo/tree_info.dart';

class QuoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QuoteListState();
  }
}

class _QuoteListState extends State<QuoteList>
    with SingleTickerProviderStateMixin {
  var counter = 10;
  List<Job> quotes = [];
  List<Job> filtered = [];
  bool is_fetching = false;
  late AnimationController _animationController;
  late Animation _animation;
   final filterCtrl = TextEditingController();

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

  // void getJobs() {
  //   Helper.get(
  //       "nativeappservice/jobinfoQuote?contractor_id=${Helper.user?.companyId}&process_id=1",
  //       {}).then((response) {
  //     setState(() {
  //       is_fetching = false;
  //     });
  //     quotes = (json.decode(response.body) as List)
  //         .map((f) => Job.fromJson(f))
  //         .toList();
  //
  //     filtered.clear();
  //     filtered.addAll(quotes);
  //     print("type=${quotes.runtimeType}");
  //   }).catchError((error) {
  //     setState(() {
  //       is_fetching = false;
  //     });
  //     print(error);
  //   });
  // }

  void getJobs() {
    Helper.get(
        "nativeappservice/jobinfoQuote?contractor_id=${Helper.user?.companyId}&process_id=1",
        {}
    ).then((response) {
      if (mounted) {
        setState(() {
          is_fetching = false;
        });
        quotes = (json.decode(response.body) as List)
            .map((f) => Job.fromJson(f))
            .toList();

        filtered.clear();
        filtered.addAll(quotes);
        print("type=${quotes.runtimeType}");
      }
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
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Quote"),
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
                    // ignore: deprecated_member_use
                    filtered = [];
                    filtered.addAll(quotes);
                  } else {
                    filtered.clear();
                    quotes.forEach((job) {
                      if (job.jobDesc!.toLowerCase().contains(text.toLowerCase()) ||
                          job.address!.toLowerCase().contains(text.toLowerCase()) ||
                          job.jobNo!.toLowerCase().contains(text.toLowerCase()) ||
                          job.siteContactName!.toLowerCase().contains(text.toLowerCase()) ||
                          job.siteContactMobile!
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          job.jobStatus!.toLowerCase().contains(text.toLowerCase()))
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
                            itemCount: quotes == null ? 0 : filtered.length,
                            itemBuilder: (context, index) {
                              var quote = filtered[index];
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                                child: QuoteListItem(
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

class QuoteListItem extends StatefulWidget {
  const QuoteListItem(
      {required this.quote, required this.index, required this.refreshJobs});

  final Job quote;
  final int index;
  final VoidCallback refreshJobs;

  @override
  _QuoteListItemState createState() => _QuoteListItemState();
}

class _QuoteListItemState extends State<QuoteListItem> {
  var date_string = "";

  @override
  void initState() {
    // var time = widget.quote.schedTime.replaceAll("pm", " pm").replaceAll("am", " am");

    // var date_split = widget.quote.schedDate.split('T')[0].split('-');
    // date_string =
    //     "${date_split[2]}th ${Helper.intToMonth(int.parse(date_split[1]))} ${time.toLowerCase()}";
    // print(date_split);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Global.job = null;
        Global.job = widget.quote;
        print(widget.quote.jobNo);
        await Navigator.of(context).pushNamed('site_inspection');
        widget.refreshJobs();
      },
      child: Container(
        color:
            widget.index % 2 == 0 ? Themer.listEvenColor : Themer.listOddColor,
        child: SizedBox(
            height: 260,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("TM ${widget.quote.jobNo}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Themer.textGreenColor)),
                      Text("${widget.quote.scheduleDisplay}",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Themer.textGreenColor)),
                    ],
                  ),
                  Text(
                    "${widget.quote.address}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
                                  heroTag: widget.quote.jobId != null ? 'photo_${widget.quote.jobId}' : 'photo_default',
                                    //heroTag: '${widget.quote.jobId}',
                                    child:
                                        SvgPicture.asset('assets/images/${(() {
                                      if (widget.quote.beforeImagesExists ==
                                          'false')
                                        return 'photo_button_2x.svg';
                                      else if (widget.quote.treeinfoExists ==
                                          'false')
                                        return 'treeinfo_button_2x.svg';
                                      else if (widget.quote.costExists ==
                                          'false')
                                        return 'costing_button_2x.svg';
                                      else
                                        return 'view_job.svg';
                                    }())}'),
                                    onPressed: () async {

                                      Global.crewDetails = null;
                                      Global.info = null;
                                      Global.info = TreeInfo();
                                      Global.fence = FenceInfo();
                                      Global.substan = '';
                                      Global.head = null;
                                      Global.site_info_update = false;
                                      Global.fence_info_update = false;
                                      Global.costing_update = false;
                                      Global.before_images = [];
                                      Global.after_images = [];
                                      Global.fence=null;
                                      Global.standing_images=[];
                                      Global.damage_images=[];

                                      Global.job = widget.quote;
                                      Global.fence=FenceInfo();
                                      if (widget.quote.beforeImagesExists ==
                                          'false')
                                        await Navigator.pushNamed(
                                            context, 'before_photos');
                                      else if (widget.quote.treeinfoExists ==
                                          'false')
                                        await Navigator.pushNamed(
                                            context, 'number_of_tree');
                                      else if (widget.quote.costExists ==
                                          'false')
                                        await Navigator.pushNamed(
                                            context, 'crew_configuration');
                                      else
                                        await Navigator.pushNamed(
                                            context, 'site_inspection');
                                      widget.refreshJobs();
                                    }),
                              )),
                          Text(
                            (() {
                              if (widget.quote.beforeImagesExists == 'false')
                                return 'PHOTOS';
                              else if (widget.quote.treeinfoExists == 'false')
                                return 'TREE INFO';
                              else if (widget.quote.costExists == 'false')
                                return 'JOB COSTING';
                              else
                                return 'VIEW JOB';
                            }()),
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
                                  heroTag:  widget.quote.jobId != null
                                      ? 'location_${widget.quote.jobId}'
                                      : 'location_default',
                                  //  heroTag: '${widget.quote.jobId}_2',
                                    child: SvgPicture.asset(
                                        'assets/images/location_button_2x.svg'),
                                    onPressed: () async {
                                      var action =
                                          await Helper.showMultiActionModal(
                                              context,
                                              title: 'Site Address',
                                              description:
                                                  widget.quote.address ?? ' ',
                                              negativeButtonText:
                                                  'GET DIRECION',
                                              negativeButtonimage:
                                                  'get_direction.svg',
                                              positiveButtonText: 'VIEW ON MAP',
                                              positiveButtonimage:
                                                  'view_on_map.svg');
                                      if (action == true) {
                                        Helper.openDirection(
                                            widget.quote.address??'');
                                      } else if (action == false) {
                                        Helper.openMap(widget.quote.address??'');
                                      }
                                    }),
                              )),
                          Text(
                            "LOCATION",
                            style: TextStyle(color: Themer.textGreenColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
