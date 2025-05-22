import 'package:isar/isar.dart';

part 'hp_check_log.g.dart';

@Collection()
class HpCheckLog {
  Id id = 0; // only need one record
  late DateTime lastChecked;
}
