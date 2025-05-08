import 'message_model.dart';

final dummyMessages = [
  ChatMessage(
    message: "Client Hired You! Contact started.",
    isMe: false,
    timestamp: DateTime.now(),
    type: MessageType.info,
  ),
  ChatMessage(
    message: "Passport.pdf",
    isMe: true,
    timestamp: DateTime.now(),
    type: MessageType.file,
    fileName: "Passport.pdf",
    fileSize: "200 KB",
  ),
  ChatMessage(
    message: "Share me your passport.",
    isMe: false,
    timestamp: DateTime.now(),
    type: MessageType.text,
  ),
  ChatMessage(
    message: "Sure Sir.",
    isMe: true,
    timestamp: DateTime.now(),
    type: MessageType.text,
  ),
  ChatMessage(
    message: "Please be here in time",
    isMe: false,
    timestamp: DateTime.now(),
    type: MessageType.text,
  ),
];
