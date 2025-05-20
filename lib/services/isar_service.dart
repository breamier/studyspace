import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studyspace/models/astronaut_pet.dart';
import 'package:studyspace/models/goal.dart';
import '../models/mission.dart';
import '../models/session.dart';
import 'astro_hp_service.dart';

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
      final isar = await Isar.open(
          [GoalSchema, MissionSchema, SessionSchema, AstronautPetSchema],
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
    debugPrint("Session added successfully!");
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

  Future<void> initializeTestGoals() async {
    final isar = await db;

    // Clear existing data for clean test
    await isar.writeTxn(() async {
      await isar.goals.clear();
      await isar.sessions.clear();
    });

    // Create test goal 3 (due today - increases health when completed)
    final goal3 = Goal()
      ..goalName = "Health Booster"
      ..start = DateTime.now().subtract(Duration(days: 2))
      ..end = DateTime.now().add(Duration(days: 5))
      ..difficulty = "Easy"
      ..reps = 1
      ..interval = 2
      ..easeFactor = 2.5
      ..upcomingSessionDates = [DateTime.now()]; // Due today

    // Create test goal 4 (already completed - should add HP)
    final goal4 = Goal()
      ..goalName = "Completed Goal"
      ..start = DateTime.now().subtract(Duration(days: 7))
      ..end = DateTime.now().add(Duration(days: 1))
      ..difficulty = "Medium"
      ..reps = 2
      ..interval = 3
      ..easeFactor = 2.0
      ..completedSessionDates = [DateTime.now().subtract(Duration(days: 1))]
      ..upcomingSessionDates = []; // No upcoming sessions since it's completed

    // Create a completed session for goal4
    final completedSession = Session()
      ..difficulty = "Medium"
      ..imgPath = "test_path"
      ..duration = 60 // 60 minutes
      ..start = DateTime.now().subtract(Duration(days: 1, hours: 1))
      ..end = DateTime.now().subtract(Duration(days: 1))
      ..goal.value = goal4;

    await isar.writeTxn(() async {
      await isar.goals.putAll([goal3, goal4]);
      await isar.sessions.put(completedSession);
      await completedSession.goal.save();
    });

    print("Created 2 test goals with:"
        "\n- 1 goal due today"
        "\n- 1 completed goal with session"
        "\nHP will increase when the app processes completed sessions");
  }

  Future<List<Session>> getAllSessions() async {
    final isar = await db;
    return await isar.sessions.where().sortByEnd().findAll();
  }
}









// // Create test goal 1 (missed by 1 day)
    // final goal1 = Goal()
    //   ..goalName = "Math Study"
    //   ..start = DateTime.now().subtract(Duration(days: 3))
    //   ..end = DateTime.now().add(Duration(days: 3))
    //   ..difficulty = "Medium"
    //   ..reps = 2
    //   ..interval = 3
    //   ..easeFactor = 2.3
    //   ..upcomingSessionDates = [DateTime.now().subtract(Duration(days: 1))];

    // // Create test goal 2 (missed by 2 days)
    // final goal2 = Goal()
    //   ..goalName = "Physics Review"
    //   ..start = DateTime.now().subtract(Duration(days: 5))
    //   ..end = DateTime.now().add(Duration(days: 1))
    //   ..difficulty = "Hard"
    //   ..reps = 3
    //   ..interval = 5
    //   ..easeFactor = 1.8
    //   ..upcomingSessionDates = [DateTime.now().subtract(Duration(days: 2))];