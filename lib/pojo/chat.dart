class Chat {
  String? id;
  String? schedNote;
  String? username;
  String? createdAt;

  Chat({this.id, this.schedNote, this.username, this.createdAt});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schedNote = json['sched_note'];
    username = json['username'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sched_note'] = this.schedNote;
    data['username'] = this.username;
    data['created_at'] = this.createdAt;
    return data;
  }
}
