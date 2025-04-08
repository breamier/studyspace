import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './topic_overview.dart';

class StudyOverview extends StatefulWidget {
  const StudyOverview({super.key});

  @override
  State<StudyOverview> createState() => _StudyOverviewState();
}

class StudyGoal {
  final String title;
  final String dueDate;
  bool completed;

  StudyGoal({
    required this.title,
    required this.dueDate,
    required this.completed,
  });
}

class _StudyOverviewState extends State<StudyOverview> {
  final List<StudyGoal> studyGoals = [
    StudyGoal(
        title: 'Automata Theory', dueDate: '12/08/2024', completed: false),
    StudyGoal(
        title: 'Statistics and Probability',
        dueDate: '12/08/2024',
        completed: false),
    StudyGoal(title: 'Other Topic', dueDate: '12/08/2024', completed: false),
    StudyGoal(
        title: 'Other Topic Too', dueDate: '12/08/2024', completed: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/backGroundScreen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                'Current Study Goals',
                style: GoogleFonts.arimo(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const SearchBar(
                leading: Icon(Icons.search, color: Colors.white),
                hintText: 'Search for a study goal',
                backgroundColor: WidgetStatePropertyAll<Color>(
                    Color.fromRGBO(50, 50, 50, 1)),
                hintStyle: WidgetStatePropertyAll<TextStyle>(
                  TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 15),
                  const Icon(Icons.sort, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'due date: ascending',
                    style: GoogleFonts.arimo(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: studyGoals.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: StudyGoalCard(
                        goal: studyGoals[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopicOverview(
                                topicTitle: studyGoals[index].title,
                                targetDate: studyGoals[index].dueDate,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudyGoalCard extends StatelessWidget {
  final StudyGoal goal;
  final VoidCallback onTap;

  const StudyGoalCard({
    super.key,
    required this.goal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(30, 30, 30, 1),
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.white, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                "images/asset-book.png",
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: GoogleFonts.arimo(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due on ${goal.dueDate}',
                      style: GoogleFonts.arimo(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
