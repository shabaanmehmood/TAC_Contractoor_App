// models/notification_model.dart
class ContractorNotification {
  final String id;
  final String title;
  final String body;
  final String image;
  final bool isRead;
  final String fcmToken;
  final DateTime createdAt;

  ContractorNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.isRead,
    required this.fcmToken,
    required this.createdAt,
  });

  factory ContractorNotification.fromJson(Map<String, dynamic> json) {
    return ContractorNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      image: json['image'],
      isRead: json['isRead'],
      fcmToken: json['fcmToken'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
