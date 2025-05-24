import 'package:flutter/material.dart';
import 'package:studyspace/models/goal.dart';
import 'package:intl/intl.dart';
import 'package:studyspace/screens/dashboard_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/services/scheduler.dart';

class PreviewStudyGoal extends StatelessWidget {
  final Goal goal;
  PreviewStudyGoal({super.key, required this.goal});

  Future<List<DateTime>> _getSessionDates(Goal goal) async {
    return await Scheduler().initializeSessions(goal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Preview Learning Goal",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("I will learn...",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  )),
              TextFormField(
                initialValue: goal.goalName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white)),
                  prefixIcon: const Icon(Icons.book_outlined),
                ),
                enabled: false,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "From...",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          readOnly: true,
                          initialValue:
                              DateFormat("MM/dd/yyyy").format(goal.start),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon:
                                const Icon(Icons.calendar_month_outlined),
                          ),
                          enabled: false,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Until ...",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: DateFormat("MM/dd/yyyy").format(goal.end),
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon:
                                const Icon(Icons.calendar_month_outlined),
                          ),
                          enabled: false,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    "I think it would have",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      chipTheme: Theme.of(context).chipTheme.copyWith(
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                    ),
                    child: ChoiceChip(
                      label: Text(goal.difficulty),
                      selected: false,
                      showCheckmark: false,
                      selectedColor: Colors.white,
                      backgroundColor: Colors.grey[900],
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const Text(
                    "difficulty.",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "My specific study goals are ...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Column(
                children: goal.subtopics.isEmpty
                    ? [
                        ListTile(
                          leading: const Icon(Icons.info_outline,
                              color: Colors.white54),
                          title: const Text(
                            "No subtopics added.",
                            style: TextStyle(
                                color: Colors.white54,
                                fontStyle: FontStyle.italic),
                          ),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        )
                      ]
                    : goal.subtopics
                        .map((s) => ListTile(
                              leading: const Icon(
                                Icons.track_changes,
                                color: Colors.white,
                              ),
                              title: Text(
                                s.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ))
                        .toList(),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<DateTime>>(
                  future: _getSessionDates(goal),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error retrieving sessions"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No sessions found.'));
                    }

                    final sessionDates = snapshot.data!;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2050, 12, 31),
                        focusedDay: goal.start,
                        calendarStyle: const CalendarStyle(
                          todayDecoration: BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle),
                          todayTextStyle: TextStyle(color: Colors.black),
                          markerDecoration: BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                        ),
                        selectedDayPredicate: (day) =>
                            day.isAtSameMomentAs(goal.start) ||
                            day.isAtSameMomentAs(goal.end),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(color: Colors.white),
                          leftChevronIcon:
                              Icon(Icons.chevron_left, color: Colors.white),
                          rightChevronIcon:
                              Icon(Icons.chevron_right, color: Colors.white),
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, _) {
                            if (sessionDates.any((sessionDate) =>
                                sessionDate.year == day.year &&
                                sessionDate.month == day.month &&
                                sessionDate.day == day.day)) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 30),
              const Text(
                "* These are the dates of your study sessions & revisions",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                  onPressed: () async {
                    final sessionDates =
                        await Scheduler().initializeSessions(goal);
                    goal.upcomingSessionDates = sessionDates;
                    await IsarService().addGoal(goal);
                    if (context.mounted) {
                      // Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                DashboardScreen(isar: IsarService())),
                        (route) => false,
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.lightGreen,
                  child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Save Learning Goal",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15))
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
