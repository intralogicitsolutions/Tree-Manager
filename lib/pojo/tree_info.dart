class TreeInfo {
  String? id;
  String? jobId;
  String? jobNo;
  String? jobAllocId;
  String? height;
  String? trunk;
  String? treeLocation;
  String? distance;
  String? health;
  String? access;
  String? workCategory;
  String? waste;
  String? fence;
  String? roof;
  String? other;
  String? noTree;
  String? age;

  TreeInfo(
      {this.id,
      this.jobId,
      this.jobNo,
      this.jobAllocId,
      this.height,
      this.trunk,
      this.treeLocation,
      this.distance,
      this.health,
      this.access,
      this.workCategory,
      this.waste,
      this.fence='6',
      this.roof='5',
      this.other='9',
      this.noTree,
      this.age});

  TreeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'];
    jobNo = json['job_no'];
    jobAllocId = json['job_alloc_id'];
    height = json['height'];
    trunk = json['trunk'];
    treeLocation = json['tree_location'];
    distance = json['distance'];
    health = json['health'];
    access = json['access'];
    workCategory = json['work_category'];
    waste = json['waste'];
    fence = json['fence'];
    roof = json['roof'];
    other = json['other'];
    noTree = json['no_tree'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_id'] = this.jobId;
    data['job_no'] = this.jobNo;
    data['job_alloc_id'] = this.jobAllocId;
    data['height'] = this.height;
    data['trunk'] = this.trunk;
    data['tree_location'] = this.treeLocation;
    data['distance'] = this.distance;
    data['health'] = this.health;
    data['access'] = this.access;
    data['work_category'] = this.workCategory;
    data['waste'] = this.waste;
    data['fence'] = this.fence;
    data['roof'] = this.roof;
    data['other'] = this.other;
    data['no_tree'] = this.noTree;
    data['age'] = this.age;
    return data;
  }
}
