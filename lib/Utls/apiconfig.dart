import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mr_deal_user/booknow_module/booking_confirm/booking_cnf_model.dart';
import 'package:mr_deal_user/booknow_module/booking_model.dart';
import 'package:mr_deal_user/common_widgets/globals.dart';
import 'package:mr_deal_user/home_module/home_model.dart';
import 'package:mr_deal_user/home_module/specific_data/specific_model_model.dart';
import 'package:mr_deal_user/login_module/login_model.dart';
import 'package:mr_deal_user/login_module/otp_module/otp_model.dart';
import 'package:mr_deal_user/profile_module/delete_acc/delete_acc_model.dart';
import 'package:mr_deal_user/profile_module/edit_profile_module/edit_model.dart';
import 'package:mr_deal_user/profile_module/profile_model.dart';
import 'package:mr_deal_user/profile_module/register_module/register_model.dart';
import 'package:mr_deal_user/shop_list_module/shop_ls_model.dart';
import 'package:mr_deal_user/wallet_module/wallet_model.dart';
import 'deal_constant.dart';

class Apiconfig {
  static var timeoutrespon = {"status": false, "message": "timeout"};

  static Future<dynamic> postAPITyp(url, [header, params]) async {
    print('post');
    print(header);
    print(json.encode(params));
    print(url);
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            body: params != null ? json.encode(params) : {},
            headers: header,
          )
          .timeout(const Duration(seconds: 20));

      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      print('Timeout $e');
      return timeoutrespon;
    } on SocketException catch (e) {
      print('socketeee: $e');
      return timeoutrespon;
    } on Error catch (e) {
      print("in catch--");
      print('Error: $e');
    }
  }

  static Future<dynamic> getMethod(url, [header]) async {
    print(url);
    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: header,
          )
          .timeout(const Duration(seconds: 20));

      final statusCode = response.statusCode;
      if (statusCode != 200 || response.body == null) {
        throw TimeoutException(
            'An error ocurred : [Status Code : $statusCode]');
      }
      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      print('Timeout $e');
      return timeoutrespon;
    } on SocketException catch (e) {
      print(e);
      return timeoutrespon;
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  Future<ContactVerifyModel> verifyContactApi(
      http.Client client, request) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'users/contact-verify', header, request);
    print('response === $response');
    ContactVerifyModel data = ContactVerifyModel.fromMap(response);
    return data;
  }

  Future<OtpVerifyModel> verifyOtpApi(http.Client client, request, code) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'users/contact-verify?code=$code',
        header,
        request);
    print('response === $response');
    OtpVerifyModel data = OtpVerifyModel.fromMap(response);
    return data;
  }

  // Future<RegisterModel> registerApi(http.Client client, request) async {
  //   var header = {
  //     "Content-Type": "application/json",
  //   };

  //   final response = await postAPITyp(
  //       Constants.BASE_URL + 'vendor/register', header, request);
  //   print('response === $response');
  //   RegisterModel data = RegisterModel.fromMap(response);
  //   return data;
  // }

  Future<HomepageModel> homepageApi(http.Client client) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response =
        await getMethod(Constants.BASE_URL + 'users/models/homepage', header);
    print('hp response === $response');
    HomepageModel data = HomepageModel.fromMap(response);
    return data;
  }

  Future<ShopListModel> shopListApi(http.Client client) async {
    var header = {
      "Content-Type": "application/json",
    };
    var request = {"lat": MrDealGlobals.lat, "long": MrDealGlobals.long};

    final response =
        await postAPITyp(Constants.BASE_URL + 'vendor/all', header, request);
    print('response === $response');
    ShopListModel data = ShopListModel.fromMap(response);
    return data;
  }

  Future<RegisterUserModel> registerUserApi(http.Client client, request) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'users/register', header, request);
    print('response === $response');
    RegisterUserModel data = RegisterUserModel.fromMap(response);
    return data;
  }

  Future<BookingModel> bookingApi(http.Client client, request) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response =
        await postAPITyp(Constants.BASE_URL + 'booking/save', header, request);
    print('response === $response');
    BookingModel data = BookingModel.fromJson(response);
    return data;
  }

  Future<ProfileModel> profileAPi(http.Client client, contact) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response =
        await getMethod(Constants.BASE_URL + 'users/$contact', header);
    print('profile response === $response');
    ProfileModel data = ProfileModel.fromMap(response);
    return data;
  }

  Future<ConfirmationModel> cnfbookingApi(http.Client client, request) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'payment-status/$request', header, {});
    print('response === $response');
    ConfirmationModel data = ConfirmationModel.fromMap(response);
    return data;
  }

  Future<EditProfileModel> editProfileAPi(http.Client client, request) async {
    var header = {
      "Content-Type": "application/json",
    };
    print('#@@@@@@@@@@@@@@');
    print(request);
    final response = await postAPITyp(
        Constants.BASE_URL + 'users/update/${MrDealGlobals.userContact}',
        header,
        request);
    print('response === $response');
    EditProfileModel data = EditProfileModel.fromMap(response);
    print('###@@@@@@$data');
    return data;
  }

  Future<WalletModel> walletApi(http.Client client, request) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'users/bookings', header, request);
    print('response === $response');
    WalletModel data = WalletModel.fromMap(response);
    return data;
  }

  Future<SpecificModelData> specificModelApi(
      http.Client client, request) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'users/model-data', header, request);
    print('response === $response');
    SpecificModelData data = SpecificModelData.fromMap(response);
    return data;
  }

  Future<DeleteUserModel> deleteAccApi(http.Client client) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'users/delete/${MrDealGlobals.userContact}',
        header, {});
    print(response);
    DeleteUserModel data = DeleteUserModel.fromMap(response);
    return data;
  }
}
