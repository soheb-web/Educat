
import 'dart:convert';


PaymentVerifyModel PaymentVerifyModelFromJson(String str) =>
    PaymentVerifyModel.fromJson(json.decode(str));

String PaymentVerifyModelToJson(PaymentVerifyModel data) =>
    json.encode(data.toJson());

class PaymentVerifyModel {
  String razorpay_payment_id;
  String razorpay_order_id;
  String razorpay_signature;


  PaymentVerifyModel({

    required this.razorpay_payment_id,
    required this.razorpay_order_id,
    required this.razorpay_signature,


  });

  factory PaymentVerifyModel.fromJson(Map<String, dynamic> json) =>
      PaymentVerifyModel(
        razorpay_payment_id: json["razorpay_payment_id"],
        razorpay_order_id: json["razorpay_order_id"],
        razorpay_signature: json["razorpay_signature"],

      );

  Map<String, dynamic> toJson() => {
    "razorpay_payment_id": razorpay_payment_id,
    "razorpay_order_id": razorpay_order_id,
    "razorpay_signature": razorpay_signature,

  };
}
