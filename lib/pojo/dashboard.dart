class Dash {
  String? contractorId;
  String? jobstatusCons;
  int? countOfJobs;
  int? overdueCount;

  Dash(
      {this.contractorId,
      this.jobstatusCons,
      this.countOfJobs,
      this.overdueCount});

  Dash.fromJson(Map<String, dynamic> json) {
    contractorId = json['contractor_id'];
    jobstatusCons = json['jobstatusCons'];
    countOfJobs = json['CountOfJobs'];
    overdueCount = json['OverdueCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contractor_id'] = this.contractorId;
    data['jobstatusCons'] = this.jobstatusCons;
    data['CountOfJobs'] = this.countOfJobs;
    data['OverdueCount'] = this.overdueCount;
    return data;
  }
}
