import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/helper.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/pojo/Job.dart';

class ReportList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReportState();
  }
}

class ReportState extends State<ReportList> {
  var counter = 10;
  List<Job>? quotes = [];
  bool is_fetching = false;

  @override
  void initState() {
    print("ibiting");
    is_fetching = true;
    Helper.get(
        "nativeappservice/jobinfoReports?contractor_id=${Helper.user!.companyId}&process_id=1",
        {}).then((response) {
      setState(() {
        is_fetching = false;
      });
      quotes = (json.decode(response.body) as List)
          .map((f) => Job.fromJson(f))
          .toList();

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
    //Helper.bottom_nav_selected = 3;

    return Scaffold(
      appBar: Helper.getAppBar(context, title: "Reports"),
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
                      prefixIcon: Icon(Icons.search)),
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
                      child: quotes!.length != 0
                          ? ListView.builder(
                              itemCount: quotes == null ? 0 : quotes!.length,
                              itemBuilder: (context, index) {
                                var quote = quotes![index];
                                var date_string = '';
                                var idate_string = '';
                                try {
                                  var date = quote.payDate?.split("/");
                                  var date_split = date;
                                  print(date_split);
                                  date_string =
                                      "${date_split![0]}${Helper.getOrdinal(int.parse(date_split[0]))} ${Helper.intToMonth(int.parse(date_split[1]))} ${date_split[2]}";

                                  var idate = quote.invoiceDate?.split("/");
                                  var idate_split = idate;
                                  print(idate_split);
                                  idate_string =
                                      "${idate_split![0]}${Helper.getOrdinal(int.parse(idate_split[0]))} ${Helper.intToMonth(int.parse(idate_split[1]))} ${idate_split[2]}";
                                } catch (e) {}
                                return GestureDetector(
                                  onTap: () {
                                    Global.job = quote;
                                    Navigator.pushNamed(context, 'report_view');
                                  },
                                  child: Container(
                                    color: index % 2 == 0
                                        ? Themer.listEvenColor
                                        : Themer.listOddColor,
                                    child: SizedBox(
                                        height: 260,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 5, 15, 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Text("Job No: TM ${quote.jobNo}",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Themer
                                                          .textGreenColor)),
                                              // quote.jobDesc!.text
                                              //     .color(Colors.black)
                                              //     .size(16)
                                              //     .fontFamily('OpenSans')
                                              //     .make(),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                      'assets/images/location_black.svg'),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                      child: Text(
                                                          quote.address ??
                                                              ' ')),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5),
                                                      child: SvgPicture.asset(
                                                          'assets/images/work_black.svg')),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Flexible(
                                                      child: Text(
                                                          'Completed on ' +
                                                                  idate_string)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5),
                                                      child: SvgPicture.asset(Helper
                                                                  .countryCode ==
                                                              "UK"
                                                          ? 'assets/images/pound_symbol.svg'
                                                          : 'assets/images/dollar-symbol_black.svg')),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Flexible(
                                                      child: Text(
                                                          'Payment paid on ' +
                                                                  date_string)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
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
