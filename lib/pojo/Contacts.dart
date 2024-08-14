class Contact {
  String? jobId;
  String? workNumber;
  String? contactName;
  String? mobile;
  String? homeNumber;

  Contact(
      {this.jobId,
      this.workNumber,
      this.contactName,
      this.mobile,
      this.homeNumber});

  Contact.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'] as String? ?? '';
    workNumber = json['WorkNumber'] as String? ?? '';
    contactName = json['ContactName'] as String? ?? '';
    mobile = json['Mobile'] as String? ?? '';
    homeNumber = json['HomeNumber'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_id'] = this.jobId;
    data['WorkNumber'] = this.workNumber;
    data['ContactName'] = this.contactName;
    data['Mobile'] = this.mobile;
    data['HomeNumber'] = this.homeNumber;
    return data;
  }
}
