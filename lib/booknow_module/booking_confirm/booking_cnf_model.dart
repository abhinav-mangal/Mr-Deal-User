// To parse this JSON data, do
//
//     final confirmationModel = confirmationModelFromMap(jsonString);

import 'dart:convert';

ConfirmationModel confirmationModelFromMap(String str) =>
    ConfirmationModel.fromMap(json.decode(str));

String confirmationModelToMap(ConfirmationModel data) =>
    json.encode(data.toMap());

class ConfirmationModel {
  ConfirmationModel({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory ConfirmationModel.fromMap(Map<String, dynamic> json) =>
      ConfirmationModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
      };
}
