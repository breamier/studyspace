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

  //keep track if goal is a current or upcoming
  bool get isCurrent =>
      start.isBefore(DateTime.now()) || end.isAtSameMomentAs(DateTime.now());

  bool get isUpcoming => start.isAfter(DateTime.now());
}

@embedded
@embedded
class Subtopic {
  late String name;
  bool completed = false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subtopic &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          completed == other.completed;

  @override
  int get hashCode => name.hashCode ^ completed.hashCode;
}
