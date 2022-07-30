import 'package:http/http.dart' as http;
import 'package:mr_deal_user/Utls/apiconfig.dart';

import 'home_view.dart';

class homePgPresenter {
  HomepageView? _homepageView;

  void getHomepageResp(HomepageView homepageView) {
    _homepageView = homepageView;

    Apiconfig()
        .homepageApi(
      http.Client(),
    )
        .then((value) {
      _homepageView?.homepageResponse(value);
    }).catchError((err) {
      _homepageView?.homepgErr(err);
    });
  }
}
