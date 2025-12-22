
import 'dart:convert';

PaymentCreateModel PaymentCreateModelFromJson(String str) =>
    PaymentCreateModel.fromJson(json.decode(str));

String PaymentCreateModelToJson(PaymentCreateModel data) =>
    json.encode(data.toJson());

class PaymentCreateModel {
  String amount;
  String currency;
  String description;


  PaymentCreateModel({

    required this.amount,
    required this.currency,
    required this.description,


  });

  factory PaymentCreateModel.fromJson(Map<String, dynamic> json) =>
      PaymentCreateModel(
        amount: json["amount"],
        currency: json["currency"],
        description: json["description"],

      );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "currency": currency,
    "description": description,

  };
}



