import 'package:studyspace/models/mission.dart';
import 'package:studyspace/services/isar_service.dart';

class MissionManager {
  final IsarService isarService;

  MissionManager(this.isarService);

  Future<Mission?> checkMissionCompletion(MissionType type) async {
    final missions = await isarService.getMissions();

    try {
      final matchingMission = missions.firstWhere(
        (mission) => mission.type == type && !mission.completed,
      );

      await isarService.completeMission(matchingMission.id);
      return matchingMission;
    } catch (e) {
      return null;
    }
  }

  Future<Mission?> getActiveMissionByType(MissionType type) async {
    final missions = await isarService.getMissions();
    try {
      return missions.firstWhere(
        (mission) => mission.type == type && !mission.completed,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Mission?> completeMissionByType(MissionType type) async {
    final mission = await getActiveMissionByType(type);
    if (mission != null) {
      await isarService.completeMission(mission.id);
    }
    return mission;
  }
}
