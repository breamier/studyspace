import 'package:isar/isar.dart';
import 'session.dart';

part 'goal.g.dart';

@Collection()
class Goal {
  Id id = Isar.autoIncrement;
  late String goalName;
  late DateTime start;
  late DateTime end;
  late String difficulty;

  late int reps = 0;
  late int interval = 0;
  late double easeFactor = 2.5;

  List<DateTime> sessionDates = [];
  List<Subtopic> subtopics = [];

  //keep track if goal is a current or upcoming
  bool get isCurrent =>
      start.isBefore(DateTime.now()) || end.isAtSameMomentAs(DateTime.now());

  bool get isUpcoming => start.isAfter(DateTime.now());

  @Backlink(to: 'goal')
  final sessions = IsarLinks<Session>();
}

@embedded


@embedded
class Subtopic {
  late String name;
  bool completed = false;
  Id id = Isar.autoIncrement;

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
