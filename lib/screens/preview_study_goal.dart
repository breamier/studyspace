import 'package:flutter/material.dart';
import 'package:studyspace/models/goal.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:studyspace/services/isar_service.dart';

class PreviewStudyGoal extends StatelessWidget {
  final Goal goal;
  const PreviewStudyGoal({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Learning Goal",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            )),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_circle_left_outlined,
              color: Colors.white,
            )),
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
                          "To...",
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
                  ChoiceChip(
                    label: Text(goal.difficulty),
                    selected: false,
                    showCheckmark: false,
                    selectedColor: Colors.white,
                    backgroundColor: Colors.grey[900],
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white),
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
                children: goal.subtopics
                    .map((s) => ListTile(
                          leading: const Icon(
                            Icons.track_changes,
                            color: Colors.lightGreen,
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
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2050, 12, 31),
                focusedDay: goal.start,
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                      color: Colors.greenAccent, shape: BoxShape.circle),
                  markerDecoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
                    if (day == goal.start || day == goal.end) {
                      return Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.lightGreen,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              MaterialButton(
                  onPressed: () async {
                    await IsarService().addGoal(goal);
                    if (context.mounted)
                      Navigator.popUntil(context, (route) => route.isFirst);
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
