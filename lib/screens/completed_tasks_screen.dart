import 'package:flutter/material.dart';
import 'package:studyspace/services/isar_service.dart';
import '../widgets/navbar.dart';

final Color kPurple = Color(0xFF9B59B6);

final TextStyle kHeadingFont = TextStyle(
  fontFamily: 'BrunoAceSC',
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(blurRadius: 10.0, color: Colors.white, offset: Offset(0, 0)),
    Shadow(blurRadius: 20.0, color: kPurple, offset: Offset(0, 0)),
  ],
);

final TextStyle kBodyFont = TextStyle(
  fontFamily: 'Arimo',
  fontSize: 14,
  color: Colors.white,
);

final List<Map<String, dynamic>> completedTasks = [
  {
    'date': 'April 29, 2025',
    'tasks': [
      {
        'title': 'Pumping Lemma',
        'subject': 'Automata Theory',
        'timeSpent': '5h 56m',
        'subtopics': [
          {
            'title': 'Algebraic laws for regular expressions',
            'time': '3h 2m',
          },
          {
            'title': 'Pumping lemma for regular languages',
            'time': '2h 54m',
          },
        ],
        'images': ['choco1.jpg', 'choco2.jpg', 'choco3.jpg'],
      },
      {
        'title': 'DFA Minimization',
        'subject': 'Automata Theory',
        'timeSpent': '2h 15m',
      },
    ]
  },
  {
    'date': 'April 30, 2025',
    'tasks': [
      {
        'title': 'Turing Machines',
        'subject': 'Automata Theory',
        'timeSpent': '4h 10m',
      },
    ]
  }
];

class CompletedTasksScreen extends StatelessWidget {
  final IsarService isar;
  const CompletedTasksScreen({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Completed Tasks', style: kHeadingFont),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/stars.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: completedTasks.map((day) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(day['date'], style: kHeadingFont),
                    const SizedBox(height: 12),
                    Column(
                      children: (day['tasks'] as List).map<Widget>((task) {
                        return CompletedTaskCard(task: task);
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 3,
          isar: isar,
        ));
  }
}

class CompletedTaskCard extends StatefulWidget {
  final Map<String, dynamic> task;

  const CompletedTaskCard({super.key, required this.task});

  @override
  State<CompletedTaskCard> createState() => _CompletedTaskCardState();
}

class _CompletedTaskCardState extends State<CompletedTaskCard> {
  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return GestureDetector(
      onTap: () {
        setState(() {
          showDetails = !showDetails;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: title, subject
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title and time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task['title'],
                        style: kBodyFont.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text('Total study time: ${task['timeSpent']}',
                        style: kBodyFont.copyWith(fontSize: 13)),
                  ],
                ),
                // Subject
                Text(task['subject'], style: kBodyFont.copyWith(fontSize: 13)),
              ],
            ),

            // Expanded content
            if (showDetails &&
                task['subtopics'] != null &&
                task['images'] != null) ...[
              const SizedBox(height: 12),
              Divider(color: Colors.white30, thickness: 0.8),
              const SizedBox(height: 12),
              Text('Subtopics:',
                  style: kBodyFont.copyWith(
                      fontSize: 13, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Column(
                children: (task['subtopics'] as List).map<Widget>((sub) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Text(sub['time'], style: kBodyFont),
                        const SizedBox(width: 8),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.white38,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(sub['title'],
                              textAlign: TextAlign.left, style: kBodyFont),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.white30, thickness: 0.8),
              const SizedBox(height: 12),
              Text('Photos:', style: kBodyFont),
              const SizedBox(height: 8),
              Row(
                children: (task['images'] as List).map<Widget>((img) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                Image.asset('assets/$img', fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/$img'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
