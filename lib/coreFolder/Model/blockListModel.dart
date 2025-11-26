// To parse this JSON data, do
//
//     final blockListModel = blockListModelFromJson(jsonString);

import 'dart:convert';

BlockListModel blockListModelFromJson(String str) => BlockListModel.fromJson(json.decode(str));

String blockListModelToJson(BlockListModel data) => json.encode(data.toJson());

class BlockListModel {
    List<Datum>? data;

    BlockListModel({
        this.data,
    });

    factory BlockListModel.fromJson(Map<String, dynamic> json) => BlockListModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    int? blockerId;
    int? blockedId;
    bool? status;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.blockerId,
        this.blockedId,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        blockerId: json["blocker_id"],
        blockedId: json["blocked_id"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "blocker_id": blockerId,
        "blocked_id": blockedId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
