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

  const LandingPage({Key? key, this.selectedIndex = 0}) : super(key: key); // <-- Accept in constructor


  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late int _currentIndex;

  final List<Widget> _pages = [
    const HomeView(),
    AvailableGuardsScreen(),
    // const JobsView(),
    // MyJobsView1(),
    MyJobsScreen(),
    // EarningsScreen(),
    MessagesScreen(),
    const AccountScreen(),
    // const ChatsScreen(),
    // const CourseSchedule(),
    // const MyProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex; // <-- Set the initial index with argument!
  }

  @override
  void didUpdateWidget(LandingPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the selectedIndex has changed and update _currentIndex accordingly
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      setState(() {
        _currentIndex = widget.selectedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode(BuildContext context) =>
    //     Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      extendBody: false,
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: Get.height * 0.08,
          padding: EdgeInsets.only(top: AppSpacing.fiveVertical),
          child: ClipRRect(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 10.0,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              backgroundColor: AppColors.kDarkBlue,
              selectedLabelStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.kSkyBlue,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle:
              const TextStyle(fontSize: 13, color: Colors.grey),
              selectedFontSize: 14,
              unselectedFontSize: 13,
              unselectedItemColor: Colors.grey,
              currentIndex: _currentIndex,
              selectedItemColor: AppColors.kSkyBlue,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  backgroundColor: AppColors.kDarkBlue,
                  icon: SvgPicture.asset(
                    AppAssets.kHome,
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Home',
                  activeIcon: SvgPicture.asset(
                    AppAssets.kHome,
                    color: AppColors.kSkyBlue,
                    height: 20,
                    width: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: AppColors.kDarkBlue,
                  icon: SvgPicture.asset(
                    AppAssets.kGuards,
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Jobs',
                  activeIcon: SvgPicture.asset(
                    AppAssets.kGuards,
                    color: AppColors.kSkyBlue,
                    height: 20,
                    width: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: AppColors.kDarkBlue,
                  icon: SvgPicture.asset(
                    AppAssets.kJobs,
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'My Jobs',
                  activeIcon: SvgPicture.asset(
                    AppAssets.kJobs,
                    color: AppColors.kSkyBlue,
                    height: 20,
                    width: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: AppColors.kDarkBlue,
                  icon: SvgPicture.asset(
                    AppAssets.kMessages,
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Messages',
                  activeIcon: SvgPicture.asset(
                    AppAssets.kMessages,
                    color: AppColors.kSkyBlue,
                    height: 20,
                    width: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: AppColors.kDarkBlue,
                  icon: SvgPicture.asset(
                    AppAssets.kAccount,
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Account',
                  activeIcon: SvgPicture.asset(
                    AppAssets.kAccount,
                    color: AppColors.kSkyBlue,
                    height: 20,
                    width: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
