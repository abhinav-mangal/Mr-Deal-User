import 'package:http/http.dart' as http;
import 'package:mr_deal_user/Utls/apiconfig.dart';

import 'booking_view.dart';

class BookingPresenter {
  BookingView? _bookingView;

  void getbookingDetails(BookingView bookingView, _body) {
    _bookingView = bookingView;

    Apiconfig()
        .bookingApi(
      http.Client(),
      _body,
    )
        .then((value) {
      _bookingView?.bookingResp(value);
    }).catchError((err) {
      _bookingView?.bookingErr(err);
    });
  }
}
