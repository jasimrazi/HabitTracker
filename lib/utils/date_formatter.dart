import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('MMM d');
  return formatter.format(date);
}
