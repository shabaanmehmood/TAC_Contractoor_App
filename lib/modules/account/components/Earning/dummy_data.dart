import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';               // for jsonDecode

// ----------  SAME MODELS  ----------
class ContractorPaymentData {
  final String contractorId;
  final int totalAmount;
  final int count;
  final List<Payment> payments;

  ContractorPaymentData({
    required this.contractorId,
    required this.totalAmount,
    required this.count,
    required this.payments,
  });

  factory ContractorPaymentData.fromRawJson(Map<String, dynamic> json) =>
      ContractorPaymentData(
        contractorId: json["contractorId"],
        totalAmount: json["totalAmount"],
        count: json["count"],
        payments: List<Payment>.from(
            json["payments"].map((x) => Payment.fromRawJson(x))),
      );
}

class Payment {
  final String id;
  final String amount;
  final String paymentDate;
  final String status;
  final Guard guard;

  Payment({
    required this.id,
    required this.amount,
    required this.paymentDate,
    required this.status,
    required this.guard,
  });

  factory Payment.fromRawJson(Map<String, dynamic> json) => Payment(
    id: json["id"],
    amount: json["amount"],
    paymentDate: json["paymentDate"],
    status: json["status"],
    guard: Guard.fromRawJson(json["guard"]),
  );
}

class Guard {
  final String id;
  final String fullName;
  final String profileImage;

  Guard({
    required this.id,
    required this.fullName,
    required this.profileImage,
  });

  factory Guard.fromRawJson(Map<String, dynamic> json) => Guard(
    id: json["id"],
    fullName: json["fullName"],
    profileImage: json["profileImage"],
  );
}
// ----------  /MODELS  ----------

class TestController extends GetxController {
  final RxList<Payment> payments = <Payment>[].obs;

  @override
  void onInit() {
    super.onInit();
    // ---  YOUR EXACT JSON  ---
    const jsonString = '''
      {
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
      }
    ''';

    final data = ContractorPaymentData.fromRawJson(
      jsonDecode(jsonString),
    );
    payments.assignAll(data.payments);
  }
}

class TestScreen extends StatelessWidget {
  final TestController c = Get.put(TestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(() => c.payments.isEmpty
            ? const Text('Still empty 😢', style: TextStyle(color: Colors.white))
            : ListView.builder(
          itemCount: c.payments.length,
          itemBuilder: (_, i) {
            final p = c.payments[i];
            return ListTile(
              title: Text(p.guard.fullName,
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text('\$${p.amount}',
                  style: const TextStyle(color: Colors.white70)),
            );
          },
        )),
      ),
    );
  }
}

/*  ---  HOW TO RUN  ---
    Get.to(() => TestScreen());
*/