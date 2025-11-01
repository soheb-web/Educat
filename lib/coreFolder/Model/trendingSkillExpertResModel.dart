// To parse this JSON data, do
//
//     final trendingExpertResModel = trendingExpertResModelFromJson(jsonString);

import 'dart:convert';

TrendingExpertResModel trendingExpertResModelFromJson(String str) =>
    TrendingExpertResModel.fromJson(json.decode(str));

String trendingExpertResModelToJson(TrendingExpertResModel data) =>
    json.encode(data.toJson());

class TrendingExpertResModel {
  bool status;
  Skill? skill;
  List<Expert> experts;

  TrendingExpertResModel({
    required this.status,
    this.skill,
    required this.experts,
  });

  factory TrendingExpertResModel.fromJson(Map<String, dynamic> json) =>
      TrendingExpertResModel(
        status: json["status"] ?? false,
        skill: json["skill"] != null ? Skill.fromJson(json["skill"]) : null,
        experts: json["experts"] != null
            ? List<Expert>.from(json["experts"].map((x) => Expert.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "skill": skill?.toJson(),
        "experts": List<dynamic>.from(experts.map((x) => x.toJson())),
      };
}

class Expert {
  int id;
  String name;
  String description;
  String experience;
  String profilePic;
  List<String> tags;

  Expert({
    required this.id,
    required this.name,
    required this.description,
    required this.experience,
    required this.profilePic,
    required this.tags,
  });

  factory Expert.fromJson(Map<String, dynamic> json) => Expert(
        id: json["id"] ?? 0,
        name: json["name"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        experience: json["experience"]?.toString() ?? "",
        profilePic: json["profile_pic"]?.toString() ?? "",
        tags: json["tags"] != null
            ? List<String>.from(json["tags"].map((x) => x.toString()))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "experience": experience,
        "profile_pic": profilePic,
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class Skill {
  int id;
  String? title;
  String? level;
  String? description;
  String? image;

  Skill({
    required this.id,
    this.title,
    this.level,
    this.description,
    this.image,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        id: json["id"] ?? 0,
        title: json["title"]?.toString(),
        level: (json["level"] == null ||
                json["level"].toString().toLowerCase() == "null")
            ? null
            : json["level"].toString(),
        description: (json["description"] == null ||
                json["description"].toString().toLowerCase() == "null")
            ? null
            : json["description"].toString(),
        image: (json["image"] == null ||
                json["image"].toString().toLowerCase() == "null")
            ? null
            : json["image"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "level": level,
        "description": description,
        "image": image,
      };
}
