import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/models/myJobs_model.dart';
import 'package:taccontractor/modules/checkin/jobcheckin/Submited_Review_Screen.dart';
import 'package:taccontractor/modules/feedback/ReviewSubmittedScreen.dart';
import 'package:taccontractor/modules/feedback/feedbackController.dart';

class ContractorSubmitReviewScreen extends StatefulWidget {
  final MyjobsModel job;
  const ContractorSubmitReviewScreen({super.key, required this.job});

  @override
  State<ContractorSubmitReviewScreen> createState() =>
      _ContractorSubmitReviewScreenState();
}

class _ContractorSubmitReviewScreenState
    extends State<ContractorSubmitReviewScreen> {
  final RxDouble rating = 0.0.obs;
  final TextEditingController reviewController = TextEditingController();
  final JobFeedbackController feedbackController = Get.put(JobFeedbackController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Padding(
                padding: EdgeInsets.only(
                  top: Get.height * 0.01,
                  left: Get.width * 0.04,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.kBack,
                      height: Get.height * 0.07,
                      width: Get.width * 0.07,
                      color: AppColors.kgrey,
                    ),
                    SizedBox(width: Get.width * 0.04),
                    Text(
                      "Share Your Review",
                      style: AppTypography.kBold18
                          .copyWith(color: AppColors.kWhite),
                    ),
                  ],
                ),
              ),

              /// Divider
              Container(
                width: double.infinity,
                height: 1,
                color: AppColors.kgrey,
                margin: EdgeInsets.symmetric(vertical: Get.height * 0.015),
              ),

              /// Job Title and Pay
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.job.jobTitle,
                        style: AppTypography.kBold20
                            .copyWith(color: AppColors.kWhite),
                      ),
                    ),
                    Text(
                      "\$${widget.job.payPerHour}",
                      style: AppTypography.kBold20
                          .copyWith(color: Colors.cyanAccent),
                    ),
                  ],
                ),
              ),

              /// Date & Time
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.06, vertical: Get.height * 0.01),
                child: Row(
                  children: [
                    Image.asset("assets/icon/jobCalender.png",
                        scale: Get.width * 0.0025, color: AppColors.kgrey),
                    SizedBox(width: 6),
                    Text(
                      widget.job.shifts.first.date,
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kgrey),
                    ),
                    SizedBox(width: 16),
                    Image.asset("assets/icon/time.png",
                        scale: Get.width * 0.0025, color: AppColors.kgrey),
                    SizedBox(width: 6),
                    Text(
                      "${widget.job.shifts.first.startTime.substring(0, 5)} - ${widget.job.shifts.first.endTime.substring(0, 5)}",
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kgrey),
                    ),
                  ],
                ),
              ),

              /// Guard Dropdown Field
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.06, vertical: Get.height * 0.01),
                child: Text('Guard',
                    style: AppTypography.kBold18
                        .copyWith(color: AppColors.kWhite)),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.kPrimary,
                      width: Get.width * 0.003,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Left Icon
                    Container(
                      margin: EdgeInsets.only(top: Get.width * 0.03),
                      child: Image.asset(AppAssets.kPer,
                          width: Get.width * 0.05),
                    ),

                    SizedBox(width: 18),

                    /// TextField
                    Expanded(
                      child: TextFormField(
                        controller: reviewController,
                        style: AppTypography.kLight14
                            .copyWith(color: AppColors.kWhite),
                        decoration: InputDecoration(
                          hintText: 'Select guards from this jobs..',
                          hintStyle: AppTypography.kLight14
                              .copyWith(color: AppColors.kgrey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    /// Right Icon (Rotated arrow)
                    Container(
                      margin: EdgeInsets.only(top: Get.width * 0.03),
                      child: Transform.rotate(
                        angle: 3 * 3.1416 / 2, // 270 degrees
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: Get.width * 0.06,
                          color: AppColors.kgrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Rating
              SizedBox(height: Get.height * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                child: Text(
                  'Rate this Job',
                  style: AppTypography.kBold16.copyWith(
                    color: AppColors.kWhite,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              Obx(() {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                  child: RatingBar.builder(
                    initialRating: rating.value,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    unratedColor: Colors.grey[700],
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: AppColors.kSkyBlue,
                    ),
                    onRatingUpdate: (value) {
                      rating.value = value;
                    },
                  ),
                );
              }),

              SizedBox(height: Get.height * 0.02),

              /// Write Review
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                child: Text(
                  'Write your review',
                  style: AppTypography.kBold16
                      .copyWith(color: AppColors.kWhite),
                ),
              ),
              SizedBox(height: Get.height * 0.015),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                child: TextFormField(
                  maxLines: 3,
                  style: AppTypography.kLight14
                      .copyWith(color: AppColors.kWhite),
                  decoration: InputDecoration(
                    hintText:
                        'Share your experience with job and employer',
                    hintStyle:
                        AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                    prefixIcon: Image.asset(AppAssets.kPen,
                        width: Get.width * 0.05),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.kPrimary,
                          width: Get.width * 0.003),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.kPrimary,
                          width: Get.width * 0.003),
                    ),
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.12),

              /// Submit Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kSkyBlue,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async{
                        await feedbackController.submitJobFeedback(
                      jobId: widget.job.jobId, 
                      rating: rating.value.toInt(),  
                      review: reviewController.text,
                    );
                      Get.to(() => ContractorReviewSubmittedScreen(
                        job: widget.job,
                        rating: rating.value.toDouble(),
                        review: reviewController.text,
                      ));
                    },
                    child: Obx(()=>feedbackController.isLoading.value
                              ? CircularProgressIndicator()
                              :Text(
                      "Submit Review",
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kBlack),
                    ),)
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
