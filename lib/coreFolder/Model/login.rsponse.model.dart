// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  String? message;
  Data? data;

  LoginResponseModel({
    this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int userid;
  String? email;
  dynamic userType;
  String? token;
  String? deviceToken;
  String? fullName;

  Data({
    required this.userid,
    this.email,
    this.userType,
    this.token,
    this.deviceToken,
    this.fullName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userid: json["User_id"],
        email: json["email"],
        userType: json["user_type"],
        token: json["token"],
        deviceToken: json["device_token"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "User_id": userid,
        "email": email,
        "user_type": userType,
        "token": token,
        "device_token": deviceToken,
        "full_name": fullName,
      };
}
