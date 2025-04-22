import 'package:isar/isar.dart';

part 'mission.g.dart';

@Collection()
class Mission {
  Id id = Isar.autoIncrement;
  late String text;
  bool completed = false;
  DateTime? completedDate;
  late String dailyKey;

  Mission({required this.text});

  @Index()
  String get dailyKeyIndex => dailyKey;
}
