class Job {
  String? jobId;
  String? jobAllocId;
  String? jobNo;
  String? schedDate;
  String? schedTime;
  int? siteContactCount;
  String? siteContactName;
  String? siteContactMobile;
  String? address;
  String? jobDesc;
  String? jobSpDesc;
  String? wpcompanyid;
  String? reqid;
  String? jobStatus;
  String? contractorId;
  String? updateAllowed;
  String? beforeImagesExists;
  String? images;
  String? afterImagesExists;
  String? deletebeforeimages;
  String? deleteAfterimages;
  String? treeinfoExists;
  String? costExists;
  String? siteHazardFormExists;
  String? siteHazardUploadExists;
  String? scheduleExists;
  String? imagesExists;
  String? jobReqId;
  String? jobDate;
  String? suburb;
  String? timeframe;
  String? invoiceDate;
  String? payDate;
  String? quoteDate;
  String? invoiceComplete;
  String? siteHazard;
  String? fenceRequired;
  String? scheduleDisplay;
  String? addressDisplay;
  String? callDialogVersion;
  String? overdue;
  String? deleteSiteHazardImages;
  String? deleteFenceImages;

  bool accepted;

  Job({
     this.jobId,
     this.jobAllocId,
     this.jobNo,
     this.schedDate,
     this.schedTime,
     this.siteContactCount,
     this.siteContactName,
     this.siteContactMobile,
     this.address,
     this.jobDesc,
     this.jobSpDesc,
     this.wpcompanyid,
     this.reqid,
     this.jobStatus,
     this.contractorId,
     this.updateAllowed,
     this.beforeImagesExists,
     this.images,
     this.afterImagesExists,
     this.deletebeforeimages,
     this.deleteAfterimages,
     this.deleteSiteHazardImages,
     this.deleteFenceImages,
     this.treeinfoExists,
     this.costExists,
     this.siteHazardFormExists,
     this.siteHazardUploadExists,
     this.scheduleExists,
     this.imagesExists,
     this.jobReqId,
     this.jobDate,
     this.suburb,
     this.timeframe,
     this.invoiceDate,
     this.payDate,
     this.quoteDate,
     this.invoiceComplete,
     this.siteHazard,
     this.fenceRequired,
     this.scheduleDisplay,
     this.addressDisplay,
     this.callDialogVersion,
     this.overdue,
    this.accepted = false,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobId: json['job_id'] as String? ?? '',
      jobAllocId: json['job_alloc_id'] as String? ?? '',
      jobNo: json['job_no'] ?? json['JobNo'] as String? ?? '',
      schedDate: json['SchedDate'] as String? ?? '',
      schedTime: json['SchedTime'] as String? ?? '',
      siteContactCount: json['SiteContactCount'] as int? ?? 0,
      siteContactName: json['SiteContactName'] as String? ?? '',
      siteContactMobile: json['SiteContactMobile'] as String? ?? '',
      address: json['Address'] as String? ?? '',
      jobDesc: json['job_desc'] as String? ?? '',
      jobSpDesc: json['job_sp_desc'] as String? ?? '',
      wpcompanyid: json['wpcompanyid'] as String? ?? '',
      reqid: json['reqid'] as String? ?? '',
      jobStatus: json['JobStatus'] as String? ?? '',
      contractorId: json['contractor_id'] as String? ?? '',
      updateAllowed: json['updateAllowed'] as String? ?? '',
      beforeImagesExists: json['ImagesExists'] ?? json['BeforeImagesExists'] as String? ?? '',
      images: json['images'] as String? ?? '',
      afterImagesExists: json['AfterImagesExists'] as String? ?? '',
      deletebeforeimages: json['deletebeforeimages'] as String? ?? '',
      deleteAfterimages: json['deleteAfterimages'] as String? ?? '',
      deleteSiteHazardImages: json['deleteSiteHazardImages'] as String? ?? '',
      deleteFenceImages: json['deleteFenceImages'] as String? ?? '',
      treeinfoExists: json['TreeInfoExists'] ?? json['treeinfoExists'] as String? ?? '',
      costExists: json['costExists'] ?? json['CostExists'] as String? ?? '',
      siteHazardFormExists: json['SiteHazardFormExists'] as String? ?? '',
      siteHazardUploadExists: json['SiteHazardUploadExists'] as String? ?? '',
      scheduleExists: json['ScheduleExists'] as String? ?? '',
      imagesExists: json['ImagesExists'] as String? ?? '',
      jobReqId: json['JobReqId'] as String? ?? '',
      jobDate: json['JobDate'] as String? ?? '',
      suburb: json['Suburb'] as String? ?? '',
      timeframe: json['Timeframe'] as String? ?? '',
      invoiceDate: json['InvoiceDate'] as String? ?? '',
      payDate: json['PayDate'] as String? ?? '',
      quoteDate: json['QuoteDate'] as String? ?? '',
      invoiceComplete: json['invoiceComplete'] as String? ?? '',
      siteHazard: json['SiteHazard'] as String? ?? '',
      fenceRequired: json['FenceRequired'] as String? ?? '',
      scheduleDisplay: json['ScheduleDisplay'] as String? ?? '',
      addressDisplay: json['AddressDisplay'] as String? ?? '',
      callDialogVersion: json['callDialogVersion'] as String? ?? '',
      overdue: json['overdue'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job_id'] = this.jobId;
    data['job_alloc_id'] = this.jobAllocId;
    data['job_no'] = this.jobNo;
    data['SchedDate'] = this.schedDate;
    data['SchedTime'] = this.schedTime;
    data['SiteContactCount'] = this.siteContactCount;
    data['SiteContactName'] = this.siteContactName;
    data['SiteContactMobile'] = this.siteContactMobile;
    data['Address'] = this.address;
    data['job_desc'] = this.jobDesc;
    data['job_sp_desc'] = this.jobSpDesc;
    data['wpcompanyid'] = this.wpcompanyid;
    data['reqid'] = this.reqid;
    data['JobStatus'] = this.jobStatus;
    data['contractor_id'] = this.contractorId;
    data['updateAllowed'] = this.updateAllowed;
    data['BeforeImagesExists'] = this.beforeImagesExists;
    data['images'] = this.images;
    data['AfterImagesExists'] = this.afterImagesExists;
    data['deletebeforeimages'] = this.deletebeforeimages;
    data['deleteAfterimages'] = this.deleteAfterimages;
    data['treeinfoExists'] = this.treeinfoExists;
    data['costExists'] = this.costExists;
    data['SiteHazardFormExists'] = this.siteHazardFormExists;
    data['SiteHazardUploadExists'] = this.siteHazardUploadExists;
    data['scheduleExists'] = this.scheduleExists;
    data['imagesExists'] = this.imagesExists;
    data['JobReqId'] = this.jobReqId;
    data['JobDate'] = this.jobDate;
    data['Suburb'] = this.suburb;
    data['Timeframe'] = this.timeframe;
    data['InvoiceDate'] = this.invoiceDate;
    data['PayDate'] = this.payDate;
    data['QuoteDate'] = this.quoteDate;
    data['invoiceComplete'] = this.invoiceComplete;
    data['siteHazard'] = this.siteHazard;
    data['FenceRequired'] = this.fenceRequired;
    data['ScheduleDisplay'] = this.scheduleDisplay;
    data['AddressDisplay'] = this.addressDisplay;
    data['callDialogVersion'] = this.callDialogVersion;
    data['overdue'] = this.overdue;
    return data;
  }
}


