// earnings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/modules/account/components/Earning/filter_bottom_sheet.dart';
import 'earning_model.dart';
import 'dummy_data.dart';

class EarningsController extends GetxController {
  RxInt selectedIndex = 0.obs;

  final RxList<EarningModel> currentEarnings = <EarningModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEarnings();
  }

  void selectIndex(int index) {
    if (index != 4) {
      selectedIndex.value = index;
      loadEarnings();
    }
  }

  void loadEarnings() {
    switch (selectedIndex.value) {
      case 0:
        currentEarnings.value = thisWeekEarnings;
        break;
      case 1:
        currentEarnings.value = lastWeekEarnings;
        break;
      case 2:
        currentEarnings.value = lastMonthEarnings;
        break;
      case 3:
        Get.bottomSheet(
          EarningsFilterOverlay(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );

      default:
        currentEarnings.clear();
    }
  }
}
