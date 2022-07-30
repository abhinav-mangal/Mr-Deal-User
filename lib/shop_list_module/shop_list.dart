import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_user/common_widgets/colors_widget.dart';
import 'package:mr_deal_user/common_widgets/connectivity.dart';
import 'package:mr_deal_user/common_widgets/font_size.dart';
import 'package:mr_deal_user/common_widgets/loader.dart';
import 'package:mr_deal_user/common_widgets/no_internet.dart';
import 'package:mr_deal_user/common_widgets/text_widget.dart';
import 'package:mr_deal_user/home_module/home_model.dart';
import 'package:mr_deal_user/shop_details_module/shop_details.dart';
import 'package:mr_deal_user/shop_list_module/shop_ls_presenter.dart';
import 'package:mr_deal_user/shop_list_module/shop_ls_view.dart';

import 'shop_ls_model.dart';

class ShopListScreen extends StatefulWidget {
  final dynamic phnData;
  const ShopListScreen({Key? key, required this.phnData}) : super(key: key);

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen>
    implements ShopListView {
  var noConnection;
  bool _isLoading = true;
  ShopListModel? _shopList;
  Widget _appbar() {
    return AppBar(
        backgroundColor: theme_color,
        centerTitle: false,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: theme_color),
        ),
        title: const TextWidget(
          text: 'Shop',
          size: text_size_18,
          color: white_color,
        ));
  }

  Widget _body() {
    return Container(
      color: Colors.grey.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 15),
        key: UniqueKey(),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopDetails(
                            shopDeatils: _shopList?.data![index],
                            phnData: widget.phnData,
                          )));
            },
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: white_color,
                    border: Border.all(width: 0.5, color: shadow_color),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: shadow_color,
                          borderRadius: BorderRadius.circular(5)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: _shopList!.data![index].shopImage != null
                              ? _shopList!.data![index].shopImage!
                              : '',
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const Loader(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      color: transparent,
                      width: MediaQuery.of(context).size.width - 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: _shopList?.data![index].shopName ?? '',
                            size: text_size_15,
                            weight: FontWeight.w500,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextWidget(
                            text:
                                'Address : ${_shopList?.data![index].address ?? ''}',
                            size: text_size_15,
                            weight: FontWeight.w400,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextWidget(
                            text:
                                'Mobile No. : ${_shopList?.data![index].contact}',
                            size: text_size_15,
                            weight: FontWeight.w400,
                          )
                        ],
                      ),
                    )
                  ],
                )),
          );
        },
        itemCount: _shopList?.data?.length ?? 0,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    shopLstApiCall();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void shopLstApiCall() {
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        ShopLstPresenter().getShopList(this);
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
          ShopLstPresenter().getShopList(this);
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

  @override
  void ShopLsErr(error) {
    print('error shop list -- > $error');
    setState(() {
      _isLoading = false;
    });
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
  void shopLsResp(ShopListModel _shopListModelresp) {
    print('Shop list resp -- > ${_shopListModelresp.toMap()}');
    _shopList = _shopListModelresp;
    setState(() {
      _isLoading = false;
    });
  }
}
