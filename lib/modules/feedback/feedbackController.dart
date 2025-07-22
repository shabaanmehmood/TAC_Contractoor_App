import 'package:get/get.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/controllers/user_controller.dart';


import 'package:get/get.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/controllers/user_controller.dart';

class JobFeedbackController extends GetxController {
  RxBool isLoading = false.obs;
  MyApIService myApiService = MyApIService();
  UserController userController = Get.find<UserController>();

  Future<void> submitJobFeedback({
    required String jobId,
    required int rating,
    required String review,
  }) async {
    try {
      isLoading(true);

      final String guardId = userController.userData.value!.id!;

      final response = await myApiService.postJobFeedback(
        guardId,
        jobId,
        rating,
        review,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Job feedback submitted successfully");
      } else {
        Get.snackbar("Error", "Failed: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Exception", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }
}
