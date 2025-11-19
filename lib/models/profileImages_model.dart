class ProfileImages {
  String? image;
  bool? isMain;
  // String? createdDate;

  ProfileImages({
    this.image,
    this.isMain,
    // this.createdDate
  });

  ProfileImages.fromJson(Map<String, dynamic> json) {
    image = json['imageUrl'];
    isMain = json['isMain'];
    // createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['isMain'] = this.isMain;
    // data['createdDate'] = this.createdDate;
    return data;
  }
}
