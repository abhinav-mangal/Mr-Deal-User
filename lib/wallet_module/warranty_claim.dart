import 'package:flutter/material.dart';
import 'package:mr_deal_user/common_widgets/button_widget.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';

class WarrantyClaim extends StatefulWidget {
  final String bookingId;
  WarrantyClaim({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<WarrantyClaim> createState() => _WarrantyClaimState();
}

class _WarrantyClaimState extends State<WarrantyClaim> {
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
          TextWidget(
            text: "Booking ID: ${widget.bookingId}",
            size: text_size_14,
            weight: FontWeight.w500,
            alignment: TextAlign.center,
            color: GREY_COLOR_GREY,
          ),
          const SizedBox(
            height: 35,
          ),
          const TextWidget(
            text: 'Thank you for sharing your booking ID to claim warranty.',
            size: text_size_18,
            alignment: TextAlign.center,
            weight: FontWeight.w500,
          ),
          const SizedBox(height: 50),
          const TextWidget(
            text:
                'Our support team will get in touch with you on registered contact number within 24 hours.',
            size: text_size_18,
            alignment: TextAlign.center,
          ),
          const SizedBox(height: 50),
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
            body: WillPopScope(onWillPop: _onwillpop, child: _body()),
          )),
    );
  }

  Future<bool> _onwillpop() async {
    return false;
  }
}
