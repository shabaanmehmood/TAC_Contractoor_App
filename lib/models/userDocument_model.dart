class UserDocument {
  final String? id;
  final String? type;
  final String? fileUrl;
  final String? originalFileName;
  final String? documentNumber;
  final String? expiryDate;
  final bool? isVerified;
  final String? createdDate;
  final String? updatedDate;

  UserDocument({
    this.id,
    this.type,
    this.fileUrl,
    this.originalFileName,
    this.documentNumber,
    this.expiryDate,
    this.isVerified,
    this.createdDate,
    this.updatedDate,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json) {
    return UserDocument(
      id: json['id'],
      type: json['type'],
      fileUrl: json['fileUrl'],
      originalFileName: json['originalFileName'],
      documentNumber: json['documentNumber'],
      expiryDate: json['expiryDate'],
      isVerified: json['isVerified'],
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
    );
  }
}