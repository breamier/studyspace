import 'package:studyspace/services/isar_service.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color kPurple = Color(0xFF6C44DD);
const Color kOnyx = Color(0xFF0E0E0E);
const Color kWhite = Colors.white;
const Color kYellow = Color(0x55C2A400);
const Color kGreen = Color(0x5540973A);
const Color kRed = Color(0x5443020C);
const Color kBrown = Color(0x554D372E);

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
    final allSessionsCount = await getTotalSessionsCompleted();
    print("Average Session Duration: ${total ~/ allSessionsCount}");
    return total ~/ allSessionsCount;
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

  Future<List<Map<String, dynamic>>> getStudySchedule() async {
    final goals = await isar.getAllGoals();
    final now = DateTime.now();
    final schedule = <Map<String, dynamic>>[];

    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final goal in goals) {
      for (final date in goal.upcomingSessionDates) {
        if (date.isBefore(now)) continue;

        final label = getDateLabel(date);
        grouped.putIfAbsent(label, () => []);

        final totalSessions = goal.upcomingSessionDates.length +
            goal.completedSessionDates.length;
        final completed = goal.completedSessionDates.length;
        final progress = totalSessions > 0 ? completed / totalSessions : 0.0;

        print("Progress: $progress");

        final title = goal.goalName;

        grouped[label]!.add({
          'title': title,
          'date': formatDate(goal.end),
          'color': colorForGoal(title),
          'progress': progress,
        });
      }
    }
    grouped.forEach((label, lessons) {
      schedule.add({'label': label, 'lessons': lessons});
    });

    return schedule;
  }

  getDateLabel(DateTime date) {
    DateTime now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'TODAY';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day + 1) {
      return 'TOMORROW';
    }
    return '${monthAbbrev(date.month)} ${date.day}';
  }

  String monthAbbrev(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }

  colorForGoal(String title) {
    const colors = [kYellow, kGreen, kRed, kBrown, kPurple, kOnyx];
    final hash = title.hashCode;
    final index = hash.abs() % colors.length;
    return colors[index];
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('MMMM d, y');
    return formatter.format(date);
  }
}
