import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:studyspace/services/notif_service.dart';
import 'package:studyspace/screens/replenished_astronaut_screen.dart';
import 'package:studyspace/screens/splash_screen.dart';
import 'package:studyspace/study-session/study_session.dart';
import 'package:studyspace/study-session/study_session_camera.dart';
import 'screens/dashboard_screen.dart';
import 'package:studyspace/services/isar_service.dart';
import 'screens/astronaut_pet_screen.dart';
import 'screens/astronaut_traveling_screen.dart';
import 'services/scheduler.dart';
import 'services/astro_hp_service.dart';

import './models/goal.dart';
import './models/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isarService = IsarService();
  // await AndroidAlarmManager.initialize();
  await NotifService().initNotification();
  await isarService.initializeDailyMissions();

  runApp(const StudySpaceApp());
}

class StudySpaceApp extends StatelessWidget {
  const StudySpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Space',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  final isar = IsarService();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final service = IsarService();

  @override
  void initState() {
    super.initState();
    IsarService().initializeDefaultPet();
    final hpService = AstroHpService(service);
    //_checkCompletedSessions();
    hpService.checkMissedSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Study Space Home'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  NotifService().scheduleDailyCustomNotifications();
                },
                child: const Text('Schedule Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  NotifService().scheduleNotification(
                      title: "TEST",
                      body: "Scheduled",
                      dateTime:
                          DateTime(2025, 5, 17, 22, 54)); // change time to test
                },
                child: const Text('Schedule single Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  NotifService().printScheduledNotifications();
                },
                child: const Text('Show Scheduled Notifications'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final goal = await IsarService().getFirstGoal();

                  if (goal == null || goal.upcomingSessionDates.isEmpty) {
                    print("Goal or sessions not found.");
                    return;
                  }

                  final completedDate = goal.upcomingSessionDates.first;
                  const newDifficulty = 'medium'; // simulate difficulty

                  await Scheduler().completeStudySession(
                    goal: goal,
                    completedDate: completedDate,
                    newDifficulty: newDifficulty,
                  );
                },
                child: Text("Simulate Study Session"),
              ),
              ElevatedButton(
                onPressed: _testHpSystem,
                child: Text('Test HP System'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudySessionCamera(
                                goalId: 1,
                              )),
                    );
                  },
                  child: const Text("StudySession")),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DashboardScreen(isar: widget.isar)),
                  );
                },
                child: const Text('Go to Dashboard'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SplashScreen(isar: widget.isar)),
                  );
                },
                child: const Text('Go to Splash Screen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudySession(
                              goalId: 1,
                              imgLoc: "",
                            )),
                  );
                },
                child: const Text('Go to Study Session'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AstronautPetScreen(isar: widget.isar)),
                  );
                },
                child: const Text('Go to Astronaut Pet Screen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AstronautTravelScreen(isar: widget.isar)),
                  );
                },
                child: const Text('Go to Astronaut Traveling Screen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ReplenishedAstronautScreen()),
                  );
                },
                child: const Text('Go to Replenished Astronaut Screen'),
              ),
              ElevatedButton(
                onPressed: () {
                  NotifService().showNotification(
                    title: "Study Space 🌌",
                    body: "🌠 Study stars are aligning just for you!",
                  );
                },
                child: const Text('Show Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.isar.clearDb();
                },
                child: const Text('Clear Database'),
              )
            ])));
  }

  Future<void> _testHpSystem() async {
    final isarService = IsarService();
    final hpService = AstroHpService(isarService);

    // DON'T reset the database - we want to keep existing state
    // Only initialize pet if it doesn't exist
    var pet = await isarService.getCurrentPet();
    if (pet == null) {
      await isarService.initializeDefaultPet();
      pet = await isarService.getCurrentPet();
    }

    print('Current HP before test: ${pet?.hp}');

    final now = DateTime.now();
    final testId = now.millisecondsSinceEpoch;

    // TEST 1: HP INCREASE - Create and complete a session
    final goal = Goal()
      ..goalName = "Test Goal $testId"
      ..start = now.subtract(Duration(days: 1))
      ..end = now.add(Duration(days: 7))
      ..difficulty = "Medium"
      ..reps = 1
      ..interval = 1
      ..easeFactor = 2.5
      ..upcomingSessionDates = [now];

    final session = Session()
      ..difficulty = "Medium"
      ..duration = 45
      ..start = now.subtract(Duration(minutes: 45))
      ..end = now
      ..imgPath = "test_path_$testId"
      ..goal.value = goal;

    // Save to database
    final isar = await isarService.db;
    await isar.writeTxn(() async {
      await isar.goals.put(goal);
      await isar.sessions.put(session);
      await session.goal.save();
      await goal.sessions.save();
    });

    // Apply HP increase
    await hpService.applyStudySessionHp(session: session, goal: goal);

    /* START: COMMENT THIS IF YOU WANT TO TEST HP INCREASE */

    // // TEST 2: HP DECREASE - Create a missed session
    // final missedGoal = Goal()
    //   ..goalName = "Missed Goal $testId"
    //   ..start = now.subtract(Duration(days: 3))
    //   ..end = now.add(Duration(days: 5))
    //   ..difficulty = "Medium"
    //   ..reps = 2
    //   ..interval = 2
    //   ..easeFactor = 2.3
    //   ..upcomingSessionDates = [now.subtract(Duration(days: 1))];

    // await isar.writeTxn(() => isar.goals.put(missedGoal));
    // await hpService.checkMissedSessions();

    /* END: COMMENT THIS IF YOU WANT TO TEST HP INCREASE */

    // Get updated pet
    pet = await isarService.getCurrentPet();
    print('New HP after test: ${pet?.hp}');
  }
}
