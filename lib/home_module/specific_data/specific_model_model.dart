// To parse this JSON data, do
//
//     final specificModelData = specificModelDataFromMap(jsonString);

import 'dart:convert';

SpecificModelData specificModelDataFromMap(String str) =>
    SpecificModelData.fromMap(json.decode(str));

String specificModelDataToMap(SpecificModelData data) =>
    json.encode(data.toMap());

class SpecificModelData {
  SpecificModelData({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory SpecificModelData.fromMap(Map<String, dynamic> json) =>
      SpecificModelData(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data?.toMap(),
      };
}

class Data {
  Data({
    this.modelId,
    this.mName,
    this.warrantyPriceDays,
    this.warrantyPriceMonthly,
    this.priceRangeNormal,
    this.priceRangeAmoled,
    this.bName,
    this.sName,
  });

  String? modelId;
  String? mName;
  int? warrantyPriceDays;
  int? warrantyPriceMonthly;
  List<int>? priceRangeNormal;
  List<int>? priceRangeAmoled;
  String? bName;
  String? sName;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        modelId: json["model_id"] == null ? null : json["model_id"],
        mName: json["m_name"] == null ? null : json["m_name"],
        warrantyPriceDays: json["warranty_price_days"] == null
            ? null
            : json["warranty_price_days"],
        warrantyPriceMonthly: json["warranty_price_monthly"] == null
            ? null
            : json["warranty_price_monthly"],
        priceRangeNormal: json["price_range_normal"] == null
            ? null
            : List<int>.from(json["price_range_normal"].map((x) => x)),
        priceRangeAmoled: json["price_range_amoled"] == null
            ? null
            : List<int>.from(json["price_range_amoled"].map((x) => x)),
        bName: json["b_name"] == null ? null : json["b_name"],
        sName: json["s_name"] == null ? null : json["s_name"],
      );

  Map<String, dynamic> toMap() => {
        "model_id": modelId == null ? null : modelId,
        "m_name": mName == null ? null : mName,
        "warranty_price_days":
            warrantyPriceDays == null ? null : warrantyPriceDays,
        "warranty_price_monthly":
            warrantyPriceMonthly == null ? null : warrantyPriceMonthly,
        "price_range_normal": priceRangeNormal == null
            ? null
            : List<dynamic>.from(priceRangeNormal!.map((x) => x)),
        "price_range_amoled": priceRangeAmoled == null
            ? null
            : List<dynamic>.from(priceRangeAmoled!.map((x) => x)),
        "b_name": bName == null ? null : bName,
        "s_name": sName == null ? null : sName,
      };
}
