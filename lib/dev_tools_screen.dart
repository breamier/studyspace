import 'package:flutter/material.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/models/session.dart';
import 'package:studyspace/screens/astronaut_pet_screen.dart';
import 'package:studyspace/screens/astronaut_traveling_screen.dart';
import 'package:studyspace/screens/dashboard_screen.dart';
import 'package:studyspace/screens/replenished_astronaut_screen.dart';
import 'package:studyspace/screens/splash_screen.dart';
import 'package:studyspace/services/astro_hp_service.dart';
import 'package:studyspace/services/notif_service.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/services/scheduler.dart';
import 'package:studyspace/study-session/study_session.dart';
import 'package:studyspace/study-session/study_session_camera.dart';

class DevToolsScreen extends StatefulWidget {
  final IsarService isar;
  const DevToolsScreen({super.key, required this.isar});

  @override
  State<DevToolsScreen> createState() => _DevToolsScreenState();
}

class _DevToolsScreenState extends State<DevToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Tools'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await NotifService().scheduleDailyCustomNotifications();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Scheduled notifications!')),
                  );
                },
                child: const Text('Test Schedule Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  NotifService().printScheduledNotifications();
                },
                child: const Text('Show Scheduled Notifications'),
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await NotifService().cancelAllNotifications();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Cancelled all notifications!')),
                  );
                },
                child: const Text('Test Cancel Notifications'),
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
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await widget.isar.clearDb();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Database cleared!')),
                  );
                },
                child: const Text('Test Clear Database'),
              ),
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
                onPressed: () async {
                  await widget.isar.resetAllMissions();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("All missions have been reset!")),
                  );
                },
                child: const Text('Reset All Missions'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pet = await widget.isar.getCurrentPet();
                  if (pet != null) {
                    pet.progress = 0.0;
                    await widget.isar.updatePet(pet);
                    setState(() {});
                  }
                },
                child: Text("Reset Pet Progress"),
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
                onPressed: () async {
                  final goal = await widget.isar.getFirstGoal();
                  if (goal == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "No goals found. Please create a goal first.")),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudySession(
                            goalId: 1, imgLoc: "", isarService: widget.isar)),
                  );
                },
                child: const Text('Go to Study Session'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pet = await widget.isar.getCurrentPet();
                  if (pet == null || pet.planetsCount == 0) {
                    // Go to pet screen if no planets visited yet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AstronautPetScreen(isar: widget.isar),
                      ),
                    ).then((_) => setState(() {}));
                  } else {
                    // go to traveling screen and force arrived view if planetCount is >=1
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AstronautTravelScreen(
                          isar: widget.isar,
                          forceArrived: true,
                        ),
                      ),
                    );
                  }
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
                onPressed: _testHpSystem,
                child: Text('Test HP'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final goal = await widget.isar.getFirstGoal();
                    if (goal == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "No goals found. Please create a goal first.")),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudySessionCamera(
                                goalId: 1,
                                isarService: widget.isar,
                              )),
                    );
                  },
                  child: const Text("StudySession")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _testHpSystem() async {
    final isarService = IsarService();
    final hpService = AstroHpService(isarService);

    // DON'T reset the database - we want to keep existing state

    // only initialize pet if it doesn't exist
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

    /* START: COMMENT THIS IF YOU WANT TO TEST HP DECREASE */

    // TEST 2: HP DECREASE - Create a missed session
    final missedGoal = Goal()
      ..goalName = "Missed Goal $testId"
      ..start = now.subtract(Duration(days: 3))
      ..end = now.add(Duration(days: 5))
      ..difficulty = "Medium"
      ..reps = 2
      ..interval = 2
      ..easeFactor = 2.3
      ..upcomingSessionDates = [now.subtract(Duration(days: 1))];

    await isar.writeTxn(() => isar.goals.put(missedGoal));
    await hpService.checkMissedSessions();

    /* END: COMMENT THIS IF YOU WANT TO TEST HP DECREASE */

    // Get updated pet
    pet = await isarService.getCurrentPet();
    print('New HP after test: ${pet?.hp}');
  }
}
