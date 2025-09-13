// // controllers/notification_controller.dart
// import 'package:get/get.dart';
// import 'package:taccontractor/controllers/user_controller.dart';
// import 'package:taccontractor/dataproviders/api_service.dart';
// import 'package:taccontractor/models/notification_model.dart';


// class NotificationController extends GetxController {
//   var notifications = <ContractorNotification>[].obs;
//   var isLoading = false.obs;

//   final MyApIService _notificationService = MyApIService();
//   UserController userController = Get.find<UserController>();
  
//   Future<void> loadNotifications() async {
//     try {
//       isLoading.value = true;
//       final String contractorId = userController.userData.value!.id!;
//       final fetched = await _notificationService.fetchNotifications(contractorId);
//       notifications.assignAll(fetched);
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }



// controllers/notification_controller.dart
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
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

  Future<void> markAllRead() async {
    try {
      final String contractorId = userController.userData.value!.id!;
      
      // Call the API service to mark notifications as read
      await _notificationService.markAllNotificationsAsRead(contractorId);
      
      // Clear the local list only after a successful API call
      notifications.clear();
      
      Get.snackbar("Success", "All notifications have been marked as read.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.kGreenS,
        colorText: AppColors.kWhite
      );

    } catch (e) {
      // Show an error message if the API call fails
      Get.snackbar("Error", e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.kACardCancelled,
        colorText: AppColors.kWhite,
      );
    }
  }
}