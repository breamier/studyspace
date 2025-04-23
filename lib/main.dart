import 'package:flutter/material.dart';
import 'package:studyspace/screens/add_study_goal.dart';
import 'package:studyspace/splash_screen.dart';
import 'package:studyspace/study-session/study_session_camera.dart';
import 'screens/dashboard_screen.dart';
import 'screens/study_overview_screen.dart';
import 'information_screen.dart';
import 'package:studyspace/services/isar_service.dart';
import 'screens/analytics_screen.dart';
import 'astronaut_pet_screen.dart';

void main() async {
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudySessionCamera()),
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
                        builder: (context) => const AstronautPetScreen()),
                  );
                },
                child: const Text('Go to Astronaut Pet Screen Screen'),
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
