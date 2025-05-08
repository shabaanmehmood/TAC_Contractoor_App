import 'package:get/get.dart';
import 'message_model.dart';
import 'chat_dummy_data.dart';

class ChatController extends GetxController {
  RxList<ChatMessage> messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyMessages();
  }

  void loadDummyMessages() {
    messages.addAll(dummyMessages);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add(ChatMessage(
      message: text,
      isMe: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    ));
  }
}
