import 'package:http/http.dart' as http;
import 'package:mr_deal_user/Utls/apiconfig.dart';

import 'booking_cnf_view.dart';

class CNFBookingPresenter {
  BookingCNFView? _bookingCNFView;

  void getbookingDetails(BookingCNFView bookingCNFView, _body) {
    _bookingCNFView = bookingCNFView;

    Apiconfig()
        .cnfbookingApi(
      http.Client(),
      _body,
    )
        .then((value) {
      _bookingCNFView?.cnfbookingResp(value);
    }).catchError((err) {
      _bookingCNFView?.cnfbookingErr(err);
    });
  }
}
