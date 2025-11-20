import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/modules/Guards/guards_view.dart';
import 'package:taccontractor/modules/Jobs/Create%20Jobs/setJobDetailsScreen.dart';
import 'package:taccontractor/modules/Jobs/jobs_page.dart';
import 'package:taccontractor/modules/Jobs/myJobs_view.dart';
import 'package:taccontractor/modules/Messages/messages.dart';
import 'package:taccontractor/modules/account/account.dart';
import 'package:taccontractor/modules/account/components/Earning/earnings_screen.dart';
import 'package:taccontractor/modules/home/home_view.dart';
import 'package:taccontractor/modules/myJobs/myJobsScreen.dart';
import 'package:taccontractor/modules/newjob%20section/my_jobs_view.dart';

import '../../controllers/user_controller.dart';
import '../find_jobs/guards.dart';

class LandingPage extends StatefulWidget {
  final int selectedIndex; // <-- Add this

  const LandingPage({Key? key, this.selectedIndex = 0})
      : super(key: key); // <-- Accept in constructor

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late int _currentIndex;

  final List<Widget> _pages = [
    HomeView(),
    const GuardsView(),
    MyJobsView1(),
    MessagesScreen(),
    const AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(LandingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      setState(() {
        _currentIndex = widget.selectedIndex;
      });
    }
  }

  Widget _buildCustomBottomNav() {
    return Container(
      color: AppColors.kDarkBlue,
      height: Get.height * 0.08 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(
        top: AppSpacing.fiveVertical,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          _buildNavItem(0, AppAssets.kHome, 'Home'),
          _buildNavItem(1, AppAssets.kGuards, 'Guards'),
          _buildNavItem(2, AppAssets.kJobs, 'Jobs'),
          _buildNavItem(3, AppAssets.kMessages, 'Messages'),
          _buildNavItem(4, AppAssets.kAccount, 'Account'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    bool isSelected = _currentIndex == index;

    return Expanded(
      child: Material(
        color: AppColors.kDarkBlue, // Important: Set material background
        child: InkWell(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          highlightColor: AppColors.kDarkBlue.withOpacity(0.1),
          splashColor: AppColors.kSkyBlue.withOpacity(0.2),
          child: Container(
            color: AppColors.kDarkBlue, // Ensure container background
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  color: isSelected ? AppColors.kSkyBlue : Colors.grey,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppColors.kSkyBlue : Colors.grey,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }
}
