class Task{

  String? id;
  String? label;
  String? value;
  String? caption;
  Task({this.id,this.label,this.value,this.caption});

  // Task.fromJson(Map<String, dynamic> json) {
  //   id = json['id'] as String? ?? '';
  //   label = json['label'] as String? ?? '';
  //   value = json['value'] as String? ?? '';
  //   caption = json['caption'] as String? ?? '';
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['label'] = this.label;
  //   data['value'] = this.value;
  //   data['caption'] = this.caption;
  //   return data;
  // }

}