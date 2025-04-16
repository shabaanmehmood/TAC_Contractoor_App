import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'dummy_review_data.dart';

class ReviewController extends GetxController {
  final reviews = <DummyReviewData>[].obs;
  final averageRating = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    reviews.value = DummyReviewData.getReviews();
    _calculateAverage();
  }

  void _calculateAverage() {
    if (reviews.isNotEmpty) {
      final total = reviews.map((e) => e.rating).reduce((a, b) => a + b);
      averageRating.value = total / reviews.length;
    }
  }
}

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReviewController controller = Get.put(ReviewController());

    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: const Text(
          'Reviews & Rating',
          style: TextStyle(color: AppColors.kWhite, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: AppColors.kWhite),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.kinput, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    controller.averageRating.value.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppColors.kWhite,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      '/5',
                      style: TextStyle(
                        color: AppColors.kgrey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  double avg = controller.averageRating.value;
                  if (i < avg.floor()) {
                    return const Icon(Icons.star, color: AppColors.kSkyBlue);
                  } else if (i < avg) {
                    return const Icon(Icons.star_half,
                        color: AppColors.kSkyBlue);
                  } else {
                    return const Icon(Icons.star_border,
                        color: AppColors.kSkyBlue);
                  }
                }),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.reviews.length,
                  itemBuilder: (_, index) {
                    final review = controller.reviews[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.kJobCardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ...List.generate(5, (i) {
                                return Icon(
                                  i < review.rating.floor()
                                      ? Icons.star
                                      : (i < review.rating
                                          ? Icons.star_half
                                          : Icons.star_border),
                                  color: AppColors.kSkyBlue,
                                  size: 18,
                                );
                              }),
                              const SizedBox(width: 6),
                              Text(
                                review.rating.toString(),
                                style: const TextStyle(
                                  color: AppColors.kWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            review.reviewText,
                            style: const TextStyle(
                              color: AppColors.ktextlight,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
