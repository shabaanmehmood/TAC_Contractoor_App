// earnings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/modules/account/components/Earning/filter_bottom_sheet.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../models/earning_model.dart';

class EarningsController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final RxList<Payment> currentPayments = <Payment>[].obs;
  Rx<ContractorPaymentData?> earningsData = Rx<ContractorPaymentData?>(null);

  final Rxn<String> selectedClient = Rxn<String>();
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final RxBool filtersApplied = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEarnings('98ee92af-e3b0-446c-993b-a86d9f4c11b7');
  }

  /* ----------  API  ---------- */
  Future<void> fetchEarnings(String userId) async {
    final apiService = MyApIService();
    final data = await apiService.getEarnings(userId);

    // fallback JSON that we know works
    final fallbackJson = {
      "contractorId": "98ee92af-e3b0-446c-993b-a86d9f4c11b7",
      "totalAmount": 2333,
      "count": 1,
      "payments": [
        {
          "id": "a990078d-a30a-4da2-9806-15b4c446e213",
          "amount": "2333.00",
          "paymentDate": "2025-07-29",
          "status": "paid",
          "guard": {
            "id": "2b70e6cf-ae7e-4dc0-a12d-3ffae78d342a",
            "fullName": "John D1oe",
            "profileImage": "images/1747682607736.png"
          }
        }
      ]
    };

    earningsData.value =
        data ?? ContractorPaymentData.fromJson(fallbackJson);
    loadPaymentsByTab();
  }

  /* ----------  TAB & FILTER  ---------- */
  void loadPaymentsByTab() {
    final source = earningsData.value?.payments ?? [];
    final now = DateTime.now();
    DateTime start;

    switch (selectedIndex.value) {
      case 0: // This Week
        start = now.subtract(Duration(days: now.weekday - 1));
        currentPayments.value = _filterPaymentsByDate(source, start, now);
        break;
      case 1: // Last Week
        start = now.subtract(Duration(days: now.weekday + 6));
        final end = start.add(const Duration(days: 6));
        currentPayments.value = _filterPaymentsByDate(source, start, end);
        break;
      case 2: // Last 30 days
        currentPayments.value = source;
        break;
    }
  }

  List<Payment> _filterPaymentsByDate(
      List<Payment> list, DateTime from, DateTime to) {
    return list.where((p) {
      final d = DateTime.parse(p.paymentDate);
      return !d.isBefore(from) && !d.isAfter(to);
    }).toList();
  }

  void applyCustomFilter({
    required String? client,
    required DateTime? from,
    required DateTime? to,
  }) {
    final source = earningsData.value?.payments ?? [];
    final filtered = source.where((p) {
      final matchesClient =
          client == null || client.isEmpty || p.guard.fullName == client;
      final jobDate = DateTime.parse(p.paymentDate);
      final matchesDate = (from == null || !jobDate.isBefore(from)) &&
          (to == null || !jobDate.isAfter(to));
      return matchesClient && matchesDate;
    }).toList();

    selectedClient.value = client;
    startDate.value = from;
    endDate.value = to;
    filtersApplied.value = true;
    currentPayments.value = filtered;
  }

  void clearFilters() {
    selectedClient.value = null;
    startDate.value = null;
    endDate.value = null;
    filtersApplied.value = false;
    loadPaymentsByTab();
  }

  void selectIndex(int index) {
    if (index != 3) {
      selectedIndex.value = index;
      clearFilters();
      loadPaymentsByTab();
    } else {
      Get.bottomSheet(
        const EarningsFilterOverlay(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    }
  }
}