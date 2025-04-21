import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPurple = Color(0xFF6C44DD);
const Color kOnyx = Color(0xFF0E0E0E);
const Color kWhite = Colors.white;
const Color kYellow = Color(0x55C2A400);
const Color kGreen = Color(0x5540973A);
const Color kRed = Color(0x5443020C);
const Color kBrown = Color(0x554D372E);

final TextStyle kHeadingFont = GoogleFonts.brunoAce(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(blurRadius: 10.0, color: Colors.white, offset: Offset(0, 0)),
    Shadow(blurRadius: 20.0, color: kPurple, offset: Offset(0, 0)),
  ],
);

final TextStyle kBodyFont = GoogleFonts.arimo(
  fontSize: 14,
  color: Colors.white,
);

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final List<Map<String, dynamic>> studySchedule = [
    {
      'label': 'TODAY',
      'lessons': [
        {
          'title': 'Subprograms',
          'subject': 'CMSC 131',
          'color': kGreen,
          'progress': 0.7
        },
        {
          'title': 'Communication',
          'subject': 'CMSC 134',
          'color': kYellow,
          'progress': 0.3
        },
      ],
    },
    {
      'label': 'TOMORROW',
      'lessons': [
        {
          'title': 'Conditional Pr...',
          'subject': 'STAT 105',
          'color': kRed,
          'progress': 0.0
        },
        {
          'title': 'Basic concept...',
          'subject': 'STAT 105',
          'color': kBrown,
          'progress': 0.1
        },
        {
          'title': 'Probability fun...',
          'subject': 'STAT 105',
          'color': kRed,
          'progress': 0.0
        },
      ],
    },
    {
      'label': 'APR 22',
      'lessons': [
        {
          'title': 'Loops Review',
          'subject': 'CMSC 131',
          'color': kGreen,
          'progress': 0.5
        },
        {
          'title': 'ANOVA',
          'subject': 'STAT 105',
          'color': kBrown,
          'progress': 0.4
        },
      ],
    },
    {
      'label': 'APR 23',
      'lessons': [
        {
          'title': 'Function Calls',
          'subject': 'CMSC 131',
          'color': kGreen,
          'progress': 1.0
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOnyx,
      appBar: AppBar(
        backgroundColor: kOnyx,
        elevation: 0,
        title: Text('Analytics', style: kHeadingFont.copyWith(fontSize: 18)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/stars.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            analyticsUnsavedBanner(),
            const SizedBox(height: 20),
            daySection(),
            const SizedBox(height: 20),
            statsGrid(),
            const SizedBox(height: 24),
            seeFinishedGoalsButton(),
          ],
        ),
      ),
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

  Widget analyticsUnsavedBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kPurple.withOpacity(0.2),
        border: Border.all(color: kPurple),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: kWhite),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Analytics Unsaved\nLogin to save and sync data',
              style: kBodyFont.copyWith(color: kWhite),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kWhite,
              foregroundColor: kPurple,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Login'),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.close, color: kWhite),
        ],
      ),
    );
  }

  bool _isExpanded = false;

  Widget daySection() {
    final displayedDays =
        _isExpanded ? studySchedule : studySchedule.take(2).toList();

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: kPurple),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _isExpanded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: displayedDays.map((day) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle(day['label']),
                        const SizedBox(height: 8),
                        wrapChips(
                            (day['lessons'] as List).map<Widget>((lesson) {
                          return lessonChip(
                            lesson['title'],
                            lesson['subject'],
                            lesson['color'],
                            progress: lesson['progress'],
                          );
                        }).toList()),
                      ],
                    ),
                  );
                }).toList(),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayedDays.map((day) {
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle(day['label']),
                          const SizedBox(height: 8),
                          wrapChips(
                              (day['lessons'] as List).map<Widget>((lesson) {
                            return lessonChip(
                              lesson['title'],
                              lesson['subject'],
                              lesson['color'],
                              progress: lesson['progress'],
                            );
                          }).toList()),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Text(text, style: kHeadingFont.copyWith(fontSize: 16, shadows: []));
  }

  Widget lessonChip(String title, String subject, Color color,
      {double progress = 0.5}) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: kBodyFont.copyWith(
                  color: kWhite, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subject, style: kBodyFont.copyWith(fontSize: 12)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress < 0.3
                    ? Colors.red
                    : progress < 0.7
                        ? Colors.yellow
                        : const Color.fromARGB(255, 0, 255, 8),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget wrapChips(List<Widget> chips) {
    return Wrap(children: chips);
  }

  Widget statsGrid() {
    final stats = [
      ['Total Learning Goals', '5'],
      ['Sessions Completed', '9'],
      ['Total Study Time', '14h 34m'],
      ['Avg Session Duration', '1h 35m'],
      ['Focus Streak', '4 days'],
      ['Longest Study Session', '3h 20m'],
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.6,
      children: stats.map((s) => statCard(s[0], s[1])).toList(),
    );
  }

  Widget statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        border: Border.all(color: kWhite),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kBodyFont.copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          Text(value,
              style: kBodyFont.copyWith(
                  fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget seeFinishedGoalsButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.arrow_forward),
      label: const Text('See finished learning goals'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(40, 189, 183, 183),
        foregroundColor: kWhite,
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: kBodyFont.copyWith(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
