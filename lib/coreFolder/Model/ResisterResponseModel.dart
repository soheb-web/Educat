// To parse this JSON data, do
//
//     final resisterResponseModel = resisterResponseModelFromJson(jsonString);

import 'dart:convert';

ResisterResponseModel resisterResponseModelFromJson(String str) =>
    ResisterResponseModel.fromJson(json.decode(str));

String resisterResponseModelToJson(ResisterResponseModel data) =>
    json.encode(data.toJson());

class ResisterResponseModel {
  String? message;
  Data? data;

  ResisterResponseModel({
    this.message,
    this.data,
  });

  factory ResisterResponseModel.fromJson(Map<String, dynamic> json) =>
      ResisterResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? serviceType;
  String? userType;
  dynamic profilePic;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.serviceType,
    this.userType,
    this.profilePic,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        serviceType: json["service_type"],
        userType: json["user_type"],
        profilePic: json["profile_pic"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(
            json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(
            json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() =>
      {
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "service_type": serviceType,
        "user_type": userType,
        "profile_pic": profilePic,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
