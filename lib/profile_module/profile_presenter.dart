import 'package:http/http.dart' as http;
import 'package:mr_deal_user/Utls/apiconfig.dart';
import 'package:mr_deal_user/profile_module/profile_view.dart';

class ProfilePresenter {
  ProfileView? _profileView;

  void getprofileDetails(ProfileView profileView, _body) {
    _profileView = profileView;

    Apiconfig()
        .profileAPi(
      http.Client(),
      _body,
    )
        .then((value) {
      _profileView?.profileResp(value);
    }).catchError((err) {
      _profileView?.ProfileErr(err);
    });
  }
}
