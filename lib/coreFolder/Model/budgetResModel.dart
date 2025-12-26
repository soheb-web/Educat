// To parse this JSON data, do
//
//     final budgetResModel = budgetResModelFromJson(jsonString);

import 'dart:convert';

BudgetResModel budgetResModelFromJson(String str) => BudgetResModel.fromJson(json.decode(str));

String budgetResModelToJson(BudgetResModel data) => json.encode(data.toJson());

class BudgetResModel {
    String? status;
    List<Datum>? data;

    BudgetResModel({
        this.status,
        this.data,
    });

    factory BudgetResModel.fromJson(Map<String, dynamic> json) => BudgetResModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;
    String? price;
    String? discount;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.name,
        this.price,
        this.discount,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        discount: json["discount"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "discount": discount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
