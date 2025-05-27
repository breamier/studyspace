import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/models/session.dart';
import 'package:studyspace/services/sm.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/services/sm_response.dart';
import 'package:studyspace/services/isar_service.dart';
import '../services/astro_hp_service.dart';

class Scheduler {
  final IsarService _isarService;
  final AstroHpService _hpService;

  Scheduler()
      : _isarService = IsarService(),
        _hpService = AstroHpService(IsarService());

  Future<List<DateTime>> initializeSessions(Goal goal) async {
    Scheduler scheduler = Scheduler();

    DateTime currentStartDate = goal.start;
    DateTime endDate = goal.end;
    String difficulty = goal.difficulty;
    int reps = goal.reps;
    int interval = goal.interval;
    double easeFactor = goal.easeFactor;

    List<DateTime> sessionDates = [];
    sessionDates.add(currentStartDate);

    while (currentStartDate.isBefore(endDate)) {
      DateTime nextDate = scheduler.scheduleNextReview(
        startDate: currentStartDate,
        endDate: endDate,
        difficulty: difficulty,
        previousRepetitions: reps,
        previousInterval: interval,
        previousEaseFactor: easeFactor,
      );
      print("Current: $currentStartDate - Next: $nextDate");
      sessionDates.add(nextDate);

      Sm sm = Sm();
      SmResponse response = sm.calc(
        quality: mapDifficultyToQuality(goal.difficulty),
        repetitions: reps,
        previousInterval: interval,
        previousEaseFactor: easeFactor,
      );

      reps = response.repetitions;
      interval = response.interval;
      easeFactor = response.easeFactor;

      print("Reps: $reps");
      print("Interval: $interval");
      print("easeFactor: $easeFactor");

      currentStartDate = nextDate;
    }

    if (!sessionDates.contains(endDate)) {
      sessionDates.add(endDate);
    }

    for (var date in sessionDates) {
      print("Session Date: ${DateFormat('yyyy-MM-dd').format(date)}");
    }

    return sessionDates;
  }

  int mapDifficultyToQuality(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 4;
      case 'medium':
        return 3;
      case 'difficult':
        return 2;
      default:
        return 4;
    }
  }

  DateTime scheduleNextReview({
    DateTime? startDate,
    DateTime? endDate,
    String difficulty = "Easy",
    int previousRepetitions = 0,
    int previousInterval = 0,
    double previousEaseFactor = 2.5,
    int quality = 4, // Default: Easy (4)
  }) {
    startDate ??= DateTime.now();
    endDate ??= startDate.add(Duration(days: 30));

    switch (difficulty.toLowerCase()) {
      case 'easy':
        quality = 4;
        break;
      case 'medium':
        quality = 3;
        break;
      case 'difficult':
        quality = 2;
        break;
      default:
        quality = 4;
    }

    Sm sm = Sm();
    SmResponse response = sm.calc(
      quality: quality,
      repetitions: previousRepetitions,
      previousInterval: previousInterval,
      previousEaseFactor: previousEaseFactor,
    );

    DateTime nextReviewDate = startDate.add(Duration(days: response.interval));

    if (nextReviewDate.isAfter(endDate)) {
      nextReviewDate = endDate;
    }

    return nextReviewDate;
  }

  int _calculateSessionDuration(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 30; // 30 minutes
      case 'medium':
        return 45; // 45 minutes
      case 'difficult':
        return 60; // 60 minutes
      default:
        return 30;
    }
  }

  Future<void> completeStudySession({
    required Goal goal,
    required DateTime completedDate,
    required String newDifficulty,
  }) async {
    final today = DateTime(
      completedDate.year,
      completedDate.month,
      completedDate.day,
    );

    // check if scheduled
    final isScheduled = goal.upcomingSessionDates.any((d) =>
        d.year == today.year && d.month == today.month && d.day == today.day);

    // check if completed today
    final alreadyCompletedToday = goal.completedSessionDates.any((d) =>
        d.year == today.year && d.month == today.month && d.day == today.day);

    final isFirstScheduledSessionToday = isScheduled && !alreadyCompletedToday;

    // Always update difficulty
    goal.difficulty = newDifficulty;

    final scheduler = Scheduler();

    // Update SM parameters
    int quality = Scheduler().mapDifficultyToQuality(newDifficulty);

    final sm = Sm();
    final response = sm.calc(
      quality: quality,
      repetitions: goal.reps,
      previousInterval: goal.interval,
      previousEaseFactor: goal.easeFactor,
    );
    // If first session on scheduled date, update SM + recalculate
    if (isFirstScheduledSessionToday) {
      goal.reps = response.repetitions;
      goal.interval = response.interval;
      goal.easeFactor = response.easeFactor;
      goal.difficulty = newDifficulty;

      goal.upcomingSessionDates = await scheduler.initializeSessions(goal);
      print("SM updated. Upcoming session dates recalculated:");
    } else {
      // If not first session, just recalculate upcoming sessions based on new difficulty
      goal.upcomingSessionDates = await scheduler.initializeSessions(goal);
      print("Only upcoming sessions recalculated.");
    }

    // Add completed date
    goal.completedSessionDates.add(today);

    final session = Session()
      ..difficulty = newDifficulty
      ..duration = _calculateSessionDuration(newDifficulty)
      ..start = completedDate
          .subtract(Duration(minutes: _calculateSessionDuration(newDifficulty)))
      ..end = completedDate
      ..goal.value = goal;

    await _hpService.applyStudySessionHp(
      session: session,
      goal: goal,
    );

    await IsarService().updateGoal(goal);

    print(
        "Session completed on $completedDate with '$newDifficulty' difficulty.");
    print("Updated upcoming session dates:");
    for (final d in goal.upcomingSessionDates) {
      print(d.toIso8601String());
    }
  }

  // Postpones the next Study Session
  Future<void> postponeStudySession({required Id goalId}) async {
    final goal = await IsarService().getGoalById(goalId);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (goal!.upcomingSessionDates.length <= 2) {
      return;
    }

    goal.upcomingSessionDates.sort((a, b) => a.compareTo(b));

    final firstDate = goal.upcomingSessionDates.first;
    final lastDate = goal.upcomingSessionDates.last;

    final middleDates = goal.upcomingSessionDates
        .sublist(1, goal.upcomingSessionDates.length - 1);

    if (todayDate.isBefore(middleDates.first)) {
      // Case 1: today < first middle session
      final postponedDate = middleDates.first.add(const Duration(days: 1));
      middleDates[0] = postponedDate;
    } else if (todayDate.isAfter(middleDates.first)) {
      // Case 2: today > first middle session
      final postponedDate = todayDate.add(const Duration(days: 1));
      middleDates.removeWhere((d) => d.isBefore(todayDate));
      middleDates.insert(0, postponedDate);
    } else {
      // Case 3: today == first middle session
      final postponedDate = todayDate.add(const Duration(days: 1));
      middleDates.add(postponedDate);
    }

    final updated = <DateTime>[firstDate, ...middleDates.toSet(), lastDate];
    updated.sort((a, b) => a.compareTo(b));
    goal.upcomingSessionDates = updated;

    await IsarService().updateGoal(goal);

    print("Postponed: updated upcoming dates: ${goal.upcomingSessionDates}");
  }
}
