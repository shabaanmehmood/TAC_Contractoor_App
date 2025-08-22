// models/notification_model.dart
class ContractorNotification {
  final String id;
  final String title;
  final String body;
  // final String image;
   final String? image; // Change this to be nullable
  final bool isRead;
  final String fcmToken;
  final DateTime createdAt;

  ContractorNotification({
    required this.id,
    required this.title,
    required this.body,
    // required this.image,
     this.image, // Remove 'required' here
    required this.isRead,
    required this.fcmToken,
    required this.createdAt,
  });

  factory ContractorNotification.fromJson(Map<String, dynamic> json) {
    return ContractorNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      image: json['image'], // It will now accept null
      isRead: json['isRead'],
      fcmToken: json['fcmToken'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
