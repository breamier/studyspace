import 'package:studyspace/models/mission.dart';
import 'package:studyspace/services/isar_service.dart';

class MissionManager {
  final IsarService isarService;

  MissionManager(this.isarService);

  Future<Mission?> checkMissionCompletion(MissionType type) async {
    final missions = await isarService.getMissions();
    print("Today's missions:");
    for (final m in missions) {
      print(
          '${m.text} | type: ${m.type} | completed: ${m.completed} | dailyKey: ${m.dailyKey}');
    }
    try {
      final matchingMission = missions.firstWhere(
        (m) => m.type == type && !m.completed,
      );
      await isarService.completeMission(matchingMission.id);

      // fetch the updated mission from the db
      final updatedMission =
          await isarService.getMissionById(matchingMission.id);
      print(
          'Updated mission: $updatedMission, completed: ${updatedMission?.completed}');
      return updatedMission;
    } catch (e, stack) {
      print('Error in checkMissionCompletion: $e');
      print(stack);
      return null;
    }
  }

  Future<Mission?> completeMissionByType(MissionType type) async {
    final missions = await isarService.getMissions();
    final mission =
        missions.where((m) => m.type == type && !m.completed).toList();
    if (mission.isNotEmpty) {
      final m = mission.first;
      await isarService.completeMission(m.id);
      m.completed = true;
      return m;
    }
    return null;
  }
}
