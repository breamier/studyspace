import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studyspace/models/goal.dart';
import '../models/mission.dart';
import '../models/session.dart';
import '../models/astronaut_pet.dart';

import 'astro_missions_service.dart';
import 'package:studyspace/models/hp_check_log.dart';
import '../item_manager.dart';

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
    debugPrint("Goal added successfully!");
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

  Future<void> updateSubtopic(Goal goal, int index, Subtopic subtopic) async {
    final isar = await db;
    print(goal.subtopics);
    goal.subtopics[index] = subtopic;
    await isar.writeTxn(() => isar.goals.put(goal));
    notifyListeners();
  }

  Future<void> deleteGoal(Goal goal) async {
    final isar = await db;
    final sessions = await isar.sessions
        .filter()
        .goal((q) => q.idEqualTo(goal.id))
        .findAll();
    await isar.writeTxn(() async {
      await isar.sessions.deleteAll(sessions.map((s) => s.id).toList());
      isar.goals.delete(goal.id);
    });
    notifyListeners();
  }

  Future<void> deleteSubtopicAtIndex(Goal goal, int index) async {
    final isar = db;
    var updated = goal.subtopics.toList();
    updated = updated.sublist(0, index) + updated.sublist(index + 1);
    goal.subtopics = updated;
    await isar.then((value) => value.writeTxn(() => value.goals.put(goal)));
    notifyListeners();
  }

  Future<void> deleteSubtopic(Goal goal, Subtopic subtopic) async {
    final isar = await db;
    final updatedSubtopics =
        goal.subtopics.where((sub) => sub.name != subtopic.name).toList();

    int duplicateCount =
        goal.subtopics.where((sub) => sub.name == subtopic.name).length;
    while (duplicateCount > 1) {
      updatedSubtopics.add(subtopic);
      debugPrint(subtopic.name);
      duplicateCount--;
    }
    goal.subtopics = updatedSubtopics;
    await isar.writeTxn(() => isar.goals.put(goal));
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

    ItemManager().resetUnlocksAndCurrent();

    ItemManager().itemChangedNotifier.value =
        !ItemManager().itemChangedNotifier.value;
    notifyListeners();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    debugPrint('ISAR DB path: ${dir.path}');
    if (Isar.instanceNames.isEmpty) {
      final isar = await Isar.open([
        AstronautPetSchema,
        GoalSchema,
        MissionSchema,
        SessionSchema,
        HpCheckLogSchema
      ], directory: dir.path, inspector: true);
      debugPrint('ISAR DB opened: ${isar.name}');
      return isar;
    }

    return Future.value(Isar.getInstance());
  }

  // // MISSION METHODS

  late MissionService _missionService;
  bool _servicesInitialized = false;

  // Initialize services after DB is opened
  Future<void> initializeServices() async {
    final database = await db;
    _missionService = MissionService(database);
    _servicesInitialized = true;
  }

  // Call this from your app initialization
  Future<void> initializeDailyMissions() async {
    await initializeServices();
    await _missionService.initializeDailyMissions();
  }

  // Get today's missions
  Future<List<Mission>> getMissions() async {
    await initializeServices();
    return await _missionService.getTodaysMissions();
  }

  // Complete a mission
  Future<void> completeMission(Id missionId) async {
    await initializeServices();
    await _missionService
        .completeMission(missionId); // update mission and pet progress
  }

  // Fail a mission
  Future<void> failMission(Id missionId) async {
    await initializeServices();
    await _missionService.failMission(missionId);
  }

  // Get mission completion percentage
  Future<double> getMissionCompletionPercentage() async {
    await initializeServices();
    return await _missionService.getMissionCompletionPercentage();
  }

  // get missions by id
  Future<Mission?> getMissionById(Id id) async {
    final isar = await db;
    return await isar.missions.get(id);
  }

  // reset mission complete status to false [ FOR DEBUG/TESTING]
  Future<void> resetAllMissions() async {
    final isar = await db;
    await isar.writeTxn(() async {
      final missions = await isar.missions.where().findAll();
      for (final mission in missions) {
        mission.completed = false;
        mission.completedDate = null;
        await isar.missions.put(mission);
      }
    });
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
    debugPrint(newSession.difficulty);
    debugPrint(newSession.imgPath);
    goal.sessions.add(newSession);
    await isar.writeTxn(() async {
      await isar.goals.put(goal);
      await isar.sessions.put(newSession);
      await newSession.goal.save();
      await goal.sessions.save();
    });

    // update next session here
    debugPrint("Session added successfully!");
  }

  Future<List<Session>> getAllSessions() async {
    final isar = await db;
    return await isar.sessions.where().sortByEnd().findAll();
  }

  Future<List<Map<String, dynamic>>> getCompletedGoals() async {
    final isar = await db;
    final goals = await isar.goals.where().findAll();
    final now = DateTime.now();
    final formatter = DateFormat('MMMM d, y');

    List<Map<String, dynamic>> completed = [];

    for (final goal in goals) {
      if (goal.completedSessionDates.isEmpty) continue;

      // Load sessions
      await goal.sessions.load();
      final sessions = goal.sessions.toList();

      // Filter completed sessions
      final completedSessions = sessions
          .where((s) =>
              goal.completedSessionDates.any((d) => isSameDate(s.start, d)) &&
              s.start.isBefore(now))
          .toList();

      if (completedSessions.isEmpty) continue;

      final sessionDetails = completedSessions
          .map((s) => {
                'date': formatter.format(s.start),
                'time': formatDuration(Duration(seconds: s.duration)),
              })
          .toList();

      final totalTime = sumDurations(sessionDetails);

      final goalMap = {
        'title': goal.goalName,
        'dateCompleted':
            formatter.format(goal.completedSessionDates.last), // last session
        'timeSpent': totalTime,
        'subtopics': goal.subtopics.map((t) => {'title': t.name}).toList(),
        'images': completedSessions.map((s) => s.imgPath).toList(),
        'sessions': sessionDetails,
      };

      completed.add(goalMap);
    }

    return completed;
  }

  // Helper to check if two DateTime objects are the same day
  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // Format duration like '1h 45m'
  String formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h}h ${m}m ${s}s';
    } else if (m > 0) {
      return '${m}m ${s}s';
    } else {
      return '${s}s';
    }
  }

  String sumDurations(List<Map<String, dynamic>> sessions) {
    int totalSeconds = 0;
    for (final s in sessions) {
      final time = s['time'] as String;
      final match =
          RegExp(r'(?:(\d+)h)?\s*(?:(\d+)m)?\s*(?:(\d+)s)?').firstMatch(time);
      if (match != null) {
        final h = int.tryParse(match.group(1) ?? '0') ?? 0;
        final m = int.tryParse(match.group(2) ?? '0') ?? 0;
        final sec = int.tryParse(match.group(3) ?? '0') ?? 0;
        totalSeconds += h * 3600 + m * 60 + sec;
      }
    }
    return formatDuration(Duration(seconds: totalSeconds));
  }

  Stream<Goal?> watchGoalById(Id id) async* {
    final isar = await db;
    yield* isar.goals.watchObject(id, fireImmediately: true);
  }

  // ASTRONAUT PET METHODS

  // Default Pet
  Future<void> initializeDefaultPet() async {
    final isar = await db;
    final existingPets = await isar.astronautPets.where().findAll();

    if (existingPets.isEmpty) {
      await createPet(name: 'Astro', skinType: 'default', shipType: 'default');
      debugPrint('Created default pet');
    }
  }

  // get the current pet
  Future<AstronautPet?> getCurrentPet() async {
    final isar = await db;
    return await isar.astronautPets.where().findFirst();
  }

  // update pet in database
  Future<void> updatePet(AstronautPet pet) async {
    final isar = await db;
    print('Updating pet ${pet.id} with HP: ${pet.hp}');
    await isar.writeTxn(() async {
      await isar.astronautPets.put(pet);
      print('Pet updated in transaction');
    });
    print('Transaction completed');
    notifyListeners();
  }

  // get pet by ID
  Future<AstronautPet?> getPetById(Id id) async {
    final isar = await db;
    return await isar.astronautPets.get(id);
  }

  // create new pet
  Future<AstronautPet> createPet({
    String name = 'Astro',
    String skinType = 'default',
    String shipType = 'default',
  }) async {
    final isar = await db;
    final newPet = AstronautPet.create(
      name: name,
      skinType: skinType,
      shipType: shipType,
    );

    await isar.writeTxn(() async {
      await isar.astronautPets.put(newPet);
    });
    return newPet;
  }

  Future<DateTime?> getLastMissedSessionCheck() async {
    final isar = await db;
    final log = await isar.hpCheckLogs.get(0);
    return log?.lastChecked;
  }

  Future<void> setLastMissedSessionCheck(DateTime date) async {
    final isar = await db;
    final log = HpCheckLog()
      ..id = 0
      ..lastChecked = date;
    await isar.writeTxn(() async {
      await isar.hpCheckLogs.put(log);
    });
  }
}
