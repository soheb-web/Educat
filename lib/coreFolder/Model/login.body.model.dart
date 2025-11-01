// To parse this JSON data, do
//
//     final loginBodyModel = loginBodyModelFromJson(jsonString);

import 'dart:convert';

LoginBodyModel loginBodyModelFromJson(String str) => LoginBodyModel.fromJson(json.decode(str));

String loginBodyModelToJson(LoginBodyModel data) => json.encode(data.toJson());

class LoginBodyModel {
    String email;
    String password;
    String deviceToken;
    LoginBodyModel({
        required this.email,
        required this.password,
        required this.deviceToken
    });

    factory LoginBodyModel.fromJson(Map<String, dynamic> json) => LoginBodyModel(
        email: json["email"],
        password: json["password"],
        deviceToken: json["device_token"],

    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "device_token": deviceToken
    };
}
