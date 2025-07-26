import 'package:intl/intl.dart';

String utcToLocalTime(DateTime utcTime) {
  final DateTime utcDateTime = utcTime;
  final DateTime localDateTime = utcDateTime.toLocal();
  final DateFormat formatter = DateFormat('h:mm a');
  return formatter.format(localDateTime);
}
