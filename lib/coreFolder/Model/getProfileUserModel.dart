// To parse this JSON data, do
//
//     final getUserProfileModel = getUserProfileModelFromJson(jsonString);

import 'dart:convert';

GetUserProfileModel getUserProfileModelFromJson(String str) => GetUserProfileModel.fromJson(json.decode(str));

String getUserProfileModelToJson(GetUserProfileModel data) => json.encode(data.toJson());

class GetUserProfileModel {
  String? message;
  Data? data;

  GetUserProfileModel({
    this.message,
    this.data,
  });

  factory GetUserProfileModel.fromJson(Map<String, dynamic> json) => GetUserProfileModel(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? deviceToken;
  dynamic token;
  String? profilePic;
  dynamic userType;
  String? serviceType;
  String? description;
  int? skillsId;
  String? totalExperience;
  String? usersField;
  String? languageKnown;
  String? linkedinUser;
  dynamic dob;
  dynamic gender;
  String? resumeUpload;
  dynamic status;
  dynamic coins;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? skills;

  Data({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.deviceToken,
    this.token,
    this.profilePic,
    this.userType,
    this.serviceType,
    this.description,
    this.skillsId,
    this.totalExperience,
    this.usersField,
    this.languageKnown,
    this.linkedinUser,
    this.dob,
    this.gender,
    this.resumeUpload,
    this.status,
    this.coins,
    this.createdAt,
    this.updatedAt,
    this.skills,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    fullName: json["full_name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    deviceToken: json["device_token"],
    token: json["token"],
    profilePic: json["profile_pic"],
    userType: json["user_type"],
    serviceType: json["service_type"],
    description: json["description"],
    skillsId: json["skills_id"],
    totalExperience: json["total_experience"],
    usersField: json["users_field"],
    languageKnown: json["language_known"],
    linkedinUser: json["linkedin_user"],
    dob: json["dob"],
    gender: json["gender"],
    resumeUpload: json["resume_upload"],
    status: json["status"],
    coins: json["coins"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    skills: json["skills"] == null ? [] : List<String>.from(json["skills"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "phone_number": phoneNumber,
    "device_token": deviceToken,
    "token": token,
    "profile_pic": profilePic,
    "user_type": userType,
    "service_type": serviceType,
    "description": description,
    "skills_id": skillsId,
    "total_experience": totalExperience,
    "users_field": usersField,
    "language_known": languageKnown,
    "linkedin_user": linkedinUser,
    "dob": dob,
    "gender": gender,
    "resume_upload": resumeUpload,
    "status": status,
    "coins": coins,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
  };
}