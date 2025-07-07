import 'package:get/get.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/models/myJobs_model.dart';

import '../../controllers/user_controller.dart';

class MyJobsController extends GetxController {
  RxList<MyjobsModel> allJobs = <MyjobsModel>[].obs;
  RxBool isLoading = false.obs;
  MyApIService myApiService = MyApIService();
  UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    fetchMyJobs();
    super.onInit();
  }

  Future<void> fetchMyJobs() async {
    try {
      isLoading(true);
      var jobs = await myApiService.getMyJobs(userController.userData.value!.id!);
      allJobs.assignAll(jobs);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch jobs");
    } finally {
      isLoading(false);
    }
  }


  List<MyjobsModel> getJobsByStatus(String status) {
    return allJobs.where((job) => job.jobStatus == status).toList();
  }
}
