//imports
import 'package:flutter/material.dart';

//models
//import 'package:studyspace/models/astronaut_pet.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/models/session.dart';

//services
import 'package:studyspace/services/isar_service.dart';

class AstroHpService {
  // Base HP values
  static const double maxHp = 100.0;
  static const double minHp = 0.0;
  static const double baseIncrease = 5.0;

  // Difficulty modifiers
  static const Map<String, double> difficultyModifiers = {
    'Easy': 1.0,
    'Medium': 1.5,
    'Difficult': 2.0,
  };

  final IsarService _isarService;

  AstroHpService(this._isarService);

  // Calculate HP increase after study session
  Future<double> calculateHpIncrease({
    required Session session,
    required Goal goal,
  }) async {
    final durationHours = session.duration / 60.0;

    final difficultyMultiplier = difficultyModifiers[goal.difficulty] ?? 1.0;

    final repsFactor = 1 + (0.1 * goal.reps); // More reps = more effort
    final intervalFactor =
        1 + (0.05 * goal.interval); // Longer intervals = more valuable
    final easeFactor = goal.easeFactor / 2.5;

    // base HP increase with spaced repetition factors
    double hpIncrease = baseIncrease *
        durationHours *
        difficultyMultiplier *
        repsFactor *
        intervalFactor *
        easeFactor;

    return hpIncrease.clamp(0, maxHp * 0.25);
  }

  // Calculate HP penalty for missed sessions
  Future<double> calculateHpPenalty({
    required Goal goal,
    required int daysLate,
  }) async {
    // Get difficulty multiplier (harder goals penalize more)
    final difficultyMultiplier = difficultyModifiers[goal.difficulty] ?? 1.0;

    // SM-2 algorithm factors
    final repsPenalty = 1 + (0.05 * goal.reps); // More reps = bigger penalty
    final intervalPenalty =
        1 + (0.1 * goal.interval); // Longer intervals = bigger penalty
    final easePenalty = 2.5 / goal.easeFactor; // Lower ease = bigger penalty

    double hpDecrease = 2.0 * // Base penalty
        daysLate *
        difficultyMultiplier *
        repsPenalty *
        intervalPenalty *
        easePenalty;

    return hpDecrease.clamp(0, maxHp * 0.2);
  }

  Future<void> applyStudySessionHp({
    required Session session,
    required Goal goal,
  }) async {
    final pet = await _isarService.getCurrentPet();
    if (pet == null) return;

    final hpIncrease = await calculateHpIncrease(
      session: session,
      goal: goal,
    );

    print('[HP] Increasing HP by $hpIncrease for ${goal.goalName}');
    print('[HP] Session duration: ${session.duration} minutes');
    print(
        '[HP] Goal factors - reps: ${goal.reps}, interval: ${goal.interval}, ease: ${goal.easeFactor}');

    pet.hp = (pet.hp + hpIncrease).clamp(minHp, maxHp);
    pet.isAlive = pet.hp > 0;

    await _isarService.updatePet(pet);
    print('[HP] Updated pet HP to: ${pet.hp}');
  }

  Future<void> checkMissedSessions() async {
    debugPrint('--- Checking missed sessions ---');
    final now = DateTime.now();
    final pet = await _isarService.getCurrentPet();
    if (pet == null) {
      debugPrint('No pet found!');
      return;
    }

    debugPrint('Current pet HP: ${pet.hp}');
    final goals = await _isarService.getAllGoals();

    for (final goal in goals) {
      if (!goal.isCurrent || goal.upcomingSessionDates.isEmpty) continue;

      final nextSessionDate = goal.upcomingSessionDates.first;
      if (nextSessionDate.isBefore(now)) {
        final daysLate = now.difference(nextSessionDate).inDays;
        if (daysLate > 0) {
          final hpDecrease = await calculateHpPenalty(
            goal: goal,
            daysLate: daysLate,
          );

          debugPrint(
              '[HP] Decreasing HP by $hpDecrease for missed session in ${goal.goalName}');
          debugPrint(
              '[HP] Days late: $daysLate, Goal factors - reps: ${goal.reps}, interval: ${goal.interval}, ease: ${goal.easeFactor}');

          pet.hp = (pet.hp - hpDecrease).clamp(minHp, maxHp);
          pet.isAlive = pet.hp > 0;
        }
      }
    }

    await _isarService.updatePet(pet);
    debugPrint('Final pet HP: ${pet.hp}');
  }

  // Get HP color based on current percentage
  static Color getHpColor(double hpPercent) {
    if (hpPercent >= 0.8) return Colors.green;
    if (hpPercent >= 0.5) return Colors.yellow;
    return Colors.red;
  }
}
