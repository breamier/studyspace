// lib/models/mission.dart
import 'package:isar/isar.dart';

part 'mission.g.dart';

@Collection()
class Mission {
  Id id = Isar.autoIncrement;

  late String text;

  @Enumerated(EnumType.name)
  late MissionType type;

  @Enumerated(EnumType.name)
  late MissionDifficulty difficulty;
  bool completed = false;
  DateTime? completedDate;
  late String dailyKey;

  late int rewardPoints;
  late int penaltyPoints;
  late int hpPenalty;

  late bool isActive;
  DateTime? expiryDate;

  Mission({
    required this.text,
    this.type = MissionType.minor,
    this.difficulty = MissionDifficulty.easy,
    this.completed = false,
    this.completedDate,
    required this.dailyKey,
    required this.rewardPoints,
    required this.penaltyPoints,
    required this.hpPenalty,
    this.isActive = true,
    this.expiryDate,
  });

  @Index()
  String get dailyKeyIndex => dailyKey;
}

enum MissionType {
  study,
  minor,
  selfie,
  travel,
  purchase,
  deepMindFocus,
  informationOverload,
}

enum MissionDifficulty {
  easy,
  medium,
  hard,
  extreme,
}
