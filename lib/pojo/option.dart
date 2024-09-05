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
    id = json['id'] as String? ?? '';
    workflowStep = json['workflow_step'] as String? ?? '';
    optionNo = json['option_no'] as String? ?? '';
    caption = json['caption'] as String? ?? '';
    prefillText = json['prefill_text'] as String? ?? '';
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
