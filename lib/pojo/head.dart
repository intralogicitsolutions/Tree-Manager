class Head {
  String? id;
  String? rateSetId;
  String? jobId;
  String? jobAllocId;
  String? costRefno;
  double? subTotal;
  int? taxRate;
  double? tpTaxTotal;
  double? tpGrandTotal;
  String? processId;
  String? jobManager;
  String? jobContact;
  String? jobNotes;
  String? owner;
  String? createdBy;
  String? lastModifiedBy;
  String? createdAt;
  String? lastUpdatedAt;
  String? wpPmNotes;
  String? wpPmSubstantiation;
  String? tpJobSubstantiation;
  int? wpGrandTotal;
  int? wpTaxTotal;
  String? date;
  String? wpRateSetId;
  String? quoteDate;
  String? quoteNo;
  String? tpInvoiceNo;
  String? status;
  int? wpSubTotal;
  String? wpInvoiceNo;
  String? wpInvDt;
  String? source;
  String? rebateTotal;
  String? markComplete;
  String? tpPayDt;
  String? uploadBy;
  String? tpInvoiceDt;

  Head(
      {this.id,
      this.rateSetId,
      this.jobId,
      this.jobAllocId,
      this.costRefno,
      this.subTotal,
      this.taxRate,
      this.tpTaxTotal,
      this.tpGrandTotal,
      this.processId,
      this.jobManager,
      this.jobContact,
      this.jobNotes,
      this.owner,
      this.createdBy,
      this.lastModifiedBy,
      this.createdAt,
      this.lastUpdatedAt,
      this.wpPmNotes,
      this.wpPmSubstantiation,
      this.tpJobSubstantiation,
      this.wpGrandTotal,
      this.wpTaxTotal,
      this.date,
      this.wpRateSetId,
      this.quoteDate,
      this.quoteNo,
      this.tpInvoiceNo,
      this.status,
      this.wpSubTotal,
      this.wpInvoiceNo,
      this.wpInvDt,
      this.source,
      this.rebateTotal,
      this.markComplete,
      this.tpPayDt,
      this.uploadBy,
      this.tpInvoiceDt});

  Head.fromJson(Map<String, dynamic> json) {
    print('jsonjsonjsonjsondatadta ==> ${json}');
    id = json['id'] as String? ?? '';
    rateSetId = json['rate_set_id'] as String? ?? '';
    jobId = json['job_id'] as String? ?? '';
    jobAllocId = json['job_alloc_id'] as String? ?? '';
    costRefno = json['cost_refno'] as String? ?? '';
    // subTotal = double.parse(json['sub_total'].toString());
    // taxRate = double.parse(json['tax_rate'].toString());
    // tpTaxTotal = double.parse(json['tp_tax_total'].toString());
    // tpGrandTotal = double.parse(json['tp_grand_total'].toString());

    // subTotal = json['sub_total'] as double? ?? 0.0;
    subTotal = json['sub_total'] != null
        ? (json['sub_total'] is int
        ? (json['sub_total'] as int).toDouble()
        : json['sub_total'] as double?)
        : 0.0;
    taxRate = json['tax_rate'] as int? ?? 0;
    tpTaxTotal = json['tp_tax_total'] as double? ?? 0.0;
    tpGrandTotal = json['tp_grand_total'] as double? ?? 0.0;

    // subTotal = (json['sub_total'] as num?)?.toDouble();
    // taxRate = (json['tax_rate'] as num?)?.toDouble();
    // tpTaxTotal = (json['tp_tax_total'] as num?)?.toDouble();
    // tpGrandTotal = (json['tp_grand_total'] as num?)?.toDouble();

    processId = json['process_id'] as String? ?? '';
    jobManager = json['job_manager'] as String? ?? '';
    jobContact = json['job_contact'] as String? ?? '';
    jobNotes = json['job_notes'] as String? ?? '';
    owner = json['owner'] as String? ?? '';
    createdBy = json['created_by'] as String? ?? '';
    lastModifiedBy = json['last_modified_by'] as String? ?? '';
    createdAt = json['created_at'] as String? ?? '';
    lastUpdatedAt = json['last_updated_at'] as String? ?? '';
    wpPmNotes = json['wp_pm_notes'] as String?;
    wpPmSubstantiation = json['wp_pm_substantiation'] as String? ?? '';
    tpJobSubstantiation = json['tp_job_substantiation'] as String? ?? '';
    wpGrandTotal = json['wp_grand_total'] as int? ?? 0;
    wpTaxTotal = json['wp_tax_total'] as int? ?? 0;
    date = json['date'] as String? ?? '';
    wpRateSetId = json['wp_rate_set_id'] as String? ?? '';
    quoteDate = json['quote_date'] as String? ?? '';
    quoteNo = json['quote_no'] as String? ?? '';
    tpInvoiceNo = json['tp_invoice_no'] as String? ?? '';
    status = json['status'] as String? ?? '';
    wpSubTotal = json['wp_sub_total'] as int? ?? 0;
    wpInvoiceNo = json['wp_invoice_no'] as String? ?? '';
    wpInvDt = json['wp_inv_dt'] as String? ?? '';
    source = json['source'] as String? ?? '';
    rebateTotal = json['rebate_total'] as String? ?? '';
    markComplete = json['mark_complete'] as String? ?? '';
    tpPayDt = json['tp_pay_dt'] as String? ?? '';
    uploadBy = json['Upload_by'] as String? ?? '';
    tpInvoiceDt = json['tp_invoice_dt'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rate_set_id'] = this.rateSetId;
    data['job_id'] = this.jobId;
    data['job_alloc_id'] = this.jobAllocId;
    data['cost_refno'] = this.costRefno;
    data['sub_total'] = this.subTotal;
    data['tax_rate'] = this.taxRate;
    data['tp_tax_total'] = this.tpTaxTotal;
    data['tp_grand_total'] = this.tpGrandTotal;
    data['process_id'] = this.processId;
    data['job_manager'] = this.jobManager;
    data['job_contact'] = this.jobContact;
    data['job_notes'] = this.jobNotes;
    data['owner'] = this.owner;
    data['created_by'] = this.createdBy;
    data['last_modified_by'] = this.lastModifiedBy;
    data['created_at'] = this.createdAt;
    data['last_updated_at'] = this.lastUpdatedAt;
    data['wp_pm_notes'] = this.wpPmNotes;
    data['wp_pm_substantiation'] = this.wpPmSubstantiation;
    data['tp_job_substantiation'] = this.tpJobSubstantiation;
    data['wp_grand_total'] = this.wpGrandTotal;
    data['wp_tax_total'] = this.wpTaxTotal;
    data['date'] = this.date;
    data['wp_rate_set_id'] = this.wpRateSetId;
    data['quote_date'] = this.quoteDate;
    data['quote_no'] = this.quoteNo;
    data['tp_invoice_no'] = this.tpInvoiceNo;
    data['status'] = this.status;
    data['wp_sub_total'] = this.wpSubTotal;
    data['wp_invoice_no'] = this.wpInvoiceNo;
    data['wp_inv_dt'] = this.wpInvDt;
    data['source'] = this.source;
    data['rebate_total'] = this.rebateTotal;
    data['mark_complete'] = this.markComplete;
    data['tp_pay_dt'] = this.tpPayDt;
    data['Upload_by'] = this.uploadBy;
    data['tp_invoice_dt'] = this.tpInvoiceDt;
    return data;
  }
}
