import 'dart:convert';
import 'package:intl/intl.dart';
// import 'package:background_locator/location_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_manager/auth/forgot_password.dart';
import 'package:tree_manager/auth/help_center.dart';
import 'package:tree_manager/auth/login.dart';
import 'package:tree_manager/available_jobs/job_detail.dart';
import 'package:tree_manager/comms/call_status.dart';
import 'package:tree_manager/comms/comment_box.dart';
import 'package:tree_manager/comms/confirm_schedule.dart';
import 'package:tree_manager/comms/schedule_date.dart';
import 'package:tree_manager/comms/schedule_time.dart';
import 'package:tree_manager/costing/add_other.dart';
import 'package:tree_manager/costing/crew_configuration.dart';
import 'package:tree_manager/costing/crew_selection.dart';
import 'package:tree_manager/costing/edit_hours.dart';
import 'package:tree_manager/costing/edit_item.dart';
import 'package:tree_manager/costing/edit_other.dart';
import 'package:tree_manager/costing/hours_on_site.dart';
import 'package:tree_manager/costing/manual_equip.dart';
import 'package:tree_manager/costing/manual_hours.dart';
import 'package:tree_manager/costing/manual_other.dart';
import 'package:tree_manager/costing/manual_staff.dart';
import 'package:tree_manager/costing/quote_list.dart';
import 'package:tree_manager/costing/review_item.dart';
import 'package:tree_manager/costing/review_quote.dart';
import 'package:tree_manager/costing/sub_equip.dart';
import 'package:tree_manager/costing/total_amount.dart';
import 'package:tree_manager/dashboard/approval_list.dart';
import 'package:tree_manager/dashboard/dashboard.dart';
import 'package:tree_manager/dashboard/invoice_list.dart';
import 'package:tree_manager/dashboard/job_list.dart';
import 'package:tree_manager/dashboard/schedule_list.dart';
import 'package:tree_manager/dashboard/schedule_work_list.dart';
import 'package:tree_manager/dialog/email_dialog.dart';
import 'package:tree_manager/dialog/multi_action_dialog.dart';
import 'package:tree_manager/dialog/porgess_dialog.dart';
import 'package:tree_manager/dialog/single_action_dialog.dart';
import 'package:tree_manager/helper/Global.dart';
import 'package:tree_manager/helper/theme.dart';
import 'package:tree_manager/invoice/accident.dart';
import 'package:tree_manager/invoice/costomer_on_site.dart';
import 'package:tree_manager/invoice/emergency_contact.dart';
import 'package:tree_manager/invoice/gen_invoice.dart';
import 'package:tree_manager/invoice/hazard_photos.dart';
import 'package:tree_manager/invoice/invoice.dart';
import 'package:tree_manager/invoice/invoice_the_job.dart';
import 'package:tree_manager/invoice/sign_off.dart';
import 'package:tree_manager/invoice/work_completion.dart';
import 'package:tree_manager/menu/comms/chat_view.dart';
import 'package:tree_manager/menu/comms/comm_list.dart';
import 'package:tree_manager/menu/more.dart';
import 'package:tree_manager/menu/notes.dart';
import 'package:tree_manager/menu/payment_list.dart';
import 'package:tree_manager/menu/pdf_viewer.dart';
import 'package:tree_manager/menu/report_view.dart';
import 'package:tree_manager/menu/reports.dart';
import 'package:tree_manager/menu/work_flow.dart';
import 'package:tree_manager/notification/NotificationCounterBloc.dart';
import 'package:tree_manager/notification/notification_data.dart';
import 'package:tree_manager/notification/notification_list.dart';
import 'package:tree_manager/pojo/User.dart';
import 'package:tree_manager/schedule_work/schedule_work.dart';
import 'package:tree_manager/site_hazard/add_otherTask.dart';
import 'package:tree_manager/site_hazard/add_others.dart';
import 'package:tree_manager/site_hazard/equip_selection.dart';
import 'package:tree_manager/site_hazard/hazard_review.dart';
import 'package:tree_manager/site_hazard/hazard_uploads.dart';
import 'package:tree_manager/site_hazard/q1.dart';
import 'package:tree_manager/site_hazard/review_staff.dart';
import 'package:tree_manager/site_hazard/sign_off_hazard.dart';
import 'package:tree_manager/site_hazard/staff_selection.dart';
import 'package:tree_manager/site_hazard/staff_sign_grid.dart';
import 'package:tree_manager/site_hazard/tasks.dart';
import 'package:tree_manager/site_hazard/thing.dart';
import 'package:tree_manager/site_hazard/thing_control.dart';
import 'package:tree_manager/site_hazard/thing_rate.dart';
import 'package:tree_manager/site_inspection/damage_check.dart';
import 'package:tree_manager/site_inspection/damage_fence_a.dart';
import 'package:tree_manager/site_inspection/damage_fence_b.dart';
import 'package:tree_manager/site_inspection/damage_other_a.dart';
import 'package:tree_manager/site_inspection/damage_other_b.dart';
import 'package:tree_manager/site_inspection/damage_roof_a.dart';
import 'package:tree_manager/site_inspection/damage_roof_b.dart';
import 'package:tree_manager/site_inspection/fence_height.dart';
import 'package:tree_manager/site_inspection/fence_images/fence_photos.dart';
import 'package:tree_manager/site_inspection/fence_type.dart';
import 'package:tree_manager/site_inspection/fence_width.dart';
import 'package:tree_manager/site_inspection/image_view.dart';
import 'package:tree_manager/site_inspection/number_of_tree.dart';
import 'package:tree_manager/site_inspection/site_before_photos.dart';
import 'package:tree_manager/site_inspection/site_inspection.dart';
import 'package:tree_manager/site_inspection/tree_access.dart';
import 'package:tree_manager/site_inspection/tree_detail.dart';
import 'package:tree_manager/site_inspection/tree_distance.dart';
import 'package:tree_manager/site_inspection/tree_height.dart';
import 'package:tree_manager/site_inspection/tree_location.dart';
import 'package:tree_manager/site_inspection/waste_generated.dart';
import 'package:tree_manager/site_inspection/work_required.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show sin, cos, sqrt, atan2;
import 'package:vector_math/vector_math.dart' as vector;

