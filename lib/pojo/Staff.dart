class Staff {
  String? id;
  String? firstName;
  String? lastName;

  bool? checked=false;
  bool? rev_checked=false;
  bool? signed=false;
  bool? uploaded=false;
  String? base64;
  String? created_at;
  String? sign_id;

  Staff({this.id, this.firstName, this.lastName});

  Staff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
