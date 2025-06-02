import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';

class MessagesController extends GetxController {
  final RxInt selectedChipIndex = 0.obs;

  static const List<String> chipLabels = [
    'All',
    'Unread',
    'Blocked',
    'Favorites'
  ];

  final RxList<MessageModel> messages = <MessageModel>[
    MessageModel(
      name: 'Hugh Jackman',
      time: '09:35 pm',
      message: 'Do keep the time track and be on time. Thanks',
      image: AppAssets.kUserPicture,
    ),
    MessageModel(
      name: 'Chris Hemsworth',
      time: '11:35 pm',
      message: 'Do you have your armed suite with you. Need you...',
      image: AppAssets.kUserPicture,
    ),
    MessageModel(
      name: 'SilverLuxe Labs',
      time: '09:05 pm',
      message: 'Hey sir, You have updated your shift. be on time.',
      image: AppAssets.kUserPicture,
    ),
  ].obs;
}

class MessageModel {
  final String name;
  final String time;
  final String message;
  final String image;

  const MessageModel({
    required this.name,
    required this.time,
    required this.message,
    required this.image,
  });
}
