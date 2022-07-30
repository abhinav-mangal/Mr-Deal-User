// To parse this JSON data, do
//
//     final shopListModel = shopListModelFromMap(jsonString);

import 'dart:convert';

ShopListModel shopListModelFromMap(String str) =>
    ShopListModel.fromMap(json.decode(str));

String shopListModelToMap(ShopListModel data) => json.encode(data.toMap());

class ShopListModel {
  ShopListModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Details>? data;

  factory ShopListModel.fromMap(Map<String, dynamic> json) => ShopListModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Details>.from(json["data"].map((x) => Details.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Details {
  Details({
    this.id,
    this.contact,
    // this.coins,
    // this.createdTime,
    this.isRegistered,
    // this.distance,
    this.address,
    this.ownerName,
    this.shopImage,
    this.shopName,
    // this.modifiedTime,
    this.lat,
    this.long,
    // this.points,
  });

  String? id;
  String? contact;
  // int? coins;
  // int? createdTime;
  bool? isRegistered;
  // int? distance;
  String? address;
  String? ownerName;
  String? shopImage;
  String? shopName;
  // int? modifiedTime;
  String? lat;
  String? long;
  // int? points;

  factory Details.fromMap(Map<String, dynamic> json) => Details(
        id: json["_id"] == null ? null : json["_id"],
        contact: json["contact"] == null ? null : json["contact"],
        // coins: json["coins"] == null ? null : json["coins"],
        // createdTime: json["created_time"] == null ? null : json["created_time"],
        isRegistered:
            json["is_registered"] == null ? null : json["is_registered"],
        // distance: json["distance"] == null ? null : json["distance"],
        address: json["address"] == null ? null : json["address"],
        ownerName: json["owner_name"] == null ? null : json["owner_name"],
        shopImage: json["shop_image"] == null ? null : json["shop_image"],
        shopName: json["shop_name"] == null ? null : json["shop_name"],
        // modifiedTime:
        //     json["modified_time"] == null ? null : json["modified_time"],
        lat: json["lat"] == null ? null : json["lat"],
        long: json["long"] == null ? null : json["long"],
        // points: json["points"] == null ? null : json["points"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "contact": contact == null ? null : contact,
        // "coins": coins == null ? null : coins,
        // "created_time": createdTime == null ? null : createdTime,
        "is_registered": isRegistered == null ? null : isRegistered,
        // "distance": distance == null ? null : distance,
        "address": address == null ? null : address,
        "owner_name": ownerName == null ? null : ownerName,
        "shop_image": shopImage == null ? null : shopImage,
        "shop_name": shopName == null ? null : shopName,
        // "modified_time": modifiedTime == null ? null : modifiedTime,
        "lat": lat == null ? null : lat,
        "long": long == null ? null : long,
        // "points": points == null ? null : points,
      };
}
