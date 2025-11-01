// To parse this JSON data, do
//
//     final buyCoinBodyModel = BuyCoinBodyModelFromJson(jsonString);

import 'dart:convert';

BuyCoinBodyModel BuyCoinBodyModelFromJson(String str) => BuyCoinBodyModel.fromJson(json.decode(str));

String buyCoinBodyModelToJson(BuyCoinBodyModel data) => json.encode(data.toJson());

class BuyCoinBodyModel {
  final int? coins;
  final int? payment_id;

  BuyCoinBodyModel({
    this.coins,
    this.payment_id,
  });

  factory BuyCoinBodyModel.fromJson(Map<String, dynamic> json) => BuyCoinBodyModel(
    coins: json['coins'],
    payment_id: json['payment_id'],
  );

  Map<String, dynamic> toJson() => {
    if (coins != null) 'coins': coins,
    if (payment_id != null) 'payment_id': payment_id,
  };
}