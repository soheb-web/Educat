// To parse this JSON data, do
//
//     final getDropDownModel = getDropDownModelFromJson(jsonString);

import 'dart:convert';

GetDropDownModel getDropDownModelFromJson(String str) => GetDropDownModel.fromJson(json.decode(str));

String getDropDownModelToJson(GetDropDownModel data) => json.encode(data.toJson());

class GetDropDownModel {
  bool? success;
  Colleges? colleges;
  Companies? companies;
  Mentors? mentors;
  Skills? skills;

  GetDropDownModel({
    this.success,
    this.colleges,
    this.companies,
    this.mentors,
    this.skills,
  });

  factory GetDropDownModel.fromJson(Map<String, dynamic> json) => GetDropDownModel(
    success: json["success"],
    colleges: json["colleges"] == null ? null : Colleges.fromJson(json["colleges"]),
    companies: json["companies"] == null ? null : Companies.fromJson(json["companies"]),
    mentors: json["mentors"] == null ? null : Mentors.fromJson(json["mentors"]),
    skills: json["skills"] == null ? null : Skills.fromJson(json["skills"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "colleges": colleges?.toJson(),
    "companies": companies?.toJson(),
    "mentors": mentors?.toJson(),
    "skills": skills?.toJson(),
  };
}

class Colleges {
  List<String>? locations;
  List<String>? collageName;
  List<String>? branches;

  Colleges({
    this.locations,
    this.collageName,
    this.branches,
  });

  factory Colleges.fromJson(Map<String, dynamic> json) => Colleges(
    locations: json["locations"] == null ? [] : List<String>.from(json["locations"]!.map((x) => x)),
    collageName: json["collage_name"] == null ? [] : List<String>.from(json["collage_name"]!.map((x) => x)),
    branches: json["branches"] == null ? [] : List<String>.from(json["branches"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x)),
    "collage_name": collageName == null ? [] : List<dynamic>.from(collageName!.map((x) => x)),
    "branches": branches == null ? [] : List<dynamic>.from(branches!.map((x) => x)),
  };
}

class Companies {
  List<String>? skills;
  List<String>? industry;
  List<String>? locations;

  Companies({
    this.skills,
    this.industry,
    this.locations,
  });

  factory Companies.fromJson(Map<String, dynamic> json) => Companies(
    skills: json["skills"] == null ? [] : List<String>.from(json["skills"]!.map((x) => x)),
    industry: json["industry"] == null ? [] : List<String>.from(json["industry"]!.map((x) => x)),
    locations: json["locations"] == null ? [] : List<String>.from(json["locations"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
    "industry": industry == null ? [] : List<dynamic>.from(industry!.map((x) => x)),
    "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x)),
  };
}

class Mentors {
  Map<String, String>? skills;
  List<String>? industry;
  Map<String, String>? totalExperience;

  Mentors({
    this.skills,
    this.industry,
    this.totalExperience,
  });

  factory Mentors.fromJson(Map<String, dynamic> json) => Mentors(
    skills: Map.from(json["skills"]!).map((k, v) => MapEntry<String, String>(k, v)),
    industry: json["industry"] == null ? [] : List<String>.from(json["industry"]!.map((x) => x)),
    totalExperience: Map.from(json["total_experience"]!).map((k, v) => MapEntry<String, String>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "skills": Map.from(skills!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "industry": industry == null ? [] : List<dynamic>.from(industry!.map((x) => x)),
    "total_experience": Map.from(totalExperience!).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class Skills {
  List<String>? levels;
  List<String>? industry;

  Skills({
    this.levels,
    this.industry,
  });

  factory Skills.fromJson(Map<String, dynamic> json) => Skills(
    levels: json["levels"] == null ? [] : List<String>.from(json["levels"]!.map((x) => x)),
    industry: json["industry"] == null ? [] : List<String>.from(json["industry"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "levels": levels == null ? [] : List<dynamic>.from(levels!.map((x) => x)),
    "industry": industry == null ? [] : List<dynamic>.from(industry!.map((x) => x)),
  };
}
