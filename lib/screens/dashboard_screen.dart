import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/models/mission.dart';
import 'package:studyspace/services/isar_service.dart';

// Font styles
final TextStyle kHeadingFont = const TextStyle(
  fontFamily: 'BrunoAce',
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

final TextStyle kBodyFont = const TextStyle(
  fontFamily: 'Arimo',
  fontSize: 14,
  color: Colors.white,
);

// Color variables
const Color kPurple = Color(0xFF6C44DD);
const Color kOnyx = Color(0xFF0E0E0E);
const Color kWhite = Colors.white;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final IsarService _isarService = IsarService();
  late Future<List<Goal>> _goalsFuture;
  late Future<List<Mission>> _missionsFuture;

  final List<String> _allMissions = [
    'Study 30 minutes straight',
    'Take a picture',
    'Study a total of 1 hour',
    'Drink water every 30 mins',
    'Study after 9 PM',
    'Complete 3 study sessions',
  ];

  @override
  void initState() {
    super.initState();
    _refreshGoals();
    _isarService.initializeDailyMissions(_allMissions);
    _missionsFuture = _isarService.getMissions();
  }

  Future<List<Goal>> _fetchGoals() async {
    final isar = await _isarService.db;
    return await isar.goals.where().findAll();
  }

  void _refreshGoals() {
    setState(() {
      _goalsFuture = _fetchGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOnyx,
      appBar: AppBar(
        backgroundColor: kOnyx,
        elevation: 0,
        title: Text(
          'Study Space',
          style: kHeadingFont,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kWhite),
            onPressed: _refreshGoals,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline, color: kWhite),
          ),
        ],
      ),
      body: FutureBuilder<List<Goal>>(
        future: _goalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final goals = snapshot.data ?? [];
          final currentGoals = goals.where((g) => g.isCurrent).toList();
          final upcomingGoals = goals.where((g) => g.isUpcoming).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Study Goals
                if (currentGoals.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  sectionTitle('Current Study Goal'),
                  const SizedBox(height: 10),
                  for (final goal in currentGoals)
                    studyGoalTile(
                      '📖 ${goal.goalName}',
                      'Study Now',
                      date: DateFormat('dd / MM / yyyy').format(goal.end),
                    )
                ] else ...[
                  const SizedBox(height: 10),
                  sectionTitle('Current Study Goal'),
                  const SizedBox(height: 10),
                  const Text(
                    'No current study goals',
                    style: TextStyle(color: Colors.white),
                  ),
                ],

                // Upcoming Study Goals
                if (upcomingGoals.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  sectionTitle('Upcoming Study Goals'),
                  const SizedBox(height: 10),
                  for (final goal in upcomingGoals)
                    studyGoalTile(
                      '📖 ${goal.goalName}',
                      'View',
                      date: DateFormat('dd / MM / yyyy').format(goal.start),
                    ),
                ] else ...[
                  const SizedBox(height: 30),
                  sectionTitle('Upcoming Study Goals'),
                  const SizedBox(height: 10),
                  const Text(
                    'No upcoming study goals',
                    style: TextStyle(color: Colors.white),
                  ),
                ],

                // Mission Board
                const SizedBox(height: 30),
                sectionTitle('Mission Board'),
                const SizedBox(height: 10),
                FutureBuilder<List<Mission>>(
                  future: _missionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final missions = snapshot.data ?? [];
                    final displayedMissions = missions.take(3).toList();

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: kWhite),
                        color: const Color.fromARGB(40, 189, 183, 183),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < displayedMissions.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '${'Mission'} ${i + 1}: ${displayedMissions[i].text}',
                                style: kBodyFont.copyWith(fontSize: 14),
                              ),
                            ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.emoji_emotions_outlined,
                                  color: kWhite, size: 18),
                              label: Text(
                                'Astronaut >>',
                                style: kBodyFont.copyWith(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kOnyx,
        selectedItemColor: kPurple,
        unselectedItemColor: kWhite,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Study Goals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: 'Add Goal'),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: 'Analytics'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: kHeadingFont.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget studyGoalTile(String title, String buttonText, {String? date}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: kWhite),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kBodyFont.copyWith(fontSize: 16)),
                if (date != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Due on $date',
                      style: kBodyFont.copyWith(
                        fontSize: 12,
                        color: const Color(0xB3FFFFFF),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kOnyx,
              side: const BorderSide(color: kWhite),
              foregroundColor: kWhite,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {},
            child: Text(buttonText, style: kBodyFont),
          )
        ],
      ),
    );
  }

  Widget missionText(String mission) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          mission,
          style: kBodyFont.copyWith(fontSize: 14),
        ),
      ),
    );
  }
}
