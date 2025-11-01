// To parse this JSON data, do
//
//     final mentorsModelBody = mentorsModelBodyFromJson(jsonString);

import 'dart:convert';

MentorsModelBody mentorsModelBodyFromJson(String str) => MentorsModelBody.fromJson(json.decode(str));

String mentorsModelBodyToJson(MentorsModelBody data) => json.encode(data.toJson());

class MentorsModelBody {
    String userType;

    MentorsModelBody({
        required this.userType,
    });

    factory MentorsModelBody.fromJson(Map<String, dynamic> json) => MentorsModelBody(
        userType: json["user_type"],
    );

    Map<String, dynamic> toJson() => {
        "user_type": userType,
    };
}
