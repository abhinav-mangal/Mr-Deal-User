import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_user/common_widgets/button_widget.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/connectivity.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/loader.dart';
import 'package:mr_deal_user/common_widgets/no_internet.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:mr_deal_user/home_module/home_pg.dart';
import 'package:mr_deal_user/profile_module/register_module/register_model.dart';
import 'package:mr_deal_user/profile_module/register_module/register_presenter.dart';
import 'package:mr_deal_user/profile_module/register_module/register_view.dart';

class RegisterUser extends StatefulWidget {
  final String? contct;
  const RegisterUser({Key? key, required this.contct}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser>
    implements RegisterUserView {
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  var noConnection;
  String? selectedDate;
  bool _isLoading = false;
  String _nmValidatn = '';
  String _dobValidatn = '';
  String _emailValidatn = '';

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

  bool _validdob() {
    if (selectedDate != null) {
      _dobValidatn = '';
      setState(() {});
      return false;
    } else {
      _dobValidatn = 'Please enter your DOB';
      setState(() {});
      return true;
    }
  }

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
                        child: TextWidget(
                          text: 'Cancel',
                          color: theme_color,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: TextWidget(
                          text: 'Done',
                          color: theme_color,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedDate = _selectedDate;
                          });
                          _validdob();
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
                    size: text_size_15,
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
      text: 'Complete your profile',
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
      width: 200,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            _validNm();
            _validdob();

            // _validemail();
            if (!_validNm() && !_validdob()) {
              Map<String, dynamic> _requestBody = {
                "name": _ownerNameController.text,
                "email": _emailController.text.isNotEmpty
                    ? _emailController.text
                    : '',
                "dob":
                    selectedDate != null ? selectedDate?.substring(0, 10) : '',
                "contact": widget.contct ?? ''
              };
              setState(() {
                _isLoading = true;
              });
              Internetconnectivity().isConnected().then((value) async {
                if (value == true) {
                  RegisterPresenter().getLoginDetails(this, _requestBody);
                } else {
                  setState(() {
                    _isLoading = false;
                  });
                  noConnection = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const NoInternet()));
                  if (noConnection != null) {
                    setState(() {
                      _isLoading = true;
                    });
                    RegisterPresenter().getLoginDetails(this, _requestBody);
                  }
                }
              });
            }
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Submit',
            color: Colors.white,
            weight: FontWeight.bold,
            size: 18,
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
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  cursorColor: black_color,
                  cursorWidth: 1.0,
                  style: const TextStyle(
                      color: black_color,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp('[a-zA-Z0-9@._-]')),
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
      margin: const EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 25),
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
            margin: const EdgeInsets.only(left: 30, top: 5, bottom: 5),
            alignment: Alignment.centerLeft,
            child: TextWidget(
              text: _nmValidatn,
              color: red_color.shade700,
              size: text_size_14,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          _emailField(),
          Container(
            margin: const EdgeInsets.only(left: 30, top: 5, bottom: 5),
            alignment: Alignment.centerLeft,
            child: TextWidget(
              text: _emailValidatn,
              color: red_color.shade700,
              size: text_size_14,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          _dobField(),
          Container(
            margin: const EdgeInsets.only(left: 30, top: 5, bottom: 5),
            alignment: Alignment.centerLeft,
            child: TextWidget(
              text: _dobValidatn,
              color: red_color.shade700,
              size: text_size_14,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          _isLoading
              ? const SizedBox(
                  height: 50,
                  child: Center(
                    child: Loader(),
                  ),
                )
              : _registerBtn()
        ],
      ),
    );
  }

  Future<void> _bonosPopup(BuildContext context) async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 10),
              height: 260,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                      height: 150,
                      child: Image.asset(
                        'images/congrts.gif',
                        fit: BoxFit.fill,
                      )),
                  const TextWidget(
                    text: 'Congratulations! You have earned 50 MR DEAL Points',
                    size: text_size_18,
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: theme_color,
                        // gradient: theme_color,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TabbarPage(
                                        initialIndex: 0,
                                      )));
                        },
                        child: const TextWidget(
                          text: "Ok",
                          color: white_color,
                          size: text_size_14,
                          weight: FontWeight.bold,
                        )),
                  ),
                ],
              )),
        );
      },
    );
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
  void registerErr(error) {
    print('Register failed err -- $error');
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
  void registerResponse(RegisterUserModel _registerUserResp) {
    print('register resp == ${_registerUserResp.toMap()}');
    setState(() {
      _isLoading = false;
    });
    if (_registerUserResp.status == true) {
      _bonosPopup(context);
    }
    Fluttertoast.showToast(
        msg: _registerUserResp.message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: black_color,
        fontSize: 16.0);
  }
}
