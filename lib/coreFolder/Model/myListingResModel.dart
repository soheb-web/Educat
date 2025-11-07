// To parse this JSON data, do
//
//     final myListingResModel = myListingResModelFromJson(jsonString);

import 'dart:convert';

MyListingResModel myListingResModelFromJson(String str) =>
    MyListingResModel.fromJson(json.decode(str));

String myListingResModelToJson(MyListingResModel data) =>
    json.encode(data.toJson());

class MyListingResModel {
  bool status;
  int total;
  List<Datum> data;

  MyListingResModel({
    required this.status,
    required this.total,
    required this.data,
  });

  factory MyListingResModel.fromJson(Map<String, dynamic> json) =>
      MyListingResModel(
        status: json["status"],
        total: json["total"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "total": total,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String status;
  int studentId;
  String studentName;
  String studentEmail;
  String studentPhone;
  String studentProfile;
  String studentType;
  int mentorId;
  String mentorName;
  String mentorEmail;
  String mentorPhone;
  String mentorProfile;
  String mentorType;

  Datum({
    required this.id,
    required this.status,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.studentPhone,
    required this.studentProfile,
    required this.studentType,
    required this.mentorId,
    required this.mentorName,
    required this.mentorEmail,
    required this.mentorPhone,
    required this.mentorProfile,
    required this.mentorType,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        status: json["status"],
        studentId: json["student_id"],
        studentName: json["student_name"].toString(),
        studentEmail: json["student_email"],
        studentPhone: json["student_phone"],
        studentProfile: json["student_profile"].toString(),
        studentType: json["student_type"],
        mentorId: json["mentor_id"],
        mentorName: json["mentor_name"],
        mentorEmail: json["mentor_email"],
        mentorPhone: json["mentor_phone"],
        mentorProfile: json["mentor_profile"].toString(),
        mentorType: json["mentor_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "student_id": studentId,
        "student_name": studentName,
        "student_email": studentEmail,
        "student_phone": studentPhone,
        "student_profile": studentProfile,
        "student_type": studentType,
        "mentor_id": mentorId,
        "mentor_name": mentorName,
        "mentor_email": mentorEmail,
        "mentor_phone": mentorPhone,
        "mentor_profile": mentorProfile,
        "mentor_type": mentorType,
      };
}
