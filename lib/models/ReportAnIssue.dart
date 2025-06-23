class ReportAnIssueModel {
  String? subject;
  String? contractorId;
  String? issueDate;
  String? description;
  List<String>? supportDocuments;

  ReportAnIssueModel({
    this.subject,
    this.contractorId,
    this.issueDate,
    this.description,
    this.supportDocuments,
  });

  Map<String, dynamic> toJson() {
    return {
      if (subject != null) 'subject': subject,
      if (contractorId != null) 'contractor': contractorId,
      if (issueDate != null) 'issueDate': issueDate,
      if (description != null) 'description': description,
      if (supportDocuments != null && supportDocuments!.isNotEmpty)
        'supportDocuments': supportDocuments,
    };
  }
}
