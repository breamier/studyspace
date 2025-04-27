import 'package:intl/intl.dart';
import 'package:studyspace/services/sm.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/services/sm_response.dart';

class Scheduler {
  Future<void> initializeSessions(Goal goal) async {
    Scheduler scheduler = Scheduler();

    DateTime currentStartDate = goal.start;
    DateTime endDate = goal.end;
    String difficulty = goal.difficulty;
    int reps = goal.reps;
    int interval = goal.interval;
    double easeFactor = goal.easeFactor;

    goal.sessionDates.clear();
    goal.sessionDates.add(currentStartDate);

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
      goal.sessionDates.add(nextDate);

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

    if (!goal.sessionDates.contains(endDate)) {
      goal.sessionDates.add(endDate);
    }

    for (var date in goal.sessionDates) {
      print("Session Date: ${DateFormat('yyyy-MM-dd').format(date)}");
    }
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

    // Create an instance of SM for the calculation
    Sm sm = Sm();
    SmResponse response = sm.calc(
      quality: quality,
      repetitions: previousRepetitions,
      previousInterval: previousInterval,
      previousEaseFactor: previousEaseFactor,
    );

    // Calculate the next review date based on the interval
    DateTime nextReviewDate = startDate.add(Duration(days: response.interval));

    // Ensure the review date doesn't go beyond the end date
    if (nextReviewDate.isAfter(endDate)) {
      nextReviewDate = endDate;
    }

    return nextReviewDate;
  }
}

void main() {
  DateTime startDate = DateTime(2025, 5, 1);
  DateTime endDate = DateTime(2025, 5, 30);
  print(DateTime.now());

  Scheduler scheduler = Scheduler();

  // Simulate the first review with an Easy difficulty
  DateTime nextReview = scheduler.scheduleNextReview(
    startDate: startDate,
    endDate: endDate,
    difficulty: 'medium',
  );

  // Print the next review date
  String formattedDate = DateFormat('yyyy-MM-dd').format(nextReview);
  print("Next review date: $formattedDate");

  // Simulate 2nd Review date

  // Calculate the second review using the results from the first review
  DateTime secondReview = scheduler.scheduleNextReview(
    startDate: nextReview,
    endDate: endDate,
    difficulty: 'easy',
    previousRepetitions: 1,
    previousInterval: 6,
    previousEaseFactor: 2.28,
  );
  String secondReviewFormatted = DateFormat('yyyy-MM-dd').format(secondReview);
  print("Second review date: $secondReviewFormatted");

  // Simulate the 3rd review: Assume quality remains 'easy'

  // Calculate the third review using the results from the second review
  DateTime thirdReview = scheduler.scheduleNextReview(
    startDate: secondReview,
    endDate: endDate,
    difficulty: 'easy',
    previousRepetitions: 2, // Increased repetitions after the second review
    previousInterval: 6, // The interval from the second review
    previousEaseFactor: 2.14, // The easeFactor from the second review
  );
  String thirdReviewFormatted = DateFormat('yyyy-MM-dd').format(thirdReview);
  print("Third review date: $thirdReviewFormatted");
}
