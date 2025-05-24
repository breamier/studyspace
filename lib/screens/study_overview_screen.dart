import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/widgets/navbar.dart';
import './topic_overview_screen.dart';

class StudyOverview extends StatefulWidget {
  final IsarService isar;
  const StudyOverview({super.key, required this.isar});

  @override
  State<StudyOverview> createState() => _StudyOverviewState();
}

class _StudyOverviewState extends State<StudyOverview> {
  // get list of goals in isar
  late Future<List<Goal>> _goals;
  final TextEditingController _searchController = TextEditingController();
  // default: ascending
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _refreshGoals();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshGoals() {
    setState(() {
      _goals = widget.isar.getAllGoals();
    });
  }

  void _onSearchChanged() {
    //rebuild
    setState(() {});
  }

  void _toggleSortOrder() {
    // default: ascending
    // switch to descending if tap
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  Future<List<Goal>> _getFilteredGoals() async {
    final goals = await _goals;
    final searchGoal = _searchController.text.toLowerCase();

    // Search goal through filter
    var filterGoal = goals
        .where((goal) => goal.goalName.toLowerCase().contains(searchGoal))
        .toList();

    // Ascending order
    filterGoal.sort((a, b) =>
        _sortAscending ? a.end.compareTo(b.end) : b.end.compareTo(a.end));

    return filterGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 14, 14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backGroundScreen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Study Goals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SearchBar(
                controller: _searchController,
                leading: const Icon(Icons.search, color: Colors.white),
                hintText: 'Search for a study goal',
                backgroundColor: const WidgetStatePropertyAll<Color>(
                  Color.fromRGBO(50, 50, 50, 1),
                ),
                hintStyle: const WidgetStatePropertyAll<TextStyle>(
                  TextStyle(color: Colors.white),
                ),
                textStyle: const WidgetStatePropertyAll<TextStyle>(
                  TextStyle(color: Colors.white, fontFamily: 'Arimo'),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: _toggleSortOrder,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      const Icon(Icons.sort, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'due date: ${_sortAscending ? 'ascending' : 'descending'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Goal>>(
                  future: _getFilteredGoals(),
                  builder: (context, snapshot) {
                    // waiting state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final goals = snapshot.data ?? [];

                    // return message if search is empty
                    if (goals.isEmpty) {
                      return Center(
                        child: Text(
                          'No study goals found',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Arimo',
                          ),
                        ),
                      );
                    }

                    // list all current goals from isar db
                    return RefreshIndicator(
                      onRefresh: () async => _refreshGoals(),
                      child: ListView.builder(
                        itemCount: goals.length,
                        itemBuilder: (context, index) {
                          final goal = goals[index];
                          final dueDate =
                              DateFormat('dd/MM/yyyy').format(goal.end);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: StudyGoalCard(
                              title: goal.goalName,
                              dueDate: dueDate,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TopicOverview(goalId: goal.id),
                                  ),
                                );
                                _refreshGoals();
                              },
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
      bottomNavigationBar:
          CustomBottomNavBar(currentIndex: 1, isar: widget.isar),
    );
  }
}

class StudyGoalCard extends StatelessWidget {
  final String title;
  final String dueDate;
  final VoidCallback onTap;

  const StudyGoalCard({
    super.key,
    required this.title,
    required this.dueDate,
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
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text("📖", style: TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arimo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due on $dueDate',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Arimo',
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
