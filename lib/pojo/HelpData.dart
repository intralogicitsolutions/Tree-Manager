class HelpData {
  String? aUPhone=' ';
  String? aUEmail=' ';
  String? nZPhone=' ';
  String? nZEmail=' ';

  HelpData({this.aUPhone, this.aUEmail, this.nZPhone, this.nZEmail});

  HelpData.fromJson(Map<String, dynamic> json) {
    aUPhone = json['AUPhone'];
    aUEmail = json['AUEmail'];
    nZPhone = json['NZPhone'];
    nZEmail = json['NZEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AUPhone'] = this.aUPhone;
    data['AUEmail'] = this.aUEmail;
    data['NZPhone'] = this.nZPhone;
    data['NZEmail'] = this.nZEmail;
    return data;
  }
}