class Hazard {
  String? id;
  String? jobId;
  String? jobAllocId;
  String? completedBy;
  String? completionTime;
  int? personsOnSite;
  String? riskDetails;
  String? otherStaffDetails;
  String? processId;
  String? criteria1;
  String? riskRating1;
  String? control1;
  String? criteria2;
  String? riskRating2;
  String? control2;
  String? criteria3;
  String? riskRating3;
  String? control3;
  String? criteria4;
  String? riskRating4;
  String? control4;
  String? criteria5;
  String? riskRating5;
  String? control5;
  String? declaration;
  String? owner;
  String? createdBy;
  String? lastModifiedBy;
  String? createdAt;
  String? lastUpdatedAt;
  String? preworkYn;
  String? accidentsYn;
  String? accidentComments;
  String? equipment;
  String? task;
  String? taskOther;
  String? questionnaire;
  String? status;
  String? otherHazard1;
  String? otherHazard2;
  String? otherHazard3;
  String? otherHazard4;
  String? otherControl1;
  String? otherControl2;
  String? otherControl3;
  String? otherControl4;
  String? customStaffName;

  Hazard(
      {this.id,
      this.jobId,
      this.jobAllocId,
      this.completedBy,
      this.completionTime,
      this.personsOnSite,
      this.riskDetails,
      this.otherStaffDetails,
      this.processId,
      this.criteria1,
      this.riskRating1,
      this.control1,
      this.criteria2,
      this.riskRating2,
      this.control2,
      this.criteria3,
      this.riskRating3,
      this.control3,
      this.criteria4,
      this.riskRating4,
      this.control4,
      this.criteria5,
      this.riskRating5,
      this.control5,
      this.declaration,
      this.owner,
      this.createdBy,
      this.lastModifiedBy,
      this.createdAt,
      this.lastUpdatedAt,
      this.preworkYn,
      this.accidentsYn,
      this.accidentComments,
      this.equipment,
      this.task,
      this.taskOther,
      this.questionnaire,
      this.status,
      this.otherHazard1,
      this.otherHazard2,
      this.otherHazard3,
      this.otherHazard4,
      this.otherControl1,
      this.otherControl2,
      this.otherControl3,
      this.otherControl4,
      this.customStaffName});

  Hazard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'];
    jobAllocId = json['job_alloc_id'];
    completedBy = json['completed_by'];
    completionTime = json['completion_time'];
    personsOnSite = json['persons_on_site'];
    riskDetails = json['risk_details'];
    otherStaffDetails = json['other_staff_details'];
    processId = json['process_id'];
    criteria1 = json['criteria_1'];
    riskRating1 = json['risk_rating_1'];
    control1 = json['control_1'];
    criteria2 = json['criteria_2'];
    riskRating2 = json['risk_rating_2'];
    control2 = json['control_2'];
    criteria3 = json['criteria_3'];
    riskRating3 = json['risk_rating_3'];
    control3 = json['control_3'];
    criteria4 = json['criteria_4'];
    riskRating4 = json['risk_rating_4'];
    control4 = json['control_4'];
    criteria5 = json['criteria_5'];
    riskRating5 = json['risk_rating_5'];
    control5 = json['control_5'];
    declaration = json['declaration'];
    owner = json['owner'];
    createdBy = json['created_by'];
    lastModifiedBy = json['last_modified_by'];
    createdAt = json['created_at'];
    lastUpdatedAt = json['last_updated_at'];
    preworkYn = json['prework_yn'];
    accidentsYn = json['accidents_yn'];
    accidentComments = json['accident_comments'];
    equipment = json['equipment'];
    task = json['task'];
    taskOther = json['task_other'];
    questionnaire = json['Questionnaire'];
    status = json['status'];
    otherHazard1 = json['other_hazard_1'];
    otherHazard2 = json['other_hazard_2'];
    otherHazard3 = json['other_hazard_3'];
    otherHazard4 = json['other_hazard_4'];
    otherControl1 = json['other_control_1'];
    otherControl2 = json['other_control_2'];
    otherControl3 = json['other_control_3'];
    otherControl4 = json['other_control_4'];
    customStaffName = json['custom_staff_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_id'] = this.jobId;
    data['job_alloc_id'] = this.jobAllocId;
    data['completed_by'] = this.completedBy;
    data['completion_time'] = this.completionTime;
    data['persons_on_site'] = this.personsOnSite;
    data['risk_details'] = this.riskDetails;
    data['other_staff_details'] = this.otherStaffDetails;
    data['process_id'] = this.processId;
    data['criteria_1'] = this.criteria1;
    data['risk_rating_1'] = this.riskRating1;
    data['control_1'] = this.control1;
    data['criteria_2'] = this.criteria2;
    data['risk_rating_2'] = this.riskRating2;
    data['control_2'] = this.control2;
    data['criteria_3'] = this.criteria3;
    data['risk_rating_3'] = this.riskRating3;
    data['control_3'] = this.control3;
    data['criteria_4'] = this.criteria4;
    data['risk_rating_4'] = this.riskRating4;
    data['control_4'] = this.control4;
    data['criteria_5'] = this.criteria5;
    data['risk_rating_5'] = this.riskRating5;
    data['control_5'] = this.control5;
    data['declaration'] = this.declaration;
    data['owner'] = this.owner;
    data['created_by'] = this.createdBy;
    data['last_modified_by'] = this.lastModifiedBy;
    data['created_at'] = this.createdAt;
    data['last_updated_at'] = this.lastUpdatedAt;
    data['prework_yn'] = this.preworkYn;
    data['accidents_yn'] = this.accidentsYn;
    data['accident_comments'] = this.accidentComments;
    data['equipment'] = this.equipment;
    data['task'] = this.task;
    data['task_other'] = this.taskOther;
    data['Questionnaire'] = this.questionnaire;
    data['status'] = this.status;
    data['other_hazard_1'] = this.otherHazard1;
    data['other_hazard_2'] = this.otherHazard2;
    data['other_hazard_3'] = this.otherHazard3;
    data['other_hazard_4'] = this.otherHazard4;
    data['other_control_1'] = this.otherControl1;
    data['other_control_2'] = this.otherControl2;
    data['other_control_3'] = this.otherControl3;
    data['other_control_4'] = this.otherControl4;
    data['custom_staff_name'] = this.customStaffName;
    return data;
  }
}
