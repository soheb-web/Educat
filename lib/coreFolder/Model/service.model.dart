// To parse this JSON data, do
//
//     final serviceModelRes = serviceModelResFromJson(jsonString);

import 'dart:convert';

ServiceModelRes serviceModelResFromJson(String str) => ServiceModelRes.fromJson(json.decode(str));

String serviceModelResToJson(ServiceModelRes data) => json.encode(data.toJson());

class ServiceModelRes {
  String message;
  List<Datum> data;

  ServiceModelRes({
    required this.message,
    required this.data,
  });

  factory ServiceModelRes.fromJson(Map<String, dynamic> json) => ServiceModelRes(
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
