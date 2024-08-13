class DashSearch {
  String? jobId;
  String? jobNo;
  String? allocationId;
  String? fullAddress;
  String? navigationStep;
  String? jobStatus;
  String? jobDate;

  DashSearch(
      {this.jobId,
      this.jobNo,
      this.allocationId,
      this.fullAddress,
      this.navigationStep,
      this.jobStatus,
      this.jobDate});

  DashSearch.fromJson(Map<String, dynamic> json) {
    jobId = json['JobId'];
    jobNo = json['JobNo'];
    allocationId = json['AllocationId'];
    fullAddress = json['FullAddress'];
    navigationStep = json['navigationStep'];
    jobStatus = json['JobStatus'];
    jobDate = json['JobDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobId'] = this.jobId;
    data['JobNo'] = this.jobNo;
    data['AllocationId'] = this.allocationId;
    data['FullAddress'] = this.fullAddress;
    data['navigationStep'] = this.navigationStep;
    data['JobStatus'] = this.jobStatus;
    data['JobDate'] = this.jobDate;
    return data;
  }
}
