enum MessageType { text, image, file, info }

class ChatMessage {
  final String message;
  final bool isMe;
  final DateTime timestamp;
  final MessageType type;
  final String? fileName;
  final String? fileSize;
  final String? imageUrl;

  ChatMessage({
    required this.message,
    required this.isMe,
    required this.timestamp,
    this.type = MessageType.text,
    this.fileName,
    this.fileSize,
    this.imageUrl,
  });
}
