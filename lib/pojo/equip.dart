class Equip {
  String? headItemId;
  String? itemName;

  Equip({this.headItemId, this.itemName});

  Equip.fromJson(Map<String, dynamic> json) {
    headItemId = json['head_item_id'];
    itemName = json['item_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['head_item_id'] = this.headItemId;
    data['item_name'] = this.itemName;
    return data;
  }
}
