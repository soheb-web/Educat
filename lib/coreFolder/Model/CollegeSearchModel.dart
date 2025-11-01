// To parse this JSON data, do
//
//     final searchCollegeModel = searchCollegeModelFromJson(jsonString);

import 'dart:convert';

SearchCollegeModel searchCollegeModelFromJson(String str) => SearchCollegeModel.fromJson(json.decode(str));

String searchCollegeModelToJson(SearchCollegeModel data) => json.encode(data.toJson());

class SearchCollegeModel {
  bool? success;
  int? count;
  List<Datum>? data;

  SearchCollegeModel({
    this.success,
    this.count,
    this.data,
  });

  factory SearchCollegeModel.fromJson(Map<String, dynamic> json) => SearchCollegeModel(
    success: json["success"],
    count: json["count"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  String? slug;
  String? description;
  String? city;
  dynamic state;
  dynamic country;
  String? branch;
  String? type;
  int? ranking;
  double? rating;
  String? image;

  Datum({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.city,
    this.state,
    this.country,
    this.branch,
    this.type,
    this.ranking,
    this.rating,
    this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    branch: json["branch"],
    type: json["type"],
    ranking: json["ranking"],
    rating: json["rating"]?.toDouble(),
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "description": description,
    "city": city,
    "state": state,
    "country": country,
    "branch": branch,
    "type": type,
    "ranking": ranking,
    "rating": rating,
    "image": image,
  };
}
