import 'package:flutter/material.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await AndroidAlarmManager.initialize();
  await NotifService().initNotification();
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
}
