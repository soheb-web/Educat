// To parse this JSON data, do
//
//     final skillGetModel = skillGetModelFromJson(jsonString);

import 'dart:convert';

SkillGetModel skillGetModelFromJson(String str) => SkillGetModel.fromJson(json.decode(str));

String skillGetModelToJson(SkillGetModel data) => json.encode(data.toJson());

class SkillGetModel {
  String? message;
  List<Datum>? data;

  SkillGetModel({
    this.message,
    this.data,
  });

  factory SkillGetModel.fromJson(Map<String, dynamic> json) => SkillGetModel(
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? title;
  String? level;
  String? industry;
  String? subTitle;
  String? image;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.title,
    this.level,
    this.industry,
    this.subTitle,
    this.image,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    level: json["level"],
    industry: json["industry"],
    subTitle: json["sub_title"],
    image: json["image"],
    description: json["description"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "level": level,
    "industry": industry,
    "sub_title": subTitle,
    "image": image,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
