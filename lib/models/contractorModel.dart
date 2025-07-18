class Contractor {
  final String id;
  final String name;
  final String email;
  final String gender;
  final String? phone;

  Contractor({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    this.phone,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'],
    );
  }
}
