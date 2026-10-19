// earnings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/modules/account/components/Earning/transcation.dart';
import 'earnings_controller.dart';

class EarningsScreen extends StatelessWidget {
  final EarningsController controller = Get.put(EarningsController());

  EarningsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kWhite),
        title: Text(
          'Payments',
          style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white24, height: 1),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Balance & Hours Card ----
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.kJobCardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Obx(() {
              final total = controller.currentPayments
                  .fold(0.0, (sum, p) => sum + double.parse(p.amount));
              final hours = controller.currentPayments.length * 8;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Balance",
                        style: AppTypography.kLight14
                            .copyWith(color: AppColors.kgrey),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: AppTypography.kBold32
                            .copyWith(color: AppColors.kSkyBlue),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Hours",
                        style: AppTypography.kLight14
                            .copyWith(color: AppColors.kgrey),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "$hours",
                        style: AppTypography.kBold20
                            .copyWith(color: AppColors.kWhite),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),

          // ---- Filter Chips ----
          Obx(() {
            final chips = <Widget>[];
            if (controller.selectedClient.value != null) {
              chips.add(_buildChip(controller.selectedClient.value!, () {
                controller.clearFilters();
              }));
            }
            if (controller.startDate.value != null) {
              chips.add(_buildChip(
                  controller.startDate.value!.toString().split(' ')[0], () {
                controller.clearFilters();
              }));
            }
            if (controller.endDate.value != null) {
              chips.add(_buildChip(
                  controller.endDate.value!.toString().split(' ')[0], () {
                controller.clearFilters();
              }));
            }

            if (chips.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  ...chips,
                  GestureDetector(
                    onTap: () => controller.clearFilters(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Clear All",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // ---- Tabs matching Jobs Screen ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Obx(() {
              const tabLabels = ["This Week", "Last Week", "All"];
              return Row(
                children: List.generate(tabLabels.length, (index) {
                  final isSelected = controller.selectedIndex.value == index;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 4,
                        right: index == tabLabels.length - 1 ? 0 : 4,
                      ),
                      child: GestureDetector(
                        onTap: () => controller.selectIndex(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.kSkyBlue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.kSkyBlue,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tabLabels[index],
                            style: AppTypography.kBold14.copyWith(
                              fontSize: 13,
                              color: isSelected
                                  ? AppColors.kBlack
                                  : AppColors.kWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),

          // ---- Recent Earnings Header ----
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Text(
              "Recent Transactions",
              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
            ),
          ),

          // ---- Payments List ----
          Expanded(
            child: Obx(() {
              final payments = controller.currentPayments;
              if (payments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No payment records found",
                        style: AppTypography.kBold14.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: payments.length,
                itemBuilder: (_, index) {
                  final p = payments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    child: Material(
                      color: AppColors.kJobCardColor,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () => Get.to(
                            () => TransactionDetailsScreen(payment: p)),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.kSkyBlue
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    color: AppColors.kSkyBlue,
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.guard.fullName,
                                      style: AppTypography.kBold16.copyWith(
                                        color: AppColors.kWhite,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 13,
                                          color: AppColors.kgrey,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          p.paymentDate,
                                          style: AppTypography.kLight14
                                              .copyWith(
                                            color: AppColors.kgrey,
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "\$${double.parse(p.amount).toStringAsFixed(2)}",
                                    style: AppTypography.kBold16.copyWith(
                                      color: AppColors.kSkyBlue,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 12,
                                    color: Colors.white38,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.kSkyBlue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.kSkyBlue.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.kSkyBlue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              color: AppColors.kSkyBlue,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}