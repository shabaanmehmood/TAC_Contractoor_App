// controllers/notification_controller.dart
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/models/notification_model.dart';


class NotificationController extends GetxController {
  var notifications = <ContractorNotification>[].obs;
  var isLoading = false.obs;

  final MyApIService _notificationService = MyApIService();
  UserController userController = Get.find<UserController>();
  
  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final String contractorId = userController.userData.value!.id!;
      final fetched = await _notificationService.fetchNotifications(contractorId);
      notifications.assignAll(fetched);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
