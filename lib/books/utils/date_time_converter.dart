import 'package:freezed_annotation/freezed_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime?, String?> {
  const DateTimeConverter();
  @override
  DateTime? fromJson(String? value) {
    if (value != null) {
      return DateTime.parse(value);
    }
    return null;
  }

  @override
  String? toJson(DateTime? object) {
    if (object != null) {
      return object.toIso8601String();
    }
    return null;
  }
}