import '../pojo/locationDto.dart';

class Helper {
  // Country Declaration
  // AUS for Australia
  // UK for United Kingdom
 static var countryCode = "UK";

  // App Image

  static var AppImage = "assets/images/logo.png";

  // GBP for Pound
  // USD for Dollar
  static var currencySymbol =
      NumberFormat.simpleCurrency(name: countryCode == "UK" ? "GBP" : "USD")
          .currencySymbol;

  // More -> Help -> Contact Data
  final contactDetails =
      '{"title": "Enviro - UK","phone": "1300077233","email": "uk@gmail"}';

  static var bold =
      TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold);
  static var semibold =
      TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w500);
  static var regular = TextStyle(fontFamily: 'OpenSans');

  static Map<String, StatefulWidget Function(BuildContext)> routes = {
    "login": (BuildContext) => Login(),
    "forgot_password": (BuildContext) => ForgotPassword(),
    "help_center": (BuildContext) => HelpCenter(),
    //auth end
    "dashboard": (BuildContext) => Dashboard(),
    "job_list": (BuildContext) => JobList(),
    "quote_list": (BuildContext) => QuoteList(),
    "schedule_list": (BuildContext) => ScheduleList(),
    "enviro_list": (BuildContext) => ApprovalList(),
    "schedule_work": (BuildContext) => ScheduleWorkList(),
    "send_invoice": (BuildContext) => InvoiceList(),
    //dash end

    "job_detail": (BuildContext) => JobDetail(),
    "schedule_detail": (BuildContext) => ScheduleWork(),
    //job listing end

    "site_inspection": (BuildContext) => SiteInspection(),
    //site inspection

    "before_photos": (BuildContext) => BeforePhoto(),
    //before images end

    "number_of_tree": (BuildContext) => NumberOfTrees(),
    "tree_height": (BuildContext) => TreeHeight(),
    "tree_detail": (BuildContext) => TreeDetail(),
    "tree_location": (BuildContext) => TreeLocation(),
    "tree_distance": (BuildContext) => TreeDistance(),
    "tree_access": (BuildContext) => TreeAccess(),
    "work_required": (BuildContext) => WorkRequired(),
    "waste_generated": (BuildContext) => WasteGenerated(),
    "damage_check": (BuildContext) => DamageCheck(),
    "damage_fence_b": (BuildContext) => DamageFenceB(),
    "damage_fence_a": (BuildContext) => DamageFenceA(),
    "fence_height": (BuildContext) => FenceHeight(),
    "fence_width": (BuildContext) => FenceWidth(),
    "fence_type": (BuildContext) => Fencetype(),
    "fence_photos": (BuildContext) => FencePhotos(),
    "damage_roof_b": (BuildContext) => DamageRoofB(),
    "damage_roof_a": (BuildContext) => DamageRoofA(),
    "damage_other_b": (BuildContext) => DamageOtherB(),
    "damage_other_a": (BuildContext) => DamageOtherA(),
    //tree info

    "crew_configuration": (BuildContext) => CrewConfiguration(),
    "crew_selection": (BuildContext) => CrewSelection(),
    "hours_on_site": (BuildContext) => HoursOnSite(),
    "edit_hours": (BuildContext) => EditHours(),
    "review_quote": (BuildContext) => ReviewQuote(),
    "review_item": (BuildContext) => ReviewItem(),
    "edit_item": (BuildContext) => EditItem(),
    "edit_other": (BuildContext) => EditOther(),
    "add_other": (BuildContext) => AddOther(),
    "manual_others": (BuildContext) => ManualOther(),
    "manual_hours": (BuildContext) => ManualHoursOnSite(),
    "manual_staff": (BuildContext) => ManualStaff(),
    "manual_equip": (BuildContext) => ManualEquip(),
    "sub_equip": (BuildContext) => SubEquip(),
    "total_amount": (BuildContext) => TotalAmount(),
    //costing ends
    //site inspection end

    "call_status": (BuildContext) => CallStatus(),
    "comment_box": (BuildContext) => CommentBox(),
    "schedule_date": (BuildContext) => DayPickerPage(events: []),
    "schedule_time": (BuildContext) => ScheduleTime(),
    "confirm_schedule": (BuildContext) => ConfirmSchedule(),
    //scheduling job  end

    "image_viewer": (BuildContext) => ImageViewer(),
    //image viewer end

    "payment_list": (BuildContext) => PaymentList(),
    //payments

    "more": (BuildContext) => MoreOption(),
    "reports": (BuildContext) => ReportList(),
    "report_view": (BuildContext) => ReportView(),
    "pdf_viewer": (BuildContext) => PdfViewer(),
    "work_flow": (BuildContext) => WorkFlow(),
    //more option end

    "invoice": (BuildContext) => Invoice(),
    //invoice

    "hazard_photos": (BuildContext) => HazardPhotos(),
    //before and after images

    "accident": (BuildContext) => Accident(),
    "emergency_contact": (BuildContext) => EmergencyContact(),
    "work_completion": (BuildContext) => WorkCompletion(),
    "customer_on_site": (BuildContext) => CustomerOnSite(),
    "sign_off": (BuildContext) => SignOff(),
    "invoice_the_job": (BuildContext) => InvoiceTheJob(),
    "gen_invoice": (BuildContext) => GenInvoice(),
    'staff_selection': (BuildContext) => StaffSelection(),
    'review_staff': (BuildContext) => ReviewStaff(),
    'equip_selection': (BuildContext) => EquipSelection(),
    'tasks': (BuildContext) => Tasks(),
    'add_other_task': (BuildContext) => AddOtherTask(),
    'add_others': (BuildContext) => AddOthers(),
    'q1': (BuildContext) => Q1(),
    'thing': (BuildContext) => Thing(),
    'thing_rate': (BuildContext) => ThingRate(),
    'thing_control': (BuildContext) => ThingControl(),
    'staff_sign_grid': (BuildContext) => StaffSignGrid(),
    'sign_off_hazard': (BuildContext) => SignOffHazard(),
    'hazard_review': (BuildContext) => HazardReview(),
    'hazard_upload': (BuildContext) => HazardUpload(),
    //site hazard end

    'notes': (BuildContext) => Notes(),
    //notes end

    'chats': (BuildContext) => CommList(),
    'chat_view': (BuildContext) => ChatView(),
    //communication end

    'notification_list': (BuildContext) => NotificationList(),
    'notification_data': (BuildContext) => NotificationData(),
  };

  static CounterBloc? counter;
  static AppBar getAppBar(BuildContext context,
      {String title = "",
      String sub_title = "",
      bool backArrow = true,
      Widget? actions = null,
      bool showNotification = true,
        bool visible = true,
      int counter = 0}) {
    return AppBar(
      leading: Visibility(
          visible: backArrow,
          child: IconButton(
            icon: SvgPicture.asset(
              "assets/images/ios-back-arrow.svg",
             // color: Colors.blue,
              colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            onPressed: () {
              try {
                if(!visible){
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'quote_list', // Replace with your target route
                        (route) => false, // Clear the entire navigation stack
                  );
                }
               else if (Navigator.canPop(context))
                  Navigator.of(context).pop();
                else
                  print('cant pop back');
              } catch (e) {
                print(e);
                print('this too');
              }
            },
          )),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            "${title}",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${sub_title}",
            style: TextStyle(color: Colors.lightGreen, fontSize: 13.0),
          )
        ],
      ),
      actions: <Widget>[
        if (showNotification)
          Stack(
            children: <Widget>[
              IconButton(
                icon: SvgPicture.asset("assets/images/Notification-Icon.svg"),
                onPressed: () {
                  print("notification preessed");
                  Navigator.pushNamed(context, 'notification_list');
                },
              ),
              counter != 0
                  ? new Positioned(
                      right: 5,
                      top: 5,
                      child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: StreamBuilder(
                              stream: Helper.counter?.counterObservable,
                              builder: (context, AsyncSnapshot<int> snapshot) {
                                return Text(
                                  '${snapshot.data}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              })),
                    )
                  : new Container(
                      color: Colors.black,
                    )
            ],
          ),
        if (actions != null) actions
      ],
    );
  }

  static void getNotificationCount() {
    get('nativeappservice/getNotificationCount?contractor_id=${Helper.user?.companyId}&process_id=${Helper.user?.processId}',
        {}).then((value) {
      var json = jsonDecode(value.body);
      counter?.setCount(json['NotificationCount'] ?? 0);
    });
  }

  static var bottom_nav_selected = 0;

  static BottomNavigationBar getBottomBar(
      void Function(int index) bottomClick) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Themer.selectedBotNavColor,
      currentIndex: bottom_nav_selected,
      type: BottomNavigationBarType.fixed,
      onTap: bottomClick,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/round-home-24px.svg'),
          activeIcon: SvgPicture.asset(
            'assets/images/round-home-24px.svg',
            //color: Themer.textGreenColor,
            colorFilter: ColorFilter.mode(Themer.textGreenColor, BlendMode.srcIn),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/round-work-24px.svg'),
            activeIcon: SvgPicture.asset(
              'assets/images/round-work-24px.svg',
              //color: Themer.textGreenColor,
              colorFilter: ColorFilter.mode(Themer.textGreenColor, BlendMode.srcIn),
            ),
            label: 'Jobs'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/edit_tm.svg'),
            activeIcon: SvgPicture.asset(
              'assets/images/edit_tm.svg',
              //color: Themer.textGreenColor,
              colorFilter: ColorFilter.mode(Themer.textGreenColor, BlendMode.srcIn),
            ),
            label: 'Notes'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/round-send-24px.svg'),
            activeIcon: SvgPicture.asset(
              'assets/images/round-send-24px.svg',
              //color: Themer.textGreenColor,
              colorFilter: ColorFilter.mode(Themer.textGreenColor, BlendMode.srcIn),
            ),
            label: 'Comms'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/more_horiz-24px.svg'),
            activeIcon: SvgPicture.asset(
              'assets/images/more_horiz-24px.svg',
              //color: Themer.textGreenColor,
              colorFilter: ColorFilter.mode(Themer.textGreenColor, BlendMode.srcIn),
            ),
            label: 'More')
      ],
    );
  }

  // static bottomClickAction(int index, BuildContext context) {
  //   ModalRoute.of(context)?.setState(() {
  //     if (index == Helper.bottom_nav_selected && 1 == 2)
  //       return;
  //     else {
  //       Helper.bottom_nav_selected = index;
  //       switch (index) {
  //         case 0:
  //           Navigator.pushNamedAndRemoveUntil(
  //               context, 'dashboard', ModalRoute.withName('dashboard'));
  //           break;
  //         case 1:
  //           Navigator.pushNamedAndRemoveUntil(
  //               context, 'job_list', ModalRoute.withName('dashboard'));
  //           break;
  //         case 2:
  //           if (Global.job != null) {
  //             Navigator.pushNamedAndRemoveUntil(
  //                 context, 'notes', ModalRoute.withName('dashboard'));
  //           }
  //           break;
  //         case 3:
  //           if (Global.job != null) {
  //             Navigator.pushNamedAndRemoveUntil(
  //                 context, 'chats', ModalRoute.withName('dashboard'),
  //                 arguments: {'update': true});
  //           }
  //
  //           break;
  //         case 4:
  //           Navigator.pushNamedAndRemoveUntil(
  //               context, 'more', ModalRoute.withName('dashboard'));
  //           break;
  //         default:
  //       }
  //     }
  //   });
  // }
  static void bottomClickAction(
      int index, BuildContext context, Function updateState) {
    if (index == bottom_nav_selected && 1 == 2) return;

    updateState(() {
      bottom_nav_selected = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
            context, 'dashboard', ModalRoute.withName('dashboard'));
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
            context, 'job_list', ModalRoute.withName('dashboard'));
        break;
      case 2:
        if (Global.job != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'notes', ModalRoute.withName('dashboard'));
        }
        break;
      case 3:
        if (Global.job != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'chats', ModalRoute.withName('dashboard'),
              arguments: {'update': true});
        }
        break;
      case 4:
        Navigator.pushNamedAndRemoveUntil(
            context, 'more', ModalRoute.withName('dashboard'));
        break;
      default:
    }
  }

  static String getRateClassName(String rateClass) {
    if (rateClass == Global.normalClass)
      return 'NH';
    else if (rateClass == Global.afterClass)
      return 'AH';
    else
      return '';
  }

  static Future<bool> setTreeInfo(BuildContext context) async {
    showProgress(context, 'Saving Tree Info');
    print('saving tree info');
    var data = await post(
        "workOperationsInfo/CreateWithNewID", Global.info!.toJson(),
        is_json: true);
    print('data--->${data}');
    Global.job?.treeinfoExists = 'true';
    await Helper.updateNotificationStatus(Global.job?.jobAllocId??'');
    hideProgress();
    var json = jsonDecode(data.body);
    return json['success'] == 1;
  }

  static Future<bool> updateTreeInfo(BuildContext context) async {
    showProgress(context, 'Saving Tree Info');
    print('saving tree info  +=> ${Global.info!.toJson()}');
    var data = await put("WorkOperationsInfo/Edit", Global.info!.toJson(),
        is_json: true);
    Global.job?.treeinfoExists = 'true';
    hideProgress();
    var json = jsonDecode(data.body);
    print('data123 json=====>${json}');
    return json['success'] == 1;
  }

  static Future<bool> setFenceInfo(BuildContext context) async {
    showProgress(context, 'Saving Fence Info');
    var data = await post("AdditionalDamageInfo/Create", Global.fence!.toJson(),
        is_json: true);
    hideProgress();
    var json = jsonDecode(data.body);
    return json['success'] == 1;
  }

  static Future<bool> updateFence(BuildContext context) async {
    showProgress(context, 'Saving Fence Info');
    var data = await put("AdditionalDamageInfo/Create", Global.info!.toJson(),
        is_json: true);
    hideProgress();
    var json = jsonDecode(data.body);
    return json['success'] == 1;
  }

  static Future<bool> saveInvoice() async {
    var data =
        await post("jobinvoice/Create", Global.invoice!.toJson(), is_json: true);
    var json = jsonDecode(data.body);
    return json['success'] == 1;
  }

  static showProgress(BuildContext context, String message,
      {bool dismissable = false}) {
    Global.pd = ProgressDialog(context,
        isDismissible: dismissable,
        showLogs: false,
        type: ProgressDialogType.Normal);
    Global.pd?.style(
        message: message,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    Global.pd?.show();
  }

  static hideProgress() {
    try {
      Global.pd?.hide();
    } catch (e) {}
  }

  static Future<bool?> showSingleActionModal(BuildContext context,
      { String? title,
      Color titleTextColor = Themer.textGreenColor,
      String? description,
      Color? descriptionTextColor,
      String? descriptionPrefixIcon,
      String? buttonText,
      Color? buttonTextColor,
      String? buttonimage,
      Function? dismissAction,
      Function? buttonAction,
      String? subTitle,
      String? subDescription,
      Widget? custom}) async {
     final result = await showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
        title: title??'',
        description: description,
        buttonText: buttonText,
        buttonimage: buttonimage,
        buttonTextColor: buttonTextColor,
        titleTextColor: titleTextColor,
        descriptionTextColor: descriptionTextColor,
        descriptionPrefixIcon: descriptionPrefixIcon,
        dismissAction: dismissAction,
        buttonAction: buttonAction,
        custom: custom ?? SizedBox() ,
        subDescription: subDescription,
        subTitle: subTitle,
      ),
    );
     return result ?? null;
  }

