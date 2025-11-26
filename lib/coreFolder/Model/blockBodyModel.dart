// To parse this JSON data, do
//
//     final blockbodyModel = blockbodyModelFromJson(jsonString);

import 'dart:convert';

BlockbodyModel blockbodyModelFromJson(String str) =>
    BlockbodyModel.fromJson(json.decode(str));

String blockbodyModelToJson(BlockbodyModel data) => json.encode(data.toJson());

class BlockbodyModel {
  String? blockedId;

  BlockbodyModel({
    this.blockedId,
  });

  factory BlockbodyModel.fromJson(Map<String, dynamic> json) => BlockbodyModel(
        blockedId: json["blocked_id"],
      );

  Map<String, dynamic> toJson() => {
        "blocked_id": blockedId,
      };
}

// To parse this JSON data, do
//
//     final blockResModel = blockResModelFromJson(jsonString);

BlockResModel blockResModelFromJson(String str) =>
    BlockResModel.fromJson(json.decode(str));

String blockResModelToJson(BlockResModel data) => json.encode(data.toJson());

class BlockResModel {
  String? message;
  Data? data;

  BlockResModel({
    this.message,
    this.data,
  });

  factory BlockResModel.fromJson(Map<String, dynamic> json) => BlockResModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? blockerId;
  String? blockedId;
  bool? status;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? id;

  Data({
    this.blockerId,
    this.blockedId,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        blockerId: json["blocker_id"],
        blockedId: json["blocked_id"].toString(),
        status: json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "blocker_id": blockerId,
        "blocked_id": blockedId,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
