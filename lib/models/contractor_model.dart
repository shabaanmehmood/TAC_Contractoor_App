class ContractorModel {
  final String id;
  final String name;
  final String? email;
  final String? gender;
  final String? phone;

  ContractorModel({
    required this.id,
    required this.name,
    this.email,
    this.gender,
    this.phone,
  });

  factory ContractorModel.fromJson(Map<String, dynamic> json) {
    return ContractorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      gender: json['gender'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'phone': phone,
    };
  }
}
