import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_user/Utls/deal_constant.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:http/http.dart' as http;

class CancelCustomButton extends StatefulWidget {
  final Duration animationDuration;
  final double height;
  final double width;
  final double borderRadius;
  final String bookingId;
  final String userContact;

  const CancelCustomButton({
    this.animationDuration = const Duration(minutes: 1),
    this.height = 30,
    this.width = 55,
    this.borderRadius = 10.0,
    required this.bookingId,
    required this.userContact,
  });

  @override
  _CancelCustomButtonState createState() => _CancelCustomButtonState();
}

class _CancelCustomButtonState extends State<CancelCustomButton> {
  double _animatedWidth = 0.0;

  bool enable = true;

  bool show = true;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      setState(() {
        _animatedWidth = widget.width;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return show == false
        ? Container()
        : Stack(
            children: [
              Container(
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius,
                  ),
                  color: Colors.red,
                ),
              ),
              AnimatedContainer(
                duration: widget.animationDuration,
                height: widget.height,
                width: _animatedWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius,
                  ),
                  color: Colors.grey,
                ),
                onEnd: () => setState(() => enable = false),
              ),
              InkWell(
                child: Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius,
                    ),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                onTap: enable == false
                    ? null
                    : () {
                        warring();
                      },
              ),
            ],
          );
  }

  void warring() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Do you want to cancel this order?",
                style: TextStyle(
                    color: theme_color,
                    fontSize: text_size_16,
                    fontWeight: FontWeight.bold)),
            actions: [
              ElevatedButton(
                onPressed: () {
                  cancel();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(theme_color)),
                child: Text("Yes"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(theme_color)),
                child: Text("No"),
              )
            ],
          );
        });
  }

  Future cancel() async {
    final response = await http
        .post(Uri.parse(Constants.BASE_URL + "cancel-booking"), body: {
      "booking_id": widget.bookingId,
      "user_contact": widget.userContact
    });
    if (response.statusCode == 200) {
      var message = json.decode(response.body);
      Navigator.pop(context);
      Fluttertoast.showToast(msg: message["message"]);
      setState(() {
        show = false;
      });
    }
  }
}
