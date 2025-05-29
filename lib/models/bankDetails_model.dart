class BankDetails {
  String? id;
  String? bankName;
  String? accountTitle;
  String? accountNumber;
  String? iban;
  String? entityDate;
  String? createdDate;
  String? updatedDate;

  BankDetails({
    this.id,
    this.bankName,
    this.accountTitle,
    this.accountNumber,
    this.iban,
    this.entityDate,
    this.createdDate,
    this.updatedDate,
  });

  BankDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankName = json['bankName'];
    accountTitle = json['accountTitle'];
    accountNumber = json['accountNumber'];
    iban = json['IBAN'];
    entityDate = json['entityDate'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bankName'] = bankName;
    data['accountTitle'] = accountTitle;
    data['accountNumber'] = accountNumber;
    data['IBAN'] = iban;
    data['entityDate'] = entityDate;
    data['createdDate'] = createdDate;
    data['updatedDate'] = updatedDate;
    return data;
  }
}