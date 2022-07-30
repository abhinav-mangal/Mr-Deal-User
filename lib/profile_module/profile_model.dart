// To parse this JSON data, do
//
//     final profileModel = profileModelFromMap(jsonString);

import 'dart:convert';

ProfileModel profileModelFromMap(String str) =>
    ProfileModel.fromMap(json.decode(str));

String profileModelToMap(ProfileModel data) => json.encode(data.toMap());

class ProfileModel {
  ProfileModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory ProfileModel.fromMap(Map<String, dynamic> json) => ProfileModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class Data {
  Data({
    this.id,
    this.name,
    this.email,
    this.dob,
    this.contact,
    this.isRegistered,
    this.points,
  });

  String? id;
  String? name;
  String? email;
  String? dob;
  String? contact;
  bool? isRegistered;
  int? points;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        dob: json["dob"] == null ? null : json["dob"],
        contact: json["contact"] == null ? null : json["contact"],
        isRegistered:
            json["is_registered"] == null ? null : json["is_registered"],
        points: json["points"] == null ? null : json["points"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "dob": dob == null ? null : dob,
        "contact": contact == null ? null : contact,
        "is_registered": isRegistered == null ? null : isRegistered,
        "points": points == null ? null : points,
      };
}
