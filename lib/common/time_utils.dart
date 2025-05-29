import 'package:intl/intl.dart';

String formatTimeToStandard(DateTime? time){
  if(time == null){
    return "N/A";
  }
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
}
extension DateTimeExtention on DateTime {

  String getJustDate() {
    var time = toLocal();
    return DateFormat.yMMMEd().format(time);
  }

  String getJustTime() {
    var time = toLocal();
    return DateFormat.jm().format(time);
  }
}