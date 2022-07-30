import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_user/Utls/deal_constant.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/connectivity.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/globals.dart';
import 'package:mr_deal_user/common_widgets/loader.dart';
import 'package:mr_deal_user/common_widgets/no_internet.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:mr_deal_user/wallet_module/cancel_button.dart';
import 'package:mr_deal_user/wallet_module/wallet_model.dart';
import 'package:mr_deal_user/wallet_module/wallet_view.dart';
import 'package:intl/intl.dart';
import 'wallet_presenter.dart';
import 'package:http/http.dart' as http;

import 'warranty_claim.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

String _datetime(timestamp) {
  var dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var d12 = DateFormat('dd-MM-yyyy, hh:mm a').format(dt);

  return d12.toString();
}

String _datetimeNew(timestamp) {
  var dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var d12 = DateFormat('yyyy-MM-dd HH:mm:ss.ms').format(dt);

  return d12.toString();
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inSeconds).round();
}

int calculateTimeDifferenceBetween(
    {required DateTime startDate, required DateTime endDate}) {
  int seconds = endDate.difference(startDate).inSeconds;
  if (seconds < 60)
    return seconds;
  else if (seconds >= 60 && seconds < 3600)
    return startDate.difference(endDate).inSeconds.abs();
  else if (seconds >= 3600 && seconds < 86400)
    return startDate.difference(endDate).inSeconds.abs();
  else
    return startDate.difference(endDate).inSeconds.abs();
}

class _WalletPageState extends State<WalletPage> implements WalletView {
  bool _isLoading = true;
  var noConnection;
  WalletModel? _walletModelResp;

  // bool visible = false;

  TextEditingController bookingIdController = TextEditingController();

  bool isLoading = false;
  String formattedDate =
      DateFormat('yyyy-MM-dd HH:mm:ss.ms').format(DateTime.now());

