import 'package:flutter/material.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:mr_deal_user/wallet_module/wallet_model.dart';
import 'package:intl/intl.dart';

import '../qr_scanner.dart';

class WalletPointsAndScanner extends StatefulWidget {
  const WalletPointsAndScanner({Key? key}) : super(key: key);

  @override
  State<WalletPointsAndScanner> createState() => _WalletPointsAndScannerState();
}

String _datetime(timestamp) {
  var dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var d12 = DateFormat('dd-MM-yyyy, hh:mm a').format(dt);

  return d12.toString();
}

class _WalletPointsAndScannerState extends State<WalletPointsAndScanner> {
  var noConnection;
  WalletModel? _walletModelResp;

  Widget _body() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _totalPnts(),
          const Divider(
            endIndent: 20,
            indent: 20,
          ),
          const SizedBox(
            height: 30,
          ),
          const TextWidget(
            text: 'Click the scanner to scan\nMR DEAL code',
            size: text_size_22,
            weight: FontWeight.w500,
            alignment: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const QRViewExample()));
            },
            child: Card(
              elevation: 5,
              child: Icon(
                Icons.qr_code_scanner_rounded,
                size: 150,
                color: theme_color,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
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
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: <Color>[Color(0xff0e2c94), Color(0xff4abcf2)]),
          // ),
          ),
      title: const TextWidget(
        text: 'MR DEAL Scanner',
        size: text_size_18,
        color: white_color,
      ),
    );
  }

  Widget _totalPnts() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const TextWidget(
            text: 'Total points',
            size: text_size_18,
            weight: FontWeight.w500,
            alignment: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: theme_color,
                size: 30,
              ),
              SizedBox(
                width: 5,
              ),
              TextWidget(
                text: '50',
                size: text_size_30,
                weight: FontWeight.bold,
                alignment: TextAlign.center,
                color: theme_color,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const TextWidget(
            text: 'MR DEAL Points',
            size: text_size_16,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
}
