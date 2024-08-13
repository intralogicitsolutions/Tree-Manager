class Crew {
  String? crewDesc;
  String? crewName;
  String? id;

  Crew({this.crewDesc, this.crewName, this.id});

  Crew.fromJson(Map<String, dynamic> json) {
    crewDesc = json['crew_desc'];
    crewName = json['crew_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crew_desc'] = this.crewDesc;
    data['crew_name'] = this.crewName;
    data['id'] = this.id;
    return data;
  }
}