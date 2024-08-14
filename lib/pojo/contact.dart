class Contact {
  String? jobId;
  String? contactName;
  String? homeNumber;
  String? workNumber;
  String? mobile;

  Contact(
      {this.jobId,
      this.contactName,
      this.homeNumber,
      this.workNumber,
      this.mobile});

  Contact.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'] as String? ?? '';
    contactName = json['ContactName'] as String? ?? '';
    homeNumber = json['HomeNumber'] as String? ?? '';
    workNumber = json['WorkNumber'] as String? ?? '';
    mobile = json['Mobile'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_id'] = this.jobId;
    data['ContactName'] = this.contactName;
    data['HomeNumber'] = this.homeNumber;
    data['WorkNumber'] = this.workNumber;
    data['Mobile'] = this.mobile;
    return data;
  }
}
