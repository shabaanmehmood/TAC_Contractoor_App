import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/modules/Jobs/Create%20Jobs/setJobDetailsScreen.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/active.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/cancelled.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/completed.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/inProgress.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/open.dart';
import 'package:taccontractor/models/myJobs_model.dart';

class MyJobsScreen extends StatefulWidget {
  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  final MyApIService myApiService = MyApIService();
  final List<String> tabs = [
    "Open",
    "Active",
    "In Progress",
    "Completed",
    "Cancelled"
  ];

  List<MyjobsModel> allJobs = [];
  List<MyjobsModel> openJobs = [];
  List<MyjobsModel> activeJobs = [];
  List<MyjobsModel> inProgressJobs = [];
  List<MyjobsModel> completedJobs = [];
  List<MyjobsModel> cancelledJobs = [];

  int selectedIndex = 0;
  bool isLoading = false;
  Timer? _refreshTimer;

  // Add this to force rebuild tracking
  int rebuildCounter = 0;

  @override
  void initState() {
    super.initState();
    fetchMyJobs();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchMyJobs() async {
    try {
      setState(() {
        isLoading = true;
      });

      print('📡 Fetching jobs...');
      // Replace with your actual user ID
      final userController = Get.find<UserController>();
      var jobs =
          await myApiService.getMyJobs(userController.userData.value!.id!);

      setState(() {
        allJobs = jobs;
        _categorizeJobs();
        isLoading = false;
      });

      print('✅ Fetched ${jobs.length} jobs');
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refreshJobs() async {
    print('🔄 Manual refresh at ${DateTime.now()}');
    await fetchMyJobs();
  }

  Future<void> _autoRefreshJobs() async {
    print('⏰ AUTO-REFRESH at ${DateTime.now()}');
    if (isLoading) return;

    try {
      final userController = Get.find<UserController>();
      var jobs =
          await myApiService.getMyJobs(userController.userData.value!.id!);
      print('📦 Auto-refresh got ${jobs.length} jobs');

      // Check if data changed
      bool hasChanged = _hasDataChanged(jobs);

      if (hasChanged) {
        setState(() {
          allJobs = jobs;
          _categorizeJobs();
          rebuildCounter++;
        });
        print('✅ Auto-refresh updated UI. Rebuild: $rebuildCounter');
      } else {
        print('⚠️ No data changes, skipping UI update');
      }
    } catch (e) {
      print('❌ Auto-refresh error: $e');
    }
  }

  bool _hasDataChanged(List<MyjobsModel> newJobs) {
    if (newJobs.length != allJobs.length) return true;

    for (int i = 0; i < newJobs.length; i++) {
      if (i >= allJobs.length) return true;
      if (newJobs[i].jobId != allJobs[i].jobId ||
          newJobs[i].jobStatus != allJobs[i].jobStatus) {
        return true;
      }
    }
    return false;
  }

  void _categorizeJobs() {
    openJobs.clear();
    activeJobs.clear();
    inProgressJobs.clear();
    completedJobs.clear();
    cancelledJobs.clear();

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

    print(
        '📊 Category counts - Open: ${openJobs.length}, Active: ${activeJobs.length}, Completed: ${completedJobs.length}');
  }

  void _startPeriodicRefresh() {
    print('⏰ Starting 10-second periodic refresh');
    _refreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      print('⏰ Timer tick at ${DateTime.now()}');
      _autoRefreshJobs();
    });
  }

  List<MyjobsModel> getFilteredJobs() {
    switch (selectedIndex) {
      case 0:
        return openJobs;
      case 1:
        return activeJobs;
      case 2:
        return inProgressJobs;
      case 3:
        return completedJobs;
      case 4:
        return cancelledJobs;
      default:
        return openJobs;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        '🏗️ BUILDING UI - Rebuild: $rebuildCounter at ${DateTime.now().toString().substring(11, 19)}');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.twentyHorizontal, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.kTacLogo,
                        height: Get.height * 0.045,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "My Jobs",
                        style: AppTypography.kBold16
                            .copyWith(color: AppColors.kWhite),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Auto-refresh indicator
                      IconButton(
                        onPressed: refreshJobs,
                        icon: const Icon(Icons.refresh, color: AppColors.kSkyBlue),
                        tooltip: 'Refresh jobs',
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => SetJobDetailsScreen()),
                        child: Image.asset("assets/icon/plus.png",
                            scale: Get.width * 0.003, color: AppColors.kSkyBlue),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.015),
              /// Search Bar
              TextFormField(
                style: const TextStyle(color: AppColors.kgrey),
                decoration: InputDecoration(
                  fillColor: AppColors.kDarkBlue,
                  filled: true,
                  hintText: "Search for security jobs...",
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset("assets/icon/search.png"),
                  ),
                  hintStyle: const TextStyle(color: AppColors.kgrey, fontSize: 16),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Get.width * 0.03,
                    horizontal: Get.width * 0.04,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Get.width * 0.04),
                    borderSide:
                        const BorderSide(width: 0.8, color: AppColors.kgrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Get.width * 0.09),
                    borderSide:
                        const BorderSide(width: 0.04, color: AppColors.kgrey),
                  ),
                ),
              ),

            /// Status Info

              SizedBox(height: Get.height * 0.02),

              /// Tab Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.kSkyBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: AppColors.kSkyBlue,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          tabs[index],
                          style: AppTypography.kBold14.copyWith(
                            color: isSelected
                                ? AppColors.kBlack
                                : AppColors.kWhite,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: Get.height * 0.02),

            /// Jobs List
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildJobList(),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildJobList() {
    final filteredJobs = getFilteredJobs();
    print('📊 Displaying ${filteredJobs.length} jobs for tab $selectedIndex');

    if (filteredJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No Job Found",
              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refreshJobs,
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            SizedBox(height: Get.height * 0.02),
        itemCount: filteredJobs.length,
        itemBuilder: (context, index) {
          final job = filteredJobs[index];
          switch (selectedIndex) {
            case 0:
              return jobOpenCardWidget(job: job);
            case 1:
              return jobActiveCardWidget(job: job);
            case 2:
              return jobInProgressCardWidget(job: job);
            case 3:
              return jobCompletedCardWidget(job: job);
            case 4:
              return jobCancelledCardWidget(job: job);
            default:
              return jobOpenCardWidget(job: job);
          }
        },
      ),
    );
  }
}
