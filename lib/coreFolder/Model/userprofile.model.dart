// To parse this JSON data, do
//
//     final uSerProfieModel = uSerProfieModelFromJson(jsonString);

import 'dart:convert';

USerProfieModel uSerProfieModelFromJson(String str) =>
    USerProfieModel.fromJson(json.decode(str));

String uSerProfieModelToJson(USerProfieModel data) =>
    json.encode(data.toJson());

class USerProfieModel {
  String message;
  Data data;

  USerProfieModel({
    required this.message,
    required this.data,
  });

  factory USerProfieModel.fromJson(Map<String, dynamic> json) =>
      USerProfieModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String fullName;
  String email;
  String phoneNumber;
  dynamic token;
  String? profilePic;
  String userType;


  dynamic location;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;



  Data({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.token,
     this.profilePic,
    required this.userType,
    required this.location,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,

  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        token: json["token"],
        profilePic: json["profile_pic"],
        userType: json["user_type"],
    
        location: json["location"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "token": token,
        "profile_pic": profilePic,
        "user_type": userType,

        "location": location,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),

      };
}
