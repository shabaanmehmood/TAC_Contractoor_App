class ProfileImages {
  String? id;
  String? imageUrl;
  bool? isMain;
  String? createdDate;

  ProfileImages({this.id, this.imageUrl, this.isMain, this.createdDate});

  ProfileImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    isMain = json['isMain'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['isMain'] = this.isMain;
    data['createdDate'] = this.createdDate;
    return data;
  }
}