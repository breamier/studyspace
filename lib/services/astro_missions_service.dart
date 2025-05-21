// lib/services/mission_service.dart
import 'dart:math';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../models/mission.dart';
import '../models/astronaut_pet.dart';

class MissionService {
  final Isar isar;

  MissionService(this.isar);

  String _getTodayKey() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> initializeDailyMissions() async {
    final todayKey = _getTodayKey();

    // check if missions for today already exist
    final existingMissions =
        await isar.missions.filter().dailyKeyEqualTo(todayKey).findAll();

    if (existingMissions.isNotEmpty) {
      return; // already exist for today
    }

    //  old missions that are not completed
    await isar.writeTxn(() async {
      final oldMissions = await isar.missions
          .filter()
          .not()
          .dailyKeyEqualTo(todayKey)
          .and()
          .completedEqualTo(false)
          .findAll();

      await isar.missions.deleteAll(oldMissions.map((m) => m.id).toList());
    });

    // test test
    await isar.writeTxn(() async {
      final mission = Mission(
        text: "Take a picture before a study session",
        type: MissionType.selfie,
        difficulty: MissionDifficulty.easy,
        dailyKey: todayKey,
        rewardPoints: 50,
        penaltyPoints: 20,
        hpPenalty: 10,
        expiryDate: DateTime.now().add(const Duration(days: 1)),
      );
      await isar.missions.put(mission);
    });
  }

  // today's missions
  Future<List<Mission>> getTodaysMissions() async {
    final todayKey = _getTodayKey();
    return await isar.missions.filter().dailyKeyEqualTo(todayKey).findAll();
  }

  // complete a mission
  Future<void> completeMission(Id missionId) async {
    await isar.writeTxn(() async {
      final mission = await isar.missions.get(missionId);
      if (mission != null && !mission.completed) {
        mission.completed = true;
        mission.completedDate = DateTime.now();
        await isar.missions.put(mission);

        // Update user progress and pet HP
        await _applyMissionReward(mission);
      }
    });
  }

  // fail a mission
  Future<void> failMission(Id missionId) async {
    await isar.writeTxn(() async {
      final mission = await isar.missions.get(missionId);
      if (mission != null && !mission.completed) {
        await _applyMissionPenalty(mission);
      }
    });
  }

  // apply  reward
  Future<void> _applyMissionReward(Mission mission) async {
    final pet = await isar.astronautPets.where().findFirst();
    if (pet != null) {
      await isar.writeTxn(() async {
        // update progress
        double progressIncrease = mission.rewardPoints / 1000.0;
        pet.progress = min(1.0, pet.progress + progressIncrease);
        await isar.astronautPets.put(pet);
      });
    }
  }

  // Apply mission penalty
  Future<void> _applyMissionPenalty(Mission mission) async {
    final pet = await isar.astronautPets.where().findFirst();
    if (pet != null) {
      await isar.writeTxn(() async {
        // decrease HP
        pet.hp = max(0, pet.hp - mission.hpPenalty);

        // decrease progress
        double progressDecrease = mission.penaltyPoints / 1000.0;
        pet.progress = max(0, pet.progress - progressDecrease);

        await isar.astronautPets.put(pet);
      });
    }
  }

  // Get mission completion percentage
  Future<double> getMissionCompletionPercentage() async {
    final todaysMissions = await getTodaysMissions();

    if (todaysMissions.isEmpty) {
      return 0.0;
    }

    final completedCount = todaysMissions.where((m) => m.completed).length;
    return completedCount / todaysMissions.length;
  }
}

// class for mission data
class MissionData {
  final String text;
  final MissionType type;
  final MissionDifficulty difficulty;
  final int rewardPoints;
  final int penaltyPoints;
  final int hpPenalty;

  MissionData(
    this.text,
    this.type,
    this.difficulty,
    this.rewardPoints,
    this.penaltyPoints,
    this.hpPenalty,
  );
}


// All available missions with their rewards and penalties
    // final allMissions = [
    //   // Minor missions
    //   // MissionData(
    //   //   "Study 30 minutes straight",
    //   //   MissionType.study,
    //   //   MissionDifficulty.easy,
    //   //   50, // reward points
    //   //   20, // penalty points
    //   //   10, // hp penalty
    //   // ),
    //   MissionData(
    //     "Take a picture before a study session",
    //     MissionType.selfie,
    //     MissionDifficulty.easy,
    //     50,
    //     20,
    //     10,
    //   ),
    //   // MissionData(
    //   //   "Study a total of 1 hour",
    //   //   MissionType.study,
    //   //   MissionDifficulty.easy,
    //   //   50,
    //   //   20,
    //   //   10,
    //   // ),
    //   // MissionData(
    //   //   "Complete 3 study sessions",
    //   //   MissionType.study,
    //   //   MissionDifficulty.medium,
    //   //   50,
    //   //   20,
    //   //   10,
    //   // ),
    //   // MissionData(
    //   //   "Drink water every 30 mins",
    //   //   MissionType.minor,
    //   //   MissionDifficulty.easy,
    //   //   50,
    //   //   20,
    //   //   10,
    //   // ),
    //   // MissionData(
    //   //   "Study after 9 PM",
    //   //   MissionType.study,
    //   //   MissionDifficulty.easy,
    //   //   50,
    //   //   20,
    //   //   10,
    //   // ),
    //   // // Special missions
    //   // MissionData(
    //   //   "Deep Mind Focus: Study 3 hours straight",
    //   //   MissionType.deepMindFocus,
    //   //   MissionDifficulty.hard,
    //   //   75,
    //   //   40,
    //   //   20,
    //   // ),
    //   // MissionData(
    //   //   "Information Overload: Study 5 hours straight",
    //   //   MissionType.informationOverload,
    //   //   MissionDifficulty.extreme,
    //   //   100,
    //   //   40,
    //   //   20,
    //   // ),
    // ];
