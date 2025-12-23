// To parse this JSON data, do
//
//     final createlistBodyModel = createlistBodyModelFromJson(jsonString);

import 'dart:convert';

CreatelistBodyModel createlistBodyModelFromJson(String str) =>
    CreatelistBodyModel.fromJson(json.decode(str));

String createlistBodyModelToJson(CreatelistBodyModel data) =>
    json.encode(data.toJson());

class CreatelistBodyModel {
  String education;
  String experience;
  List<String> subjects;
  String fee;
  String description;
  String location;
  String duration;
  String teachingMode;

  CreatelistBodyModel({
    required this.education,
    required this.experience,
    required this.subjects,
    required this.fee,
    required this.description,
    required this.location,
    required this.duration,
    required this.teachingMode,
  });

  factory CreatelistBodyModel.fromJson(Map<String, dynamic> json) =>
      CreatelistBodyModel(
        education: json["education"],
        experience: json["experience"],
        subjects: List<String>.from(json["subjects"].map((x) => x)),
        fee: json["fee"],
        description: json["description"],
        location: json['location'],
        duration: json['duration'],
        teachingMode: json['teaching_mode'],
      );

  Map<String, dynamic> toJson() => {
        "education": education,
        "experience": experience,
        "subjects": List<dynamic>.from(subjects.map((x) => x)),
        "fee": fee,
        "description": description,
        'location': location,
        "duration": duration,
        "teaching_mode": teachingMode,
      };
}
