library global;

import 'package:background_locator/location_dto.dart';
import 'package:flutter/material.dart';
import 'package:tree_manager/dialog/porgess_dialog.dart';
import 'package:tree_manager/pojo/Crew.dart';
import 'package:tree_manager/pojo/CrewDetail.dart';
import 'package:tree_manager/pojo/FenceInfo.dart';
import 'package:tree_manager/pojo/Invoice_data.dart';
import 'package:tree_manager/pojo/Job.dart';
import 'package:tree_manager/pojo/Staff.dart';
import 'package:tree_manager/pojo/Task.dart';
import 'package:tree_manager/pojo/detail.dart';
import 'package:tree_manager/pojo/equip.dart';
import 'package:tree_manager/pojo/hazard.dart';
import 'package:tree_manager/pojo/head.dart';
import 'package:tree_manager/pojo/network_image.dart';
import 'package:tree_manager/pojo/option.dart';
import 'package:tree_manager/pojo/other_item.dart';
import 'package:tree_manager/pojo/signature.dart';
import 'package:tree_manager/pojo/tree_info.dart';
import 'package:tree_manager/pojo/notification.dart' as Noti;

class Global {
  static String rateSet = "";
  static String rateClass = "";
  static int taxRate = 0;

  static String normalClass = "";
  static String afterClass = "";
  static String? selectedRateClass;

  static List<OtherItem>? others = [];
  static List<OtherItem> staffs = [];
  static List<OtherItem> equips = [];
  static List<OtherItem>? sub_equips = [];

  static bool locationRunning = false;

  static Head? head;
  static List<Detail> details = [];
  static String substan = "";

  static Job? job;
  static Crew? crew;
  static Noti.Notification? noti;

  static bool site_info_update = false;
  static bool fence_info_update = false;
  static bool costing_update = false;

  static TreeInfo? info;
  static List<NetworkPhoto>? before_images = [];
  static List<NetworkPhoto>? after_images = [];

  // Fence images
  static List<NetworkPhoto> standing_images = [];
  static List<NetworkPhoto> damage_images = [];

  static InvoiceData? invoice;

  static bool site_hazard_update = false;
  static  Hazard? hazard;
  static List<NetworkPhoto> hazard_images = [];

  static List<Staff> hzd_staffs = [];
  static List<Equip> hzd_equips = [];
  static List<Option> hzd_qstn = [];
  static List<Task> hzd_task = [];

  static List<Option> w_task = [];
  static List<Option> m_task = [];
  static List<Option> t_task = [];
  static List<Option> j_task = [];

  static List<Option> w_ctrl = [];
  static List<Option> m_ctrl = [];
  static List<Option> t_ctrl = [];
  static List<Option> j_ctrl = [];

  static List<Option> w_rate = [];
  static List<Option> m_rate = [];
  static List<Option> t_rate = [];
  static List<Option> j_rate = [];

  // Selected hazard items
  static List<Option> sel_w_task = [];
  static List<Option> sel_m_task = [];
  static List<Option> sel_t_task = [];
  static List<Option> sel_j_task = [];
  static List<Option> sel_w_other_task = [];
  static List<Option> sel_m_other_task = [];
  static List<Option> sel_t_other_task = [];
  static List<Option> sel_j_other_task = [];

  static List<Option> sel_w_ctrl = [];
  static List<Option> sel_m_ctrl = [];
  static List<Option> sel_t_ctrl = [];
  static List<Option> sel_j_ctrl = [];
  static List<Option> sel_w_other_ctrl = [];
  static List<Option> sel_m_other_ctrl = [];
  static List<Option> sel_t_other_ctrl = [];
  static List<Option> sel_j_other_ctrl = [];

  static String? sel_w_rate = "";
  static String? sel_m_rate = "";
  static String? sel_t_rate = "";
  static String? sel_j_rate = "";

  static Color? sel_w_color = Colors.transparent;
  static Color? sel_m_color = Colors.transparent;
  static Color? sel_t_color = Colors.transparent;
  static Color? sel_j_color = Colors.transparent;

  static List<Staff> hzd_sel_staff = [];
  static List<Staff> hzd_sel_other_staff = [];
  static List<Equip> hzd_sel_equip = [];
  static List<Equip> hzd_sel_other_equip = [];

  static List<String> hzd_sel_answr = [];
  static List<Task> hzd_sel_task = [];
  static List<Task> hzd_sel_other_task = [];

  // Hazard triplets
  static List<Map<String, String>> hzd_triplet = [
    {
      'task_title': 'Hazard (1/4)',
      'task_sub_title': 'Weather',
      'rate_title': 'Weather Hazard',
      'rate_sub_title': 'Rate Weather Hazards',
      'ctrl_title': 'Weather Hazard',
      'ctrl_sub_title': 'Weather Control',
    },
    {
      'task_title': 'Hazard (1/4)',
      'task_sub_title': 'Job Site',
      'rate_title': 'Job Site Hazard',
      'rate_sub_title': 'Rate Job Site Hazards',
      'ctrl_title': 'Job Site Hazard',
      'ctrl_sub_title': 'Job Site Control Measures',
    },
    {
      'task_title': 'Hazard (1/4)',
      'task_sub_title': 'Tree',
      'rate_title': 'Tree Hazard',
      'rate_sub_title': 'Rate Tree Hazard',
      'ctrl_title': 'Tree Hazard',
      'ctrl_sub_title': 'Control Tree Hazard',
    },
    {
      'task_title': 'Hazard (1/4)',
      'task_sub_title': 'Manual Task',
      'rate_title': 'Task Hazard',
      'rate_sub_title': 'Rate Manual Tasks Hazards',
      'ctrl_title': 'Task Hazard',
      'ctrl_sub_title': 'Control Manual Task Hazards',
    },
  ];

  static bool signRequired = false;
  static bool invoiceAllowed = false;

  static List<Signature>? signs = [];

  static List<CrewDetail>? crewDetails = [];
  static List<dynamic> crews = [];
  static ProgressDialog? pd;

  // Preloads
  static List<Option> comment = [];
  static List<Option> eta_not = [];
  static List<Option> substa_cost = [];
  static List<Option> approval = [];
  static List<Option> before_photos = [];
  static List<Option> after_photos = [];
  static List<Option> hazard_uploads = [];
  static List<Option> emergency_contact = [];
  static List<Option> work_not_completed = [];
  static List<Option> payment = [];
  // Fence data preloads
  static List<Option> fence_height = [];
  static List<Option> fence_length = [];
  static List<Option> fence_type = [];
  static List<Option> fence_damage = [];
  static List<Option> fence_comments = [];

  // Fence data
  static  FenceInfo? fence;

  static Map<String, dynamic> flow = {};

  static String? base64Sign = "";

  static LocationDto? previousLocation;
}
