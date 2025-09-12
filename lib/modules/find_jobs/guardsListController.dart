import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/models/guardsList_model.dart';
import '../../../dataproviders/api_service.dart';
import '../../models/jobMinimal_model.dart';

class GuardsController extends GetxController {

  
 final RxInt selectedIndex = 0.obs;

  // List of button titles
  final List<String> buttonTitles = ['All', 'Armed', 'Event', 'Corporate'];

  // Method to update the selected index
  void setSelectedIndex(int index) {
    selectedIndex.value = index;
    // You can also add filtering logic here based on the index
    // e.g., filterJobsByStatus(buttonTitles[index].toLowerCase());
  }
  
  final RxList<GuardsList> guards = <GuardsList>[].obs;
  final RxList<GuardsList> filtered = <GuardsList>[].obs;
  final RxString searchText = ''.obs;
  final RxBool isLoading = true.obs;
  final MyApIService apiService = MyApIService();
  final RxList<JobMinimal> jobs = <JobMinimal>[].obs;
  final Rx<JobMinimal?> selectedJob = Rx<JobMinimal?>(null);
  final RxString selectedJobId = ''.obs;
  final RxList<RxString> selectedShiftIds = <RxString>[].obs;
  UserController userController = Get.find<UserController>();
  final Rx<GuardsList?> selectedGuard = Rx<GuardsList?>(null);
  GuardsList? get currentGuard => selectedGuard.value;
  void pickGuard(GuardsList guard) => selectedGuard.value = guard;

  @override
  void onInit() {
    fetchGuards();
    super.onInit();
    ever(searchText, (_) => _performFilter());
  }

  Future<void> fetchGuards() async {
    isLoading(true);
    final data = await apiService.getAllGuardsListForAvailableGuards();
    guards.assignAll(data);
    final list = await apiService.getAllJobsListForDirectHire(userController.userData.value!.id!);
    jobs.assignAll(list);
    _performFilter();
    isLoading(false);
  }

 Future<void> loadJobs() async {
   if (jobs.isEmpty) {
     final list = await apiService.getAllJobsListForDirectHire(userController.userData.value!.id!);
     jobs.assignAll(list);
   }

   // Show alert if no jobs are available
   if (jobs.isEmpty) {
     Get.dialog(
       AlertDialog(
         backgroundColor: AppColors.kDarkBlue,
         title: Text('No Active Jobs',
             style: AppTypography.kBold18.copyWith(color: Colors.white)),
         content: Text(
           "There's no active job to hire guard for. Please create a job first to hire guard directly.",
           style: AppTypography.kLight16.copyWith(color: Colors.white),
         ),
         actions: [
           ElevatedButton(
             style: ElevatedButton.styleFrom(
                 backgroundColor: AppColors.kSkyBlue,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
             onPressed: () => Get.back(),
             child: Text('OK',
                 style: AppTypography.kBold14.copyWith(color: Colors.black)),
           ),
         ],
       ),
     );
   }
 }

  void _performFilter() {
    final q = searchText.value.trim().toLowerCase();
    if (q.isEmpty) {
      filtered.assignAll(guards);
    } else {
      filtered.assignAll(
        guards.where((g) => g.fullName.toLowerCase().contains(q)),
      );
    }
  }
}