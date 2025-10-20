import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/modules/alerts/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    controller.loadNotifications();

    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A192F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.markAllRead();
            },
            child: const Text(
              "Mark all read",
              style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text("No notifications", style: TextStyle(color: Colors.white)),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
  final item = controller.notifications[index];
  
  final String? imageUrl = (item.image != null && item.image!.isNotEmpty)
      ? '${MyApIService.imageBaseUrl}/${item.image}'
      : null;

  final String createdAtText = item.createdAt != null
      ? DateFormat.Hm().format(item.createdAt!)
      : "";

  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF112240),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/logo.png',
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'assets/logo.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title ?? "No title",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.body ?? "",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(
          createdAtText,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    ),
  );
},

        );
      }),
    );
  }
}
