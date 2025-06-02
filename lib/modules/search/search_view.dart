import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/modules/home/components/search_field.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/job_card.dart';

import '../../data/data/constants/app_colors.dart';
import '../../data/data/constants/app_typography.dart';
import '../../models/jobCard_model.dart';
import '../../models/job_model.dart';
import '../Guards/guards_view.dart';
import '../fiilters/sort_overlay.dart';

class SearchViewController extends GetxController {
  final RxList<JobData> jobList = <JobData>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;
  final RxList<String> appliedFilters = <String>[].obs;
  final RxString sortBy = 'Latest'.obs;

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  void initWithData() {
    final guardsController = Get.find<GuardsViewController>();
    jobList.value = guardsController.jobList;
  }

  List<JobData> getFilteredJobs() {
    var jobs = jobList.where((job) {
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return job.title.toLowerCase().contains(query) ||
            job.contractorName.toLowerCase().contains(query) ||
            job.categoryName.toLowerCase().contains(query) ||
            job.location.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    if (selectedFilter.value != 'All') {
      jobs = jobs.where((job) => _getCategoryType(job) == selectedFilter.value).toList();
    }

    if (appliedFilters.isNotEmpty) {
      jobs = jobs.where((job) {
        return appliedFilters.every((filter) {
          return true;
        });
      }).toList();
    }

    switch (sortBy.value) {
      case 'Latest':
        jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Oldest':
        jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Pay Rate (High to Low)':
        jobs.sort((a, b) => b.payPerHour.compareTo(a.payPerHour));
        break;
      case 'Pay Rate (Low to High)':
        jobs.sort((a, b) => a.payPerHour.compareTo(b.payPerHour));
        break;
    }

    return jobs;
  }

  String _getCategoryType(JobData job) {
    if (job.categoryName.toLowerCase().contains('armed')) {
      return 'Armed';
    } else if (job.categoryName.toLowerCase().contains('event')) {
      return 'Event';
    } else if (job.categoryName.toLowerCase().contains('corporate')) {
      return 'Corporate';
    } else {
      return 'Other';
    }
  }

  void addFilter(String filter) {
    if (!appliedFilters.contains(filter)) {
      appliedFilters.add(filter);
    }
  }

  void removeFilter(String filter) {
    appliedFilters.remove(filter);
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
  }
}

class SearchView extends StatelessWidget {
  SearchView({Key? key}) : super(key: key) {
    controller.initWithData();
  }

  final controller = Get.put(SearchViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              SizedBox(height: AppSpacing.tenVertical),
              Obx(() => controller.appliedFilters.isEmpty
                  ? SizedBox()
                  : _buildAppliedFilters()),
              SizedBox(height: AppSpacing.tenVertical),
              Row(
                children: [
                  Obx(() => Text(
                    '${controller.getFilteredJobs().length} records found',
                    style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                  )),
                  Spacer(),
                  TextButton.icon(
                    onPressed: () => showSortBottomSheet(context),
                    label: Text(
                      'Sort by',
                      style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
                    ),
                    icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.fiveVertical),
              _buildFilterChips(),
              SizedBox(height: AppSpacing.tenVertical),
              Expanded(
                child: Obx(() {
                  final jobs = controller.getFilteredJobs();
                  return ListView.separated(
                    itemCount: jobs.length,
                    separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return FutureBuilder<JobCardModel>(
                        future: Get.find<GuardsViewController>().jobDataToCardModel(job),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return SizedBox();
                          return JobCard(
                            jobTitle: snapshot.data!.jobTitle,
                            perHourRate: snapshot.data!.perHourRate,
                            companyName: snapshot.data!.companyName,
                            rating: snapshot.data!.rating,
                            hiringTag: snapshot.data!.hiringTag,
                            jobType: snapshot.data!.jobType,
                            location: snapshot.data!.location,
                            distance: snapshot.data!.distance,
                            day: snapshot.data!.day,
                            shiftTime: snapshot.data!.shiftTime,
                            requiredPersons: snapshot.data!.requiredPersons,
                            jobDept: snapshot.data!.jobDept,
                            jobData: job,
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => Get.back(canPop: true),
              label: Text('Search', style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        SizedBox(height: AppSpacing.tenVertical),
        SearchField(
          isBorderBlue: true,
          isIconColorBlue: true,
          text: 'Armed Security Jobs in Perth',
          icon1: AppAssets.kCross,
          icon2: AppAssets.kFilter,
          leadingIcon: AppAssets.kSearch,
          isEnabled: true,
          controller: TextEditingController(),
          onChanged: (value) {
            controller.searchQuery.value = value;
          },
        ),
      ],
    );
  }

  Widget _buildAppliedFilters() {
    return Wrap(
      spacing: 8,
      children: controller.appliedFilters.map((filter) {
        return Chip(
          label: Text(filter),
          onDeleted: () => controller.removeFilter(filter),
          backgroundColor: AppColors.kSkyBlue,
          labelStyle: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
        );
      }).toList(),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip("All"),
          SizedBox(width: 10),
          _buildFilterChip("Armed"),
          SizedBox(width: 10),
          _buildFilterChip("Event"),
          SizedBox(width: 10),
          _buildFilterChip("Corporate"),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Obx(() => FilterChip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.kSkyBlue),
      ),
      label: Text(label),
      selected: controller.selectedFilter.value == label,
      onSelected: (bool selected) {
        controller.updateFilter(label);
      },
      backgroundColor: AppColors.kDarkBlue,
      selectedColor: AppColors.kSkyBlue,
      disabledColor: AppColors.kDarkBlue,
      showCheckmark: false,
      surfaceTintColor: Colors.transparent,
      labelStyle: AppTypography.kBold14.copyWith(
        color: controller.selectedFilter.value == label ? Colors.white : AppColors.kSkyBlue,
      ),
    ));
  }
}