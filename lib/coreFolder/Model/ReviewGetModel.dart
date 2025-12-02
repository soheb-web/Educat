// // To parse this JSON data, do
// //
// //     final reviewGetModel = reviewGetModelFromJson(jsonString);

// import 'dart:convert';

// ReviewGetModel reviewGetModelFromJson(String str) => ReviewGetModel.fromJson(json.decode(str));

// String reviewGetModelToJson(ReviewGetModel data) => json.encode(data.toJson());

// class ReviewGetModel {
//   bool? status;
//   Collage? collage;
//   List<Review>? reviews;

//   ReviewGetModel({
//     this.status,
//     this.collage,
//     this.reviews,
//   });

//   factory ReviewGetModel.fromJson(Map<String, dynamic> json) => ReviewGetModel(
//     status: json["status"],
//     collage: json["collage"] == null ? null : Collage.fromJson(json["collage"]),
//     reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
//   );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "collage": collage?.toJson(),
//     "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
//   };
// }

// class Collage {
//   int? id;
//   String? name;
//   String? description;
//   String? phone;
//   String? email;
//   String? website;
//   String? image;
//   String? city;
//   String? pincode;
//   String? type;
//   dynamic rating;
//   dynamic totalReviews;
//   Map<String, int>? distribution;

//   Collage({
//     this.id,
//     this.name,
//     this.description,
//     this.phone,
//     this.email,
//     this.website,
//     this.image,
//     this.city,
//     this.pincode,
//     this.type,
//     this.rating,
//     this.totalReviews,
//     this.distribution,
//   });

//   factory Collage.fromJson(Map<String, dynamic> json) => Collage(
//     id: json["id"],
//     name: json["name"],
//     description: json["description"],
//     phone: json["phone"],
//     email: json["email"],
//     website: json["website"],
//     image: json["image"],
//     city: json["city"],
//     pincode: json["pincode"],
//     type: json["type"],
//     rating: json["rating"],
//     totalReviews: json["total_reviews"],
//     distribution: Map.from(json["distribution"]!).map((k, v) => MapEntry<String, int>(k, v)),
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "description": description,
//     "phone": phone,
//     "email": email,
//     "website": website,
//     "image": image,
//     "city": city,
//     "pincode": pincode,
//     "type": type,
//     "rating": rating,
//     "total_reviews": totalReviews,
//     "distribution": Map.from(distribution!).map((k, v) => MapEntry<String, dynamic>(k, v)),
//   };
// }

// class Review {
//   int? userId;
//   int? rating;
//   String? description;
//   List<dynamic>? skills;
//   DateTime? createdAt;

//   Review({
//     this.userId,
//     this.rating,
//     this.description,
//     this.skills,
//     this.createdAt,
//   });

//   factory Review.fromJson(Map<String, dynamic> json) => Review(
//     userId: json["user_id"],
//     rating: json["rating"],
//     description: json["description"],
//     skills: json["skills"] == null ? [] : List<dynamic>.from(json["skills"]!.map((x) => x)),
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "user_id": userId,
//     "rating": rating,
//     "description": description,
//     "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
//     "created_at": createdAt?.toIso8601String(),
//   };
// }
// To parse this JSON data, do
//
//     final reviewGetModel = reviewGetModelFromJson(jsonString);

import 'dart:convert';

ReviewGetModel reviewGetModelFromJson(String str) =>
    ReviewGetModel.fromJson(json.decode(str));

String reviewGetModelToJson(ReviewGetModel data) => json.encode(data.toJson());

class ReviewGetModel {
  bool? status;
  Collage? collage;
  List<Review>? reviews;

  ReviewGetModel({
    this.status,
    this.collage,
    this.reviews,
  });

  factory ReviewGetModel.fromJson(Map<String, dynamic> json) => ReviewGetModel(
        status: json["status"],
        collage:
            json["collage"] == null ? null : Collage.fromJson(json["collage"]),
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "collage": collage?.toJson(),
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}

class Collage {
  int? id;
  String? name;
  String? description;
  String? phone;
  String? email;
  String? website;
  String? image;
  String? city;
  String? pincode;
  String? type;
  double? rating;
  int? totalReviews;
  Map<String, int>? distribution;
  List<NameWiseRating>? nameWiseRating;

  Collage({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.email,
    this.website,
    this.image,
    this.city,
    this.pincode,
    this.type,
    this.rating,
    this.totalReviews,
    this.distribution,
    this.nameWiseRating,
  });

  factory Collage.fromJson(Map<String, dynamic> json) => Collage(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        phone: json["phone"],
        email: json["email"],
        website: json["website"],
        image: json["image"],
        city: json["city"],
        pincode: json["pincode"],
        type: json["type"],
        rating: json["rating"]?.toDouble(),
        totalReviews: json["total_reviews"],
        distribution: Map.from(json["distribution"]!)
            .map((k, v) => MapEntry<String, int>(k, v)),
        nameWiseRating: json["name_wise_rating"] == null
            ? []
            : List<NameWiseRating>.from(json["name_wise_rating"]!
                .map((x) => NameWiseRating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "phone": phone,
        "email": email,
        "website": website,
        "image": image,
        "city": city,
        "pincode": pincode,
        "type": type,
        "rating": rating,
        "total_reviews": totalReviews,
        "distribution": Map.from(distribution!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "name_wise_rating": nameWiseRating == null
            ? []
            : List<dynamic>.from(nameWiseRating!.map((x) => x.toJson())),
      };
}

class NameWiseRating {
  String? name;
  String? averageRating;
  int? totalReviews;

  NameWiseRating({
    this.name,
    this.averageRating,
    this.totalReviews,
  });

  factory NameWiseRating.fromJson(Map<String, dynamic> json) => NameWiseRating(
        name: json["name"],
        averageRating: json["average_rating"],
        totalReviews: json["total_reviews"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "average_rating": averageRating,
        "total_reviews": totalReviews,
      };
}

class Review {
  int? userId;
  int? rating;
  String? description;
  String? name;
  List<dynamic>? skills;
  DateTime? createdAt;

  Review({
    this.userId,
    this.rating,
    this.description,
    this.name,
    this.skills,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        userId: json["user_id"],
        rating: json["rating"],
        description: json["description"],
        name: json["name"],
        skills: json["skills"] == null
            ? []
            : List<dynamic>.from(json["skills"]!.map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "rating": rating,
        "description": description,
        "name": name,
        "skills":
            skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
      };
}
