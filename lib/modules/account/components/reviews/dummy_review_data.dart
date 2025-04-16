class DummyReviewData {
  final double rating;
  final String reviewText;

  DummyReviewData({required this.rating, required this.reviewText});

  static List<DummyReviewData> getReviews() {
    return [
      DummyReviewData(
        rating: 5.0,
        reviewText:
            "John was professional and handled the security escort perfectly.",
      ),
      DummyReviewData(
        rating: 5.0,
        reviewText:
            "John was professional and handled the security escort perfectly.",
      ),
      DummyReviewData(
        rating: 4.5,
        reviewText:
            "John was professional and handled the security escort perfectly.",
      ),
      DummyReviewData(
        rating: 5.0,
        reviewText:
            "John was professional and handled the security escort perfectly.",
      ),
      DummyReviewData(
        rating: 5.0,
        reviewText:
            "John was professional and handled the security escort perfectly.",
      ),
      DummyReviewData(
        rating: 5.0,
        reviewText:
            "John was professional and handled the security escort perfectly.",
      ),
    ];
  }
}
