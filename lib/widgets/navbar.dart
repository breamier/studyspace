import 'package:flutter/material.dart';
import 'package:studyspace/screens/dashboard_screen.dart'; // index 0
import 'package:studyspace/screens/study_overview_screen.dart'; // index 1
import 'package:studyspace/screens/add_study_goal.dart'; // index 2 (FAB)
import 'package:studyspace/screens/analytics_screen.dart'; // index 3
// import 'package:studyspace/screens/settings_screen.dart';       // index 4

const Color kPurple = Color(0xFF6C44DD);
const Color kOnyx = Color(0xFF0E0E0E);
const Color kWhite = Colors.white;
const Color kDarkGray = Color(0xFF161616);

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _handleNavigation(BuildContext context, int index) {
    Widget screen;

    switch (index) {
      case 0:
        screen = const DashboardScreen();
        break;
      case 1:
        screen = const StudyOverview();
        break;
      case 2:
        screen = const AddStudyGoal();
        break;
      case 3:
        screen = const AnalyticsScreen();
        break;
      // case 4:
      //   screen = const SettingsScreen();
      //   break;
      default:
        screen = const DashboardScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigationBar(
              backgroundColor: kDarkGray,
              selectedItemColor: currentIndex == -1 ? kWhite : kPurple,
              unselectedItemColor: kWhite,
              currentIndex:
                  (currentIndex >= 0 && currentIndex <= 4) ? currentIndex : 0,
              showUnselectedLabels: true,
              onTap: (index) {
                if (index != 2) {
                  _handleNavigation(context, index);
                }
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Goals'),
                BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.analytics), label: 'Analytics'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Settings'),
              ],
            ),
          ),
          Positioned(
            child: GestureDetector(
              onTap: () => _handleNavigation(context, 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kPurple.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Add Goal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
