class InvoiceData {
  String? id;
  String? jobId;
  String? jobAllocId;
  String? accidentsYn;
  String? accidentsText;
  String? completedYn;
  String? completedText;
  String? customerYn;
  bool? signOffReqd;
  String? signOffYn;
  bool? invoiceAllowed;
  String? invoiceYn;
  int? createdBy;
  String? createdAt;
  int? lastModifiedBy;
  String? lastUpdatedAt;

  InvoiceData(
      { this.id,
       this.jobId,
       this.jobAllocId,
       this.accidentsYn,
       this.accidentsText,
       this.completedYn,
       this.completedText,
       this.customerYn,
       this.signOffReqd,
       this.signOffYn,
       this.invoiceAllowed,
       this.invoiceYn,
       this.createdBy,
       this.createdAt,
       this.lastModifiedBy,
       this.lastUpdatedAt});

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      id: json['id'] as String? ?? '',
      jobId: json['job_id'] as String? ?? '',
      jobAllocId: json['job_alloc_id'] as String? ?? '',
      accidentsYn: json['accidents_yn'] as String? ?? '',
      accidentsText: json['accidents_text'] as String? ?? '',
      completedYn: json['completed_yn'] as String? ?? '',
      completedText: json['completed_text'] as String? ?? '',
      customerYn: json['customer_yn'] as String? ?? '',
      signOffReqd: json['sign_off_reqd'] as bool? ?? false,
      signOffYn: json['sign_off_yn'] as String? ?? '',
      invoiceAllowed: json['invoice_allowed'] as bool? ?? false,
      invoiceYn: json['invoice_yn'] as String? ?? '',
      createdBy: json['created_by'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      lastModifiedBy: json['last_modified_by'] as int? ?? 0,
      lastUpdatedAt: json['last_updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_id'] = this.jobId;
    data['job_alloc_id'] = this.jobAllocId;
    data['accidents_yn'] = this.accidentsYn;
    data['accidents_text'] = this.accidentsText;
    data['completed_yn'] = this.completedYn;
    data['completed_text'] = this.completedText;
    data['customer_yn'] = this.customerYn;
    data['sign_off_reqd'] = this.signOffReqd;
    data['sign_off_yn'] = this.signOffYn;
    data['invoice_allowed'] = this.invoiceAllowed;
    data['invoice_yn'] = this.invoiceYn;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['last_modified_by'] = this.lastModifiedBy;
    data['last_updated_at'] = this.lastUpdatedAt;
    return data;
  }
}
