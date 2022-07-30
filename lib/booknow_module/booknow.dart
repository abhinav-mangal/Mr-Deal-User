import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mr_deal_user/booknow_module/booking_confirm/booking_cnf_model.dart';
import 'package:mr_deal_user/booknow_module/booking_model.dart';
import 'package:mr_deal_user/booknow_module/payment_webpage.dart';
import 'package:mr_deal_user/common_widgets/button_widget.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/connectivity.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/globals.dart';
import 'package:mr_deal_user/common_widgets/loader.dart';
import 'package:mr_deal_user/common_widgets/no_internet.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:mr_deal_user/shop_list_module/shop_ls_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../Utls/deal_constant.dart';
import 'booking_confirm/booking_cnf_presenter.dart';
import 'booking_confirm/booking_cnf_view.dart';
import 'booking_presenter.dart';
import 'booking_view.dart';
import 'confirm_booking.dart';

class BookNow extends StatefulWidget {
  final dynamic phnData;
  final Details? shopDeatils;
  const BookNow({Key? key, required this.phnData, required this.shopDeatils})
      : super(key: key);

  @override
  State<BookNow> createState() => _BookNowState();
}

class _BookNowState extends State<BookNow>
    implements BookingView, BookingCNFView {
  bool _daywarenty = true;
  bool _monthwarenty = true;
  dynamic _phoneDetails;
  int _dayAmt = 0;
  int _monthAmt = 0;
  bool _isLoadingWarenty = false;
  bool _isLoadingNonWarenty = false;
  var noConnection;
  bool _isloading = false;
  late Razorpay _razorpay;

  Future? _bookingApiCall(request, typ) {
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        BookingPresenter().getbookingDetails(this, request);
      } else {
        setState(() {
          _isLoadingWarenty = false;
          _isLoadingNonWarenty = false;
        });
        noConnection = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const NoInternet()));
        if (noConnection != null) {
          setState(() {
            if (typ == 'warenty') {
              _isLoadingWarenty = true;
            } else {
              _isLoadingNonWarenty = true;
            }
          });
          return BookingPresenter().getbookingDetails(this, request);
        }
      }
    });
  }

  void _bookingConfirmation(request) {
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        CNFBookingPresenter().getbookingDetails(this, request);
      } else {
        setState(() {
          _isloading = false;
        });
        noConnection = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const NoInternet()));
        if (noConnection != null) {
          setState(() {
            _isloading = true;
          });
          CNFBookingPresenter().getbookingDetails(this, request);
        }
      }
    });
  }

  Widget _warrentySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const TextWidget(
            text: 'MR DEAL Warranty Conditions',
            size: text_size_20,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Checkbox(
                  activeColor: theme_color,
                  value: _daywarenty ? true : false,
                  onChanged: (bool? value) {
                    setState(() {
                      _daywarenty = !_daywarenty;
                      if (_daywarenty) {
                        _dayAmt = _phoneDetails?.warrantyPriceDays ?? 0;
                      } else {
                        _dayAmt = 0;
                      }
                    });
                  },
                ),
              ),
              const TextWidget(
                text: '10 Days replacement warranty',
                color: black_color,
                size: text_size_15,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Checkbox(
                  activeColor: theme_color,
                  value: _monthwarenty ? true : false,
                  onChanged: (bool? value) {
                    setState(() {
                      _monthwarenty = !_monthwarenty;
                      if (_monthwarenty) {
                        _monthAmt = _phoneDetails?.warrantyPriceMonthly ?? 0;
                      } else {
                        _monthAmt = 0;
                      }
                    });
                  },
                ),
              ),
              const TextWidget(
                text: '6 Months functional warranty',
                color: black_color,
                size: text_size_15,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          _isLoadingWarenty
              ? const SizedBox(
                  height: 50,
                  child: Center(
                    child: Loader(),
                  ),
                )
              : InkWell(
                  onTap: () async {
                    if (_daywarenty || _monthwarenty) {
                      var _req = {
                        "user_contact": MrDealGlobals.userContact,
                        "vendor_contact": widget.shopDeatils?.contact ?? '',
                        "model_id": widget.phnData?.modelId ?? '',
                        "booking_status": "Pending",
                        "warranty_days": _daywarenty,
                        "warranty_monthly": _monthwarenty
                      };
                      setState(() {
                        _isLoadingWarenty = true;
                      });
                      _openCheckout();
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please select atleast 1 warrenty',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: shadow_color,
                          textColor: red_color.shade700,
                          fontSize: 16.0);
                    }
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: _daywarenty || _monthwarenty
                            ? theme_color
                            : shadow_color,
                        // gradient: theme_color,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextWidget(
                      text:
                          'PROCEED WITH WARRANTY PAY Rs ${_dayAmt + _monthAmt}',
                      color: _daywarenty || _monthwarenty
                          ? white_color
                          : black_color,
                      size: text_size_14,
                      weight: FontWeight.w600,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        children: [
          _warrentySection(),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: shadow_color,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          _nowarrenty(),
          const SizedBox(
            height: 30,
          ),
          _warning()
        ],
      ),
    );
  }

  Widget _nowarrenty() {
    return _isLoadingNonWarenty
        ? const SizedBox(
            height: 50,
            child: Center(
              child: Loader(),
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 55,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: GradientButtonWidget(
                onTap: () async {
                  if (!_daywarenty && !_monthwarenty) {
                    var _req = {
                      "user_contact": MrDealGlobals.userContact,
                      "vendor_contact": widget.shopDeatils?.contact ?? '',
                      "model_id": widget.phnData?.modelId ?? '',
                      "booking_status": "Pending",
                      "warranty_days": false,
                      "warranty_monthly": false
                    };
                    setState(() {
                      _isLoadingNonWarenty = true;
                    });
                    await _bookingApiCall(_req, 'non_warenty');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConfirmBooking()));
                  }
                },
                color:
                    _daywarenty || _monthwarenty ? shadow_color : theme_color,
                child: TextWidget(
                  text: 'PROCEED WITHOUT WARRANTY',
                  color:
                      _daywarenty || _monthwarenty ? black_color : Colors.white,
                  weight: FontWeight.bold,
                  size: text_size_14,
                )),
          );
  }

  Widget _warning() {
    return Container(
      color: milky_white,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: const TextWidget(
        text:
            'If you proceed without warranty then MR DEAL will not be responsible for any damage.',
        size: text_size_16,
        weight: FontWeight.w400,
        alignment: TextAlign.center,
        color: black_color,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _phoneDetails = widget.phnData;
    _dayAmt = _phoneDetails?.warrantyPriceDays ?? 0;
    _monthAmt = _phoneDetails?.warrantyPriceMonthly ?? 0;
    _razorpay = Razorpay();

    // handlers
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // Future.delayed(const Duration(seconds: 4), () async {
    //   var _req = {
    //     "user_contact": MrDealGlobals.userContact,
    //     "vendor_contact": widget.shopDeatils?.contact ?? '',
    //     "model_id": widget.phnData?.modelId ?? '',
    //     "booking_status": "Pending",
    //     "warranty_days": false,
    //     "warranty_monthly": false
    //   };
    //   setState(() {
    //     _isLoadingNonWarenty = true;
    //   });
    //   _bookingApiCall(_req, 'non_warenty');
    // });
  }

  Future<String> generateOrderId(String key, String secret, int amount) async {
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }';

    var res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');

    return json.decode(res.body)['id'].toString();
  }

  void _openCheckout() {
    var options = {
      'key': 'rzp_live_4LDOZbb0G83pgr',
      'amount': (_dayAmt + _monthAmt) * 100,
      // 'amount': 1 * 100,
      'name': 'MR Deal',
      // 'order_id' : await generateOrderId(
      //   "rzp_live_BIEH0CXdrrcLwN", "d38AX9Ihc7c0tbshkM9opauw", int.parse(_finalAmount.toStringAsFixed(0)) * 100),
      'description': 'MR Deal Warranty',
      'timeout': 300,
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(response.paymentId);
    var _req = {
      "user_contact": MrDealGlobals.userContact,
      "vendor_contact": widget.shopDeatils?.contact ?? '',
      "model_id": widget.phnData?.modelId ?? '',
      "booking_status": "Pending",
      "warranty_days": _daywarenty,
      "warranty_monthly": _monthwarenty,
      "paymentLinkId": response.paymentId
    };
    setState(() {
      _isLoadingWarenty = false;
    });
    await _bookingApiCall(_req, 'warenty');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ConfirmBooking()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isLoadingWarenty = false;
    });
    Fluttertoast.showToast(msg: "Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            appBar: PreferredSize(
                child: _appbar(), preferredSize: const Size.fromHeight(60)),
            body: _isloading
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: Loader(),
                    ),
                  )
                : _body(),
          )),
    );
  }

  @override
  void bookingErr(error) {
    setState(() {
      _isLoadingWarenty = false;
      _isLoadingNonWarenty = false;
    });
    Fluttertoast.showToast(
        msg: error ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: red_color.shade700,
        fontSize: 16.0);
  }

  @override
  Future<void> bookingResp(BookingModel _bookingModel) async {
    // print('Booking resp---> ${_bookingModel.toMap()}');
    setState(() {
      _isLoadingWarenty = false;
      _isLoadingNonWarenty = false;
    });
    if (_bookingModel.status == true &&
        _bookingModel.data?.paymentLink == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ConfirmBooking()));
    } else if (_bookingModel.status == true &&
        _bookingModel.data?.paymentLink != null) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentPage(
                    finalURL: _bookingModel.data?.paymentLink,
                  ))).then((value) async {
        setState(() {
          _isloading = true;
        });
        await checkPaid(_bookingModel);
        _bookingConfirmation(_bookingModel.data?.paymentLinkId);
      });
    }
  }

  Future checkPaid(BookingModel _bookingModel) async {
    var booking = json.encode(_bookingModel.data!.booking);
    final response = await http.post(
      Uri.parse(Constants.BASE_URL + "booking/paid"),
      body: booking,
    );
    print(response.body);
  }

  @override
  void cnfbookingErr(error) {
    setState(() {
      _isloading = false;
    });
    Fluttertoast.showToast(
        msg: error ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: red_color.shade700,
        fontSize: 16.0);
  }

  @override
  void cnfbookingResp(ConfirmationModel _confirmationModel) {
    setState(() {
      _isloading = false;
    });
    if (_confirmationModel.status == true) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ConfirmBooking()));
    } else {
      Fluttertoast.showToast(
          msg: _confirmationModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: red_color.shade700,
          fontSize: 16.0);
    }
  }

  Widget _appbar() {
    return AppBar(
        backgroundColor: theme_color,
        centerTitle: false,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: theme_color),
        ),
        title: const TextWidget(
          text: 'Warranty',
          size: text_size_18,
          color: white_color,
        ));
  }
}
