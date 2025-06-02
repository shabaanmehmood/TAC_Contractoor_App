import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:taccontractor/modules/checkin/jobcheckin/job_live_complete.dart';
import 'job_live_screen.dart'; // 👈 Import the screen you want to navigate to

class JobCheckinController extends GetxController {
  var isSelfieTaken = false.obs;

  void takeSelfie() {
    isSelfieTaken.value = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      Get.to(() => JobLiveScreen_complete()); // 👈 Navigate to Live Job Screen
    });
  }
}
