import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/checkin/jobcheckin/job_checkin_screen.dart';
import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';
import 'package:tac/widhets/common%20widgets/buttons/myJob_card.dart';

import 'dummy_data.dart';
import 'job_live_controller.dart';

class JobLiveScreen extends StatelessWidget {
  final controller = Get.put(JobLiveController());

  JobLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text(
          "Job Details",
          style: TextStyle(color: Color.fromRGBO(230, 241, 255, 1)),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text("Need Support?",
                  style: TextStyle(color: Colors.lightBlue)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildShiftCard(),
                  const SizedBox(height: 16),
                  _buildLocationCard(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141927),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dummyJob['title']!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(dummyJob['name']!,
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(width: 6),
                    const Text("Actor", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Text("Job Details",
                        style: TextStyle(color: Colors.lightBlue)),
                    SizedBox(width: 4),
                    Icon(Icons.open_in_new, color: Colors.lightBlue, size: 16),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: [
              Text(
                dummyJob['rate']!,
                style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildShiftCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Shift",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text("Waiting For Approval",
                  style: TextStyle(color: Colors.amberAccent)),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "The job timer will start after employer approval.",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              controller.timerText,
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "If the employer does not approve within 30 minutes, the timer will start automatically.",
            style: TextStyle(color: Colors.white38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Live Location Alerts",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Icon(Icons.info_outline, color: Colors.white30, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.circle, size: 12, color: Colors.green),
              const SizedBox(width: 8),
              const Text("You are on track.",
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dummyJob['location']!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/map.jpg', // Add your map image here
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Get Directions"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0E21),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: controller.checkboxValue.value,
                    onChanged: (val) {
                      controller.checkboxValue.value = val ?? false;
                    },
                    activeColor: Colors.lightBlueAccent,
                  ),
                  Expanded(
                    child: Text(
                      "I understand the shift can only be closed after the scheduled time. Employer may deduct payment if ended early or skipped without reason.",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  )
                ],
              )),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: controller.checkboxValue.value
                ? controller.toggleApproval
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              disabledBackgroundColor: AppColors.kSkyBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size.fromHeight(60),
            ),
            child: const Text("Close My Shift",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
