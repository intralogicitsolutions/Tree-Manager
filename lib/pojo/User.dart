class User {
  String? id;
  String? password;
  String? companyId;
  int? processId;
  String? userName;
  String? userLocked;
  int? loginAttempt;
  String? staffId;
  int? invalidCount;
  String? clientType;
  String? userGroupId;

  User(
      {this.id,
      this.password,
      this.companyId,
      this.processId,
      this.userName,
      this.userLocked,
      this.loginAttempt,
      this.staffId,
      this.invalidCount,
      this.clientType,
      this.userGroupId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    companyId = json['company_id'];
    processId = json['process_id'];
    userName = json['UserName'];
    userLocked = json['user_locked'];
    loginAttempt = json['login_attempt'];
    staffId = json['staff_id'];
    invalidCount = json['Invalid_count'];
    clientType = json['Client_Type'];
    userGroupId = json['user_group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['company_id'] = this.companyId;
    data['process_id'] = this.processId;
    data['UserName'] = this.userName;
    data['user_locked'] = this.userLocked;
    data['login_attempt'] = this.loginAttempt;
    data['staff_id'] = this.staffId;
    data['Invalid_count'] = this.invalidCount;
    data['Client_Type'] = this.clientType;
    data['user_group_id'] = this.userGroupId;
    return data;
  }
}
