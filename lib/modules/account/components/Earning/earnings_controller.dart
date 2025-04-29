// earnings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/modules/account/components/Earning/filter_bottom_sheet.dart';
import 'earning_model.dart';
import 'dummy_data.dart';

class EarningsController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final RxList<EarningModel> currentEarnings = <EarningModel>[].obs;

  final Rxn<String> selectedClient = Rxn<String>();
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();

  final RxBool filtersApplied = false.obs;

  void applyCustomFilter({
    required String? client,
    required DateTime? from,
    required DateTime? to,
  }) {
    List<EarningModel> allEarnings = [
      ...thisWeekEarnings,
      ...lastWeekEarnings,
      ...lastMonthEarnings,
    ];

    final filtered = allEarnings.where((e) {
      final matchesClient =
          client == null || client.isEmpty || e.client == client;

      final jobDate = DateTime.tryParse(_convertDate(e.date));
      final matchesDate = jobDate != null &&
          (from == null || !jobDate.isBefore(from)) &&
          (to == null || !jobDate.isAfter(to));

      return matchesClient && matchesDate;
    }).toList();

    selectedClient.value = client;
    startDate.value = from;
    endDate.value = to;
    filtersApplied.value = true;
    currentEarnings.value = filtered;
  }

  void clearFilters() {
    selectedClient.value = null;
    startDate.value = null;
    endDate.value = null;
    filtersApplied.value = false;
    loadEarnings();
  }

  String _convertDate(String input) {
    try {
      final parts = input.split(','); // e.g. ["March 21", " 2024"]
      if (parts.length != 2) return '';

      final dateParts = parts[0].trim().split(' '); // ["March", "21"]
      final monthStr = dateParts[0];
      final day = int.tryParse(dateParts[1]);
      final year = int.tryParse(parts[1].trim());

      if (day == null || year == null) return '';

      final months = {
        'January': 1,
        'February': 2,
        'March': 3,
        'April': 4,
        'May': 5,
        'June': 6,
        'July': 7,
        'August': 8,
        'September': 9,
        'October': 10,
        'November': 11,
        'December': 12,
      };

      final month = months[monthStr];
      if (month == null) return '';

      final date = DateTime(year, month, day);
      return date.toIso8601String();
    } catch (e) {
      return '';
    }
  }

  void selectIndex(int index) {
    if (index != 3) {
      selectedIndex.value = index;
      clearFilters();
      loadEarnings();
    } else {
      Get.bottomSheet(
        EarningsFilterOverlay(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
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
      default:
        currentEarnings.clear();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadEarnings();
  }
}
