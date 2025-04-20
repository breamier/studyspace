import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Font styles
final TextStyle kHeadingFont = GoogleFonts.brunoAce(
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/stars.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Today's Study Goals
              const SizedBox(height: 10),
              sectionTitle("Today's Study Goal"),
              const SizedBox(height: 10),
              studyGoalTile(
                '📖 Statistics and Probability',
                'Study Now',
                isToday: true,
              ),
              const SizedBox(height: 30),

// Upcoming Study Goals
              sectionTitle('Upcoming Study Goals'),
              const SizedBox(height: 10),
              studyGoalTile(
                '📖 Automata Theory',
                'Study Now',
                date: '12 / 08 / 2024',
              ),
              studyGoalTile(
                '📖 Software Engineering',
                'Study Now',
                date: '22 / 08 / 2024',
              ),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(
          title,
          style: kHeadingFont.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget studyGoalTile(String title, String buttonText,
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
                  offset: Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          if (isToday)
            Padding(
              padding: const EdgeInsets.only(right: 8),
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
              side: BorderSide(color: kWhite),
              foregroundColor: Colors.white,
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
