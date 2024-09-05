class Signature {
  String? id;
  String? siteHazardId;
  String? userId;
  String? signature;
  String? owner;
  String? createdBy;
  String? lastModifiedBy;
  String? createdAt;
  String? lastUpdatedAt;
  String? customStaffName;
  String? staffName;

  Signature(
      {this.id,
      this.siteHazardId,
      this.userId,
      this.signature,
      this.owner,
      this.createdBy,
      this.lastModifiedBy,
      this.createdAt,
      this.lastUpdatedAt,
      this.customStaffName,
      this.staffName});

  Signature.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String? ?? '';
    siteHazardId = json['site_hazard_id'] as String? ?? '';
    userId = json['user_id'] as String? ?? '';
    signature = json['signature'] as String? ?? '';
    owner = json['owner'] as String? ?? '';
    createdBy = json['created_by'] as String? ?? '';
    lastModifiedBy = json['last_modified_by'] as String? ?? '';
    createdAt = json['created_at'] as String? ?? '';
    lastUpdatedAt = json['last_updated_at'] as String? ?? '';
    customStaffName = json['custom_staff_name'] as String? ?? '';
    staffName = json['StaffName'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site_hazard_id'] = this.siteHazardId;
    data['user_id'] = this.userId;
    data['signature'] = this.signature;
    data['owner'] = this.owner;
    data['created_by'] = this.createdBy;
    data['last_modified_by'] = this.lastModifiedBy;
    data['created_at'] = this.createdAt;
    data['last_updated_at'] = this.lastUpdatedAt;
    data['custom_staff_name'] = this.customStaffName;
    data['StaffName'] = this.staffName;
    return data;
  }
}
