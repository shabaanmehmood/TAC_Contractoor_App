class CreateDisputeModel {
  String? disputeType;
  String? jobId;
  String? dateOfIncident;
  String? description;
  String? transactionId;
  String? transactionDate;
  String? disputeAmount;
  String? contractorId;
  String? supportingDocument;

  CreateDisputeModel({
    this.disputeType,
    this.jobId,
    this.dateOfIncident,
    this.description,
    this.transactionId,
    this.transactionDate,
    this.disputeAmount,
    this.contractorId,
    this.supportingDocument,
  });

  Map<String, dynamic> toJson() {
    return {
      if (disputeType != null) 'disputeType': disputeType,
      if (jobId != null) 'jobId': jobId,
      if (dateOfIncident != null) 'dateOfIncident': dateOfIncident,
      if (description != null) 'description': description,
      if (transactionId != null) 'transactionId': transactionId,
      if (transactionDate != null) 'transactionDate': transactionDate,
      if (disputeAmount != null) 'disputeAmount': disputeAmount,
      if (contractorId != null) 'contractorId': contractorId,
      if (supportingDocument != null) 'supportingDocument': supportingDocument,
    };
  }
}
