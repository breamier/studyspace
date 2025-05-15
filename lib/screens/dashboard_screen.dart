import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/models/mission.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/screens/study_overview_screen.dart';
import 'package:studyspace/screens/add_study_goal.dart';
import 'package:studyspace/screens/analytics_screen.dart';
import 'package:studyspace/screens/information_screen.dart';
import 'package:studyspace/screens/astronaut_pet_screen.dart';
import '../study-session/study_session_camera.dart';
import '../widgets/navbar.dart';

// Font styles
final TextStyle kHeadingFont = const TextStyle(
  fontFamily: 'BrunoAceSC',
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(
      blurRadius: 10.0,
      color: Colors.white,
      offset: Offset(0, 0),
    ),
    Shadow(
      blurRadius: 20.0,
      color: kPurple,
      offset: Offset(0, 0),
    ),
  ],
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
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        setState(() {
          _selectedIndex = index;
        });
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudyOverview()),
        ).then((_) => setState(() => _selectedIndex = 0));
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddStudyGoal()),
        ).then((_) => setState(() => _selectedIndex = 0));
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
        ).then((_) => setState(() => _selectedIndex = 0));
        break;
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings screen coming soon!')),
        );
        setState(() {
          _selectedIndex = 0;
        });
        break;
    }
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
            IconButton(
              icon: const Icon(Icons.help_outline, color: kWhite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InformationScreen()),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/stars.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder<List<Goal>>(
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
                      sectionTitle("Today's Study Goal"),
                      const SizedBox(height: 10),
                      for (final goal in currentGoals)
                        studyGoalTile(
                          '📖 ${goal.goalName}',
                          'Study Now',
                          goal.id,
                          date: DateFormat('dd / MM / yyyy').format(goal.end),
                          isToday:
                              DateUtils.isSameDay(goal.end, DateTime.now()),
                        )
                    ] else ...[
                      // Today's Study Goals
                      const SizedBox(height: 10),
                      sectionTitle("Today's Study Goal"),
                      const SizedBox(height: 10),
                      const Text(
                        'No study goals today',
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
                          goal.id,
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AstronautPetScreen()),
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.emoji_emotions_outlined,
                                      color: kWhite,
                                      size: 18),
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
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 0,
          onTap: (index) {
            if (index != 3) {
              Navigator.pop(context);
            }
          },
        ));
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: kHeadingFont.copyWith(
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget studyGoalTile(String title, String buttonText, Id goalId,
      {String? date, bool isToday = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isToday
            ? const Color.fromARGB(201, 244, 244, 244).withOpacity(0.1)
            : Colors.transparent,
        border: Border.all(
          color: isToday ? kPurple : kWhite,
          width: isToday ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 229, 220, 255).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          if (isToday)
            const Padding(
              padding: EdgeInsets.only(right: 8),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kBodyFont.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
                ),
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
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => StudySessionCamera(goalId: goalId,)));
            },
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
