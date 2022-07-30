import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mr_deal_user/booknow_module/booknow.dart';
import 'package:mr_deal_user/common_widgets/button_widget.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/loader.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:mr_deal_user/shop_list_module/shop_ls_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../map.dart';

class ShopDetails extends StatefulWidget {
  final Details? shopDeatils;
  final dynamic phnData;
  const ShopDetails(
      {Key? key, required this.shopDeatils, required this.phnData})
      : super(key: key);

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  Details? _shopDeatils;

  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height - 90,
      color: white_color,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _image(),
            _ownerDetails(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    return Container(
      height: 350,
      decoration: BoxDecoration(
          color: black_color, borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          imageUrl: _shopDeatils?.shopImage ?? '',
          fit: BoxFit.fill,
          placeholder: (context, url) => const Loader(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _appbar() {
    return AppBar(
        backgroundColor: theme_color,
        centerTitle: false,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: theme_color),
        ),
        title: const TextWidget(
          text: 'Shop Details',
          size: text_size_18,
          color: white_color,
        ));
  }

  Widget _ownerDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          TextWidget(
            text: _shopDeatils?.shopName ?? 'Shop Name',
            size: text_size_20,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 25,
          ),
          const TextWidget(
            text: 'Owner Name',
            size: text_size_16,
            color: black_color,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 5,
          ),
          TextWidget(
            text: _shopDeatils?.ownerName ?? '',
            size: text_size_15,
            color: GREY_COLOR_GREY,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 15,
          ),
          const TextWidget(
            text: 'Contact Number',
            size: text_size_16,
            color: black_color,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 5,
          ),
          TextWidget(
            text: _shopDeatils?.contact ?? '',
            size: text_size_15,
            color: GREY_COLOR_GREY,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 15,
          ),
          const TextWidget(
            text: 'Address',
            size: text_size_16,
            color: black_color,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 5,
          ),
          TextWidget(
            text: _shopDeatils?.address ?? '',
            size: text_size_15,
            color: GREY_COLOR_GREY,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              _callNow(_shopDeatils?.contact ?? ''),
              const SizedBox(
                width: 10,
              ),
              _getDirection()
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          _bookNow()
        ],
      ),
    );
  }

  phonecall(contactno) async {
    var contact = contactno;
    if (Platform.isAndroid) {
      launchUrlString("tel:$contact");
    } else {
      launchUrlString("tel://${contact.toString().replaceAll(" ", "%20")}");
    }
  }

  Widget _bookNow() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            _termsAlert(context);
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Deal Done',
            color: Colors.white,
            weight: FontWeight.w600,
            size: 16,
          )),
    );
  }

  Widget _callNow(_contact) {
    return Expanded(
      child: InkWell(
        onTap: () {
          phonecall(_contact);
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
                color: shadow_color,
                offset: Offset(1.0, 1.0),
                blurRadius: 1.0,
                spreadRadius: 1.0),
          ], color: theme_color, borderRadius: BorderRadius.circular(5)),
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.phone,
                color: white_color,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              TextWidget(
                text: 'Call Now',
                color: Colors.white,
                weight: FontWeight.w600,
                size: text_size_15,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getDirection() {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (_shopDeatils?.lat != null && _shopDeatils?.long != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapPage(
                          lat: _shopDeatils?.lat ?? '',
                          long: _shopDeatils?.long ?? '',
                        )));
          } else {
            print('Location not available');
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
                color: shadow_color,
                offset: Offset(1.0, 1.0),
                blurRadius: 1.0,
                spreadRadius: 1.0),
          ], color: theme_color, borderRadius: BorderRadius.circular(5)),
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.location_on_outlined,
                color: white_color,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              TextWidget(
                text: 'Get Direction',
                color: Colors.white,
                weight: FontWeight.w600,
                size: text_size_15,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _shopDeatils = widget.shopDeatils;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: _appbar(), preferredSize: const Size.fromHeight(60)),
      body: _body(),
    );
  }

  // Future<void> _termsAlert(BuildContext context) async {
  //   showDialog(
  //     barrierDismissible: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(5.0))),
  //         child: Container(
  //             margin: const EdgeInsets.only(
  //                 top: 20, left: 10, right: 10, bottom: 20),
  //             height: 220,
  //             child: Column(
  //               children: [
  //                 const TextWidget(
  //                   text:
  //                       "We recommend our vendors to use high quality screens only.\n\nWe are responsible for further assistance only if you accept warranty policy at the time of booking.",
  //                   size: text_size_16,
  //                   weight: FontWeight.w500,
  //                   alignment: TextAlign.center,
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 Container(
  //                   height: 35,
  //                   padding: const EdgeInsets.symmetric(horizontal: 20),
  //                   decoration: BoxDecoration(
  //                       color: theme_color,
  //                       // gradient: theme_color,
  //                       borderRadius: BorderRadius.circular(5)),
  //                   child: TextButton(
  //                       onPressed: () {
  //                         Navigator.pop(context, true);
  //                         Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => BookNow(
  //                                       phnData: widget.phnData,
  //                                       shopDeatils: widget.shopDeatils,
  //                                     )));
  //                       },
  //                       child: const TextWidget(
  //                         text: "CONTINUE",
  //                         color: white_color,
  //                         size: text_size_14,
  //                         weight: FontWeight.w500,
  //                       )),
  //                 ),
  //               ],
  //             )),
  //       );
  //     },
  //   );
  // }

  Future<void> _termsAlert(BuildContext context) async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
              margin: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 20),
              height: 500,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const TextWidget(
                    text:
                        "Before changing the display by vendor please pay attention to the below points.",
                    size: text_size_14,
                    weight: FontWeight.w400,
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 350,
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: shadow_color)),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.phone_android_rounded,
                                size: 35,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TextWidget(
                                text:
                                    'If there is a facility,\nplease keep your important\ndata as backup.',
                                size: text_size_13,
                                softwrap: true,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: shadow_color)),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.phone_android_rounded,
                                size: 35,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TextWidget(
                                text: 'Keep your mobile\ncharged enough.',
                                size: text_size_13,
                                softwrap: true,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 0.5, color: shadow_color)),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.phone_android_rounded,
                                size: 35,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TextWidget(
                                text:
                                    'If your device is water/\nphysical damage too much,\nthen mobile may get dead\n while processing.',
                                size: text_size_13,
                                softwrap: true,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 0.5, color: shadow_color)),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.phone_android_rounded,
                                size: 35,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TextWidget(
                                text:
                                    "We recommend our vendors\nto use high quality screens\nonly.",
                                size: text_size_13,
                                softwrap: true,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookNow(
                                        phnData: widget.phnData,
                                        shopDeatils: widget.shopDeatils,
                                      )));
                        },
                        child: const TextWidget(
                          text: "CONTINUE",
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
}