  Widget _body() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const TextWidget(
            text: 'Transaction History',
            size: text_size_18,
            weight: FontWeight.w500,
          ),
          const SizedBox(
            height: 10,
          ),
          _isLoading
              ? const Center(
                  child: SizedBox(height: 500, child: Loader()),
                )
              : _trxnHistry()
        ],
      ),
    );
  }

  Widget _trxnHistry() {
    return Container(
      height: MediaQuery.of(context).size.height - 230,
      child: (_walletModelResp?.data?.length ?? 0) == 0
          ? const Center(
              child: TextWidget(
              text: 'No Transactions Found',
              size: text_size_20,
              weight: FontWeight.w600,
            ))
          : ListView.builder(
              itemCount: _walletModelResp?.data?.length ?? 0,
              padding: const EdgeInsets.only(top: 10),
              // reverse: true,
              itemBuilder: (context, i) {
                var details = _walletModelResp?.data![i].userDetails;
                print(details);
                var createdTime =
                    _datetimeNew(_walletModelResp?.data![i].createdTime);
                // print(createdTime);
                DateTime from = DateTime.parse(createdTime);
                DateTime to = DateTime.parse(formattedDate);
                // var diffrence = daysBetween(from, to);
                // print(diffrence);

                var time = calculateTimeDifferenceBetween(
                    startDate: from, endDate: to);
                print(time);

                String warranty() {
                  if (_walletModelResp?.data![i].warrantyDays == true &&
                      _walletModelResp?.data![i].warrantyMonthly == true) {
                    return "10 days replacement warranty & 6 month functional warranty";
                  } else if (_walletModelResp?.data![i].warrantyMonthly ==
                          true &&
                      _walletModelResp?.data![i].warrantyDays == false) {
                    return "6 month functional warranty";
                  } else if (_walletModelResp?.data![i].warrantyDays == true &&
                      _walletModelResp?.data![i].warrantyMonthly == false) {
                    return "10 days replacement warranty";
                  } else {
                    return "N/A";
                  }
                }

                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AnswerPdfPage(
                    //               testNo: i + 1,
                    //               url: solutionsList![i].url,
                    //             )));
                  },
                  child: Container(
                      // height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                          color: white_color,
                          border: Border.all(color: theme_color, width: 0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                color: transparent,
                                padding: const EdgeInsets.only(bottom: 5),
                                width: MediaQuery.of(context).size.width - 110,
                                child: SelectableText(
                                    'Booking ID : ${_walletModelResp?.data![i].bookingId ?? ''}',
                                    style: TextStyle(
                                        fontSize: text_size_14,
                                        fontWeight: FontWeight.w500)),
                              ),
                              "${_walletModelResp?.data![i].bookingStatus}"
                                          .contains('Cancelled') ||
                                      "${_walletModelResp?.data![i].bookingStatus}"
                                          .contains('Delivered')
                                  ? Container()
                                  : time >= 60
                                      ? Container()
                                      : CancelCustomButton(
                                          bookingId:
                                              "${_walletModelResp?.data![i].bookingId}",
                                          userContact:
                                              "${_walletModelResp?.data![i].userContact}")
                            ],
                          ),
                          TextWidget(
                            text:
                                'Shop Name : ${_walletModelResp?.data![i].shopName ?? ''}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          // Container(
                          //   color: transparent,
                          //   padding: const EdgeInsets.only(bottom: 5),
                          //   width: MediaQuery.of(context).size.width - 110,
                          //   child:
                          // ),
                          TextWidget(
                            text:
                                'Booked On : ${_datetime(_walletModelResp?.data![i].createdTime)}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          TextWidget(
                            text:
                                'Model Name & Make : ${_walletModelResp?.data![i].brand}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          TextWidget(
                            text: 'Warranty Status : ${warranty()}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          TextWidget(
                            text:
                                'Payment Ref. No : ${_walletModelResp?.data![i].paymentLinkId ?? "N/A"}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          // Container(
                          //   padding: const EdgeInsets.only(bottom: 5),
                          //   child: TextWidget(
                          //     text:
                          //         'Owner name : ${_walletModelResp?.data![i].shopDetails?.ownerName ?? ''}',
                          //     size: text_size_14,
                          //     weight: FontWeight.w500,
                          //   ),
                          // ),
                          TextWidget(
                            text:
                                'Service status : ${_walletModelResp?.data![i].bookingStatus}'
                                ' ${_walletModelResp?.data![i].editedTime  ?? ""}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "${_walletModelResp?.data![i].bookingStatus}"
                                      .contains('Cancelled')
                                  ? Container()
                                  : _walletModelResp?.data![i].otp == null
                                      ? Container()
                                      : Text(
                                          "OTP: ${_walletModelResp?.data![i].otp}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                              _walletModelResp?.data![i].otp == null
                                  ? _walletModelResp?.data![i].paymentLinkId !=
                                          null
                                      ? ElevatedButton(
                                          onPressed: () {
                                            claimWarranty(
                                                user_contact:
                                                    "${_walletModelResp?.data![i].userDetails!.contact}",
                                                bookingId:
                                                    "${_walletModelResp?.data![i].bookingId}");
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8))),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      theme_color)),
                                          child: Text("Claim Warranty"))
                                      : Container()
                                  : Container()
                            ],
                          ),
                          SizedBox(height: 10),
                          "${_walletModelResp?.data![i].bookingStatus}"
                                  .contains('Cancelled')
                              ? Container()
                              : _walletModelResp?.data![i].otp == null
                                  ? Container()
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          border: Border.all(
                                              color: theme_color, width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        child: Text(
                                          "PLEASE SHARE THE OTP WITH THE MR DEAL VENDOR AT THE TIME OF COLLECTNG YOUR DEVICE",
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    )
                        ],
                      )),
                );
              }),
    );
  }

  void claimWarranty(
      {required String user_contact, required String bookingId}) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          bool visible = false;
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 15),
            child: StatefulBuilder(builder: (context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Enter your booking ID",
                    style:
                        TextStyle(color: theme_color, fontSize: text_size_16),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 50,
                      child: TextFormField(
                        controller: bookingIdController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: theme_color)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: theme_color)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: theme_color)),
                            hintStyle: TextStyle(fontSize: 12),
                            hintText: "Your Booking ID"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                      visible: visible,
                      child: const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Invalid booking ID. Please enter correct booking ID.",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ))),
                  const SizedBox(height: 10),
                  isLoading == false
                      ? ElevatedButton(
                          onPressed: () async {
                            await claimWarrantyApi(user_contact: user_contact)
                                .then((value) {
                              if (value == false) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WarrantyClaim(
                                            bookingId: bookingId)));
                              } else {
                                setState(() => visible = value);
                              }
                            });

                            // Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(theme_color)),
                          child: const Text("Submit"),
                        )
                      : CircularProgressIndicator(),
                  const SizedBox(height: 10),
                ],
              );
            }),
          );
        });
  }

  Future claimWarrantyApi({required String user_contact}) async {
    final response = await http.post(
      Uri.parse(Constants.BASE_URL + "claim-warranty"),
      body: {
        "booking_id": bookingIdController.text,
        "user_contact": user_contact
      },
    );
    var data = json.decode(response.body);
    var status = data["status"];

    if (status == true) {
      return false;
    } else {
      return true;
    }
  }

  Widget _appbar() {
    return AppBar(
      backgroundColor: theme_color,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: <Color>[Color(0xff0e2c94), Color(0xff4abcf2)]),
          // ),
          ),
      title: const TextWidget(
        text: 'MR DEAL Transactions',
        size: text_size_18,
        color: white_color,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _walletAPiCall();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _walletAPiCall() {
    var contact = {"contact": MrDealGlobals.userContact};
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        WalletPresenter().getTrxnDetails(this, contact);
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        noConnection = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const NoInternet()));
        if (noConnection != null) {
          if (mounted) {
            setState(() {
              _isLoading = true;
            });
          }

          WalletPresenter().getTrxnDetails(this, contact);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            appBar: PreferredSize(
                child: _appbar(), preferredSize: const Size.fromHeight(60)),
            body: _body(),
          )),
    );
  }

  @override
  void walletErr(error) {
    print('Contct verify == $error');
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    Fluttertoast.showToast(
        msg: 'Something went wrong!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: red_color.shade700,
        fontSize: 16.0);
  }

  @override
  void walletResp(WalletModel _walletModel) {
    _walletModelResp = _walletModel;
    if (_walletModelResp?.status == true) {
    } else {
      Fluttertoast.showToast(
          msg: _walletModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: red_color.shade700,
          fontSize: 16.0);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
