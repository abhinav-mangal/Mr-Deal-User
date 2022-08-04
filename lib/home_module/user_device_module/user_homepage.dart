import 'package:flutter/material.dart';
import 'package:mr_deal_user/common_widgets/button_widget.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/connectivity.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/globals.dart';
import 'package:mr_deal_user/common_widgets/images_path.dart';
import 'package:mr_deal_user/common_widgets/loader.dart';
import 'package:mr_deal_user/common_widgets/no_internet.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:mr_deal_user/home_module/home_model.dart';
import 'package:mr_deal_user/home_module/specific_data/specific_model_model.dart';
import 'package:mr_deal_user/home_module/specific_data/specific_model_presenter.dart';
import 'package:mr_deal_user/home_module/specific_data/specific_model_view.dart';
import 'package:mr_deal_user/shop_list_module/shop_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home_presenter.dart';
import '../home_view.dart';
import '../image_caurosel.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> implements HomepageView {
  var noConnection;
  bool _isLoading = true;
  HomepageModel? _homepageresp;
  bool _brandList = false;
  bool _seriesList = false;
  bool _modelList = false;
  String _brandNm = '';
  String _seriesNm = '';
  String _modelNm = '';
  SeriesModel? _selectedPhoneData;
  bool _proceed = false;
  List<Series>? _seriesDataList;
  List<SeriesModel>? _modelDataList;
  final bool _repairLoader = false;

  Widget _appbar() {
    return AppBar(
      backgroundColor: theme_color,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: <Color>[Color(0xff0e2c94), Color(0xff4abcf2)])

            color: theme_color),
      ),
      title: const TextWidget(
        text: 'What are you looking for?',
        size: text_size_18,
        color: white_color,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          AppImages.mrDealLogo,
        ),
      ),
    );
  }

  Widget _deviceInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Card(
        elevation: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget(
                    text: 'Your Device',
                    size: text_size_20,
                    weight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    color: transparent,
                    width: 200,
                    child: TextWidget(
                      text:
                          'Model : ${MrDealGlobals.deviceBrand} ${MrDealGlobals.deviceModel}',
                      size: text_size_16,
                      weight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // _repairLoader
                  //     ? Container(
                  //         height: 50,
                  //         child: Loader(),
                  //       )
                  //     : InkWell(
                  //         onTap: () {
                  //           var _requestbody = {
                  //             "brand": MrDealGlobals.deviceBrand,
                  //             "series": MrDealGlobals.deviceProduct,
                  //             "model": MrDealGlobals.deviceModel
                  //           };
                  //           setState(() {
                  //             _repairLoader = true;
                  //           });
                  //           SpecificModelPresenter()
                  //               .getspecificModelData(this, _requestbody);
                  //         },
                  //         child: Container(
                  //           padding: const EdgeInsets.symmetric(vertical: 5),
                  //           width: 120,
                  //           decoration: BoxDecoration(
                  //               color: theme_color,
                  //               borderRadius: BorderRadius.circular(30)),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Container(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 15),
                  //                 child: const TextWidget(
                  //                   text: 'Repair',
                  //                   size: text_size_16,
                  //                   color: white_color,
                  //                 ),
                  //               ),
                  //               const Icon(
                  //                 Icons.arrow_forward_ios,
                  //                 color: white_color,
                  //                 size: 20,
                  //               ),
                  //               const SizedBox(
                  //                 width: 5,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       )
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: GREY_COLOR_GREY.shade200,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  MrDealGlobals.device == 'android'
                      ? 'images/phone.png'
                      : 'images/iphone.png',
                  height: 70,
                )

                // const Icon(
                //   Icons.phone_iphone_sharp,
                //   size: 80,
                // ),
                )
          ],
        ),
      ),
    );
  }

  Widget _nearDevice() {
    return SizedBox(
      width: 250,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            setState(() {
              _proceed = true;
            });
            if (_selectedPhoneData != null) {
              _reparingAlert(context, _selectedPhoneData);
            }
          },
          color: _selectedPhoneData != null ? theme_color : shadow_color,
          child: const TextWidget(
            text: 'Get Nearby Shop',
            color: Colors.white,
            weight: FontWeight.w600,
            size: 16,
          )),
    );
  }

  Future<void> _customerCarePopup(BuildContext context) async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 20, right: 10, bottom: 10),
              height: 260,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                      height: 140,
                      child: Image.asset(
                        'images/customer_care.gif',
                        fit: BoxFit.fill,
                      )),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Warranty Number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   child: const TextWidget(
                  //     text: 'Email us :\nsupport@mrdealgroup.com',
                  //     size: text_size_16,
                  //     weight: FontWeight.w500,
                  //     color: Color(0xff777777),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   height: 35,
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   decoration: BoxDecoration(
                  //       color: theme_color,
                  //       // gradient: theme_color,
                  //       borderRadius: BorderRadius.circular(5)),
                  //   child: TextButton(
                  //       onPressed: () {
                  //         Navigator.pop(context, true);
                  //       },
                  //       child: const TextWidget(
                  //         text: "Ok",
                  //         color: white_color,
                  //         size: text_size_14,
                  //         weight: FontWeight.bold,
                  //       )),
                  // ),
                ],
              )),
        );
      },
    );
  }

  Widget _customerCare() {
    return SizedBox(
      width: 250,
      height: 50,
      child: GradientButtonWidget(
          onTap: () {
            _customerCarePopup(context);
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Customer Care',
            color: Colors.white,
            weight: FontWeight.w500,
            size: 18,
          )),
    );
  }

  Widget _claimWarranty() {
    return SizedBox(
      width: 250,
      height: 50,
      child: GradientButtonWidget(
          onTap: () {
            _customerCarePopup(context);
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Claim Warranty',
            color: Colors.white,
            weight: FontWeight.w500,
            size: 18,
          )),
    );
  }

  launchCaller() async {
    const url = "tel:02267700008";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  // launchUrl(emailLaunchUri);

  Widget _aboutUs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          const TextWidget(
            text: 'About Us:',
            size: text_size_20,
            weight: FontWeight.w500,
            alignment: TextAlign.start,
          ),
          const SizedBox(
            height: 10,
          ),
          const TextWidget(
            text:
                "MR DEAL is on the verge of a breakthrough to create an ecosystem that enables our selected Vendors to repair the mobile phones of our Customers at the click of a button through our website as well as a web application. When it comes to smartphone repairs, we're a one-stop shop that does it all.\n\nWe are a pioneer in the process of fast repairs of mobile phones and hence we will provide the best quality services with the help of our technology. ",
            size: text_size_16,
            weight: FontWeight.w400,
            color: Color(0xff777777),
            alignment: TextAlign.justify,
          ),
          const SizedBox(
            height: 10,
          ),
          const TextWidget(
            text: 'Version : 1.0',
            size: text_size_16,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 20,
          ),

          Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(14)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Contact Customer Care:",
                    style: TextStyle(
                        color: theme_color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () async => await launchCaller(),
                  icon: Icon(Icons.call),
                  color: theme_color,
                ),
                IconButton(
                  onPressed: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'support@mrdealgroup.com',
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Warranty Claim request by new user',
                      }),
                    );
                    await launchUrl(emailLaunchUri);
                  },
                  icon: Icon(Icons.mail),
                  color: theme_color,
                )
              ],
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _dropDown(List<DataModel>? list, String type) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        key: UniqueKey(),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              // if (type == 'brand') {
              _brandNm = list![index].brand ?? '';
              _seriesDataList = list[index].series ?? [];
              // } else if (type == 'series') {
              _seriesNm = '';
              // } else {
              _modelNm = '';
              // }
              _proceed = false;
              _selectedPhoneData = null;
              // _selectedPhoneData = list[index];
              setState(() {
                _brandList = false;
              });
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.6))),
              child: TextWidget(
                text: (list![index].brand ?? ''),

                // type == 'brand'
                //     ? (list![index].brand ?? '')
                //     : type == 'series'
                //         ? (list![index].series ?? '')
                //         : (list![index].model ?? ''),
                size: text_size_16,
                alignment: TextAlign.center,
              ),
            ),
          );
        },
        itemCount: _homepageresp?.data?.models?.length ?? 0,
      ),
    );
  }

  Widget _dropDownSeries(List<Series>? serieslist, String type) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        key: UniqueKey(),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              // if (type == 'brand') {
              // _brandNm = serieslist![index].brand ?? '';
              // } else if (type == 'series') {
              _seriesNm = serieslist![index].sName ?? '';
              _modelDataList = serieslist[index].model ?? [];
              // } else {
              _modelNm = '';
              // }
              _proceed = false;
              _selectedPhoneData = null;
              // _selectedPhoneData = list[index];
              setState(() {
                _seriesList = false;
              });
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.6))),
              child: TextWidget(
                text: (serieslist![index].sName ?? ''),

                // type == 'brand'
                //     ? (list![index].brand ?? '')
                //     : type == 'series'
                //         ? (list![index].series ?? '')
                //         : (list![index].model ?? ''),
                size: text_size_16,
                alignment: TextAlign.center,
              ),
            ),
          );
        },
        itemCount: serieslist?.length ?? 0,
      ),
    );
  }

  Widget _dropDownModel(List<SeriesModel>? modellist, String type) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        key: UniqueKey(),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              // if (type == 'brand') {
              // _brandNm = serieslist![index].brand ?? '';
              // } else if (type == 'series') {
              // _seriesNm = modellist![index].mName ?? '';

              // } else {
              _modelNm = modellist![index].mName ?? '';
              // }
              _proceed = false;
              _selectedPhoneData = modellist[index];
              setState(() {
                _modelList = false;
              });
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.6))),
              child: TextWidget(
                text: (modellist![index].mName ?? ''),

                // type == 'brand'
                //     ? (list![index].brand ?? '')
                //     : type == 'series'
                //         ? (list![index].series ?? '')
                //         : (list![index].model ?? ''),
                size: text_size_16,
                alignment: TextAlign.center,
              ),
            ),
          );
        },
        itemCount: modellist?.length ?? 0,
      ),
    );
  }

  Widget _selectDevice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const TextWidget(
            text: 'Select Device',
            size: text_size_20,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _brandList = true;
                  });
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      backgroundColor: Colors.grey.shade300,
                      context: context,
                      builder: (context) {
                        return _dropDown(_homepageresp?.data?.models, 'brand');
                      });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.8,
                          color: _brandList ? blue_color : GREY_COLOR_GREY)),
                  child: Row(
                    children: [
                      TextWidget(
                        text: 'Select Brand',
                        size: text_size_13,
                        color: _brandList ? blue_color : black_color,
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: _brandList ? blue_color : black_color,
                      )
                    ],
                  ),
                ),
              ),
              (_seriesDataList?.length ?? 0) > 0
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _seriesList = true;
                        });
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            backgroundColor: Colors.grey.shade300,
                            context: context,
                            builder: (context) {
                              return _dropDownSeries(_seriesDataList, 'series');
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 0.8,
                                color: _seriesList
                                    ? blue_color
                                    : GREY_COLOR_GREY)),
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'Select Series',
                              size: text_size_13,
                              color: _seriesList ? blue_color : black_color,
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: _seriesList ? blue_color : black_color,
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              (_modelDataList?.length ?? 0) > 0
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _modelList = true;
                        });
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            backgroundColor: Colors.grey.shade300,
                            context: context,
                            builder: (context) {
                              return _dropDownModel(_modelDataList, 'model');
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 0.8,
                                color:
                                    _modelList ? blue_color : GREY_COLOR_GREY)),
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'Select Model',
                              size: text_size_13,
                              color: _modelList ? blue_color : black_color,
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: _modelList ? blue_color : black_color,
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Wrap(
            spacing: 10.0,
            children: [
              _brandNm != ''
                  ? Chip(
                      label: TextWidget(
                        text: 'Brand : $_brandNm',
                        size: text_size_16,
                        color: white_color,
                        weight: FontWeight.w400,
                      ),
                      backgroundColor: theme_color,
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              _seriesNm != ''
                  ? Chip(
                      label: TextWidget(
                        text: 'Series : $_seriesNm',
                        size: text_size_16,
                        color: white_color,
                        weight: FontWeight.w400,
                      ),
                      backgroundColor: theme_color)
                  : const SizedBox(
                      height: 0,
                    ),
              _modelNm != ''
                  ? Chip(
                      label: TextWidget(
                        text: 'Model : $_modelNm',
                        size: text_size_16,
                        color: white_color,
                        weight: FontWeight.w400,
                      ),
                      backgroundColor: theme_color)
                  : const SizedBox(
                      height: 0,
                    ),
            ],
          )
        ],
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: ImageSlider(
                imgListData: _homepageresp?.data?.images,
              ),
            ),
            _deviceInfo(),
            _selectDevice(),
            SizedBox(
              height: 20,
            ),
            _nearDevice(),
            _selectedPhoneData == null && _proceed == true
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    child: const TextWidget(
                      text: 'Please select device specifications',
                      color: red_color,
                      size: text_size_15,
                    ),
                  )
                : SizedBox(height: 0),
            _aboutUs()
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print(MrDealGlobals.deviceBrand);
    homepageApiCall();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void homepageApiCall() {
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        homePgPresenter().getHomepageResp(this);
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
          homePgPresenter().getHomepageResp(this);
        }
      }
    });
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
            body: _isLoading
                ? Center(
                    child: Container(
                        child: Image.asset(
                      'images/gears.gif',
                      height: 60,
                    )),
                  )
                : _body(),
          )),
    );
  }

  Future<void> _reparingAlert(
      BuildContext context, SeriesModel? phnData) async {
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
              height: 300,
              child: Column(
                children: <Widget>[
                  const TextWidget(
                    text: 'Repairing cost for your searched device',
                    size: text_size_15,
                    weight: FontWeight.w600,
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'Brand : $_brandNm',
                        size: text_size_14,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget(
                        text: 'Series : $_seriesNm',
                        size: text_size_14,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextWidget(
                      text: 'Model : $_modelNm',
                      size: text_size_14,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          text: 'Normal Display',
                          size: text_size_16,
                          weight: FontWeight.w500,
                        ),
                        TextWidget(
                          text:
                              'Approx : ${phnData?.priceRangeNormal?[0] ?? ''} - ${phnData?.priceRangeNormal?[1] ?? ''}',
                          size: text_size_15,
                          weight: FontWeight.w500,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const TextWidget(
                          text: 'Amoled Display',
                          size: text_size_16,
                          weight: FontWeight.w500,
                        ),
                        TextWidget(
                          text:
                              'Approx : ${phnData?.priceRangeAmoled?[0] ?? ''} - ${phnData?.priceRangeAmoled?[1] ?? ''}',
                          size: text_size_15,
                          weight: FontWeight.w500,
                        )
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
                                  builder: (context) => ShopListScreen(
                                        phnData: phnData,
                                      )));
                        },
                        child: const TextWidget(
                          text: "Ok",
                          color: white_color,
                          size: text_size_14,
                          weight: FontWeight.w500,
                        )),
                  ),
                ],
              )),
        );
      },
    );
  }

  Future<void> _specificDeviceReparingAlert(
      BuildContext context, SpecificModelData? _specificModelData) async {
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
              height: 300,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const TextWidget(
                    text: 'Reparing cost for your searched device',
                    size: text_size_15,
                    weight: FontWeight.w600,
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'Brand : ${_specificModelData?.data?.bName}',
                        size: text_size_14,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget(
                        text: 'Series : ${_specificModelData?.data?.sName}',
                        size: text_size_14,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextWidget(
                      text: 'Model : ${_specificModelData?.data?.mName}',
                      size: text_size_14,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          text: 'Normal Display',
                          size: text_size_16,
                          weight: FontWeight.w500,
                        ),
                        TextWidget(
                          text:
                              'Approx : ${_specificModelData?.data?.priceRangeNormal?[0] ?? ''} - ${_specificModelData?.data?.priceRangeNormal?[1] ?? ''}',
                          size: text_size_15,
                          weight: FontWeight.w500,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const TextWidget(
                          text: 'Amoled Display',
                          size: text_size_16,
                          weight: FontWeight.w500,
                        ),
                        TextWidget(
                          text:
                              'Approx : ${_specificModelData?.data?.priceRangeAmoled?[0] ?? ''} - ${_specificModelData?.data?.priceRangeAmoled?[1] ?? ''}',
                          size: text_size_15,
                          weight: FontWeight.w500,
                        )
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
                                  builder: (context) => ShopListScreen(
                                        phnData: _specificModelData?.data,
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

  Future<void> _reparingOwnAlert(BuildContext context) async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
              margin: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 10),
              height: 150,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const TextWidget(
                    text:
                        'Sorry!! Currently we are running out of Stock for your specific deveice display.',
                    size: text_size_18,
                    alignment: TextAlign.center,
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
  void homepageResponse(HomepageModel _homepageModelresp) {
    _homepageresp = _homepageModelresp;
    print('home pg resp-->>>');
    print(_homepageModelresp.toMap());

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void homepgErr(error) {
    print('homepage error');
    print(error);
    setState(() {
      _isLoading = false;
    });
  }

  // @override
  // void specificErr(error) {
  //   // TODO: implement specificErr
  //   print('specific error $error');
  //   setState(() {
  //     _repairLoader = false;
  //   });
  //   _reparingOwnAlert(context);
  // }

  // @override
  // void specificModelData(SpecificModelData _specificModelData) {
  //   // TODO: implement specificModelData
  //   print('specific data ${_specificModelData.toMap()}');
  //   if (_specificModelData.status == true && _specificModelData.data != null) {
  //     _specificDeviceReparingAlert(context, _specificModelData);
  //   } else {
  //     _reparingOwnAlert(context);
  //   }
  //   setState(() {
  //     _repairLoader = false;
  //   });
  // }
}
