class Document {
  final String? type;
  final String? fileUrl;
  final String? originalFileName;
  final String? documentNumber;
  final String? expiryDate;

  Document({
    this.type,
    this.fileUrl,
    this.originalFileName,
    this.documentNumber,
    this.expiryDate,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      type: json['type'],
      fileUrl: json['fileUrl'],
      originalFileName: json['originalFileName'],
      documentNumber: json['documentNumber'],
      expiryDate: json['expiryDate'],
    );
  }
}
