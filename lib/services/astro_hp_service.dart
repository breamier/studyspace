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
    'Medium': 1.2,
    'Difficult': 1.5,
  };

  final IsarService _isarService;

  AstroHpService(this._isarService);

  // Calculate HP increase after study session
  Future<double> calculateHpIncrease({
    required Session session,
    required Goal goal,
  }) async {
    // Convert duration to hours (e.g. 90 minutes -> 1.5 hours)
    final durationHours = session.duration / 60.0;

    // Get difficulty multiplier
    final difficultyMultiplier = difficultyModifiers[goal.difficulty] ?? 1.0;

    // SM-2 factor adjustment (using test values if not implemented yet)
    final reps = goal.reps;
    final repetitionPenalty = 1 / (1 + (0.1 * reps));

    // Calculate base HP increase
    double hpIncrease =
        baseIncrease * durationHours * difficultyMultiplier * repetitionPenalty;

    // Cap at max possible increase (20% of max HP per session)
    return hpIncrease.clamp(0, maxHp * 0.2);
  }

  // Calculate HP penalty for missed sessions
  Future<double> calculateHpPenalty({
    required Goal goal,
    required int daysLate,
  }) async {
    // Get difficulty multiplier
    final difficultyMultiplier = difficultyModifiers[goal.difficulty] ?? 1.0;

    // SM-2 factor adjustments (using test values)
    final interval = goal.interval;
    final easeFactor = goal.easeFactor;

    final intervalPenalty = 1 + (0.05 * interval);
    final easeFactorPenalty = 2.5 / easeFactor;

    // Base penalty (3% per day late)
    double hpDecrease = 3.0 *
        daysLate *
        difficultyMultiplier *
        intervalPenalty *
        easeFactorPenalty;

    // Cap at max penalty (15% of max HP)
    return hpDecrease.clamp(0, maxHp * 0.15);
  }

  // Apply HP changes after study session
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

    pet.hp = (pet.hp + hpIncrease).clamp(minHp, maxHp);
    pet.isAlive = pet.hp > 0;

    await _isarService.updatePet(pet);
  }

  // Check for missed sessions and apply penalties
  Future<void> checkMissedSessions() async {
    print('--- Checking missed sessions ---');
    final now = DateTime.now();
    final pet = await _isarService.getCurrentPet();
    if (pet == null) {
      print('No pet found!');
      return;
    }

    print('Current pet HP: ${pet.hp}');
    final goals = await _isarService.getAllGoals();
    print('Found ${goals.length} goals to check');

    for (final goal in goals) {
      print('\nChecking goal: ${goal.goalName}');
      print('Next session date: ${goal.upcomingSessionDates.firstOrNull}');

      if (goal.isCurrent &&
          goal.upcomingSessionDates.isNotEmpty &&
          goal.upcomingSessionDates.first.isBefore(now)) {
        final daysLate = now.difference(goal.upcomingSessionDates.first).inDays;
        print('Found missed session! Days late: $daysLate');

        if (daysLate > 0) {
          final hpDecrease = await calculateHpPenalty(
            goal: goal,
            daysLate: daysLate,
          );
          print('Calculated HP decrease: $hpDecrease');

          pet.hp = (pet.hp - hpDecrease).clamp(minHp, maxHp);
          pet.isAlive = pet.hp > 0;
          print('New HP: ${pet.hp}');
        }
      }
    }

    await _isarService.updatePet(pet);
    print('Final pet HP saved: ${pet.hp}');
  }

  // Get HP color based on current percentage
  static Color getHpColor(double hpPercent) {
    if (hpPercent >= 0.8) return Colors.green;
    if (hpPercent >= 0.5) return Colors.yellow;
    return Colors.red;
  }
}
