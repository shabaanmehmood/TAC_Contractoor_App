import 'dart:async';
import 'package:get/get.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/models/myJobs_model.dart';
import '../../controllers/user_controller.dart';

class MyJobsController extends GetxController {
  List<MyjobsModel> allJobs = [];
  List<MyjobsModel> openJobs = [];
  List<MyjobsModel> activeJobs = [];
  List<MyjobsModel> inProgressJobs = [];
  List<MyjobsModel> completedJobs = [];
  List<MyjobsModel> cancelledJobs = [];
  
  bool isLoading = false;
  int selectedIndex = 0;
  
  MyApIService myApiService = MyApIService();
  UserController userController = Get.find<UserController>();
  Timer? _refreshTimer;

  @override
  void onInit() {
    print('🚀 MyJobsController initialized');
    fetchMyJobs();
    _startPeriodicRefresh();
    super.onInit();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    print('🛑 MyJobsController closed');
    super.onClose();
  }

  Future<void> fetchMyJobs() async {
    try {
      isLoading = true;
      update();
      
      print('📡 Fetching jobs...');
      var jobs = await myApiService.getMyJobs(userController.userData.value!.id!);
      allJobs = jobs;
      _categorizeJobs();
      
      print('✅ Fetched ${jobs.length} jobs');
      update();
      
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch jobs");
      print('❌ Error: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> refreshJobs() async {
    print('🔄 refreshJobs() called at ${DateTime.now()}');
    if (isLoading) return;
    
    try {
      print('📡 Calling API...');
      var jobs = await myApiService.getMyJobs(userController.userData.value!.id!);
      print('📦 Received ${jobs.length} jobs from API');
      
      allJobs = jobs;
      _categorizeJobs();
      
      print('✅ UI refresh triggered manually');
      update(); // THIS IS KEY - forces GetBuilder to rebuild
      
    } catch (e) {
      print('❌ Refresh error: $e');
    }
  }

  Future<void> _autoRefreshJobs() async {
    print('⏰ AUTO-REFRESH at ${DateTime.now()}');
    if (isLoading) return;
    
    try {
      var jobs = await myApiService.getMyJobs(userController.userData.value!.id!);
      print('📦 Auto-refresh got ${jobs.length} jobs');
      
      allJobs = jobs;
      _categorizeJobs();
      
      print('✅ Auto-refresh completed');
      update(); // THIS IS KEY - forces GetBuilder to rebuild
      
    } catch (e) {
      print('❌ Auto-refresh error: $e');
    }
  }

  void _categorizeJobs() {
    print('🗂️ Categorizing ${allJobs.length} jobs');
    
    // Clear all lists
    openJobs.clear();
    activeJobs.clear();
    inProgressJobs.clear();
    completedJobs.clear();
    cancelledJobs.clear();
    
    // Categorize each job
    for (var job in allJobs) {
      String status = (job.jobStatus ?? '').toLowerCase().trim();
      
      switch (status) {
        case 'open':
          openJobs.add(job);
          break;
        case 'active':
          activeJobs.add(job);
          break;
        case 'in_progress':
          inProgressJobs.add(job);
          break;
        case 'completed':
          completedJobs.add(job);
          break;
        case 'cancelled':
          cancelledJobs.add(job);
          break;
      }
    }
    
    print('📊 Category counts - Open: ${openJobs.length}, Active: ${activeJobs.length}, Completed: ${completedJobs.length}');
  }

  void _startPeriodicRefresh() {
    print('⏰ Starting 10-second periodic refresh');
    _refreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      print('⏰ Timer tick at ${DateTime.now()}');
      _autoRefreshJobs();
    });
  }
}