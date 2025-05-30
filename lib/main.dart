import 'package:flutter/material.dart';
import 'package:studyspace/screens/dashboard_screen.dart';
import 'package:studyspace/screens/splash_screen.dart';
import 'package:studyspace/services/notif_service.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final service = IsarService();
  bool? hasSeenTutorial;
  late IsarService isarService;

  @override
  void initState() {
    super.initState();
    _init();
    // final hpService = AstroHpService(service);

    // Should be run once a day to check for missed sessions || comment out to test
    //hpService.checkMissedSessions();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('hasSeenTutorial') ?? false;
    isarService = IsarService();
    await NotifService().initNotification();
    await isarService.initializeDailyMissions();

    final notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    if (notificationsEnabled) {
      await NotifService().scheduleDailyCustomNotifications();
    }
    setState(() {
      hasSeenTutorial = seen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasSeenTutorial == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return hasSeenTutorial!
        ? DashboardScreen(isar: isarService)
        : SplashScreen(isar: isarService);
  }
}
