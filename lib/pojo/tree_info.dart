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
    id = json['id'] as String? ?? '';
    jobId = json['job_id'] as String? ?? '';
    jobNo = json['job_no'] as String? ?? '';
    jobAllocId = json['job_alloc_id'] as String? ?? '';
    height = json['height'] as String? ?? '';
    trunk = json['trunk'] as String? ?? '';
    treeLocation = json['tree_location'] as String? ?? '';
    distance = json['distance'] as String? ?? '';
    health = json['health'] as String? ?? '';
    access = json['access'] as String? ?? '';
    workCategory = json['work_category'] as String? ?? '';
    waste = json['waste'] as String? ?? '';
    fence = json['fence'] as String? ?? '';
    roof = json['roof'] as String? ?? '';
    other = json['other'] as String? ?? '';
    noTree = json['no_tree'] as String? ?? '';
    age = json['age'] as String? ?? '';
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
