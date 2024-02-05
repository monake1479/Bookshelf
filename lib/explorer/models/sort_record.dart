import 'package:ztp_projekt/explorer/models/sort_field.dart';
import 'package:ztp_projekt/explorer/models/sort_type_enum.dart';

class SortRecord {
  SortRecord({
    required this.field,
    required this.type,
  });
  SortField field;
  SortType type;
}
