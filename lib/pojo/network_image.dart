import 'dart:io';

class NetworkPhoto {
  String? source;
  String? vs;
  String? id;
  String? jobId;
  String? jobAllocId;
  String? companyId;
  String? uploadType;
  String? uploadTypeDetail;
  String? imgInc;
  String? imgType;
  String? imgPath;
  String? imgDescription;
  String? imgName;
  String? status;
  String? processId;
  Null owner;
  Null createdBy;
  Null lastModifiedBy;
  Null createdAt;
  Null lastUpdatedAt;
  String? included;
  String? uploadBy;
  String? uploadTime;
  String? username;
  String? userId;

 // File? localImage;
  bool? camera=false;
  File? fromFile;
  //XFile? image;
  //File? localImage;


  NetworkPhoto(
      {this.source,
        this.vs,
        this.id,
        this.jobId,
        this.jobAllocId,
        this.companyId,
        this.uploadType,
        this.uploadTypeDetail,
        this.imgInc,
        this.imgType,
        this.imgPath,
        this.imgDescription,
        this.imgName,
        this.status,
        this.processId,
        this.owner,
        this.createdBy,
        this.lastModifiedBy,
        this.createdAt,
        this.lastUpdatedAt,
        this.included,
        this.uploadBy,
        this.uploadTime,
        this.username,
        this.userId,
        this.camera,
      });

  NetworkPhoto.fromJson(Map<String, dynamic> json) {
    print('jsonjsonjsonjson ==> ${json}');
    source = json['source'];
    vs = json['vs'];
    id = json['id'];
    jobId = json['job_id'];
    jobAllocId = json['job_alloc_id'];
    companyId = json['company_id'];
    uploadType = json['upload_type'];
    uploadTypeDetail = json['upload_type_detail'];
    imgInc = json['img_inc'];
    imgType = json['img_type'];
    imgPath = json['img_path'];
    imgDescription = json['img_description'];
    imgName = json['img_name'];
    status = json['status'];
    processId = json['process_id'];
    owner = json['owner'];
    createdBy = json['created_by'];
    lastModifiedBy = json['last_modified_by'];
    createdAt = json['created_at'];
    lastUpdatedAt = json['last_updated_at'];
    included = json['included'];
    uploadBy = json['upload_by'];
    uploadTime = json['upload_time'];
    username = json['username'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    data['vs'] = this.vs;
    data['id'] = this.id;
    data['job_id'] = this.jobId;
    data['job_alloc_id'] = this.jobAllocId;
    data['company_id'] = this.companyId;
    data['upload_type'] = this.uploadType;
    data['upload_type_detail'] = this.uploadTypeDetail;
    data['img_inc'] = this.imgInc;
    data['img_type'] = this.imgType;
    data['img_path'] = this.imgPath;
    data['img_description'] = this.imgDescription;
    data['img_name'] = this.imgName;
    data['status'] = this.status;
    data['process_id'] = this.processId;
    data['owner'] = this.owner;
    data['created_by'] = this.createdBy;
    data['last_modified_by'] = this.lastModifiedBy;
    data['created_at'] = this.createdAt;
    data['last_updated_at'] = this.lastUpdatedAt;
    data['included'] = this.included;
    data['upload_by'] = this.uploadBy;
    data['upload_time'] = this.uploadTime;
    data['username'] = this.username;
    data['user_id'] = this.userId;
    return data;
  }
}
