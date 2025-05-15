import 'package:flutter/material.dart';
import 'package:studyspace/screens/add_study_goal.dart';
import 'package:studyspace/services/notif_service.dart';
import 'package:studyspace/screens/replenished_astronaut_screen.dart';
import 'package:studyspace/screens/splash_screen.dart';
import 'package:studyspace/study-session/study_session.dart';
import 'package:studyspace/study-session/study_session_camera.dart';
import 'screens/dashboard_screen.dart';
import 'screens/study_overview_screen.dart';
import 'screens/information_screen.dart';
import 'package:studyspace/services/isar_service.dart';
import 'screens/analytics_screen.dart';
import 'screens/astronaut_pet_screen.dart';
import 'screens/astronaut_traveling_screen.dart';
import 'services/scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  final service = IsarService();

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
                        builder: (context) => const DashboardScreen()),
                  );
                },
                child: const Text('Go to Dashboard'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudyOverview()),
                  );
                },
                child: const Text('Go to Study Overview'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                  );
                },
                child: const Text('Go to Splash Screen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddStudyGoal()),
                  );
                },
                child: const Text('Add Study Goal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnalyticsScreen()),
                  );
                },
                child: const Text('Go to Analytics Screen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InformationScreen()),
                  );
                },
                child: const Text('Go to Information Screen'),
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
                        builder: (context) => const AstronautPetScreen()),
                  );
                },
                child: const Text('Go to Astronaut Pet Screen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AstronautTravelScreen()),
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
                      title: "Study Space", body: "Learn Now!");
                },
                child: const Text('Show Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.service.clearDb();
                },
                child: const Text('Clear Database'),
              )
            ])));
  }
}
