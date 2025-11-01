// To parse this JSON data, do
//
//     final mentorHomeModel = mentorHomeModelFromJson(jsonString);

import 'dart:convert';

MentorHomeModel mentorHomeModelFromJson(String str) => MentorHomeModel.fromJson(json.decode(str));

String mentorHomeModelToJson(MentorHomeModel data) => json.encode(data.toJson());

class MentorHomeModel {
  bool? status;
  Data? data;

  MentorHomeModel({
    this.status,
    this.data,
  });

  factory MentorHomeModel.fromJson(Map<String, dynamic> json) => MentorHomeModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? fullName;
  String? profilePic;
  String? description;
  String? userType;
  dynamic location;
  String? coins;
  int? profileCompletion;
  List<AcceptedStudent>? acceptedStudents;
  List<Message>? messages;

  Data({
    this.id,
    this.fullName,
    this.profilePic,
    this.description,
    this.userType,
    this.location,
    this.coins,
    this.profileCompletion,
    this.acceptedStudents,
    this.messages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    fullName: json["full_name"],
    profilePic: json["profile_pic"],
    description: json["description"],
    userType: json["user_type"],
    location: json["location"],
    coins: json["coins"],
    profileCompletion: json["profile_completion"],
    acceptedStudents: json["accepted_students"] == null ? [] : List<AcceptedStudent>.from(json["accepted_students"]!.map((x) => AcceptedStudent.fromJson(x))),
    messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "profile_pic": profilePic,
    "description": description,
    "user_type": userType,
    "location": location,
    "coins": coins,
    "profile_completion": profileCompletion,
    "accepted_students": acceptedStudents == null ? [] : List<dynamic>.from(acceptedStudents!.map((x) => x.toJson())),
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class AcceptedStudent {
  int? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? profilePic;
  String? description;

  AcceptedStudent({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePic,
    this.description,
  });

  factory AcceptedStudent.fromJson(Map<String, dynamic> json) => AcceptedStudent(
    id: json["id"],
    fullName: json["full_name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    profilePic: json["profile_pic"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "phone_number": phoneNumber,
    "profile_pic": profilePic,
    "description": description,
  };
}

class Message {
  int? id;
  String? senderName;
  String? message;
  String? profilePic;
  int? unreadCount;
  DateTime? timestamp;

  Message({
    this.id,
    this.senderName,
    this.message,
    this.profilePic,
    this.unreadCount,
    this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    senderName: json["sender_name"],
    message: json["message"],
    profilePic: json["profile_pic"],
    unreadCount: json["unread_count"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_name": senderName,
    "message": message,
    "profile_pic": profilePic,
    "unread_count": unreadCount,
    "timestamp": timestamp?.toIso8601String(),
  };
}
