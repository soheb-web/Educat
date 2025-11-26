// To parse this JSON data, do
//
//     final profileGetModel = profileGetModelFromJson(jsonString);

import 'dart:convert';

ProfileGetModel profileGetModelFromJson(String str) =>
    ProfileGetModel.fromJson(json.decode(str));

String profileGetModelToJson(ProfileGetModel data) =>
    json.encode(data.toJson());

class ProfileGetModel {
  int? id;
  String? fullName;
  String? profilePic;
  dynamic usersField;
  dynamic description;
  dynamic totalExperience;
  dynamic skills;
  dynamic languageKnown;
  dynamic linkedinUser;
  dynamic companiesWorked;
  String? resumeUpload;
  String? status;

  ProfileGetModel({
    this.id,
    this.fullName,
    this.profilePic,
    this.usersField,
    this.description,
    this.totalExperience,
    this.skills,
    this.languageKnown,
    this.linkedinUser,
    this.companiesWorked,
    this.resumeUpload,
    this.status,
  });

  factory ProfileGetModel.fromJson(Map<String, dynamic> json) =>
      ProfileGetModel(
        id: json["id"],
        fullName: json["full_name"],
        profilePic: json["profile_pic"],
        usersField: json["users_field"],
        description: json["description"],
        totalExperience: json["total_experience"],
        skills: json["skills"],
        languageKnown: json["language_known"],
        linkedinUser: json["linkedin_user"],
        companiesWorked: json["companies_worked"],
        resumeUpload: json["resume_upload"],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "profile_pic": profilePic,
        "users_field": usersField,
        "description": description,
        "total_experience": totalExperience,
        "skills": skills,
        "language_known": languageKnown,
        "linkedin_user": linkedinUser,
        "companies_worked": companiesWorked,
        "resume_upload": resumeUpload,
        "status" : status,
      };
}