static Future<bool?> showMultiActionModal(
  BuildContext context, {
  String? title,
  Color titleTextColor = Themer.textGreenColor,
  String? description,
  Color? descriptionTextColor,
  String? descriptionPrefixIcon,
  String? positiveButtonText,
  Color? positiveButtonTextColor,
  String? positiveButtonimage,
  Function? positiveButtonAction,
  String? negativeButtonText,
  Color? negativeButtonTextColor,
  String? negativeButtonimage,
  final void Function()? negativeButtonAction,
  //Function? dismissAction,
      final VoidCallback? dismissAction,
}) async {
  final result = await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) => MultiActionDialog(
      title: title??'',
      description: description,
      titleTextColor: titleTextColor,
      descriptionTextColor: descriptionTextColor,
      descriptionPrefixIcon: descriptionPrefixIcon,
      positiveButtonText: positiveButtonText,
      positiveButtonTextColor: positiveButtonTextColor,
      positiveButtonimage: positiveButtonimage,
      positiveButtonAction: positiveButtonAction,
      negativeButtonText: negativeButtonText,
      negativeButtonTextColor: negativeButtonTextColor,
      negativeButtonimage: negativeButtonimage,
      negativeButtonAction: negativeButtonAction ,
      dismissAction: dismissAction,
    ),
  );

  return result ?? null; // Provide a default value if result is null
}

  // static Future<bool> showMultiActionModal(
  //   BuildContext context, {
  //   String? title,
  //   Color titleTextColor = Themer.textGreenColor,
  //   String? description,
  //   Color? descriptionTextColor,
  //   String? descriptionPrefixIcon,
  //   String? positiveButtonText,
  //   Color? positiveButtonTextColor,
  //   String? positiveButtonimage,
  //   Function? positiveButtonAction,
  //   String? negativeButtonText,
  //   Color? negativeButtonTextColor,
  //   String? negativeButtonimage,
  //   Function? negativeButtonAction,
  //   Function? dismissAction,
  // }) async {
  //   return await showDialog<bool>(
  //     context: context,
  //     builder: (BuildContext context) => MultiActionDialog(
  //       title: title,
  //       description: description,
  //       titleTextColor: titleTextColor,
  //       descriptionTextColor: descriptionTextColor,
  //       descriptionPrefixIcon: descriptionPrefixIcon,
  //       positiveButtonText: positiveButtonText,
  //       positiveButtonTextColor: positiveButtonTextColor,
  //       positiveButtonimage: positiveButtonimage,
  //       positiveButtonAction: positiveButtonAction,
  //       negativeButtonText: negativeButtonText,
  //       negativeButtonTextColor: negativeButtonTextColor,
  //       negativeButtonimage: negativeButtonimage,
  //       negativeButtonAction: negativeButtonAction,
  //       dismissAction: dismissAction,
  //     ),
  //   );
  // }

  static Future<String> showEmailModal(
  BuildContext context, {
  String? title,
  Color? titleTextColor,
  String? description,
  Color? descriptionTextColor,
  String? descriptionPrefixIcon,
  String? positiveButtonText,
  Color? positiveButtonTextColor,
  String? positiveButtonimage,
  Function? positiveButtonAction,
  String? negativeButtonText,
  Color? negativeButtonTextColor,
  String? negativeButtonimage,
  void Function()? negativeButtonAction,
  Function? dismissAction,
}) async {
  final result = await showDialog<String>(
    context: context,
    builder: (BuildContext context) => EmailDialog(
      title: title ??'',
      description: description,
      titleTextColor: titleTextColor ?? Colors.transparent,
      descriptionTextColor: descriptionTextColor,
      descriptionPrefixIcon: descriptionPrefixIcon,
      positiveButtonText: positiveButtonText,
      positiveButtonTextColor: positiveButtonTextColor,
      positiveButtonimage: positiveButtonimage,
      positiveButtonAction: positiveButtonAction,
      negativeButtonText: negativeButtonText,
      negativeButtonTextColor: negativeButtonTextColor,
      negativeButtonimage: negativeButtonimage,
      negativeButtonAction: negativeButtonAction,
      dismissAction: dismissAction,
    ),
  );
  
  // Provide a default value if the result is null
  return result ?? ''; // Or any default non-null string you prefer
}


  static var BASE_URL = countryCode == "UK"
      ? "https://treemanager.uk:5223/"
      : "https://treemanager.com:3002/";

  static Future<http.Response> get(
      String url, Map<String, String> query) async {
    var client = http.Client();
    var tmp_url = BASE_URL + url + Uri.https("", "", query).query;
    Uri uri = Uri.parse(tmp_url);
    print('temp_url=====>${tmp_url}');
    //print(tmp_url);
    var data = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      "Authorization":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjEiLCJpYXQiOjE1MDY1NjA5ODB9.LAGHEE6tyd9FmZXaK40yDeUkHVZkOl8MdXSrtEcGwB4"
    }
    );
    print('data------->${data.body}');
    if (data.statusCode == 200) {
      // Success: Process the image data
      print('Image fetched successfully.');
    } else {
      // Handle errors
      print('Failed to fetch image. Status code: ${data.statusCode}, Message: ${data.body}');
    }
   // print('BASE_URL data----->${data}');
    return data;
  }

  static Future<http.Response> post(String url, Map<String, dynamic> body,
      {bool is_json = false}) async {
    var client = http.Client();
    String tmp_url;
    if (is_json)
      tmp_url = BASE_URL + url;
    else
      tmp_url = BASE_URL + url;
    var headers = {
      "Authorization":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjEiLCJpYXQiOjE1MDY1NjA5ODB9.LAGHEE6tyd9FmZXaK40yDeUkHVZkOl8MdXSrtEcGwB4"
    };
    if (is_json) headers.addAll({"Content-Type": "application/json"});
    Uri uri = Uri.parse(tmp_url);
    var data = is_json
        ? await client.post(uri , headers: headers, body: json.encode(body))
        : await client.post(uri , headers: headers, body: body);
    print('data==>${data.body}');
    return data;
  }

  static Future<http.Response> post2(String url, Map<String, dynamic> body,
      {bool is_json = false}) async {
    var client = http.Client();
    String tmp_url;
    tmp_url = url;
    var headers = {
      "Authorization":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjEiLCJpYXQiOjE1MDY1NjA5ODB9.LAGHEE6tyd9FmZXaK40yDeUkHVZkOl8MdXSrtEcGwB4"
    };
    if (is_json) headers.addAll({"Content-Type": "application/json"});
    Uri uri = Uri.parse(tmp_url);
    var data = is_json
        ? await client.post(uri , headers: headers, body: json.encode(body))
        : await client.post(uri , headers: headers, body: body);
    return data;
  }

  static Future<http.Response> put(String url, Map<String, dynamic> body,
      {bool is_json = false}) async {
    var client = http.Client();
    String tmp_url;
    if (is_json)
      tmp_url = BASE_URL + url;
    //tmp_url = BASE_URL + Uri.https(url, "", {}).toString();
    else
      tmp_url = BASE_URL + url;
    //tmp_url = BASE_URL + Uri.https(url, "", {}).toString();
    var headers = {
      "Authorization":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjEiLCJpYXQiOjE1MDY1NjA5ODB9.LAGHEE6tyd9FmZXaK40yDeUkHVZkOl8MdXSrtEcGwB4"
    };
    if (is_json) headers.addAll({"Content-Type": "application/json"});
    Uri uri = Uri.parse(tmp_url);
    var data = is_json
        ? await client.put(uri , headers: headers, body: json.encode(body))
        : await client.put(uri , headers: headers, body: body);
    return data;
  }

  static logResponse(http.Response resp) {
    print("url==>${resp.request!.url}");
    print("method==>${resp.request!.method}");
    print("body==>" + resp.body);
    print("code==>${resp.statusCode}");
  }

  static Future openMap(String address) async {
    //var url = "geo:0,0?q=${address.replaceAll(" ", "+")}";
    var url = Uri.parse("geo:0,0?q=${address.replaceAll(" ", "+")}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      MapsLauncher.launchQuery(address);
    }
  }

  static Future openDialer(String mobile) async {
    var url = Uri.parse("tel:${mobile}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  static Future sendMessage(String mobile) async {
    // var url = Uri.parse("sms:${mobile}");
    var url = Uri.parse("sms:${mobile}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future openEmail(String email) async {
   // var url = "mailto:$email";
    var url = Uri.parse("mailto:${email}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not make mail.';
    }
  }
 // static Future openEmail(String email) async {
 //   final Uri emailUri = Uri(
 //     scheme: 'mailto',
 //     path: email,
 //   );
 //
 //   // Try launching the email client with additional options
 //   if (await canLaunchUrl(emailUri)) {
 //     await launchUrl(
 //       emailUri,
 //       mode: LaunchMode.externalApplication,  // Opens email client externally
 //     );
 //   } else {
 //     // Log or handle the error when no email client is available
 //     throw 'Could not launch email client.';
 //   }
 // }

  static Future openDirection(String address) async {
    var url = Uri.parse("google.navigation:q=${address.replaceAll(" ", "+")}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      MapsLauncher.launchQuery(address);
    }
  }

  static User? user;
  static Future<User?> makeUser() async {
    try {
      var store = await SharedPreferences.getInstance();
      var json = store.getString('user');
      user = User.fromJson(jsonDecode(json!));
    } catch (e) {
      user = new User();
    }
    return user;
  }

  static void setUser(Map user) async {
    var store = await SharedPreferences.getInstance();
    store.setString('user', jsonEncode(user));
    makeUser();
  }

  static List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  static intToMonth(int month) {
    return months[month - 1];
  }

  static getOrdinal(int no) {
    switch (no) {
      case 0:
        return "th";
        //break;
      case 0:
        return "th";
        //break;
      case 0:
        return "th";
       // break;
      case 0:
        return "th";
       // break;
      default:
        return "th";
        //break;
    }
  }

  static String makeTextAvatar(String name) {
    var text = name.trim();
    if (text.isEmpty) {
      return "";  // Default value for empty names
    }
    var words = text.toUpperCase().split(" ");
    if (words.length >= 2) {
      return words[0][0] + "" + words[1][0];
    } else if (words.length == 1 && words[0].isNotEmpty) {
      return "" + words[0][0];
    } else {
      return "";
    }
  }

  static updateNotificationStatus(String alloc_id) {
    Helper.get(
        'nativeappservice/updateNotificationStatus?contractor_id=${user?.companyId}&process_id=${user?.processId}&job_alloc_id=$alloc_id',
        {}).then((value) {
      Global.noti = null;
    }).catchError((onError) {
      Global.noti = null;
    });
  }

  static Future<String> getAppVersion() async {
    // return Platform.isAndroid
    //     ? (await GetVersion.projectCode)
    //     : (await GetVersion.projectVersion);
  
    //WidgetsFlutterBinding.ensureInitialized();
    final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;  // Returns the version number as a string
  }

  //Calculating the distance between two points
  static double getDistance(LocationDto _currentPosition) {
    double earthRadius = 6371000;
    var dLat = vector
        .radians(Global.previousLocation!.latitude - _currentPosition.latitude);
    var dLng = vector.radians(
        Global.previousLocation!.longitude - _currentPosition.longitude);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(vector.radians(_currentPosition.latitude)) *
            cos(vector.radians(Global.previousLocation!.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = earthRadius * c; //d is the distance in meters
    return d;
  }
}
