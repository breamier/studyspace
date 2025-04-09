import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Font styles
final TextStyle kHeadingFont = GoogleFonts.brunoAce(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

final TextStyle kBodyFont = GoogleFonts.arimo(
  fontSize: 14,
  color: Colors.white,
);

// Color variables
const Color kPurple = Color(0xFF6C44DD);
const Color kOnyx = Color(0xFF0E0E0E);
const Color kWhite = Colors.white;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline, color: kWhite),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Study Goals
            const SizedBox(height: 10),
            sectionTitle('Current Study Goal'),
            const SizedBox(height: 10),
            studyGoalTile('📖 Statistics and Probability', 'Study Now'),
            const SizedBox(height: 30),

            // Upcoming Study Goals
            sectionTitle('Upcoming Study Goals'),
            const SizedBox(height: 10),
            studyGoalTile('📖 Automata Theory', 'Study Now',
                date: '12 / 08 / 2024'),
            studyGoalTile('📖 Software Engineering', 'Study Now',
                date: '22 / 08 / 2024'),
            const SizedBox(height: 30),

            // Mission Board
            sectionTitle('Mission Board'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: kWhite),
                color: Color.fromARGB(40, 189, 183, 183),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  missionText('Mission 1: Study 30 minutes straight'),
                  missionText('Mission 2: Take a picture'),
                  missionText('Mission 3: Study a total of 1 hour'),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.emoji_emotions_outlined,
                          color: kWhite),
                      label: Text(
                        'Visit your astronaut >>',
                        style: kBodyFont.copyWith(fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      // Navbar
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
                        color: Color(0xB3FFFFFF),
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
