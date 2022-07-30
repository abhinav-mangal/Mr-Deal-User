import 'package:http/http.dart' as http;
import 'package:mr_deal_user/Utls/apiconfig.dart';

import 'edit_view.dart';

class EditProfilePresenter {
  EditProfileView? _editProfileView;

  void getLoginDetails(EditProfileView editProfileView, _body) {
    _editProfileView = editProfileView;

    Apiconfig()
        .editProfileAPi(
      http.Client(),
      _body,
    )
        .then((value) {
      _editProfileView?.editprofileResp(value);
    }).catchError((err) {
      _editProfileView?.editProdileErr(err);
    });
  }
}
