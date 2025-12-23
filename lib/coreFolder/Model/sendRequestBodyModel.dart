// To parse this JSON data, do
//
//     final sendRequestBodyModel = sendRequestBodyModelFromJson(jsonString);

import 'dart:convert';

SendRequestBodyModel sendRequestBodyModelFromJson(String str) =>
    SendRequestBodyModel.fromJson(json.decode(str));

String sendRequestBodyModelToJson(SendRequestBodyModel data) =>
    json.encode(data.toJson());

class SendRequestBodyModel {
  int mentorId;

  SendRequestBodyModel({
    required this.mentorId,
  });

  factory SendRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      SendRequestBodyModel(
        mentorId: json["mentor_id"],
      );

  Map<String, dynamic> toJson() => {
        "mentor_id": mentorId,
      };
}

// To parse this JSON data, do
//
//     final acceptRequestBodyModel = acceptRequestBodyModelFromJson(jsonString);

AcceptRequestBodyModel acceptRequestBodyModelFromJson(String str) =>
    AcceptRequestBodyModel.fromJson(json.decode(str));

String acceptRequestBodyModelToJson(AcceptRequestBodyModel data) =>
    json.encode(data.toJson());

class AcceptRequestBodyModel {
  String requestId;

  AcceptRequestBodyModel({
    required this.requestId,
  });

  factory AcceptRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      AcceptRequestBodyModel(
        requestId: json["request_id"],
      );

  Map<String, dynamic> toJson() => {
        "request_id": requestId,
      };
}



// To parse this JSON data, do
//
//     final applybodyModel = applybodyModelFromJson(jsonString);

ApplybodyModel applybodyModelFromJson(String str) =>
    ApplybodyModel.fromJson(json.decode(str));

String applybodyModelToJson(ApplybodyModel data) => json.encode(data.toJson());

class ApplybodyModel {
  String? title;
  String? body;
  int? userId;

  ApplybodyModel({
    this.title,
    this.body,
    this.userId,
  });

  factory ApplybodyModel.fromJson(Map<String, dynamic> json) => ApplybodyModel(
        title: json["title"],
        body: json["body"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "user_id": userId,
      };
}
