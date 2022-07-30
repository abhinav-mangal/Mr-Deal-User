import 'package:flutter/material.dart';

import 'common_widgets/colors_widget.dart';
import 'common_widgets/font_size.dart';
import 'common_widgets/text_widget.dart';

class PayOnline extends StatefulWidget {
  final String? shopname;
  const PayOnline({Key? key, this.shopname}) : super(key: key);

  @override
  State<PayOnline> createState() => _PayOnlineState();
}

class _PayOnlineState extends State<PayOnline> {
  Widget _appbar() {
    return AppBar(
        backgroundColor: theme_color,
        centerTitle: false,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xff0e2c94), Color(0xff4abcf2)]),
          ),
        ),
        title: const TextWidget(
          text: 'Pay Points',
          size: text_size_18,
          color: white_color,
        ));
  }

  Widget _body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          TextWidget(
            text: 'Paying to',
            size: text_size_20,
            weight: FontWeight.w500,
          ),
          SizedBox(
            height: 30,
          ),
          TextWidget(
            text: '${widget.shopname ?? 'Shop Name'}',
            size: text_size_22,
            weight: FontWeight.w500,
          )
        ],
      ),
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
              body: _body(),
            )));
  }
}
