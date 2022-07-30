import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/loader.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final finalURL;

  PaymentPage({
    Key? key,
    required this.finalURL,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => new _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // final flutterWebviewPlugin = new FlutterWebviewPlugin();

  bool isloading = true;
  String? url;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    print(widget.finalURL);
    if (this.widget.finalURL != "") {
      url = widget.finalURL;
    }

    // flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
    //   if (state.type.toString() == "WebViewState.finishLoad") {
    //     setState(() {
    //       isloading = false;
    //     });
    //   }
    // });

    // flutterWebviewPlugin.onUrlChanged.listen((String url) {
    //   print("urlllllllllllllllllllllllllllllllllllllllllllllllll");
    //   print(url);
    //   if (url.contains(BounzConstants.PAYMENT_URL)) {
    //     print("Payment Successful");
    //     Navigator.pop(context);
    //     if (widget.flowTyp == "GIFTCARD") {
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => ConfirmationPage(
    //                 tranxId: this.widget.brf_no,
    //                 bgimg: this.widget.giftbgimg ?? ''),
    //           ));
    //     } else if (widget.flowTyp == "FLIGHT") {
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => FlightBookingConfirmationPage(
    //                     brfNo: widget.brf_no,
    //                   )));
    //     } else {
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) =>
    //                 HotelConfirmation(brf_no: this.widget.brf_no),
    //           ));
    //     }
    //   } else if (url.contains("www.intermiles.com/flights")) {
    //     print("Payment Failed");
    //     Navigator.pop(context, true);
    //   } else if (url.contains("52.3.97.131:6001/login")) {
    //     print("Hotel Payment Failed");
    //     Navigator.pop(context, true);
    //   }
    // });
  }

  // PreferredSizeWidget _appbar() {
  //   return PreferredSize(
  //     preferredSize: Size.fromHeight(55),
  //     child: GradientAppBar(
  //       title: "Pay by card",
  //       color: white_text_color,
  //       size: large_text_size_17,
  //       weight: FontWeight.w600,
  //       centerTitle: true,
  //       height: 90,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text('Demo'),
    );

    Widget _appbar() {
      return AppBar(
          backgroundColor: theme_color,
          centerTitle: false,
          automaticallyImplyLeading: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: theme_color),
          ),
          title: const TextWidget(
            text: 'Book Now',
            size: text_size_18,
            color: white_color,
          ));
    }

    return Container(
      // decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
            appBar: PreferredSize(
                child: _appbar(), preferredSize: const Size.fromHeight(60)),
            extendBody: true,
            body: Container(
              child: Column(
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 15, vertical: 10),
                  //   child: TextWidget(
                  //     text:
                  //         "Please do not click back or close the app on this page as existing booking is in progress.",
                  //     size: 15,
                  //     color: theme_color,
                  //     alignment: TextAlign.center,
                  //   ),
                  // ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                            color: Colors.grey,
                            // height: isloading == true
                            //     ? 0
                            //     : MediaQuery.of(context).size.height - 34,
                            child: WebView(
                              initialUrl: url,
                              javascriptMode: JavascriptMode.unrestricted,
                              gestureNavigationEnabled: true,
                              navigationDelegate: (NavigationRequest request) {
                                print(
                                    "urlllllllllllllllllllllllllllllllllllllllllllllllll");
                                print(request.url);
                                // if (request.url
                                //     .contains(BounzConstants.PAYMENT_URL)) {
                                //   print("Payment Successful");
                                //   Navigator.pop(context);
                                //   if (widget.flowTyp == "GIFTCARD") {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (context) =>
                                //               ConfirmationPage(
                                //                   tranxId: this.widget.brf_no,
                                //                   bgimg:
                                //                       this.widget.giftbgimg ??
                                //                           ''),
                                //         ));
                                //   }
                                // } else if (request.url
                                //     .contains("www.intermiles.com/flights")) {
                                //   print("Payment Failed");
                                //   Navigator.pop(context, true);
                                // } else if (request.url
                                //     .contains("52.3.97.131:6001/login")) {
                                //   print("Hotel Payment Failed");
                                //   Navigator.pop(context, true);
                                // }
                                return NavigationDecision.navigate;
                              },
                              onPageStarted: (finish) {
                                setState(() {
                                  print("finish load website-------->");
                                  isloading = false;
                                });
                              },
                            )),
                        isloading == true
                            ? Container(
                                child: Center(
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Loader(),
                                  ),
                                ),
                                // height: MediaQuery.of(context).size.height -
                                //     (appBar.preferredSize.height +
                                //         MediaQuery.of(context).padding.top),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                      ],
                    ),
                  ),
                  // isloading == true
                  //     ? Container(
                  //         child: Center(
                  //           child: Container(
                  //             height: 50,
                  //             width: 50,
                  //             child: Loader(),
                  //           ),
                  //         ),
                  //         height: MediaQuery.of(context).size.height -
                  //             (appBar.preferredSize.height +
                  //                 MediaQuery.of(context).padding.top),
                  //       )
                  //     : SizedBox(
                  //         height: 0,
                  //       ),
                  // Container(
                  //   color: Colors.grey,
                  //   height: isloading == true
                  //       ? 0
                  //       : MediaQuery.of(context).size.height - 34,
                  //   child: WebviewScaffold(
                  //     url: url ?? '',
                  //     withZoom: true,
                  //     withLocalStorage: true,
                  //     hidden: true,
                  //   ),
                  // )
                ],
              ),
            )),
      ),
    );
  }
}
