// To parse this JSON data, do
//
//     final getCoinModel = getCoinModelFromJson(jsonString);

import 'dart:convert';

GetCoinModel getCoinModelFromJson(String str) => GetCoinModel.fromJson(json.decode(str));

String getCoinModelToJson(GetCoinModel data) => json.encode(data.toJson());

class GetCoinModel {
  bool? status;
  String? message;
  List<Datum>? data;

  GetCoinModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetCoinModel.fromJson(Map<String, dynamic> json) => GetCoinModel(
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
  String? planName;
  int? coins;
  String? price;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.planName,
    this.coins,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    planName: json["plan_name"],
    coins: json["coins"],
    price: json["price"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan_name": planName,
    "coins": coins,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
