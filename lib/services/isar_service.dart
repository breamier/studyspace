import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studyspace/models/goal.dart';
import '../models/mission.dart';
import '../models/session.dart';

class IsarService extends ChangeNotifier {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  // Temporary
  Future<Goal?> getFirstGoal() async {
    final isar = await db;
    return await isar.goals.where().findFirst();
  }

  Goal createGoalObj(String goalName, DateTime start, DateTime end,
      String difficulty, List<Subtopic> subtopics, Id? id) {
    Goal newGoal = Goal()
      ..goalName = goalName
      ..start = start
      ..end = end
      ..difficulty = difficulty
      ..subtopics = subtopics;
    if (id != null) {
      newGoal.id = id;
    }
    return newGoal;
  }

  Future<void> addGoal(Goal newGoal) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.goals.putSync(newGoal));
    print("Goal added successfully!");
  }

  // filter -> Upcoming goals date for dashboard
  Future<List<Goal>> getCurrentGoals() async {
    final isar = await db;
    return await isar.goals
        .filter()
        .startLessThan(DateTime.now())
        .and()
        .endGreaterThan(DateTime.now())
        .findAll();
  }

  // filter -> Upcoming goals date for dashboard
  Future<List<Goal>> getUpcomingGoals() async {
    final isar = await db;
    // date should be greater than/after the DateTime.now
    return await isar.goals.filter().startGreaterThan(DateTime.now()).findAll();
  }

  // fetch all goals for study_overview screen
  Future<List<Goal>> getAllGoals() async {
    final isar = await db;
    return await isar.goals.where().sortByEnd().findAll();
  }

  Future<Goal?> getGoalById(Id id) async {
    final isar = await db;
    return await isar.goals.get(id);
  }

  Future<void> updateGoal(Goal goal) async {
    final isar = await db;
    await isar.writeTxn(() => isar.goals.put(goal));
    notifyListeners();
  }

  Future<void> updateSubtopic(Goal goal, Subtopic subtopic) async {
    goal.subtopics.where((sub) => sub.id == subtopic.id).elementAt(0).name =
        subtopic.name;
    updateGoal(goal);
    notifyListeners();
  }
  Future<void> deleteSubtopicById(Goal goal, Subtopic subtopic) async{
    goal.subtopics.removeWhere((sub)=>sub.id==subtopic.id);
    updateGoal(goal);
    notifyListeners();
  }

  Future<void> deleteSubtopics(
      Goal goal, List<Subtopic> subtopicsToDelete) async {
    final isar = await db;

    // create a new list without the subtopics to delete
    final updatedSubtopics = goal.subtopics
        .where((subtopic) => !subtopicsToDelete.contains(subtopic))
        .toList();

    // update the goal with the new subtopics list
    goal.subtopics = updatedSubtopics;

    // save
    await isar.writeTxn(() => isar.goals.put(goal));
    notifyListeners();
  }

  Future<void> clearDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    print('ISAR DB path: ${dir.path}');
    if (Isar.instanceNames.isEmpty) {
      final isar = await Isar.open([GoalSchema, MissionSchema, SessionSchema],
          directory: dir.path, inspector: true);
      print('ISAR DB opened: ${isar.name}');
      return isar;
    }

    return Future.value(Isar.getInstance());
  }

  // MISSION METHODS

  Future<List<Mission>> getMissions() async {
    final isar = await db;
    return await isar.missions.where().findAll();
  }

  Future<void> initializeDailyMissions(List<String> allMissions) async {
    final isar = await db;
    // randomize every day
    final todayKey = DateFormat('yyyyMMdd').format(DateTime.now());

    // check if we already have missions for today
    final existingMissions = await isar.missions.where().findAll();

    if (existingMissions.isEmpty ||
        existingMissions.first.dailyKey != todayKey) {
      // clear mission for new day
      await isar.writeTxn(() => isar.missions.clear());

      // randomize daily mission
      final random = Random(
          DateTime.now().millisecondsSinceEpoch ~/ 86400000); // seed value
      final shuffled = List.from(allMissions)..shuffle(random);
      final dailyMissions = shuffled.take(3).toList();

      await isar.writeTxn(() async {
        for (final text in dailyMissions) {
          await isar.missions.put(Mission(text: text)..dailyKey = todayKey);
        }
      });
    }
  }

  // Session Methods
  Future<Session> createSessionObj(DateTime start, DateTime end, int duration,
      String imgPath, String difficulty, Goal goal) async {
    Session newSession = Session()
      ..difficulty = difficulty
      ..imgPath = imgPath
      ..duration = duration
      ..start = start
      ..end = end;
    return newSession;
  }

  Future<void> addSession(Session newSession, Goal goal) async {
    final isar = await db;
    print(newSession.difficulty);
    print(newSession.imgPath);
    goal.sessions.add(newSession);
    await isar.writeTxn(() async {
      await isar.goals.put(goal);
      await isar.sessions.put(newSession);
      await newSession.goal.save();
      await goal.sessions.save();
    });
    // update next session here
    print("Session added successfully!");
  }

  Future<List<Session>> getAllSessions() async {
    final isar = await db;
    return await isar.sessions.where().sortByEnd().findAll();
  }
}
