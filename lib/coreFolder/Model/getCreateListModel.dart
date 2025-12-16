// To parse this JSON data, do
//
//     final getcreatelistModel = getcreatelistModelFromJson(jsonString);

import 'dart:convert';

GetcreatelistModel getcreatelistModelFromJson(String str) => GetcreatelistModel.fromJson(json.decode(str));

String getcreatelistModelToJson(GetcreatelistModel data) => json.encode(data.toJson());

class GetcreatelistModel {
    List<Datum>? data;

    GetcreatelistModel({
        this.data,
    });

    factory GetcreatelistModel.fromJson(Map<String, dynamic> json) => GetcreatelistModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    int? studentId;
    String? education;
    int? experience;
    List<String>? subjects;
    String? fee;
    String? description;
    DateTime? createdAt;
    DateTime? updatedAt;
    Student? student;

    Datum({
        this.id,
        this.studentId,
        this.education,
        this.experience,
        this.subjects,
        this.fee,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.student,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        studentId: json["student_id"],
        education: json["education"],
        experience: json["experience"],
        subjects: json["subjects"] == null ? [] : List<String>.from(json["subjects"]!.map((x) => x)),
        fee: json["fee"],
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        student: json["student"] == null ? null : Student.fromJson(json["student"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "education": education,
        "experience": experience,
        "subjects": subjects == null ? [] : List<dynamic>.from(subjects!.map((x) => x)),
        "fee": fee,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "student": student?.toJson(),
    };
}

class Student {
    int? id;
    String? fullName;
    String? email;

    Student({
        this.id,
        this.fullName,
        this.email,
    });

    factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
    };
}
