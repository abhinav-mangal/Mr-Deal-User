import 'package:http/http.dart' as http;
import 'package:mr_deal_user/Utls/apiconfig.dart';
import 'package:mr_deal_user/shop_list_module/shop_ls_view.dart';

class ShopLstPresenter {
  ShopListView? _shopListView;

  void getShopList(ShopListView shopListView) {
    _shopListView = shopListView;

    Apiconfig()
        .shopListApi(
      http.Client(),
    )
        .then((value) {
      _shopListView?.shopLsResp(value);
    }).catchError((err) {
      _shopListView?.ShopLsErr(err);
    });
  }
}
