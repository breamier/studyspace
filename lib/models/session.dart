import 'package:isar/isar.dart';
import 'goal.dart';

part 'session.g.dart';

@Collection()
class Session {
  Id id = Isar.autoIncrement;
  late DateTime start;
  late DateTime end;
  final goal = IsarLink<Goal>();
}
