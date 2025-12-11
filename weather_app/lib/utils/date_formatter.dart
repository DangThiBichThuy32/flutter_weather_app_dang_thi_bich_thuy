import 'package:intl/intl.dart';

String formatHour(DateTime dt, {bool is24h = true}) {
  if (is24h) return DateFormat('HH:mm').format(dt);
  return DateFormat('h a').format(dt);
}
