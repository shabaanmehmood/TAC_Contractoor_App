// lib/data/dummy_data.dart

class DummyUser {
  final String name;
  final String role;
  final String level;
  final double rating;
  final int reviews;
  final String badge;

  DummyUser({
    required this.name,
    required this.role,
    required this.level,
    required this.rating,
    required this.reviews,
    required this.badge, // ✅ This was missing before!
  });
}

final dummyUserData = DummyUser(
  name: "John Smith",
  role: "Security Professional",
  level: "Level 2",
  rating: 5.0,
  reviews: 12,
  badge: "Leader",
);
