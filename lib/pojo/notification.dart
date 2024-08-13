class Notification {
  String? jobId;
  String? jobAllocId;
  String? contractorId;
  String? processId;
  String? userId;
  String? workflowStepId;
  String? msgStatus;
  String? notificationHeading;
  String? notificationMessage;
  String? notificationDetailMessage;
  String? summaryMessage;
  String? jobNo;
  String? address;
  String? statusSummary;

  bool accepted=false;

  Notification(
      {this.jobId,
      this.jobAllocId,
      this.contractorId,
      this.processId,
      this.userId,
      this.workflowStepId,
      this.msgStatus,
      this.notificationHeading,
      this.notificationMessage,
      this.notificationDetailMessage,
      this.summaryMessage,
      this.jobNo,
      this.address,
      this.statusSummary});

  Notification.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'];
    jobAllocId = json['job_alloc_id'];
    contractorId = json['contractor_id'];
    processId = json['process_id'];
    userId = json['user_id'];
    workflowStepId = json['workflow_step_id'];
    msgStatus = json['msg_status'];
    notificationHeading = json['notification_heading'];
    notificationMessage = json['notification_message'];
    notificationDetailMessage = json['notification_detail_message'];
    summaryMessage = json['SummaryMessage'];
    jobNo = json['JobNo'];
    address = json['Address'];
    statusSummary = json['StatusSummary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_id'] = this.jobId;
    data['job_alloc_id'] = this.jobAllocId;
    data['contractor_id'] = this.contractorId;
    data['process_id'] = this.processId;
    data['user_id'] = this.userId;
    data['workflow_step_id'] = this.workflowStepId;
    data['msg_status'] = this.msgStatus;
    data['notification_heading'] = this.notificationHeading;
    data['notification_message'] = this.notificationMessage;
    data['notification_detail_message'] = this.notificationDetailMessage;
    data['SummaryMessage'] = this.summaryMessage;
    data['JobNo'] = this.jobNo;
    data['Address'] = this.address;
    data['StatusSummary'] = this.statusSummary;
    return data;
  }
}
