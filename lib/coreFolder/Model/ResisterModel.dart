// To parse this JSON data, do
//
//     final registerBodyModel = registerBodyModelFromJson(jsonString);

import 'dart:convert';

RegisterBodyModel registerBodyModelFromJson(String str) => RegisterBodyModel.fromJson(json.decode(str));

String registerBodyModelToJson(RegisterBodyModel data) => json.encode(data.toJson());

class RegisterBodyModel {
  String fullName;
  String email;
  String phoneNumber;
  String password;
  String serviceType;
  String userType;

  RegisterBodyModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.serviceType,
    required this.userType,
  });

  factory RegisterBodyModel.fromJson(Map<String, dynamic> json) => RegisterBodyModel(
    fullName: json["full_name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    password: json["password"],
    serviceType: json["service_type"],
    userType: json["user_type"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "email": email,
    "phone_number": phoneNumber,
    "password": password,
    "service_type": serviceType,
    "user_type": userType,
  };

}