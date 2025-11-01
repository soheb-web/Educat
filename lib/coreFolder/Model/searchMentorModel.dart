import 'dart:convert';

SearchMentorModel searchMentorModelFromJson(String str) => SearchMentorModel.fromJson(json.decode(str));

String searchMentorModelToJson(SearchMentorModel data) => json.encode(data.toJson());

class SearchMentorModel {
    String? message;
    List<Datum>? data;

    SearchMentorModel({
        this.message,
        this.data,
    });

    factory SearchMentorModel.fromJson(Map<String, dynamic> json) => SearchMentorModel(
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? fullName;
    String? email;
    String? phoneNumber;
    String? deviceToken;
    String? token;
    String? profilePic;
    UserType? userType;
    String? serviceType;
    String? description;
    String? location;
    String? userId;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? skillsId;
    String? totalExperience;
    String? usersField;
    String? languageKnown;
    String? linkedinUser;
    DateTime? dob;
    Gender? gender;
    dynamic resumeUpload;
    dynamic samester;
    dynamic status;

    Datum({
        this.id,
        this.fullName,
        this.email,
        this.phoneNumber,
        this.deviceToken,
        this.token,
        this.profilePic,
        this.userType,
        this.serviceType,
        this.description,
        this.location,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.skillsId,
        this.totalExperience,
        this.usersField,
        this.languageKnown,
        this.linkedinUser,
        this.dob,
        this.gender,
        this.resumeUpload,
        this.samester,
        this.status,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        deviceToken: json["device_token"],
        token: json["token"],
        profilePic: json["profile_pic"],
        userType: userTypeValues.map[json["user_type"]], // Remove !, allow null
        serviceType: json["service_type"],
        description: json["description"],
        location: json["location"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        skillsId: json["skills_id"],
        totalExperience: json["total_experience"],
        usersField: json["users_field"],
        languageKnown: json["language_known"],
        linkedinUser: json["linkedin_user"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        gender: genderValues.map[json["gender"]], // Remove !, allow null
        resumeUpload: json["resume_upload"],
        samester: json["samester"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "device_token": deviceToken,
        "token": token,
        "profile_pic": profilePic,
        "user_type": userType != null ? userTypeValues.reverse[userType] : null, // Handle null
        "service_type": serviceType,
        "description": description,
        "location": location,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "skills_id": skillsId,
        "total_experience": totalExperience,
        "users_field": usersField,
        "language_known": languageKnown,
        "linkedin_user": linkedinUser,
        "dob": dob != null
            ? "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}"
            : null, // Handle null
        "gender": gender != null ? genderValues.reverse[gender] : null, // Handle null
        "resume_upload": resumeUpload,
        "samester": samester,
        "status": status,
    };
}

enum Gender { FEMALE, MALE }

final genderValues = EnumValues({
    "female": Gender.FEMALE,
    "male": Gender.MALE,
});

enum UserType { MENTOR, USER_TYPE_MENTOR }

final userTypeValues = EnumValues({
    "Mentor": UserType.MENTOR,
    "mentor": UserType.USER_TYPE_MENTOR,
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}