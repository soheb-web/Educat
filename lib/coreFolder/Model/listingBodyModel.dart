// To parse this JSON data, do
//
//     final createlistBodyModel = createlistBodyModelFromJson(jsonString);

import 'dart:convert';

CreatelistBodyModel createlistBodyModelFromJson(String str) => CreatelistBodyModel.fromJson(json.decode(str));

String createlistBodyModelToJson(CreatelistBodyModel data) => json.encode(data.toJson());

class CreatelistBodyModel {
    String? education;
    List<String>? subjects;
    String? location;
    String? teachingMode;
    String? duration;
    String? requires;
    String? budget;
    String? mobileNumber;
    String? time;
    String? gender;
    String? communicate;
    String? state;
    String? localAddress;
    String? pincode;

    CreatelistBodyModel({
        this.education,
        this.subjects,
        this.location,
        this.teachingMode,
        this.duration,
        this.requires,
        this.budget,
        this.mobileNumber,
        this.time,
        this.gender,
        this.communicate,
        this.state,
        this.localAddress,
        this.pincode,
    });

    factory CreatelistBodyModel.fromJson(Map<String, dynamic> json) => CreatelistBodyModel(
        education: json["education"],
        subjects: json["subjects"] == null ? [] : List<String>.from(json["subjects"]!.map((x) => x)),
        location: json["location"],
        teachingMode: json["teaching_mode"],
        duration: json["duration"],
        requires: json["requires"],
        budget: json["budget"],
        mobileNumber: json["mobile_number"],
        time: json["time"],
        gender: json["gender"],
        communicate: json["communicate"],
        state: json["state"],
        localAddress: json["local_address"],
        pincode: json["pincode"],
    );

    Map<String, dynamic> toJson() => {
        "education": education,
        "subjects": subjects == null ? [] : List<dynamic>.from(subjects!.map((x) => x)),
        "location": location,
        "teaching_mode": teachingMode,
        "duration": duration,
        "requires": requires,
        "budget": budget,
        "mobile_number": mobileNumber,
        "time": time,
        "gender": gender,
        "communicate": communicate,
        "state": state,
        "local_address": localAddress,
        "pincode": pincode,
    };
}
