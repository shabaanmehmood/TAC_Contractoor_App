import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

class ContractorProfileScreen extends StatefulWidget {
  const ContractorProfileScreen({Key? key}) : super(key: key);

  @override
  State<ContractorProfileScreen> createState() => _ContractorProfileScreenState();
}

class _ContractorProfileScreenState extends State<ContractorProfileScreen> {
  int selectedTab = 0;
  final List<String> tabs = ["Active With You", "Completed With You"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Header Section with custom banner
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: Get.height * 0.015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        Text("Johsan Bill", style: AppTypography.kBold18.copyWith(color: Colors.white)),
                      ],
                    ),
                    Image.asset("assets/icon/block.png")
                  ],
                ),
              ),
        
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: Get.height * 0.12,
                    decoration: BoxDecoration(
                      color: AppColors.kSkyBlue,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.04,
                        vertical: Get.height * 0.035,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/logoforhomescreen.png',
                            width: Get.width * 0.3,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
        
                  /// Profile image slightly outside banner bottom
                  Positioned(
                    bottom: -Get.width * 0.1,
                    left: Get.width * 0.04,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Get.width * 0.02),
                      child: Image.asset(
                        'assets/userpicture.jpg',
                        width: Get.width * 0.20,
                        height: Get.width * 0.20,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
        
              /// Profile Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: Get.height * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Badge and settings
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.02,
                            vertical: Get.width * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.kGuardsCard,
                            borderRadius: BorderRadius.circular(Get.width * 0.02),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icon/Layer 2.png",
                                width: Get.width * 0.035,
                              ),
                              SizedBox(width: Get.width * 0.01),
                              Text(
                                'Leader Guard',
                                style: AppTypography.kBold10.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Get.width * 0.015),
                        CircleAvatar(
                          radius: Get.width * 0.03,
                          backgroundColor: AppColors.kGuardsCard,
                          child: Icon(Icons.verified, size: Get.width * 0.04, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
        
                    /// Name and Title
                    Text("Johsan Bill", style: AppTypography.kBold20.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text("Senior Security Professional", style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                    const SizedBox(height: 6),
        
                    /// Location Row
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.kgrey, size: 16),
                        const SizedBox(width: 4),
                        Text("New York, NY", style: AppTypography.kLight12.copyWith(color: AppColors.kgrey)),
                        const Spacer(),
                        Image.asset("assets/icon/share.png")
                      ],
                    ),
        
                    const SizedBox(height: 18),
        
                    /// Tab Buttons (Active/Completed)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(tabs.length, (index) {
                          final isSelected = selectedTab == index;
                          return Padding(
                            padding: EdgeInsets.only(right: Get.width * 0.02),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  selectedTab = index;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isSelected ? AppColors.kSkyBlue : Colors.transparent,
                                side: BorderSide(color: AppColors.kSkyBlue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              child: Text(
                                tabs[index],
                                style: AppTypography.kBold14.copyWith(
                                  color: isSelected ? AppColors.kBlack : AppColors.kWhite,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
        
                    const SizedBox(height: 20),
        
                    /// Job Cards
                    selectedTab == 0
                        ? Column(
                            children: [
                              _buildJobCardActive(
                                "Security Escort for Actor – Airport to Residence",
                                "\$ 28/hr",
                              ),
                              const SizedBox(height: 12),
                              _buildJobCardActive(
                                "Security Escort for Actor – Airport to Residence",
                                "\$ 28/hr",
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildJobCardCompleted(
                                "Security Escort for Actor – Airport to Residence",
                                "John was professional and handled the security escort perfectly.",
                                "5.0",
                              ),
                              const SizedBox(height: 12),
                              _buildJobCardCompleted(
                                "Security Escort for Actor – Airport to Residence",
                                "John was professional and handled the security escort perfectly.",
                                "5.0",
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCardActive(String title, String rate) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        color: AppColors.kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
            ),
          ),
          Text(
            rate,
            style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
          )
        ],
      ),
    );
  }

  Widget _buildJobCardCompleted(String title, String description, String rating) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        color: AppColors.kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                ),
              ),
              Row(
                children: [
                  Text(
                    rating,
                    style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: AppColors.kSkyBlue, size: 18),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
          ),
        ],
      ),
    );
  }
}
