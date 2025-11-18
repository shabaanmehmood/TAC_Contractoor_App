
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/models/notification_model.dart';

class NotificationController extends GetxController {
  var notifications = <ContractorNotification>[].obs;
  var isLoading = false.obs;

  final MyApIService _notificationService = MyApIService();
  final UserController userController = Get.find<UserController>();

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final user = userController.userData.value;
      final contractorId = user?.id;

      if (contractorId == null) {
        Get.snackbar("Error", "User ID is null");
        return;
      }

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
    final user = userController.userData.value;
    final contractorId = user?.id;

    if (contractorId == null) {
      return;
    }

    // 👉 FIX #1: If no notifications, do nothing and show no toast
    if (notifications.isEmpty) {
      return; 
    }

    await _notificationService.markAllNotificationsAsRead(contractorId);

    // Clear list so next tap does nothing
    notifications.clear();

    // 👉 FIX #2: Show toast ONLY once
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    Get.snackbar(
      "Success",
      "All notifications have been marked as read.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.kGreenS,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  } catch (e) {

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    Get.snackbar(
      "Error",
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.kACardCancelled,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}



  // Future<void> markAllRead() async {
  //   try {
  //     final user = userController.userData.value;
  //     final contractorId = user?.id;

  //     if (contractorId == null) {
  //       Get.snackbar("Error", "User ID is null");
  //       return;
  //     }

  //     await _notificationService.markAllNotificationsAsRead(contractorId);
  //     notifications.clear();

  //     Get.snackbar(
  //       "Success",
  //       "All notifications have been marked as read.",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: AppColors.kGreenS,
  //       colorText: AppColors.kWhite,
  //     );
  //   } catch (e) {
  //     Get.snackbar(
  //       "Error",
  //       e.toString(),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: AppColors.kACardCancelled,
  //       colorText: AppColors.kWhite,
  //     );
  //   }
  // }
}


// // // controllers/notification_controller.dart
// // import 'package:get/get.dart';
// // import 'package:taccontractor/controllers/user_controller.dart';
// // import 'package:taccontractor/dataproviders/api_service.dart';
// // import 'package:taccontractor/models/notification_model.dart';


// // class NotificationController extends GetxController {
// //   var notifications = <ContractorNotification>[].obs;
// //   var isLoading = false.obs;

// //   final MyApIService _notificationService = MyApIService();
// //   UserController userController = Get.find<UserController>();
  
// //   Future<void> loadNotifications() async {
// //     try {
// //       isLoading.value = true;
// //       final String contractorId = userController.userData.value!.id!;
// //       final fetched = await _notificationService.fetchNotifications(contractorId);
// //       notifications.assignAll(fetched);
// //     } catch (e) {
// //       Get.snackbar("Error", e.toString());
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// // }



// // controllers/notification_controller.dart
// import 'package:get/get.dart';
// import 'package:taccontractor/controllers/user_controller.dart';
// import 'package:taccontractor/data/data/constants/app_colors.dart';
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

//   Future<void> markAllRead() async {
//     try {
//       final String contractorId = userController.userData.value!.id!;
      
//       // Call the API service to mark notifications as read
//       await _notificationService.markAllNotificationsAsRead(contractorId);
      
//       // Clear the local list only after a successful API call
//       notifications.clear();
      
//       Get.snackbar("Success", "All notifications have been marked as read.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.kGreenS,
//         colorText: AppColors.kWhite
//       );

//     } catch (e) {
//       // Show an error message if the API call fails
//       Get.snackbar("Error", e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.kACardCancelled,
//         colorText: AppColors.kWhite,
//       );
//     }
//   }
// }


// view 

// import 'package:get/get.dart';
// import 'package:flutter/material.dart';

// class NotificationController extends GetxController {
//   var notifications = [
//     {
//       "title": "Badge Earned",
//       "message": "Congratulations! You have earned the Leader badge.",
//       "time": "03:35 PM",
//       "icon": 'assets/logo.png',
//     },
//     {
//       "title": "Congratulations! Alex hired you.",
//       "message": "Your application for 'Job Name' is approved.",
//       "time": "03:35 PM",
//       "icon": 'assets/logo.png',
//     },
//     {
//       "title": "Message Received",
//       "message": "New message from your contractor John Smith.",
//       "time": "03:15 PM",
//       "icon": 'assets/logo.png',
//     },
//     {
//       "title": "Shift Reminder",
//       "message": "Your shift starts in 30 minutes. Please check in.",
//       "time": "03:15 PM",
//       "icon": 'assets/logo.png',
//     },
//     {
//       "title": "Job Complete. Contract ended by contractor.",
//       "message": "Your License(ID) is expiring soon. Update it in the system.",
//       "time": "03:15 PM",
//       "icon": 'assets/logo.png',
//     },
//     {
//       "title": "App Update Available",
//       "message": "View your recommended match today!",
//       "time": "03:35 PM",
//       "icon": 'assets/logo.png',
//     },
//   ].obs;
// }

// class NotificationScreen extends StatelessWidget {
//   final NotificationController controller = Get.put(NotificationController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A192F), // Dark Blue Background
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A192F),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text("Notifications",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//         actions: [
//           TextButton(
//             onPressed: () {
//               controller.notifications.clear();
//             },
//             child: const Text(
//               "Mark all read",
//               style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Obx(() {
//           return ListView.separated(
//             itemCount: controller.notifications.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 10),
//             itemBuilder: (context, index) {
//               var item = controller.notifications[index];

//               return Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF112240), // Card Background
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Notification Icon
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.blueAccent.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Image.asset(item["icon"]!, height: 30, width: 30),
//                     ),
//                     const SizedBox(width: 12),
//                     // Notification Content
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             item["title"]!,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             item["message"]!,
//                             style: const TextStyle(fontSize: 14, color: Colors.grey),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Time Stamp
//                     Text(
//                       item["time"]!,
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }

