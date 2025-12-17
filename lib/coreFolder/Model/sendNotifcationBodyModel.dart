// To parse this JSON data, do
//
//     final sendNotifcationBodyModel = sendNotifcationBodyModelFromJson(jsonString);

import 'dart:convert';

SendNotifcationBodyModel sendNotifcationBodyModelFromJson(String str) => SendNotifcationBodyModel.fromJson(json.decode(str));

String sendNotifcationBodyModelToJson(SendNotifcationBodyModel data) => json.encode(data.toJson());

class SendNotifcationBodyModel {
    String deviceToken;
    String title;
    String body;

    SendNotifcationBodyModel({
        required this.deviceToken,
        required this.title,
        required this.body,
    });

    factory SendNotifcationBodyModel.fromJson(Map<String, dynamic> json) => SendNotifcationBodyModel(
        deviceToken: json["device_token"],
        title: json["title"],
        body: json["body"],
    );

    Map<String, dynamic> toJson() => {
        "device_token": deviceToken,
        "title": title,
        "body": body,
    };
}
