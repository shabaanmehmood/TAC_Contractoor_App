class PremisesType {
  final String id;
  final String name;

  PremisesType({
    required this.id,
    required this.name,
  });

  factory PremisesType.fromJson(Map<String, dynamic> json) {
    return PremisesType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
