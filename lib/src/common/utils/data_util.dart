import 'package:timeago/timeago.dart' as timeago;

class MarketDataUtils {
  static String timeagoValue(DateTime timeAt) {
    var value = timeago.format(
        DateTime.now().subtract(DateTime.now().difference(timeAt)),
        locale: 'ko');
    return value;
  }
}