// views/notification_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taccontractor/modules/alerts/notification_controller.dart';
// import 'package:intl/intl.dart'; // for time formatting

// class NotificationScreen extends StatelessWidget {
//   final NotificationController controller = Get.put(NotificationController());
//   @override
//   Widget build(BuildContext context) {
//     controller.loadNotifications();

//     return Scaffold(
//       backgroundColor: const Color(0xFF0A192F),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A192F),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text("Notifications",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//         actions: [
//           TextButton(
//             onPressed: () {
//               controller.notifications.clear();
//             },
//             child: const Text(
//               "Mark all read",
//               style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (controller.notifications.isEmpty) {
//           return const Center(child: Text("No notifications", style: TextStyle(color: Colors.white)));
//         }

//         return ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: controller.notifications.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 10),
//           itemBuilder: (context, index) {
//             final item = controller.notifications[index];
//             return Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFF112240),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               padding: const EdgeInsets.all(12),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Notification Image
//                     //   ClipRRect(
//                     //   borderRadius: BorderRadius.circular(25),
//                     //   child: Image.network(
//                     //   item.image,
//                     //   height: 40,
//                     //   width: 40,
//                     //   fit: BoxFit.cover,
//                     //   errorBuilder: (context, error, stackTrace) {
//                     //     return const Icon(Icons.image_not_supported, color: Colors.grey, size: 40);
//                     //   },
//                     // ),    ),

//                     // Notification Icon with fallback
// Container(
//   padding: const EdgeInsets.all(8),
//   decoration: BoxDecoration(
//     color: Colors.blueAccent.withOpacity(0.2),
//     shape: BoxShape.circle,
//   ),
//   child: ClipOval(
//     child: Image.network(
//       item.image!,
//       height: 30,
//       width: 30,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) {
//         // Fallback to asset icon if network image fails
//         return Image.asset(
//           'assets/logo.png',
//           height: 30,
//           width: 30,
//           fit: BoxFit.cover,
//         );
//       },
//     ),
//   ),
// ),

//                   const SizedBox(width: 12),
//                   // Notification Content
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(item.title,
//                             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
//                         const SizedBox(height: 5),
//                         Text(item.body,
//                             style: const TextStyle(fontSize: 14, color: Colors.grey),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis),
//                       ],
//                     ),
//                   ),
//                   // Time
//                   Text(
//                     DateFormat.Hm().format(item.createdAt),
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }




// // views/notification_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taccontractor/modules/alerts/notification_controller.dart';
// import 'package:intl/intl.dart';

// class NotificationScreen extends StatelessWidget {
//   final NotificationController controller = Get.put(NotificationController());
  
//   @override
//   Widget build(BuildContext context) {
//     controller.loadNotifications();

//     return Scaffold(
//       backgroundColor: const Color(0xFF0A192F),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A192F),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           "Notifications",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Call the new method to mark all as read
//               controller.markAllRead();
//             },
//             child: const Text(
//               "Mark all read",
//               style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (controller.notifications.isEmpty) {
//           return const Center(child: Text("No notifications", style: TextStyle(color: Colors.white)));
//         }

//         return ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: controller.notifications.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 10),
//           itemBuilder: (context, index) {
//             final item = controller.notifications[index];
//             print(item);
//             return Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFF112240),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               padding: const EdgeInsets.all(12),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.blueAccent.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: ClipOval(
//                       child: Image.network(
//                         item.image!,
//                         height: 30,
//                         width: 30,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Image.asset(
//                             'assets/logo.png',
//                             height: 30,
//                             width: 30,
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.title,
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           item.body,
//                           style: const TextStyle(fontSize: 14, color: Colors.grey),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     DateFormat.Hm().format(item.createdAt),
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }