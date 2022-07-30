/*Author:Animesh Banerjee
Description:homepage Tabbar Page for bottom navigation*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/connectivity.dart';
import 'package:mr_deal_user/common_widgets/globals.dart';
import 'package:mr_deal_user/common_widgets/no_internet.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:mr_deal_user/home_module/user_device_module/user_homepage.dart';
import 'package:mr_deal_user/profile_module/profile_model.dart';
import 'package:mr_deal_user/profile_module/profile_presenter.dart';
import 'package:mr_deal_user/profile_module/profile_view.dart';
import 'package:mr_deal_user/profile_module/user_profile.dart';
import 'package:mr_deal_user/wallet_module/wallet.dart';
import 'package:mr_deal_user/wallet_module/wallet_points.dart';

import 'package:url_launcher/url_launcher.dart';

import '../qr_scanner.dart';

class TabbarPage extends StatefulWidget {
  const TabbarPage({
    Key? key,
    required this.initialIndex,
  }) : super(key: key);

  final initialIndex;

  @override
  _TabbarPageState createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage>
    with SingleTickerProviderStateMixin
    implements ProfileView {
  ProfileModel? _profileModelResp;
  TabController? _tabController;
  int? _tabindex = 0;
  GlobalKey<ScaffoldState> _tabscaffoldKey = new GlobalKey<ScaffoldState>();
  var _tabval;
  var showappbar = true;
  final Location location = Location();
  var noConnection;
  int deniedTap = 0;
  int _unReadNoticount = 0;
  bool _showAppBar = true;
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();
  GlobalKey keyButton6 = GlobalKey();

  @override
  void initState() {
    super.initState();
    print('@@@@@@@@@@@@@@@@@@');
    _checkLocation().then((result) {
      print('result----->> $result');
      if (result != null) {
        setState(() {
          MrDealGlobals.lat = result.latitude;
          MrDealGlobals.long = result.longitude;
          print('#############');
          print(MrDealGlobals.lat);
          print(MrDealGlobals.long);
        });
      } else {
        print('else----->');
        print(MrDealGlobals.lat);
        print(MrDealGlobals.long);
      }
    });
    _prodileApiCall();

    _tabController = TabController(
        initialIndex: widget.initialIndex, length: 4, vsync: this);
  }

  void _prodileApiCall() {
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        ProfilePresenter().getprofileDetails(this, MrDealGlobals.userContact);
      } else {
        noConnection = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const NoInternet()));
        if (noConnection != null) {
          ProfilePresenter().getprofileDetails(this, MrDealGlobals.userContact);
        }
      }
    });
  }

  _checkLocation() async {
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      print('denied');
      if (MrDealGlobals.locationPermision == false) {
        _permissionGranted = await location.requestPermission();
      }

      setState(() {
        MrDealGlobals.locationPermision = true;
      });
    } else {
      print('accepted');
      setState(() {
        MrDealGlobals.locationPermision = true;
      });
      print(location.getLocation());
      return await location.getLocation();
    }
  }

  void _launchURL(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }

/*Bottom TabBar */
  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 12,
              color: Color.fromRGBO(0, 0, 0, 0.16),
            )
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          // border: Border(
          //   top: BorderSide(color: shadow_color, width: 0.5),
          // ),
          color: white_color),
      height: 65,
      child: TabBar(
        isScrollable: false,
        controller: _tabController,
        indicatorColor: transparent,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(
            key: keyButton2,
            child: FittedBox(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Icon(
                  Icons.home,
                  color: _tabindex == 0 ? theme_color : shadow_color,
                  size: 35,
                ),
              ),
            ),
          ),
          Tab(
            key: keyButton3,
            child: FittedBox(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Icon(
                  Icons.qr_code_scanner,
                  color: _tabindex == 1 ? theme_color : shadow_color,
                  size: 35,
                ),
              ),
            ),
          ),
          Tab(
            key: keyButton4,
            child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Image.asset(
                  'images/trxn.png',
                  height: 35,
                  color: _tabindex == 2 ? theme_color : shadow_color,
                )

                // Icon(
                //   Icons.transac,
                //   size: 35,
                //   color: _tabindex == 2 ? theme_color : shadow_color,
                // ),
                ),
          ),
          Tab(
            key: keyButton5,
            child: FittedBox(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Icon(
                  Icons.person,
                  color: _tabindex == 3 ? theme_color : shadow_color,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
        onTap: (tabIndex) {
          switch (tabIndex) {
            case 0:
              setState(() {
                _tabindex = 0;
              });

              break;
            case 1:
              setState(() {
                _tabindex = 1;
              });

              break;
            case 2:
              setState(() {
                _tabindex = 2;
              });

              break;
            case 3:
              setState(() {
                _tabindex = 3;
              });

              break;

            default:
              _tabindex = 2;
              _tabval = "Home";
          }
        },
      ),
    );
  }

  Widget _body() {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          const UserHomePage(),
          const WalletPointsAndScanner(),
          // const QRViewExample(),
          const WalletPage(),
          VenderProfile(profileModelResp: _profileModelResp)
        ]);
  }

/*BottomSheet for inStore */
  Widget bottomSheet() {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: white_color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 4, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextWidget(
                  text: 'Are you sure you want to exit ',
                  size: 17,
                ),
                TextWidget(
                  text: ' ?',
                  size: 17,
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border.fromBorderSide(
                  BorderSide(color: shadow_color, width: 0.5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  TextWidget(
                    text: 'Yes',
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.grey.shade300, width: 0.5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  TextWidget(
                    text: 'No',
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onexit() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 140,
            child: Column(
              children: <Widget>[
                TextWidget(
                  text: 'Are you sure you',
                  size: 16,
                  weight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: TextWidget(
                    text: 'want to exit?',
                    size: 16,
                    weight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  offset: const Offset(0.0, 1.0),
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0)
                            ],
                            color: theme_color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const TextWidget(
                              text: 'No',
                              size: 14,
                              color: Colors.white,
                              weight: FontWeight.w600),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  offset: const Offset(0.0, 1.0),
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0)
                            ],
                            color: theme_color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const TextWidget(
                              text: 'Yes',
                              size: 14,
                              color: Colors.white,
                              weight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: theme_color,
      ),
      child: SafeArea(
          top: true,
          bottom: true,
          child: Scaffold(
            key: _tabscaffoldKey,
            extendBody: true,
            bottomNavigationBar: _bottomBar(),
            body: WillPopScope(onWillPop: _onexit, child: _body()),
          )),
    );
  }

  @override
  void ProfileErr(error) {
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
  void profileResp(ProfileModel _profileModel) {
    if (_profileModel.status == true) {
      print('###########3222222');
      print('profile----->> ${_profileModel.toMap()}');
      setState(() {
        _profileModelResp = _profileModel;
      });
    } else {
      Fluttertoast.showToast(
          msg: _profileModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: red_color.shade700,
          fontSize: 16.0);
    }
  }
}
