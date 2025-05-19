import 'package:flutter/material.dart';
import 'package:studyspace/services/isar_service.dart';
import '../widgets/navbar.dart';
import 'dart:io';

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

final List<Map<String, dynamic>> CompletedGoals = [
  {
    'date': 'April 29, 2025',
    'tasks': [
      {
        'title': 'Pumping Lemma',
        'timeSpent': '5h 56m',
        'subtopics': [
          {
            'title': 'Algebraic laws for regular expressions',
          },
          {
            'title': 'Pumping lemma for regular languages',
          },
        ],
        'sessions': [
          {'date': 'April 29, 2025', 'time': "2h 54m"},
          {'date': 'April 29, 2025', 'time': "2h 54m"}
        ],
        'images': ['choco1.jpg', 'choco2.jpg', 'choco3.jpg'],
      },
      {
        'title': 'DFA Minimization',
        'timeSpent': '2h 15m',
      },
    ]
  },
  {
    'date': 'April 30, 2025',
    'tasks': [
      {
        'title': 'Turing Machines',
        'timeSpent': '4h 10m',
      },
    ]
  }
];

class CompletedGoalsScreen extends StatefulWidget {
  final IsarService isar;
  const CompletedGoalsScreen({super.key, required this.isar});

  @override
  State<CompletedGoalsScreen> createState() => _CompletedGoalsScreenState();
}

class _CompletedGoalsScreenState extends State<CompletedGoalsScreen> {
  late Future<List<Map<String, dynamic>>> _completedGoalsFuture;

  @override
  void initState() {
    super.initState();
    final isarService = IsarService();
    _completedGoalsFuture = isarService.getCompletedGoals();
  }

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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _completedGoalsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child:
                          Text('Error: ${snapshot.error}', style: kBodyFont));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No completed goals yet.', style: kBodyFont));
                }

                final completedGoals = snapshot.data!;
                return ListView(
                  children: completedGoals.map((goal) {
                    return CompletedTaskCard(task: goal);
                  }).toList(),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 3,
          isar: widget.isar,
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
            // Top row: title, time
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
            // Expanded content
            if (showDetails &&
                task['subtopics'] != null &&
                task['images'] != null) ...[
              const SizedBox(height: 12),
              Divider(color: Colors.white30, thickness: 0.8),
              const SizedBox(height: 12),
              Text('Sessions:',
                  style: kBodyFont.copyWith(
                      fontSize: 13, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Column(
                children: (task['sessions'] as List).map<Widget>((sesh) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Text(sesh['time'], style: kBodyFont),
                        const SizedBox(width: 8),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.white38,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(sesh['date'],
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

              // Subtopics
              Text('Subtopics Learned:', style: kBodyFont),
              const SizedBox(height: 8),
              Column(
                children: (task['subtopics'] as List).map<Widget>((sub) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.track_changes,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
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

              // Photos
              Text('Photos:', style: kBodyFont),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: (task['images'] as List).map<Widget>((img) {
                    final file = File(img);
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(file, fit: BoxFit.cover),
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
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
