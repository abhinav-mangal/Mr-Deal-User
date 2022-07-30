import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mr_deal_user/common_widgets/auth_utls.dart';

import 'common_widgets/colors_widget.dart';
import 'common_widgets/font_size.dart';
import 'common_widgets/globals.dart';
import 'common_widgets/images_path.dart';
import 'common_widgets/text_widget.dart';
import 'home_module/home_pg.dart';
import 'login_module/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget _subtitle() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: const TextWidget(
          text: 'Designed   &   Developed  By',
          size: text_size_13,
          color: GREY_COLOR_GREY_400,
          weight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _title() {
    return Center(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Image.asset(
            AppImages.mrDealLogo,
            height: 500,
          )),
    );
  }

  Widget _brandlogo() {
    return Container(
      color: white_color,
      child: Image.asset(
        AppImages.soradisLogo,
        height: 50,
      ),
    );
  }

  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: theme_color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          _title(),
        ],
      ),
    );
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () async {
      String? contact = await AuthUtils.getStringValue('contact');
      MrDealGlobals.userContact = contact ?? '';
      if (contact != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const TabbarPage(
                      initialIndex: 0,
                    )));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: _body(),
            bottomNavigationBar: Container(
              height: 120,
              color: theme_color,
              child: Column(
                children: [
                  _subtitle(),
                  const SizedBox(
                    height: 15,
                  ),
                  _brandlogo(),
                ],
              ),
            ),
          )),
    );
  }
}
