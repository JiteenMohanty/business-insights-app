import 'package:intl/intl.dart';

final NumberFormat _thousands = NumberFormat.decimalPattern();

/// Formats an integer with thousands separators, e.g. `1200` -> `1,200`.
String formatCount(int value) => _thousands.format(value);

/// Formats an ISO-style review date string (e.g. `2026-03-20`) into a friendly
/// label (e.g. `Mar 20, 2026`). Falls back to the raw string if it can't be
/// parsed, so unexpected formats never crash the UI.
String formatReviewDate(String raw) {
  try {
    final parsed = DateTime.parse(raw);
    return DateFormat('MMM d, yyyy').format(parsed);
  } catch (_) {
    return raw;
  }
}
