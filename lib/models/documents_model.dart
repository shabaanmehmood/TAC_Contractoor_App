class Documents {
  String? id;
  String? type;
  String? fileUrl;
  String? originalFileName;
  bool? isVerified;
  String? createdDate;
  String? updatedDate;

  Documents({
    this.id,
    this.type,
    this.fileUrl,
    this.originalFileName,
    this.isVerified,
    this.createdDate,
    this.updatedDate,
  });

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    fileUrl = json['fileUrl'];
    originalFileName = json['originalFileName'];
    isVerified = json['isVerified'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['type'] = type;
    data['fileUrl'] = fileUrl;
    data['originalFileName'] = originalFileName;
    data['isVerified'] = isVerified;
    data['createdDate'] = createdDate;
    data['updatedDate'] = updatedDate;
    return data;
  }
}
