import 'package:get/get.dart';

class SubmitReviewController extends GetxController {
  var rating = 0.obs;
  var reviewText = ''.obs;

  void setRating(int index) => rating.value = index;
  void setReview(String text) => reviewText.value = text;
}
