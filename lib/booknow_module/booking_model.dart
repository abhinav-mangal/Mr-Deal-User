// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

BookingModel bookingModelFromJson(String str) => BookingModel.fromJson(json.decode(str));

String bookingModelToJson(BookingModel data) => json.encode(data.toJson());

class BookingModel {
    BookingModel({
        this.status,
        this.message,
        this.data,
    });

    bool? status;
    String? message;
    Data? data;

    factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
    };
}

class Data {
    Data({
        this.paymentLinkId,
        this.paymentLink,
        this.booking,
    });

    String? paymentLinkId;
    String? paymentLink;
    Booking? booking;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        paymentLinkId: json["paymentLinkId"],
        paymentLink: json["paymentLink"],
        booking: Booking.fromJson(json["booking"]),
    );

    Map<String, dynamic> toJson() => {
        "paymentLinkId": paymentLinkId,
        "paymentLink": paymentLink,
        "booking": booking!.toJson(),
    };
}

class Booking {
    Booking({
        this.userContact,
        this.vendorContact,
        this.modelId,
        this.bookingStatus,
        this.warrantyDays,
        this.warrantyMonthly,
        this.createdTime,
        this.shopName,
        this.brand,
        this.price,
        this.bookingId,
        this.paymentLinkId,
        this.paymentLink,
        this.modelDetails,
    });

    String? userContact;
    String? vendorContact;
    String? modelId;
    String? bookingStatus;
    bool? warrantyDays;
    bool? warrantyMonthly;
    int? createdTime;
    String ?shopName;
    String? brand;
    int ?price;
    String? bookingId;
    String? paymentLinkId;
    String ?paymentLink;
    ModelDetails? modelDetails;

    factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        userContact: json["user_contact"],
        vendorContact: json["vendor_contact"],
        modelId: json["model_id"],
        bookingStatus: json["booking_status"],
        warrantyDays: json["warranty_days"],
        warrantyMonthly: json["warranty_monthly"],
        createdTime: json["created_time"],
        shopName: json["shop_name"],
        brand: json["brand"],
        price: json["price"],
        bookingId: json["booking_id"],
        paymentLinkId: json["paymentLinkId"],
        paymentLink: json["paymentLink"],
        modelDetails: ModelDetails.fromJson(json["model_details"]),
    );

    Map<String, dynamic> toJson() => {
        "user_contact": userContact,
        "vendor_contact": vendorContact,
        "model_id": modelId,
        "booking_status": bookingStatus,
        "warranty_days": warrantyDays,
        "warranty_monthly": warrantyMonthly,
        "created_time": createdTime,
        "shop_name": shopName,
        "brand": brand,
        "price": price,
        "booking_id": bookingId,
        "paymentLinkId": paymentLinkId,
        "paymentLink": paymentLink,
        "model_details": modelDetails!.toJson(),
    };
}

class ModelDetails {
    ModelDetails({
        this.modelId,
        this.mName,
        this.priceRangeNormal,
        this.priceRangeAmoled,
        this.warrantyPriceDays,
        this.warrantyPriceMonthly,
    });

    String? modelId;
    String? mName;
    List<int>? priceRangeNormal;
    List<int>? priceRangeAmoled;
    int ?warrantyPriceDays;
    int? warrantyPriceMonthly;

    factory ModelDetails.fromJson(Map<String, dynamic> json) => ModelDetails(
        modelId: json["model_id"],
        mName: json["m_name"],
        priceRangeNormal: List<int>.from(json["price_range_normal"].map((x) => x)),
        priceRangeAmoled: List<int>.from(json["price_range_amoled"].map((x) => x)),
        warrantyPriceDays: json["warranty_price_days"],
        warrantyPriceMonthly: json["warranty_price_monthly"],
    );

    Map<String, dynamic> toJson() => {
        "model_id": modelId,
        "m_name": mName,
        "price_range_normal": List<dynamic>.from(priceRangeNormal!.map((x) => x)),
        "price_range_amoled": List<dynamic>.from(priceRangeAmoled!.map((x) => x)),
        "warranty_price_days": warrantyPriceDays,
        "warranty_price_monthly": warrantyPriceMonthly,
    };
}
