// To parse this JSON data, do
//
//     final getcreatelistModel = getcreatelistModelFromJson(jsonString);

import 'dart:convert';

GetcreatelistModel getcreatelistModelFromJson(String str) =>
    GetcreatelistModel.fromJson(json.decode(str));

String getcreatelistModelToJson(GetcreatelistModel data) =>
    json.encode(data.toJson());

class GetcreatelistModel {
  List<Datum>? data;

  GetcreatelistModel({
    this.data,
  });

  factory GetcreatelistModel.fromJson(Map<String, dynamic> json) =>
      GetcreatelistModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  int? studentId;
  String? education;
  List<String>? subjects;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? location;
  String? teachingMode;
  String? duration;
  int? status;
  String? requires;
  String? budget;
  String? mobileNumber;
  String? time;
  String? gender;
  String? communicate;
  String? state;
  String? localAddress;
  String? pincode;
  Student? student;

  Datum({
    this.id,
    this.studentId,
    this.education,
    this.subjects,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.teachingMode,
    this.duration,
    this.status,
    this.requires,
    this.budget,
    this.mobileNumber,
    this.time,
    this.gender,
    this.communicate,
    this.state,
    this.localAddress,
    this.pincode,
    this.student,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        studentId: json["student_id"],
        education: json["education"],
        subjects: json["subjects"] == null
            ? []
            : List<String>.from(json["subjects"]!.map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        location: json["location"],
        teachingMode: json["teaching_mode"],
        duration: json["duration"],
        status: json["status"],
        requires: json["requires"],
        budget: json["budget"],
        mobileNumber: json["mobile_number"],
        time: json["time"],
        gender: json["gender"],
        communicate: json["communicate"],
        state: json["state"],
        localAddress: json["local_address"],
        pincode: json["pincode"],
        student:
            json["student"] == null ? null : Student.fromJson(json["student"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "education": education,
        "subjects":
            subjects == null ? [] : List<dynamic>.from(subjects!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "location": location,
        "teaching_mode": teachingMode,
        "duration": duration,
        "status": status,
        "requires": requires,
        "budget": budget,
        "mobile_number": mobileNumber,
        "time": time,
        "gender": gender,
        "communicate": communicate,
        "state": state,
        "local_address": localAddress,
        "pincode": pincode,
        "student": student?.toJson(),
      };
}

class Student {
  int? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  dynamic profilePic;

  Student({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePic,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        profilePic: json["profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "profile_pic": profilePic,
      };
}
