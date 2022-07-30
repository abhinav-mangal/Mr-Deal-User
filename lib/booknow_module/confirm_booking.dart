import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_user/common_widgets/button_widget.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:mr_deal_user/wallet_module/cancel_button.dart';
import 'package:mr_deal_user/wallet_module/wallet_view.dart';

import '../common_widgets/connectivity.dart';
import '../common_widgets/globals.dart';
import '../common_widgets/loader.dart';
import '../common_widgets/no_internet.dart';
import '../wallet_module/wallet_model.dart';
import '../wallet_module/wallet_presenter.dart';

class ConfirmBooking extends StatefulWidget {
  const ConfirmBooking({Key? key}) : super(key: key);

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> implements WalletView {
  WalletModel? _walletModelResp;

  bool _isLoading = true;

  var noConnection;
  Widget _body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: white_color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/success.gif',
            height: 200,
          ),
          const SizedBox(
            height: 25,
          ),
          const TextWidget(
            text: 'Deal Confirmed!',
            size: text_size_25,
            weight: FontWeight.w500,
            alignment: TextAlign.center,
            color: GREY_COLOR_GREY,
          ),
          const SizedBox(
            height: 35,
          ),
          const TextWidget(
            text: 'Your deal has been confirmed with\nMR DEAL APPROVED VENDOR',
            size: text_size_18,
            alignment: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          CancelCustomButton(
            height: 40,
            width: 100,
            bookingId: "${_walletModelResp?.data![0].bookingId}",
            userContact: "${_walletModelResp?.data![0].userContact}",
          ),
          SizedBox(height: 20),
          _loginbtn()
        ],
      ),
    );
  }

  Widget _appbar() {
    return AppBar(
        backgroundColor: theme_color,
        centerTitle: false,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: theme_color),
        ),
        title: const TextWidget(
          text: 'Confirmation',
          size: text_size_18,
          color: white_color,
        ));
  }

  Widget _loginbtn() {
    return SizedBox(
      width: 200,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            Navigator.pushReplacementNamed(context, "/TabbarPage");
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Go To Home',
            color: Colors.white,
            weight: FontWeight.w600,
            size: 18,
          )),
    );
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
            body: WillPopScope(
                onWillPop: _onwillpop,
                child: _isLoading
                    ? const Center(
                        child: SizedBox(height: 500, child: Loader()),
                      )
                    : _body()),
          )),
    );
  }

  Future<bool> _onwillpop() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
    _walletAPiCall();
  }

  @override
  void dispose() {
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
