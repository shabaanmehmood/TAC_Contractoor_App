import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/modules/Messages/chat_controller.dart';
import 'package:taccontractor/modules/Messages/client%20profile/client_profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:taccontractor/modules/Messages/message_model.dart';
import 'package:taccontractor/modules/contractor_messages_screen/profile.dart';

class ContractorChatScreen extends StatelessWidget {
  ContractorChatScreen({super.key});
  final ChatController controller = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            AppAssets.kBack,
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Get.back(); // or Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const Text(
              'Hugh Jackman',
              style: TextStyle(color: AppColors.kWhite),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.to(() => ContractorProfileScreen()); // Navigate on tap
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: AssetImage(AppAssets.kUserPicture),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: Colors.white12),

          // Chat messages
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller
                        .messages[controller.messages.length - 1 - index];
                    return Align(
                      alignment: msg.isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: msg.isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          _buildMessageBubble(context, msg),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE h:mma').format(msg.timestamp),
                            style: AppTypography.kLight14
                                ?.copyWith(color: Colors.grey, fontSize: 11),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                )),
          ),

          const Divider(height: 1, color: Colors.white12),

          // Bottom input field
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                IconButton(
                  icon: Image.asset(
                    AppAssets.kAdd,
                    width: 24,
                    height: 24,
                    color: AppColors.kWhite,
                  ),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: AppTypography.kLight14
                        .copyWith(color: AppColors.kWhite),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: AppTypography.kLight14
                          .copyWith(color: AppColors.kWhite.withOpacity(0.6)),
                      filled: true,
                      fillColor: AppColors.kDarkestBlue,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.kWhite.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.kWhite,
                          width: 1.2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Image.asset(
                    AppAssets.kSend,
                    width: 24,
                    height: 24,
                    color: AppColors.kPrimary,
                  ),
                  onPressed: () {
                    controller.sendMessage(messageController.text);
                    messageController.clear();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg) {
    final bubbleColor = msg.isMe ? AppColors.kChat : AppColors.kJobCardColor;

    switch (msg.type) {
      case MessageType.text:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            msg.message,
            style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
          ),
        );

      case MessageType.file:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.insert_drive_file, color: AppColors.kWhite),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.fileName ?? "File.pdf",
                    style:
                        AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                  ),
                  Text(
                    msg.fileSize ?? "200 KB",
                    style: AppTypography.kLight14
                        .copyWith(color: AppColors.kinput),
                  ),
                ],
              ),
            ],
          ),
        );

      case MessageType.image:
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(msg.imageUrl ?? AppAssets.kMap,
              width: 200, height: 140, fit: BoxFit.cover),
        );

      case MessageType.info:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.kJobCardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            msg.message,
            style: AppTypography.kBold14?.copyWith(color: AppColors.kWhite),
          ),
        );
    }
  }
}
