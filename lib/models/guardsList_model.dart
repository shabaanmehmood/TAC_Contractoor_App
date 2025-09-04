class GuardsList {
  final String id;
  final String profilePicture;
  final String professionalBadge;
  final bool isVerified;
  final String fullName;
  final String level;

  GuardsList({
    required this.id,
    required this.profilePicture,
    required this.professionalBadge,
    required this.isVerified,
    required this.fullName,
    required this.level,
  });

  factory GuardsList.fromJson(Map<String, dynamic> json) {
    final pic = _firstProfileImage(json['profileImages'] as List? ?? []);

    return GuardsList(
      id: json['id'] ?? '',
      profilePicture: pic,
      professionalBadge: json['professionalBadge'] ?? '',
      isVerified: json['isVerified'] ?? false,
      fullName: json['fullName'] ?? '',
      level: json['level'] ?? '',
    );
  }

  static String _firstProfileImage(List<dynamic> list) {
    if (list.isEmpty) return '';
    final main = list.cast<Map<String, dynamic>>().firstWhere(
          (e) => e['isMain'] == true,
      orElse: () => list.first,
    );
    final url = main['imageUrl'] as String?;
    return (url == null || url.trim().isEmpty || url.startsWith('data:')) ? '' : url;
  }

  static List<GuardsList> fromApiResponse(Map<String, dynamic> json) {
    final users = json['data'] as List;
    return users.map((e) => GuardsList.fromJson(e)).toList();
  }
}