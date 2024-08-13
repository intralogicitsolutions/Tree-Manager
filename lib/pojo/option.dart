class Option {
  String? id;
  String? workflowStep;
  String? optionNo;
  String? caption;
  String? prefillText;

  Option(
      {this.id,
      this.workflowStep,
      this.optionNo,
      this.caption,
      this.prefillText});

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workflowStep = json['workflow_step'];
    optionNo = json['option_no'];
    caption = json['caption'];
    prefillText = json['prefill_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['workflow_step'] = this.workflowStep;
    data['option_no'] = this.optionNo;
    data['caption'] = this.caption;
    data['prefill_text'] = this.prefillText;
    return data;
  }
}
