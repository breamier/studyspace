import 'package:studyspace/services/isar_service.dart';
// import 'package:studyspace/models/goal.dart';
// import 'package:studyspace/models/session.dart';
import 'dart:math';

class Analytics {
  final IsarService isar;

  Analytics(this.isar);

  Future<int> getTotalLearningGoals() async {
    final goals = await isar.getAllGoals();
    print("Total Learning Goals: ${goals.length}");
    return goals.length;
  }

  Future<int> getTotalSessionsCompleted() async {
    final allGoals = await isar.getAllGoals();
    int totalSessions = allGoals.fold<int>(
      0,
      (sum, goal) => sum + goal.completedSessionDates.length,
    );
    print("Total Sessions Completed: $totalSessions");
    return totalSessions;
  }

  Future<int> getTotalStudyTime() async {
    final allSessions = await isar.getAllSessions();
    int total = 0;
    for (var session in allSessions) {
      total += session.duration;
    }
    print("Total Study Time: $total");
    return total;
  }

  Future<int> getAverageSessionDuration() async {
    final allSessions = await isar.getAllSessions();
    if (allSessions.isEmpty) return 0;
    final total = await getTotalStudyTime();
    print("Average Session Duration: ${total ~/ allSessions.length}");
    return total ~/ allSessions.length;
  }

  Future<int> getFocusStreak() async {
    final allGoals = await isar.getAllGoals();
    final dateSet = <DateTime>{};

    for (var goal in allGoals) {
      dateSet.addAll(goal.completedSessionDates
          .map((d) => DateTime(d.year, d.month, d.day)));
    }

    final sortedDates = dateSet.toList()..sort();
    if (sortedDates.isEmpty) return 0;

    int streak = 1;
    int maxStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
      if (diff == 1) {
        streak++;
        maxStreak = max(maxStreak, streak);
      } else if (diff > 1) {
        streak = 1;
      }
    }
    print("Streak: $maxStreak");

    return maxStreak;
  }

  Future<int> getLongestStudySession() async {
    final allSessions = await isar.getAllSessions();
    int longest = 0;

    for (var session in allSessions) {
      final durationLength = session.duration;
      if (durationLength > longest) {
        longest = durationLength;
      }
    }
    print("Longest Study Session: $longest");

    return longest;
  }

  String formatTimeHourAndMinutes(int totalTime) {
    Duration duration = Duration(seconds: totalTime);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String formatStreak(int days) {
    if (days > 1) {
      return '$days days';
    } else if (days == 1) {
      return '$days day';
    } else {
      return 'No streak';
    }
  }

  Future<List<List<String>>> getStatsSummary() async {
    final totalGoals = await getTotalLearningGoals();
    final sessions = await getTotalSessionsCompleted();
    final studyTime = await getTotalStudyTime();
    final avgDuration = await getAverageSessionDuration();
    final streak = await getFocusStreak();
    final longest = await getLongestStudySession();

    return [
      ['Total Learning Goals', totalGoals.toString()],
      ['Sessions Completed', sessions.toString()],
      ['Total Study Time', formatTimeHourAndMinutes(studyTime)],
      ['Avg Session Duration', formatTimeHourAndMinutes(avgDuration)],
      ['Focus Streak', formatStreak(streak)],
      ['Longest Study Session', formatTimeHourAndMinutes(longest)],
    ];
  }
}
