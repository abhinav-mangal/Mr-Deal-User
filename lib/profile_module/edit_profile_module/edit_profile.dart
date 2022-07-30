import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_user/common_widgets/button_widget.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/connectivity.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/globals.dart';
import 'package:mr_deal_user/common_widgets/loader.dart';
import 'package:mr_deal_user/common_widgets/no_internet.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:mr_deal_user/home_module/home_pg.dart';
import 'package:mr_deal_user/profile_module/edit_profile_module/edit_model.dart';
import 'package:mr_deal_user/profile_module/register_module/register_model.dart';
import 'package:mr_deal_user/profile_module/register_module/register_presenter.dart';
import 'package:mr_deal_user/profile_module/register_module/register_view.dart';

import '../profile_model.dart';
import 'edit_presenter.dart';
import 'edit_view.dart';

class EditProfile extends StatefulWidget {
  final ProfileModel? profileModelResp;
  const EditProfile({Key? key, required this.profileModelResp})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> implements EditProfileView {
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();

  String? selectedDate;
  bool _isLoading = false;
  var noConnection;
  String _emailValidatn = '';
  String _nmValidatn = '';

  bool _validemail() {
    if (_emailController.text.isNotEmpty) {
      RegExp regx = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      if (regx.hasMatch(_emailController.text)) {
        _emailValidatn = '';
        setState(() {});
        return false;
      } else {
        _emailValidatn = 'Please enter valid email ID';
        setState(() {});
        return true;
      }
    } else {
      _emailValidatn = 'Please enter your email ID';
      setState(() {});
      return true;
    }
  }

  bool _validNm() {
    if (_ownerNameController.text.isNotEmpty) {
      _nmValidatn = '';
      setState(() {});
      return false;
    } else {
      _nmValidatn = 'Please enter your name';
      setState(() {});
      return true;
    }
  }

  void showDatePicker() {
    String? _selectedDate;
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: white_color,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: TextWidget(text: 'Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: TextWidget(text: 'Done'),
                        onPressed: () {
                          setState(() {
                            selectedDate = _selectedDate;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (value) {
                      if (value != null && value != _selectedDate) {
                        setState(() {
                          _selectedDate = value.toString();
                        });
                      }
                    },
                    initialDateTime: DateTime.now(),
                    minimumYear: 1900,
                    maximumYear: DateTime.now().year,
                    maximumDate: DateTime.now(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _dobField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 8,
          ),
          const Icon(
            Icons.date_range_outlined,
            color: GREY_COLOR_GREY,
            size: 25,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                showDatePicker();
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: transparent,
                  width: MediaQuery.of(context).size.width - 180,
                  child: TextWidget(
                    text: selectedDate == null
                        ? 'Select date of birth'
                        : "${selectedDate?.substring(0, 10)}",
                    size: text_size_14,
                    color: selectedDate == null ? GREY_COLOR_GREY : black_color,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return const TextWidget(
      text: 'Edit your profile',
      size: text_size_20,
      weight: FontWeight.w500,
    );
  }

  Widget _ownerNameField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 8,
          ),
          const Icon(
            Icons.person_outline,
            color: GREY_COLOR_GREY,
            size: 25,
          ),
          Expanded(
            child: Container(
              color: transparent,
              width: MediaQuery.of(context).size.width - 180,
              child: TextFormField(
                  controller: _ownerNameController,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  cursorColor: black_color,
                  cursorWidth: 1.0,
                  style: const TextStyle(
                      color: black_color,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                  ],
                  onChanged: (value) {
                    _validNm();
                  },
                  decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      hintText: "Enter your name",
                      hintStyle: TextStyle(
                          color: GREY_COLOR_GREY_400,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      border: InputBorder.none)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerBtn() {
    return SizedBox(
      width: 150,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            // _validemail();
            _validNm();

            if (!_validNm()) {
              var _req = {
                "contact": MrDealGlobals.userContact,
                "name": _ownerNameController.text.isNotEmpty
                    ? _ownerNameController.text
                    : '',
                "email": _emailController.text.isNotEmpty
                    ? _emailController.text
                    : '',
                "dob":
                    selectedDate != null ? selectedDate?.substring(0, 10) : '',
              };
              setState(() {
                _isLoading = true;
              });
              _updateProfile(_req);
            }
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Update',
            color: Colors.white,
            weight: FontWeight.w600,
            size: 16,
          )),
    );
  }

  Widget _emailField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 8,
          ),
          const Icon(
            Icons.email_outlined,
            color: GREY_COLOR_GREY,
            size: 25,
          ),
          Expanded(
            child: Container(
              color: transparent,
              width: MediaQuery.of(context).size.width - 180,
              child: TextFormField(
                  controller: _emailController,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  cursorColor: black_color,
                  cursorWidth: 1.0,
                  style: const TextStyle(
                      color: black_color,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  inputFormatters: [
                    FilteringTextInputFormatter((RegExp('[\\ ]')),
                        allow: false),
                  ],
                  onChanged: (value) {
                    if (_emailController.text.isNotEmpty) {
                      _validemail();
                    } else {
                      _emailValidatn = '';
                      setState(() {});
                    }
                  },
                  decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      hintText: "Enter Email (optional)",
                      hintStyle: TextStyle(
                          color: GREY_COLOR_GREY_400,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      border: InputBorder.none)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: white_color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
          ),
          _title(),
          const SizedBox(
            height: 50,
          ),
          _ownerNameField(),
          Container(
            margin: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
            alignment: Alignment.centerLeft,
            child: TextWidget(
              text: _nmValidatn,
              color: red_color.shade700,
              size: text_size_14,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          _emailField(),
          Container(
            margin: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
            alignment: Alignment.centerLeft,
            child: TextWidget(
              text: _emailValidatn,
              color: red_color.shade700,
              size: text_size_14,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          _dobField(),
          const SizedBox(
            height: 60,
          ),
          _isLoading
              ? const SizedBox(
                  height: 50,
                  child: Loader(),
                )
              : _registerBtn()
        ],
      ),
    );
  }

  void _updateProfile(_requestBody) {
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        EditProfilePresenter().getLoginDetails(this, _requestBody);
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
          EditProfilePresenter().getLoginDetails(this, _requestBody);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.profileModelResp != null) {
      _ownerNameController.text = widget.profileModelResp?.data?.name ?? '';
      _emailController.text = widget.profileModelResp?.data?.email ?? '';
      selectedDate = widget.profileModelResp?.data?.dob ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(child: _body()),
          )),
    );
  }

  @override
  void editProdileErr(error) {
    setState(() {
      _isLoading = false;
    });
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
  void editprofileResp(EditProfileModel _editProfileModel) {
    setState(() {
      _isLoading = false;
    });
    if (_editProfileModel.status == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TabbarPage(
                    initialIndex: 0,
                  )));
    }
    Fluttertoast.showToast(
        msg: _editProfileModel.message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: black_color,
        fontSize: 16.0);
  }
}
