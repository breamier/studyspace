// lib/services/mission_service.dart
import 'dart:math';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../models/mission.dart';
import '../models/astronaut_pet.dart';

final List<MissionData> dailyMissions = [
  MissionData(
    "Take a picture before a study session",
    MissionType.selfie,
    MissionDifficulty.easy,
    50,
    20,
    10,
  ),
  MissionData(
    "Study 30 minutes straight",
    MissionType.study,
    MissionDifficulty.easy,
    50,
    20,
    10,
  ),
  // new mission here
];

class MissionService {
  final Isar isar;

  MissionService(this.isar);

  String _getTodayKey() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> initializeDailyMissions() async {
    final todayKey = _getTodayKey();

    // 1. Delete old missions that are not completed (in batches)
    final oldMissions = await isar.missions
        .filter()
        .not()
        .dailyKeyEqualTo(todayKey)
        .and()
        .completedEqualTo(false)
        .findAll();

    const batchSize = 50;
    for (var i = 0; i < oldMissions.length; i += batchSize) {
      final batch =
          oldMissions.skip(i).take(batchSize).map((m) => m.id).toList();
      await isar.writeTxn(() async {
        await isar.missions.deleteAll(batch);
      });
    }

    // 2. Delete all today's missions (so we can always add the latest 3)
    final todayMissions =
        await isar.missions.filter().dailyKeyEqualTo(todayKey).findAll();
    if (todayMissions.isNotEmpty) {
      await isar.writeTxn(() async {
        await isar.missions.deleteAll(todayMissions.map((m) => m.id).toList());
      });
    }

    // 3. Add up to 3 missions from dailyMissions
    final missionsToAdd = dailyMissions.take(3).toList();
    await isar.writeTxn(() async {
      for (final missionData in missionsToAdd) {
        final mission = Mission(
          text: missionData.text,
          type: missionData.type,
          difficulty: missionData.difficulty,
          dailyKey: todayKey,
          rewardPoints: missionData.rewardPoints,
          penaltyPoints: missionData.penaltyPoints,
          hpPenalty: missionData.hpPenalty,
          expiryDate: DateTime.now().add(const Duration(days: 1)),
        );
        await isar.missions.put(mission);
      }
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
      // Do NOT start a new transaction here!
      double progressIncrease = mission.rewardPoints / 100.0;
      pet.progress = min(1.0, pet.progress + progressIncrease);
      await isar.astronautPets
          .put(pet); // This is safe, because it's called inside the outer txn
    }
  }

  // Apply mission penalty
  Future<void> _applyMissionPenalty(Mission mission) async {
    final pet = await isar.astronautPets.where().findFirst();
    if (pet != null) {
      // Do NOT start a new transaction here!
      pet.hp = max(0, pet.hp - mission.hpPenalty);
      double progressDecrease = mission.penaltyPoints / 1000.0;
      pet.progress = max(0, pet.progress - progressDecrease);
      await isar.astronautPets.put(pet);
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
      // MissionData(
      //   "Study 30 minutes straight",
      //   MissionType.study,
      //   MissionDifficulty.easy,
      //   50, // reward points
      //   20, // penalty points
      //   10, // hp penalty
      // ),
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
