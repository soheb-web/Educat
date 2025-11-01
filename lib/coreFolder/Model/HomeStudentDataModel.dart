// To parse this JSON data, do
//
//     final homeStudentDataModel = homeStudentDataModelFromJson(jsonString);

import 'dart:convert';

/// Represents the top-level data model for the student education platform's homepage API response.
HomeStudentDataModel homeStudentDataModelFromJson(String str) => HomeStudentDataModel.fromJson(json.decode(str));

/// Converts the data model back to JSON.
String homeStudentDataModelToJson(HomeStudentDataModel data) => json.encode(data.toJson());

/// The main data model containing status, mentors, skills, companies, and colleges.
class HomeStudentDataModel {
  /// Indicates whether the API request was successful.
  bool? status;

  /// A map of mentor lists, categorized by service type (e.g., "Data Science", "Psychology").
  Map<String, List<Mentor>>? mentors;

  /// A list of available skills.
  List<Skill>? skills;

  /// A list of companies.
  List<Company>? companies;

  /// A list of colleges.
  List<College>? colleges;

  HomeStudentDataModel({
    this.status,
    this.mentors,
    this.skills,
    this.companies,
    this.colleges,
  });

  factory HomeStudentDataModel.fromJson(Map<String, dynamic> json) => HomeStudentDataModel(
    status: json["status"],
    mentors: json["mentors"] == null
        ? null
        : Map.from(json["mentors"]!).map(
          (k, v) => MapEntry<String, List<Mentor>>(
        k,
        List<Mentor>.from(v.map((x) => Mentor.fromJson(x))),
      ),
    ),
    skills: json["skills"] == null ? [] : List<Skill>.from(json["skills"]!.map((x) => Skill.fromJson(x))),
    companies: json["companies"] == null ? [] : List<Company>.from(json["companies"]!.map((x) => Company.fromJson(x))),
    colleges: json["collages"] == null ? [] : List<College>.from(json["collages"]!.map((x) => College.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "mentors": mentors == null
        ? null
        : Map.from(mentors!).map(
          (k, v) => MapEntry<String, dynamic>(
        k,
        List<dynamic>.from(v.map((x) => x.toJson())),
      ),
    ),
    "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x.toJson())),
    "companies": companies == null ? [] : List<dynamic>.from(companies!.map((x) => x.toJson())),
    "collages": colleges == null ? [] : List<dynamic>.from(colleges!.map((x) => x.toJson())),
  };
}

/// Represents a company in the platform.
class Company {
  /// Unique identifier for the company.
  int? id;

  /// Name of the company.
  String? companyName;

  /// City where the company is located.
  String? city;

  /// URL to the company's image.
  String? image;

  /// Average rating of the company (parsed as a double).
  double? avgRating;

  /// Total number of reviews for the company.
  int? totalReviews;

  Company({
    this.id,
    this.companyName,
    this.city,
    this.image,
    this.avgRating,
    this.totalReviews,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    companyName: json["collage_name"], // Map from existing JSON key
    city: json["city"],
    image: json["image"],
    avgRating: json["avg_rating"] != null ? double.tryParse(json["avg_rating"]) : null,
    totalReviews: json["total_reviews"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "collage_name": companyName, // Maintain compatibility with JSON
    "city": city,
    "image": image,
    "avg_rating": avgRating?.toString(),
    "total_reviews": totalReviews,
  };
}

/// Represents a college in the platform.
class College {
  /// Unique identifier for the college.
  int? id;

  /// Name of the college.
  String? collegeName;

  /// City where the college is located.
  String? city;

  /// URL to the college's image.
  String? image;

  /// Average rating of the college (parsed as a double).
  double? avgRating;

  /// Total number of reviews for the college.
  int? totalReviews;

  College({
    this.id,
    this.collegeName,
    this.city,
    this.image,
    this.avgRating,
    this.totalReviews,
  });

  factory College.fromJson(Map<String, dynamic> json) => College(
    id: json["id"],
    collegeName: json["collage_name"], // Map from existing JSON key
    city: json["city"],
    image: json["image"],
    avgRating: json["avg_rating"] != null ? double.tryParse(json["avg_rating"]) : null,
    totalReviews: json["total_reviews"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "collage_name": collegeName, // Maintain compatibility with JSON
    "city": city,
    "image": image,
    "avg_rating": avgRating?.toString(),
    "total_reviews": totalReviews,
  };
}

/// Represents a mentor with details about their expertise and contact information.
class Mentor {
  /// Unique identifier for the mentor.
  int? id;

  /// Full name of the mentor.
  String? fullName;

  /// Email address of the mentor.
  String? email;

  /// Phone number of the mentor.
  String? phoneNumber;

  /// URL to the mentor's profile picture.
  String? profilePic;

  /// Type of service offered by the mentor (e.g., "Data Science", "Career Coaching").
  String? serviceType;

  /// Description of the mentor's expertise or services.
  String? description;

  /// Location of the mentor.
  String? location;

  /// ID of the skill associated with the mentor (references the Skill class).
  int? skillsId;

  /// Total years of experience of the mentor.
  String? totalExperience;

  /// Field or domain the mentor specializes in.
  String? usersField;

  /// Languages known by the mentor.
  String? languageKnown;

  /// LinkedIn profile URL of the mentor.
  String? linkedinUser;

  Mentor({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePic,
    this.serviceType,
    this.description,
    this.location,
    this.skillsId,
    this.totalExperience,
    this.usersField,
    this.languageKnown,
    this.linkedinUser,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) => Mentor(
    id: json["id"],
    fullName: json["full_name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    profilePic: json["profile_pic"],
    serviceType: json["service_type"],
    description: json["description"],
    location: json["location"],
    skillsId: json["skills_id"],
    totalExperience: json["total_experience"],
    usersField: json["users_field"],
    languageKnown: json["language_known"],
    linkedinUser: json["linkedin_user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "phone_number": phoneNumber,
    "profile_pic": profilePic,
    "service_type": serviceType,
    "description": description,
    "location": location,
    "skills_id": skillsId,
    "total_experience": totalExperience,
    "users_field": usersField,
    "language_known": languageKnown,
    "linkedin_user": linkedinUser,
  };
}

/// Represents a skill available on the platform.
class Skill {
  /// Unique identifier for the skill.
  int? id;

  /// Title of the skill (e.g., "Data Science", "Flutter").
  String? title;

  /// URL to the skill's image.
  String? image;

  /// Proficiency level of the skill (e.g., ADVANCED, BEGINNER, INTERMEDIATE).
  Level? level;

  Skill({
    this.id,
    this.title,
    this.image,
    this.level,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    level: json["level"] != null && levelValues.map.containsKey(json["level"])
        ? levelValues.map[json["level"]]
        : null, // Handle unexpected level values
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "level": levelValues.reverse[level],
  };
}

/// Enum representing the proficiency level of a skill.
enum Level {
  ADVANCED,
  BEGINNER,
  INTERMEDIATE,
}

/// Utility class to map string values to Level enum and vice versa.
class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

final levelValues = EnumValues({
  "ADVANCED": Level.ADVANCED,
  "BEGINNER": Level.BEGINNER,
  "INTERMEDIATE": Level.INTERMEDIATE,
});