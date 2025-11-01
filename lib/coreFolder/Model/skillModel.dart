// To parse this JSON data, do
//
//     final skillsModel = skillsModelFromJson(jsonString);

import 'dart:convert';

SkillsModel skillsModelFromJson(String str) => SkillsModel.fromJson(json.decode(str));

String skillsModelToJson(SkillsModel data) => json.encode(data.toJson());

class SkillsModel {
  String message;
  List<Datum1> data;

  SkillsModel({
    required this.message,
    required this.data,
  });

  factory SkillsModel.fromJson(Map<String, dynamic> json) => SkillsModel(
    message: json["message"],
    data: List<Datum1>.from(json["data"].map((x) => Datum1.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum1 {
  int id;
  String title;
  String subTitle;
  String? image;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  Datum1({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum1.fromJson(Map<String, dynamic> json) => Datum1(
    id: json["id"],
    title: json["title"],
    subTitle: json["sub_title"],
    image: json["image"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "sub_title": subTitle,
    "image": image,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}