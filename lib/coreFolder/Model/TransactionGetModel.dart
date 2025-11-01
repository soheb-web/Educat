// To parse this JSON data, do
//
//     final transactionGetModel = transactionGetModelFromJson(jsonString);

import 'dart:convert';

TransactionGetModel transactionGetModelFromJson(String str) => TransactionGetModel.fromJson(json.decode(str));

String transactionGetModelToJson(TransactionGetModel data) => json.encode(data.toJson());

class TransactionGetModel {
  bool? status;
  String? message;
  List<Datum>? data;

  TransactionGetModel({
    this.status,
    this.message,
    this.data,
  });

  factory TransactionGetModel.fromJson(Map<String, dynamic> json) => TransactionGetModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  int? userId;
  String? type;
  String? coins;
  String? description;
  int? paymentId;
  String? paymentMethod;
  DateTime? createdAt;

  Datum({
    this.id,
    this.userId,
    this.type,
    this.coins,
    this.description,
    this.paymentId,
    this.paymentMethod,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    type: json["type"],
    coins: json["coins"],
    description: json["description"],
    paymentId: json["payment_id"],
    paymentMethod: json["payment_method"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "type": type,
    "coins": coins,
    "description": description,
    "payment_id": paymentId,
    "payment_method": paymentMethod,
    "created_at": createdAt?.toIso8601String(),
  };
}
