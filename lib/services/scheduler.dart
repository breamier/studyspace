import 'package:intl/intl.dart';
import 'package:studyspace/services/sm.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/services/sm_response.dart';

class Scheduler {
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
        quality = 4; // Default: EASY
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
}
