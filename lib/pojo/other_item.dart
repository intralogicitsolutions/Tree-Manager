class OtherItem {
  double? hourlyRate;
  String? itemName;
  String? detail;
  String? itemId;
  String? headItemId;

  String? parent_id;
  int? hours;
  String? subStan;
  String? rateClass;

  OtherItem({this.hourlyRate, this.itemName, this.detail, this.itemId});

  OtherItem.fromJson(Map<String, dynamic> json) {
    hourlyRate = double.parse('${json['HourlyRate']??0.00}');
    itemName = json['item_name'];
    detail = json['detail'];
    itemId = json.containsKey('id')? json['id'] : json['item_id'];
    headItemId= json['head_item_id'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HourlyRate'] = this.hourlyRate;
    data['item_name'] = this.itemName;
    data['detail'] = this.detail;
    data['head_item_id'] = this.headItemId;
    data['id'] = this.itemId;
    data['parent_id'] = this.parent_id;
    return data;
  }

  String getId(){
    if(itemId!=null)
      return itemId!;
    else
      return headItemId!;
  }
}
