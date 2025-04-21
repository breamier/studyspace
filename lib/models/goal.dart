import 'package:isar/isar.dart';

part 'goal.g.dart';

@Collection()
class Goal {
  Id id = Isar.autoIncrement;
  late String goalName;
  late DateTime start;
  late DateTime end;
  late String difficulty;

  List<Subtopic> subtopics = [];
}

@embedded
class Subtopic {
  late String name;
}
