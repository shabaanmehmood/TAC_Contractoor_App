class SkillModel {
  final String id;
  final String? name;

  SkillModel({required this.id,  this.name});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SkillModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
