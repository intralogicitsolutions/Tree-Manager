import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Job.dart';
import 'package:tree_manager/pojo/Staff.dart';
import 'package:tree_manager/pojo/Task.dart';
import 'package:tree_manager/pojo/equip.dart';
import 'package:tree_manager/pojo/network_image.dart';
import 'package:tree_manager/pojo/option.dart';

class InvoiceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InvoiceState();
  }
}

class InvoiceState extends State<InvoiceList>
    with SingleTickerProviderStateMixin {
  var counter = 10;
  List<Job>? quotes = [];
  bool is_fetching = false;

  late AnimationController _animationController;
  late Animation _animation;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 8.0).animate(_animationController)
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
        "nativeappservice/jobinfoInvoice?contractor_id=${Helper.user?.companyId??''}&process_id=1",
        {}).then((response) {
      setState(() {
        is_fetching = false;
      });
      quotes = (json.decode(response.body) as List)
          .map((f) => Job.fromJson(f))
          .toList();

      print('job data ===>>> ${response.body}');
      filtered.clear();
      filtered.addAll(quotes!);

      print("type=${quotes.runtimeType}");
    }).catchError((error) {
      setState(() {
        is_fetching = false;
      });
      print(error);
    });
  }

  List<Job> filtered = [];
  var filterCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Invoice"),
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
                    filtered = [];
                    quotes?.forEach((job) {
                      if (job.address!
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          job.jobNo!
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          job.jobStatus!
                              .toLowerCase()
                              .contains(text.toLowerCase())) filtered.add(job);
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
                                child: InvoiceListItem(
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
    Helper.bottomClickAction(index, context, setState);
  }
}

class InvoiceListItem extends StatefulWidget {
  const InvoiceListItem(
      {Key? key,
      required this.quote,
      required this.index,
      required this.refreshJobs})
      : super(key: key);

  final Job quote;
  final int index;
  final VoidCallback refreshJobs;

  @override
  _InvoiceListItemState createState() => _InvoiceListItemState();
}

class _InvoiceListItemState extends State<InvoiceListItem> {
  var date_string = "";
  @override
  void initState() {
    // var time =
    //     widget.quote.schedTime?.replaceAll("pm", " pm")?.replaceAll("am", " am");

    // var date_split = widget.quote.quoteDate?.split('T')[0]?.split('-');
    // date_string =
    //     "${date_split[2]}th ${Helper.intToMonth(int.parse(date_split[1]))} ${time?.toLowerCase()}";
    // print(date_split);
    print("job data --->${widget.quote.toJson()}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Global.job = widget.quote;
        await Navigator.pushNamed(context, 'invoice');
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
                    widget.quote.address ?? '',
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
                                    heroTag: 'photo_${widget.quote.jobId}_${UniqueKey()}',
                                    //heroTag: '${widget.quote.jobId}',
                                    child: SvgPicture.asset(
                                        'assets/images/${actionIcon(widget.quote)}'),
                                    onPressed: () {
                                      Global.job = widget.quote;
                                      doAction(widget.quote);
                                    }),
                              )),
                          Text(
                            actionString(widget.quote),
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
                                    heroTag: 'location_${widget.quote.jobId}_${UniqueKey()}',
                                    //heroTag: '${widget.quote.jobId}_2',
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

  String actionIcon(Job job) {
    if (job.siteHazard == 'false')
      return 'sitehazard_button_2x.svg';
    else if (job.afterImagesExists == 'false')
      return 'photo_button_2x.svg';
    else if (job.invoiceComplete == 'false')
      return 'completejob_button_2x.svg';
    else
      return 'view_job.svg';
  }

  String actionString(Job job) {
    if (job.siteHazard == 'false')
      return 'SITE HAZARD';
    else if (job.afterImagesExists == 'false')
      return 'AFTER PHOTOS';
    else if (job.invoiceComplete == 'false')
      return 'COMPLETE JOB';
    else
      return 'VIEW JOB';
  }

  Future<void> doAction(Job job) async {
    Global.before_images = null;
    Global.before_images = null;
    Global.after_images = null;
    Global.hazard = null;
    Global.site_hazard_update = false;
    Global.base64Sign = null;
    Global.signs = null;
    Global.signRequired = false;
    Global.invoiceAllowed = false;
    Global.sel_j_color = null;
    Global.sel_t_color = null;
    Global.sel_m_color = null;
    Global.sel_w_color = null;

    Global.sel_j_other_ctrl = [];
    Global.sel_t_other_ctrl = [];
    Global.sel_m_other_ctrl = [];
    Global.sel_w_other_ctrl = [];

    Global.sel_j_other_task = [];
    Global.sel_t_other_task = [];
    Global.sel_m_other_task = [];
    Global.sel_w_other_task = [];

    Global.sel_j_task = [];
    Global.sel_t_task = [];
    Global.sel_m_task = [];
    Global.sel_w_task = [];

    Global.sel_j_ctrl = [];
    Global.sel_t_ctrl = [];
    Global.sel_m_ctrl = [];
    Global.sel_w_ctrl = [];

    Global.hzd_sel_staff = [];
    Global.hzd_sel_equip = [];
    Global.hzd_sel_task = [];

    Global.hzd_sel_other_staff = [];
    Global.hzd_sel_other_equip = [];

    Helper.showProgress(context, 'Getting Job Details');
    await Helper.get(
            "nativeappservice/jobdetailInfo?job_alloc_id=${job.jobAllocId}", {})
        .then((response) {
      Helper.hideProgress();
      setState(() {
        print('inside state');
        Global.job = Job.fromJson(jsonDecode(response.body)[0]);
      });
    }).catchError((error) {
      Helper.hideProgress();
    });
    Helper.hideProgress();

    if (job.siteHazard == 'false') {
      var action = await Helper.showMultiActionModal(context,
          title: 'Choose an Action',
          positiveButtonText: 'ENVIRO FORM',
          negativeButtonText: 'UPLOAD',
          negativeButtonimage: 'enviro_form.svg',
          positiveButtonimage: 'gallery_button.svg');
      if (action == true) {
        getAllData(job);
      } else if (action == false) {
        await Navigator.pushNamed(context, 'hazard_upload',
            arguments: {"from_review": false});
      }
    } else if (job.afterImagesExists == 'false')
      await gotoHazardUploads(job);
    else if (job.invoiceComplete == 'false')
      await Navigator.pushNamed(context, 'accident');
    else
      await Navigator.pushNamed(context, 'invoice');
    widget.refreshJobs();
  }

  Future<void> gotoHazardUploads(Job job) async {
    Helper.showProgress(context, 'Getting Images');
    Helper.get(
        "uploadimages/getUploadImgsByJobIdAllocId?job_alloc_id=${job.jobAllocId}&job_id=${job.jobId}",
        {}).then((data) async {
      Helper.hideProgress();
      print('data---->${data.body}');
      var images = (jsonDecode(data.body) as List)
          .map((f) => NetworkPhoto.fromJson(f))
          .toList();
      Global.before_images = [];
      Global.after_images = [];
      Global.hazard_images = [];
      images.forEach((f) {
        if (f.imgType == '1') Global.before_images!.add(f);
        if (f.imgType == '2') Global.after_images!.add(f);
        if (f.imgType == '3') Global.hazard_images!.add(f);
      });
      await Navigator.pushNamed(context, 'hazard_photos');
    }).catchError((onError) {
      Helper.hideProgress();
      print(onError.toString());
    });
  }

  void getAllData(Job job) {
    Helper.showProgress(context, 'Caching dependencies..');
    Helper.get(
        'nativeappservice/chkSignOff?job_id=${job.jobId}&job_alloc_id=${job.jobAllocId}&process_id=${Helper.user?.processId??''}',
        {}).then((data) {
      Global.signRequired = jsonDecode(data.body)['signOffRequired'] == 'true';
    });

    Helper.get(
        'nativeappservice/chkInvoice?job_id=${job.jobId}&job_alloc_id=${job.jobAllocId}&process_id=${Helper.user?.processId??''}',
        {}).then((data) {
      Global.invoiceAllowed = jsonDecode(data.body)['invoiceAllowed'] == 'true';
    });

    if (Global.hazard_uploads == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Hazard%20Upload%20Options',
          {}).then((value) {
        Global.hazard_uploads = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });
    Helper.get(
        'nativeappservice/getAllUsersByCompany?contractor_id=${Helper.user?.companyId??''}&job_alloc_id=${job.jobAllocId}&process_id=${Helper.user?.processId??''}',
        {}).then((value) {
      Global.hzd_staffs = (jsonDecode(value.body) as List)
          .map((e) => Staff.fromJson(e))
          .toList();
      Helper.get(
          'nativeappservice/getAllEquipmentForSHF?contractor_id=${Helper.user?.companyId??''}&job_alloc_id=${job.jobAllocId}&process_id=${Helper.user?.processId??''}',
          {}).then((value) {
        Helper.hideProgress();
        Global.hzd_equips = (jsonDecode(value.body) as List)
            .map((e) => Equip.fromJson(e))
            .toList();
        Navigator.pushNamed(context, 'staff_selection',
            arguments: {"from_review": false});
      }).catchError((onError) => Helper.hideProgress());
    }).catchError((onError) => Helper.hideProgress());

    if (Global.hzd_qstn == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=SHF%20Questions',
          {}).then((value) {
        Global.hzd_qstn = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
        if (Global.hazard != null) {
          Global.hzd_sel_answr =
              Global.hazard!.questionnaire!.split(',').toList();
        }
      });

    Helper.get(
        'nativeappservice/getAllTasksForSHF?contractor_id=${Helper.user?.companyId??''}&job_alloc_id=${job.jobAllocId}&process_id=${Helper.user?.processId??''}',
        {}).then((value) {
      var json = (jsonDecode(value.body) as List)[0] as Map<String, dynamic>;
      Global.hzd_task = [];
      for (var i = 0; i < 10; i++) {
        if (json.containsKey("Label$i")) {
          Global.hzd_task?.add(Task(
            label: json["Label$i"],
            value: json["Value$i"],
            caption: json["Label$i"],
          ));
        }
      }
    });

    if (Global.w_task == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Weather%20Hazards',
          {}).then((value) {
        Global.w_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.w_rate == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Weather%20Risk',
          {}).then((value) {
        Global.w_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.w_ctrl == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Weather%20Control',
          {}).then((value) {
        Global.w_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    ////
    if (Global.j_task == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Job%20Site%20Hazards',
          {}).then((value) {
        Global.j_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.j_rate == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Job%20Site%20Risk',
          {}).then((value) {
        Global.j_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.j_ctrl == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Job%20Site%20Control',
          {}).then((value) {
        Global.j_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    ////
    if (Global.t_task == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Tree%20Hazards',
          {}).then((value) {
        Global.t_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.t_rate == null)
      Helper.get('nativeappservice/loadOptionDetails?workflow_step=Tree%20Risk',
          {}).then((value) {
        Global.t_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.t_ctrl == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Tree%20Control',
          {}).then((value) {
        Global.t_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    ////
    if (Global.m_task == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Manual%20Tasks%20Hazards',
          {}).then((value) {
        Global.m_task = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.m_rate == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Manual%20Tasks%20Risk',
          {}).then((value) {
        Global.m_rate = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });

    if (Global.m_ctrl == null)
      Helper.get(
          'nativeappservice/loadOptionDetails?workflow_step=Manual%20Tasks%20Control',
          {}).then((value) {
        Global.m_ctrl = (jsonDecode(value.body) as List)
            .map((e) => Option.fromJson(e))
            .toList();
      });
  }
}
