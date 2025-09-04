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

  factory ContractorPaymentData.fromJson(Map<String, dynamic> json) =>
      ContractorPaymentData(
        contractorId: json["contractorId"],
        totalAmount: json["totalAmount"],
        count: json["count"],
        payments: List<Payment>.from(
            json["payments"].map((x) => Payment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "contractorId": contractorId,
    "totalAmount": totalAmount,
    "count": count,
    "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
  };
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

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json["id"],
    amount: json["amount"],
    paymentDate: json["paymentDate"],
    status: json["status"],
    guard: Guard.fromJson(json["guard"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "paymentDate": paymentDate,
    "status": status,
    "guard": guard.toJson(),
  };
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

  factory Guard.fromJson(Map<String, dynamic> json) => Guard(
    id: json["id"],
    fullName: json["fullName"],
    profileImage: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "profileImage": profileImage,
  };
}