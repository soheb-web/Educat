// To parse this JSON data, do
//
//     final searchCompanyModel = searchCompanyModelFromJson(jsonString);

import 'dart:convert';

SearchCompanyModel searchCompanyModelFromJson(String str) =>
    SearchCompanyModel.fromJson(json.decode(str));

String searchCompanyModelToJson(SearchCompanyModel data) =>
    json.encode(data.toJson());

class SearchCompanyModel {
  bool? status;
  List<Datum>? data;
  SearchCompanyModel({
    this.status,
    this.data,
  });
  factory SearchCompanyModel.fromJson(Map<String, dynamic> json) =>
      SearchCompanyModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? collageName;
  String? slug;
  String? collageDescription;
  String? phone;
  String? email;
  String? website;
  String? image;
  String? city;
  String? pincode;
  String? type;
  String? status;
  String? branch;
  String? seatIntake;
  List<String>? facilities;
  List<String>? skills;
  String? industry;
  String? location;
  int? ranking;
  double? rating;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.collageName,
    this.slug,
    this.collageDescription,
    this.phone,
    this.email,
    this.website,
    this.image,
    this.city,
    this.pincode,
    this.type,
    this.status,
    this.branch,
    this.seatIntake,
    this.facilities,
    this.skills,
    this.industry,
    this.location,
    this.ranking,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        collageName: json["collage_name"],
        slug: json["slug"],
        collageDescription: json["collage_description"],
        phone: json["phone"],
        email: json["email"],
        website: json["website"],
        image: json["image"],
        city: json["city"],
        pincode: json["pincode"],
        type: json["type"],
        status: json["status"],
        branch: json["branch"],
        seatIntake: json["seat_intake"],
        // facilities: json["facilities"] == null ? [] : List<String>.from(json["facilities"]!.map((x) => x)),
        facilities: json["facilities"] == null
            ? []
            : (json["facilities"] is List)
                ? List<String>.from(json["facilities"])
                : List<String>.from((json["facilities"] as Map)
                    .values
                    .map((e) => e.toString())),

        // skills: json["skills"] == null ? [] : List<String>.from(json["skills"]!.map((x) => x)),
        skills: json["skills"] == null
            ? []
            : (json["skills"] is List)
                ? List<String>.from(json["skills"])
                : List<String>.from(
                    (json["skills"] as Map).values.map((e) => e.toString())),

        industry: json["industry"],
        location: json["location"],
        ranking: json["ranking"],
        rating: json["rating"]?.toDouble(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collage_name": collageName,
        "slug": slug,
        "collage_description": collageDescription,
        "phone": phone,
        "email": email,
        "website": website,
        "image": image,
        "city": city,
        "pincode": pincode,
        "type": type,
        "status": status,
        "branch": branch,
        "seat_intake": seatIntake,
        "facilities": facilities == null
            ? []
            : List<dynamic>.from(facilities!.map((x) => x)),
        "skills":
            skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
        "industry": industry,
        "location": location,
        "ranking": ranking,
        "rating": rating,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
