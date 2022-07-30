import 'package:http/http.dart' as http;
import 'package:mr_deal_user/Utls/apiconfig.dart';

import 'register_view.dart';

class RegisterPresenter {
  RegisterUserView? _registerUserView;

  void getLoginDetails(RegisterUserView registerUserView, _body) {
    _registerUserView = registerUserView;

    Apiconfig()
        .registerUserApi(
      http.Client(),
      _body,
    )
        .then((value) {
      _registerUserView?.registerResponse(value);
    }).catchError((err) {
      _registerUserView?.registerErr(err);
    });
  }
}
