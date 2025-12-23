// To parse this JSON data, do
//
//     final verifyPaymentResponseModel = verifyPaymentResponseModelFromJson(jsonString);

import 'dart:convert';

VerifyPaymentResponseModel verifyPaymentResponseModelFromJson(String str) => VerifyPaymentResponseModel.fromJson(json.decode(str));

String verifyPaymentResponseModelToJson(VerifyPaymentResponseModel data) => json.encode(data.toJson());

class VerifyPaymentResponseModel {
  bool? success;
  String? message;
  Payment? payment;

  VerifyPaymentResponseModel({
    this.success,
    this.message,
    this.payment,
  });

  factory VerifyPaymentResponseModel.fromJson(Map<String, dynamic> json) => VerifyPaymentResponseModel(
    success: json["success"],
    message: json["message"],
    payment: json["payment"] == null ? null : Payment.fromJson(json["payment"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "payment": payment?.toJson(),
  };
}

class Payment {
  int? id;
  int? userId;
  String? orderId;
  String? amount;
  String? currency;
  String? status;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? paymentId;
  String? method;

  Payment({
    this.id,
    this.userId,
    this.orderId,
    this.amount,
    this.currency,
    this.status,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.paymentId,
    this.method,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json["id"],
    userId: json["user_id"],
    orderId: json["order_id"],
    amount: json["amount"],
    currency: json["currency"],
    status: json["status"],
    description: json["description"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    paymentId: json["payment_id"],
    method: json["method"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "order_id": orderId,
    "amount": amount,
    "currency": currency,
    "status": status,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "payment_id": paymentId,
    "method": method,
  };
}
