import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taccontractor/modules/shift_detail/shift_detail_components/attendance.dart';
import 'package:taccontractor/modules/shift_detail/shift_detail_components/cancel_shift.dart';
import 'package:taccontractor/modules/shift_detail/shift_detail_components/notes.dart';
import 'package:taccontractor/modules/shift_detail/shift_detail_components/reject.dart';

class EveningShiftDetails extends StatefulWidget {
  const EveningShiftDetails({super.key});

  @override
  State<EveningShiftDetails> createState() => _EveningShiftDetailsState();
}

class _EveningShiftDetailsState extends State<EveningShiftDetails> {
  int selectedDateIndex = DateTime.now().day - 1;
  bool showAttendance = true;

  late final int daysInMonth;
  late final List<String> dates;
  late final String currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    currentMonth = DateFormat('MMM').format(now); // e.g. Jul

    dates = List.generate(daysInMonth, (i) {
      final date = DateTime(now.year, now.month, i + 1);
      return "${date.day}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.02, left: Get.height * 0.02),
                  child: Row(
                    children: [
                      Image.asset(
                        AppAssets.kBack,
                        height: Get.height * 0.07,
                        width: Get.width * 0.07,
                        fit: BoxFit.contain,
                        color: AppColors.kgrey,
                      ),
                      SizedBox(width: Get.width * 0.04),
                      Text("Job Details",
                          style: AppTypography.kBold20.copyWith(color: AppColors.kWhite)),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: Get.width * 0.002,
                  color: AppColors.kgrey,
                ),
                SizedBox(height: Get.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: Text("Evening Shift",
                      style: AppTypography.kBold20.copyWith(color: AppColors.kWhite)),
                ),
                SizedBox(height: Get.height * 0.005),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: Row(
                    children: [
                      Image.asset("assets/icon/jobCalender.png",
                          scale: Get.width * 0.0025, color: AppColors.kgrey),
                      SizedBox(width: Get.width * 0.015),
                      Text("29 Mar - 30 Apr 2025",
                          style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                      Spacer(),
                      Image.asset("assets/icon/time.png",
                          scale: Get.width * 0.0025, color: AppColors.kgrey),
                      SizedBox(width: Get.width * 0.01),
                      Text("2:00 PM - 10:00 PM",
                          style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  padding: EdgeInsets.all(Get.width * 0.03),
                  decoration: BoxDecoration(
                    color: AppColors.kinput.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(Get.width * 0.02),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hitesh Sapara",
                              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
                          Text("Reporting Manager",
                              style: AppTypography.kLight12.copyWith(color: AppColors.kgrey)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(Get.width * 0.02),
                        decoration: BoxDecoration(
                          color: AppColors.kSkyBlue,
                          borderRadius: BorderRadius.circular(Get.width * 0.009),
                        ),
                        child: Image.asset("assets/icon/call.png",
                            scale: Get.width * 0.0025, color: AppColors.kBlack),
                      ),
                    ],
                  ),
                )
              ],
            ),

            SizedBox(height: Get.height * 0.02),

            /// Date Scroll
            SizedBox(height: Get.height * 0.015),
            SizedBox(
              height: Get.height * 0.066,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedDateIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDateIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: Get.width * 0.025),
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.04, vertical: Get.height * 0.006),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.kSkyBlue.withOpacity(0.6) : Colors.transparent,
                            borderRadius: BorderRadius.circular(Get.width * 0.02),
                            border: Border.all(color: isSelected ? AppColors.kSkyBlue.withOpacity(0.6):AppColors.kSkyBlue),
                          ),
                          child: Center(
                            child: Text(
                              index == DateTime.now().day - 1 ? "Today" : dates[index],
                              style: AppTypography.kLight12.copyWith(
                                  color: isSelected ? AppColors.kWhite : AppColors.kgrey),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: Get.width * 0.01),
                            padding: EdgeInsets.only(right:Get.width * 0.04 ),
                            child: Text(
                              currentMonth,
                              style: AppTypography.kLight14.copyWith(color: isSelected ? AppColors.kWhite : AppColors.kgrey),
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: Get.height * 0.02),

            /// Tabs with interactivity
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => showAttendance = true),
                    child: _TabChip(label: "Attendance", isSelected: showAttendance),
                  ),
                  SizedBox(width: Get.width * 0.025),
                  GestureDetector(
                    onTap: () => setState(() => showAttendance = false),
                    child: _TabChip(label: "Notes", isSelected: !showAttendance),
                  ),
                ],
              ),
            ),

            SizedBox(height: Get.height * 0.02),

            /// Conditional View
          Expanded(
  child: ListView.builder(
    itemCount: 3,
    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
    itemBuilder: (context, index) {
      return showAttendance
          ? buildShiftUserCard(
              name: "Sarah Martinez",
              role: "Leader Guard",
              inTime: "9:00 AM",
              outTime: "5:00 PM",
              hours: 8,
              rate: 25,
              hasProof: index % 2 == 0, // Just to vary proof status
            )
          : buildNotesCard();
    },
  ),
),


            /// Close Button
            GestureDetector(
              onTap: (){
                Get.to(CancelShiftBottomSheet());
              },
              child: Padding(
                padding: EdgeInsets.all(Get.width * 0.04),
                child: Container(
                  width: double.infinity,
                  height: Get.height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.red[800],
                    borderRadius: BorderRadius.circular(Get.width * 0.02),
                  ),
                  child: Center(
                    child: Text("Close Shift ❌",
                        style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



// /// Tab Chip Widget
class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _TabChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05, vertical: Get.height * 0.01),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.kSkyBlue : Colors.transparent,
        border: Border.all(color: AppColors.kSkyBlue),
        borderRadius: BorderRadius.circular(Get.width * 0.02),
      ),
      child: Text(
        label,
        style: AppTypography.kBold14
            .copyWith(color: isSelected ? AppColors.kBlack : AppColors.kWhite),
      ),
    );
  }
}

