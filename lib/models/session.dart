import 'package:isar/isar.dart';
import 'goal.dart';
part 'session.g.dart';

@Collection()
class Session {
  Id id = Isar.autoIncrement;
  late DateTime start;
  late DateTime end;
  late int duration;
  String imgPath = "";
  late String difficulty;
  final goal = IsarLink<Goal>();
}
