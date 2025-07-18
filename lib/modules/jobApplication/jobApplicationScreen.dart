import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taccontractor/dataproviders/api_service.dart';

import '../../data/data/constants/app_colors.dart';
import '../../data/data/constants/app_typography.dart';
import '../../models/jobApplication_model.dart';

class JobApplicationsScreen extends StatefulWidget {
  final String contractorId;
  const JobApplicationsScreen({Key? key, required this.contractorId}) : super(key: key);

  @override
  State<JobApplicationsScreen> createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen> with SingleTickerProviderStateMixin {
  late Future<List<JobApplicationModel>> _futureApplications;
  late TabController _tabController;
  final MyApIService _apiService = MyApIService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _futureApplications = _apiService.getJobApplications(widget.contractorId);
    // _futureApplications = _apiService.getJobApplications('aae1bd27-e24e-4480-b438-8c334680db49');
  }

  Future<void> _refresh() async {
    setState(() {
      // _futureApplications = _apiService.getJobApplications('aae1bd27-e24e-4480-b438-8c334680db49');
      _futureApplications = _apiService.getJobApplications(widget.contractorId);
    });
  }

  void _showGuardDetails(JobApplicationModel app, bool showActions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.kDarkBlue,
      builder: (context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> handleStatusUpdate(String status) async {
              setModalState(() => isLoading = true);
              await _apiService.updateJobStatus(
                app.applicationId,
                app.guard.id,
                app.job.id,
                status,
              );
              setModalState(() => isLoading = false);
              Navigator.pop(context);
              _refresh();
            }

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.kDarkBlue,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.kgrey, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Guard Details Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(app.guard.name, style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
                            SizedBox(height: 2),
                            Text(app.guard.email, style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  // Guard Info
                  Row(
                    children: [
                      Icon(Icons.badge, color: AppColors.kgrey, size: 18),
                      SizedBox(width: 6),
                      Text(app.guard.professionalBadge, style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.security, color: AppColors.kgrey, size: 18),
                      SizedBox(width: 6),
                      Text(app.guard.masterSecurityLicense, style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.kgrey, size: 18),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(app.guard.postalAddress, style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Action Buttons
                  if (showActions)
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () => handleStatusUpdate('approved'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kgreen.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6), // Rectangle
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text('Accept', style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () => handleStatusUpdate('rejected'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6), // Rectangle
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text('Reject', style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  List<JobApplicationModel> _filterByStatus(List<JobApplicationModel> apps, String status) {
    return apps.where((app) => app.status.status.toLowerCase() == status.toLowerCase()).toList();
  }

  Widget _buildTabContent(List<JobApplicationModel> apps, String status, bool showActions) {
    final filtered = _filterByStatus(apps, status);
    if (filtered.isEmpty) {
      return Center(child: Text('No $status applications'));
    }
    return RefreshIndicator(
      displacement: Get.height * 0.2,
      onRefresh: _refresh,
      child: ListView.builder(
        padding: EdgeInsets.all(Get.width * 0.01),
        itemCount: filtered.length,
        itemBuilder: (context, i) {
          final app = filtered[i];
          return GestureDetector(
            onTap: () => _showGuardDetails(app, showActions),
            child:
            Container(
              margin: EdgeInsets.symmetric(vertical: Get.height * 0.01, horizontal: Get.width * 0.02),
              padding: EdgeInsets.all(Get.width * 0.04),
              decoration: BoxDecoration(
                color: AppColors.kCard.withOpacity(0.9),
                border: Border.all(
                  width: Get.width * 0.001,
                  color: AppColors.kgrey,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          app.job.title,
                          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                        ),
                      ),
                      Text(
                        '\$${app.job.payPerHour}/hr',
                        style: AppTypography.kBold18.copyWith(color: Colors.cyanAccent),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.01),

                  // Location & Premises Type
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.kgrey, size: 18),
                      SizedBox(width: 5),
                      Text(
                        app.job.location,
                        style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                      ),
                      Spacer(),
                      Text(
                        app.job.premisesType.name,
                        style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.008),

                  // Date & Time
                  Row(
                    children: [
                      Image.asset("assets/icon/jobCalender.png", scale: Get.width * 0.0025, color: AppColors.kgrey),
                      SizedBox(width: 5),
                      Text(
                        app.job.shifts.isNotEmpty ? app.job.shifts[0].date.substring(0, 10) : '',
                        style: AppTypography.kLight14.copyWith(color: const Color.fromARGB(255, 180, 189, 209)),
                      ),
                      Spacer(),
                      Image.asset("assets/icon/time.png", scale: Get.width * 0.0025, color: AppColors.kgrey),
                      SizedBox(width: 5),
                      Text(
                        app.job.shifts.isNotEmpty
                            ? '${app.job.shifts[0].startTime.substring(0, 5)} - ${app.job.shifts[0].endTime.substring(0, 5)}'
                            : '',
                        style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.015),

                  // Guards Required & Avatars
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.03,
                      vertical: Get.width * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kinput.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(Get.width * 0.01),
                    ),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${app.job.noOfGuardsRequired} Guards Required",
                          style: AppTypography.kBold14.copyWith(color: AppColors.kgrey),
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                for (int i = 0; i < 3; i++)
                                  Padding(
                                    padding: EdgeInsets.only(left: i * Get.width * 0.04),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.transparent,
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/userpicture.jpg",
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Get.width * 0.03),

                  // Time Period & Avatars
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.03,
                      vertical: Get.width * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kinput.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(Get.width * 0.01),
                    ),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          app.job.shifts.isNotEmpty && app.job.shifts[0].timePeriod == "AM" ? "Morning" : "Evening",
                          style: AppTypography.kBold14.copyWith(color: AppColors.kgrey),
                        ),
                        Row(
                          children: [
                            Image.asset("assets/icon/time.png", scale: Get.width * 0.0025, color: AppColors.kgrey),
                            SizedBox(width: 3),
                            Text(
                              app.job.shifts.isNotEmpty
                                  ? '${app.job.shifts[0].startTime.substring(0, 5)} - ${app.job.shifts[0].endTime.substring(0, 5)}'
                                  : '',
                              style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                for (int i = 0; i < 3; i++)
                                  Padding(
                                    padding: EdgeInsets.only(left: i * Get.width * 0.04),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.transparent,
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/userpicture.jpg",
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.kDarkBlue,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.kWhite),
          backgroundColor: AppColors.kDarkBlue,
          title: Text('Job Applications', style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
          bottom: TabBar(
            indicatorColor: AppColors.kWhite,
            labelStyle: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
            unselectedLabelColor: AppColors.kgrey,
            controller: _tabController,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: FutureBuilder<List<JobApplicationModel>>(
          future: _futureApplications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(
                color: AppColors.kWhite,
              ));
            }
            if (snapshot.hasError) {
              print('snapshot error: ${snapshot.error}');
              return Center(child: Text('Error loading applications'));
            }
            final apps = snapshot.data ?? [];
            return TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(apps, 'pending', true),
                _buildTabContent(apps, 'approved', false),
                _buildTabContent(apps, 'rejected', false),
                _buildTabContent(apps, 'cancelled', false),
              ],
            );
          },
        ),
      ),
    );
  }
}
