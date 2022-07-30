import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mr_deal_user/splash_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'common_widgets/globals.dart';
import 'home_module/home_pg.dart';
import 'login_module/login.dart';

Future<void> main() async {
  runZoned<Future<dynamic>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    runApp(const MyApp());
  }, onError: (error, stackTrace) async {
    print(error);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);

        MrDealGlobals.deviceBrand = deviceData['brand'];
        MrDealGlobals.deviceModel = deviceData['model'];
        MrDealGlobals.deviceProduct = deviceData['product'];
        MrDealGlobals.device = 'android';
        print('Device data ---->> $deviceData');
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        MrDealGlobals.deviceBrand = deviceData['localizedModel'];
        MrDealGlobals.deviceModel = deviceData['name'];
        MrDealGlobals.deviceProduct = deviceData['model'];
        MrDealGlobals.device = 'ios';
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'board': build.androidId,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MR DEAL',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/SplashScreen': (BuildContext context) => const SplashScreen(),
          '/LoginPage': (BuildContext context) => const LoginPage(),
          // '/RegisterPage': (BuildContext context) => const RegisterPage(),
          '/TabbarPage': (BuildContext context) => const TabbarPage(
                initialIndex: 0,
              ),
        });
  }
}
