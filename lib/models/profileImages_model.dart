class ProfileImages {
  String? imageUrl;
  bool? isMain;
  // String? createdDate;

  ProfileImages({this.imageUrl, this.isMain,
    // this.createdDate
  });

  ProfileImages.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    isMain = json['isMain'];
    // createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['isMain'] = this.isMain;
    // data['createdDate'] = this.createdDate;
    return data;
  }
}