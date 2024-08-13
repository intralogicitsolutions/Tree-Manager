class Detail {
  String? id;
  String? jobId;
  String? jobAllocId;
  String? headId;
  String? itemDesc;
  String? itemId;
  String? itemQty;
  int? itemHrs;
  String? processId;
  double? itemPrice;
  double? itemTotal;
  String? itemRate;
  String? owner;
  String? createdBy;
  String? lastModifiedBy;
  String? createdAt;
  String? lastUpdatedAt;
  String? wpQty;
  String? wpRate;
  int? wpHrs;
  double? wpTotal;
  String? quoteInc;
  String? entryPoint;
  String? wpDesc;
  String? displayNo;
  String? itemName;
  var displayOrder;
  String? itemTypeId;
  String? itemCategory;
  Detail(
      {this.id,
      this.jobId,
      this.jobAllocId,
      this.headId,
      this.itemDesc,
      this.itemId,
      this.itemQty,
      this.itemHrs,
      this.processId,
      this.itemPrice,
      this.itemTotal,
      this.itemRate,
      this.owner,
      this.createdBy,
      this.lastModifiedBy,
      this.createdAt,
      this.lastUpdatedAt,
      this.wpQty,
      this.wpRate,
      this.wpHrs,
      this.wpTotal,
      this.quoteInc,
      this.entryPoint,
      this.wpDesc,
      this.displayNo,
      this.itemName,
      this.displayOrder,
      this.itemTypeId,
      this.itemCategory});

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'];
    jobAllocId = json['job_alloc_id'];
    headId = json['head_id'];
    itemDesc = json['item_desc'];
    itemId = json['item_id'];
    itemQty = json['item_qty'];
    itemHrs = json['item_hrs'];
    processId = json['process_id'];
    itemPrice = double.parse(json['item_price'].toString());
    itemTotal = double.parse(json['item_total'].toString());
    itemRate = json['item_rate'];
    owner = json['owner'];
    createdBy = json['created_by'];
    lastModifiedBy = json['last_modified_by'];
    createdAt = json['created_at'];
    lastUpdatedAt = json['last_updated_at'];
    wpQty = json['wp_qty'];
    wpRate = json['wp_rate'].toString();
    wpHrs = json['wp_hrs'];
    wpTotal = double.parse('${json['wp_total']??0.00}');
    quoteInc = json['quote_inc'];
    entryPoint = json['entry_point'];
    wpDesc = json['wp_desc'];
    displayNo = json['display_no'];
    itemName = json['item_name'];
    displayOrder = json['display_order'];
    itemTypeId = json['item_type_id'];
    itemCategory = json['ItemCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_id'] = this.jobId;
    data['job_alloc_id'] = this.jobAllocId;
    data['head_id'] = this.headId;
    data['item_desc'] = this.itemDesc;
    data['item_id'] = this.itemId;
    data['item_qty'] = this.itemQty;
    data['item_hrs'] = this.itemHrs;
    data['process_id'] = this.processId;
    data['item_price'] = this.itemPrice;
    data['item_total'] = this.itemTotal;
    data['item_rate'] = this.itemRate;
    data['owner'] = this.owner;
    data['created_by'] = this.createdBy;
    data['last_modified_by'] = this.lastModifiedBy;
    data['created_at'] = this.createdAt;
    data['last_updated_at'] = this.lastUpdatedAt;
    data['wp_qty'] = this.wpQty;
    data['wp_rate'] = this.wpRate;
    data['wp_hrs'] = this.wpHrs;
    data['wp_total'] = this.wpTotal;
    data['quote_inc'] = this.quoteInc;
    data['entry_point'] = this.entryPoint;
    data['wp_desc'] = this.wpDesc;
    data['display_no'] = this.displayNo;
    data['item_name'] = this.itemName;
    data['display_order'] = this.displayOrder;
    data['item_type_id'] = this.itemTypeId;
    data['ItemCategory'] = this.itemCategory;
    return data;
  }
}
