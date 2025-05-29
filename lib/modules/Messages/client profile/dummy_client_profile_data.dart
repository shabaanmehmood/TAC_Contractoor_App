import 'package:get/get.dart';

class ClientJob {
  final String clientName;
  final String clientRole;
  final double rating;
  final int reviewCount;
  final String title;
  final String startDate;
  final String endDate;
  final String location;
  final String distance;
  final String shiftTime;
  final String details; // New field for 'Details' tab

  ClientJob({
    required this.clientName,
    required this.clientRole,
    required this.rating,
    required this.reviewCount,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.distance,
    required this.shiftTime,
    required this.details,
  });
}

class ClientProfileController extends GetxController {
  var job = ClientJob(
    clientName: "Hugh Jackman",
    clientRole: "Actor",
    rating: 5.0,
    reviewCount: 12,
    title: "Security Escort for Actor – Airport to Residence",
    startDate: "23 Feb 2025",
    endDate: "23 Jun 2025",
    location: "4517 Washington Ave, Manchester, Kentucky 39495",
    distance: "3.1 km away",
    shiftTime: "8:00 AM – 4:00 PM",
    details:
        "Hugh Jackman is seeking professional security support for 4 months, "
        "ensuring travel and residence coverage. The guard must maintain high discretion, "
        "punctuality, and coordinate directly with event personnel. Previous VIP protection experience is a plus.",
  ).obs;

  var selectedTab = "Contracts".obs;

  void switchTab(String tab) {
    selectedTab.value = tab;
  }
}
