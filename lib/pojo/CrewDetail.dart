import 'package:tree_manager/pojo/detail.dart';

class CrewDetail {
  String? itemId;
  String? itemName;
  String? fixed;
  var hourlyRate;
  String? itemCategory;

  int count = 1;
  int hour = 1;
  String rateClass = '';
  Detail? detail = null;
  String desc = "";
  //bool showReviewEdit=false;

  CrewDetail(
      {this.itemId,
      this.itemName,
      this.fixed,
      this.hourlyRate,
      this.itemCategory});

  CrewDetail.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemName = json['ItemName'];
    fixed = json['fixed'];
    hourlyRate = double.parse('${json['HourlyRate']}');
    itemCategory = json['item_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['ItemName'] = this.itemName;
    data['fixed'] = this.fixed;
    data['HourlyRate'] = this.hourlyRate;
    data['item_category'] = this.itemCategory;
    data['count'] = this.count;
    data['hour'] = this.hour;
    return data;
  }
}
