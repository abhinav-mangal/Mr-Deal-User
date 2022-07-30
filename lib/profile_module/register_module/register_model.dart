// To parse this JSON data, do
//
//     final registerUserModel = registerUserModelFromMap(jsonString);

import 'dart:convert';

RegisterUserModel registerUserModelFromMap(String str) =>
    RegisterUserModel.fromMap(json.decode(str));

String registerUserModelToMap(RegisterUserModel data) =>
    json.encode(data.toMap());

class RegisterUserModel {
  RegisterUserModel({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory RegisterUserModel.fromMap(Map<String, dynamic> json) =>
      RegisterUserModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
      };
}
