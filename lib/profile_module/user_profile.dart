import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_user/Utls/deal_constant.dart';
import 'package:mr_deal_user/common_widgets/button_widget.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/connectivity.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/globals.dart';
import 'package:mr_deal_user/common_widgets/loader.dart';
import 'package:mr_deal_user/common_widgets/no_internet.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:mr_deal_user/profile_module/delete_acc/delete_acc_model.dart';
import 'package:mr_deal_user/profile_module/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../terms_condition.dart';
import 'delete_acc/delete_acc_presenter.dart';
import 'delete_acc/delete_acc_view.dart';
import 'edit_profile_module/edit_profile.dart';

class VenderProfile extends StatefulWidget {
  final ProfileModel? profileModelResp;
  const VenderProfile({Key? key, required this.profileModelResp})
      : super(key: key);

  @override
  State<VenderProfile> createState() => _VenderProfileState();
}

class _VenderProfileState extends State<VenderProfile>
    implements DeleteUserView {
  ProfileModel? profileDeatils;
  bool _isLoading = false;
  var noConnection;

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 100,
        color: white_color,
        width: MediaQuery.of(context).size.width,
        child: _ownerDetails(),
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
        text: 'Profile Informations',
        size: text_size_18,
        color: white_color,
      ),
      actions: [
        Row(
          children: [
            TextWidget(
              text: 'Logout',
              size: text_size_15,
              color: white_color,
            ),
            IconButton(
              icon: const Icon(Icons.logout_outlined),
              tooltip: 'Logout',
              onPressed: () {
                _onexit();

                // handle the press
              },
            ),
          ],
        ),
      ],
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
                    text: 'want to Logout?',
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
                              weight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          MrDealGlobals.userContact = '';
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.clear();
                          setState(() {});
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/LoginPage", (r) => false);
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
                              weight: FontWeight.bold),
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

  Future<bool> _ondeleteAcc() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 150,
            child: Column(
              children: <Widget>[
                TextWidget(
                  text: 'Are you sure you want to',
                  size: 16,
                  weight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                SizedBox(
                  child: TextWidget(
                    text: 'Delete your Account',
                    size: 16,
                    weight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  child: TextWidget(
                    text: 'permanently?',
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
                              weight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _isLoading = true;
                          });
                          _deleteAccApiCall();
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
                              weight: FontWeight.bold),
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

  Widget _ownerDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 35,
          ),
          const TextWidget(
            text: 'User Name',
            size: text_size_18,
            color: black_color,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 5,
          ),
          TextWidget(
            text: profileDeatils?.data?.name ?? '',
            size: text_size_16,
            color: GREY_COLOR_GREY,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 20,
          ),
          const TextWidget(
            text: 'Contact Number',
            size: text_size_18,
            color: black_color,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 5,
          ),
          TextWidget(
            text: profileDeatils?.data?.contact ?? '',
            size: text_size_16,
            color: GREY_COLOR_GREY,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 20,
          ),
          const TextWidget(
            text: 'Date Of Birth',
            size: text_size_18,
            color: black_color,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 5,
          ),
          TextWidget(
            text: profileDeatils?.data?.dob ?? '',
            size: text_size_16,
            color: GREY_COLOR_GREY,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 50,
          ),
          Center(child: _editProfileBtn()),
          const SizedBox(
            height: 30,
          ),
          Center(child: _deleteAccBtn()),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const TermsAndCondition(
                            checkURL: Constants.PRIVACY_POLICY,
                            route: 'policy',
                          )));
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white_color,
                  border: Border.all(width: 0.5, color: shadow_color),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  TextWidget(
                    text: 'Privacy and Policy',
                    color: theme_color,
                    size: text_size_18,
                  ),
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: theme_color,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _editProfileBtn() {
    return SizedBox(
      width: 200,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfile(
                          profileModelResp: widget.profileModelResp,
                        )));
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Edit Profile',
            color: Colors.white,
            weight: FontWeight.w600,
            size: text_size_16,
          )),
    );
  }

  Widget _deleteAccBtn() {
    return SizedBox(
      width: 150,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            _ondeleteAcc();
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Delete Account',
            color: Colors.white,
            weight: FontWeight.w600,
            size: text_size_16,
          )),
    );
  }

  void _deleteAccApiCall() {
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        DeleteAccPresenter().getLoginDetails(this);
      } else {
        setState(() {
          _isLoading = false;
        });
        noConnection = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const NoInternet()));
        if (noConnection != null) {
          setState(() {
            _isLoading = true;
          });
          DeleteAccPresenter().getLoginDetails(this);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.profileModelResp != null) {
      profileDeatils = widget.profileModelResp;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(
            child: _appbar(), preferredSize: const Size.fromHeight(60)),
        body: _isLoading
            ? Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: const Loader(),
              )
            : _body(),
      ),
    );
  }

  @override
  void deleteAccErr(error) {
    setState(() {
      _isLoading = false;
    });
    print('DELETE ACC -->  $error');
    Fluttertoast.showToast(
        msg: error ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: black_color,
        fontSize: 16.0);
  }

  @override
  Future<void> deleteAccResp(DeleteUserModel _deleteUserModel) async {
    print('delete Acc resp -- ${_deleteUserModel.toMap()}');
    if (_deleteUserModel.status == true) {
      Fluttertoast.showToast(
          msg: 'Your account is deleted successfully.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: black_color,
          fontSize: 16.0);
      MrDealGlobals.userContact = '';
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      _isLoading = false;
      setState(() {});
      Navigator.pushNamedAndRemoveUntil(context, "/LoginPage", (r) => false);
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: _deleteUserModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: black_color,
          fontSize: 16.0);
    }
  }
}
