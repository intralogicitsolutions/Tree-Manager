class FenceInfo {
  String? id;
  String? jobId;
  String? jobAllocId;
  String? processId;
  String? type;
  String? value1;
  String? value2;
  String? value3;
  String? value4;
  String? value5;
  String? value6;
  String? createdBy;
  String? createdAt;

  FenceInfo(
      {this.id,
      this.jobId,
      this.jobAllocId,
      this.processId,
      this.type,
      this.value1,
      this.value2,
      this.value3,
      this.value4,
      this.value5,
      this.value6,
      this.createdBy,
      this.createdAt});

  FenceInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'];
    jobAllocId = json['job_alloc_id'];
    processId = json['process_id'];
    type = json['type'];
    value1 = json['value_1'];
    value2 = json['value_2'];
    value3 = json['value_3'];
    value4 = json['value_4'];
    value5 = json['value_5'];
    value6 = json['value_6'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_id'] = this.jobId;
    data['job_alloc_id'] = this.jobAllocId;
    data['process_id'] = this.processId;
    data['type'] = this.type;
    data['value_1'] = this.value1;
    data['value_2'] = this.value2;
    data['value_3'] = this.value3;
    data['value_4'] = this.value4;
    data['value_5'] = this.value5;
    data['value_6'] = this.value6;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    return data;
  }
}
