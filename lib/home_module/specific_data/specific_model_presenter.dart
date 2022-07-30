import 'package:http/http.dart' as http;
import 'package:mr_deal_user/Utls/apiconfig.dart';

import 'specific_model_view.dart';

class SpecificModelPresenter {
  SpecificModelView? _specificModelView;

  void getspecificModelData(SpecificModelView specificModelView, request) {
    _specificModelView = specificModelView;

    Apiconfig().specificModelApi(http.Client(), request).then((value) {
      _specificModelView?.specificModelData(value);
    }).catchError((err) {
      _specificModelView?.specificErr(err);
    });
  }
}
