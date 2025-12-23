// To parse this JSON data, do
//
//     final mentorNotificationResModel = mentorNotificationResModelFromJson(jsonString);

import 'dart:convert';

MentorNotificationResModel mentorNotificationResModelFromJson(String str) => MentorNotificationResModel.fromJson(json.decode(str));

String mentorNotificationResModelToJson(MentorNotificationResModel data) => json.encode(data.toJson());

class MentorNotificationResModel {
    bool? success;
    int? studentId;
    int? totalMentors;
    List<Datum>? data;

    MentorNotificationResModel({
        this.success,
        this.studentId,
        this.totalMentors,
        this.data,
    });

    factory MentorNotificationResModel.fromJson(Map<String, dynamic> json) => MentorNotificationResModel(
        success: json["success"],
        studentId: json["student_id"],
        totalMentors: json["total_mentors"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "student_id": studentId,
        "total_mentors": totalMentors,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? fullName;
    String? email;
    String? title;
    String? body;
    int? notificationCount;

    Datum({
        this.id,
        this.fullName,
        this.email,
        this.title,
        this.body,
        this.notificationCount,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        title: json["title"],
        body: json["body"],
        notificationCount: json["notification_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "title": title,
        "body": body,
        "notification_count": notificationCount,
    };
}
