import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:mr_deal_user/paynow_online.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'common_widgets/button_widget.dart';
import 'common_widgets/colors_widget.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Expanded(flex: 2, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(height: 20),
                if (result != null)
                  TextWidget(
                    text: 'Paying to: ${result!.code}',
                    size: text_size_16,
                  )
                // Text(
                //     'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                else
                  const Text(
                    'Scan a code',
                    style: TextStyle(fontSize: 22),
                  ),
                const SizedBox(
                  height: 10,
                ),
                result != null
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: 200,
                        height: 45,
                        child: GradientButtonWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PayOnline(
                                            shopname: result!.code.toString(),
                                          )));
                            },
                            color: theme_color,
                            child: const TextWidget(
                              text: 'PAY NOW',
                              size: text_size_16,
                              color: white_color,
                            )),
                      )
                    : const SizedBox(
                        height: 0,
                      ),

                SizedBox(
                  width: 200,
                  height: 45,
                  child: GradientButtonWidget(
                    onTap: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    color: theme_color,
                    child: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        return Text(
                          'Flash: ${snapshot.data == true ? 'On' : 'Off'}',
                          style: TextStyle(color: white_color),
                        );
                      },
                    ),
                  ),
                )

                // Container(
                //   height: 50,
                //   width: 100,
                //   margin: const EdgeInsets.all(8),
                //   child: ElevatedButton(
                //       onPressed: () async {
                //         await controller?.toggleFlash();
                //         setState(() {});
                //       },
                //       child: FutureBuilder(
                //         future: controller?.getFlashStatus(),
                //         builder: (context, snapshot) {
                //           return Text('Flash: ${snapshot.data}');
                //         },
                //       )),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
