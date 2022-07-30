import 'package:http/http.dart' as http;
import 'package:mr_deal_user/Utls/apiconfig.dart';
import 'wallet_view.dart';

class WalletPresenter {
  WalletView? _walletView;

  void getTrxnDetails(WalletView walletView, _body) {
    _walletView = walletView;

    Apiconfig()
        .walletApi(
      http.Client(),
      _body,
    )
        .then((value) {
      _walletView?.walletResp(value);
    }).catchError((err) {
      _walletView?.walletErr(err);
    });
  }
}
