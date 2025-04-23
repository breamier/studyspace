import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studyspace/models/goal.dart';
import 'preview_study_goal.dart';

class AddStudyGoal extends StatefulWidget {
  const AddStudyGoal({super.key});

  @override
  State<AddStudyGoal> createState() => _AddStudyGoalState();
}

class _AddStudyGoalState extends State<AddStudyGoal> {
  final TextEditingController _goal = TextEditingController();
  final TextEditingController _start = TextEditingController();
  final TextEditingController _end = TextEditingController();
  final List<TextEditingController> subtopics = [];
  String _difficulty = "Easy";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Create a Learning Goal",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
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
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("What would you like to learn?",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                      )),
                  TextFormField(
                    controller: _goal,
                    decoration: InputDecoration(
                      hintText: 'Enter your study goal',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.book_outlined),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "When do you start?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      )),
                  TextFormField(
                    readOnly: true,
                    onTap: () => selectDate(_start),
                    controller: TextEditingController(
                        text: _start.text.isEmpty
                            ? ''
                            : _start.text.split(' ')[0]),
                    decoration: InputDecoration(
                      hintText:
                          _start.text.isEmpty ? 'MM/DD/YYYY' : _start.text,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "What is the target end date?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      )),
                  TextFormField(
                    readOnly: true,
                    onTap: () => selectDate(_end),
                    controller: TextEditingController(
                        text: _end.text.isEmpty ? '' : _end.text.split(' ')[0]),
                    decoration: InputDecoration(
                      hintText: _end.text.isEmpty ? 'MM/DD/YYYY' : _end.text,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "How difficult do you think this would be?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      )),
                  DifficultySelector(
                    selected: _difficulty,
                    onSelected: (value) {
                      setState(() {
                        _difficulty = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "What specific study goals do you have for this learning goal?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      )),
                  for (int i = 0; i < subtopics.length; i++)
                    Column(
                      children: [
                        TextFormField(
                          controller: subtopics[i],
                          decoration: InputDecoration(
                            hintText: 'Add a subtopic/lesson',
                            border: InputBorder.none,
                            prefixIcon: InkWell(
                              child: InkWell(
                                child: const Icon(
                                    Icons.indeterminate_check_box_outlined),
                                onTap: () {
                                  removeField(i);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  TextFormField(
                    readOnly: true,
                    onTap: () => addField(),
                    decoration: InputDecoration(
                      hintText: "Add a subtopic/lesson",
                      prefixIcon: const Icon(Icons.add_box),
                      border: InputBorder.none,
                    ),
                  ),
                  MaterialButton(
                      onPressed: () async {
                        await _previewGoal();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.lightGreen,
                      child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Preview Study Plan",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15))
                            ],
                          )))
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> selectDate(TextEditingController controller) async {
    DateTime? selected = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (selected != null) {
      String formattedDate = DateFormat('MM/dd/yyyy').format(selected);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  addField() {
    setState(() {
      subtopics.add(TextEditingController());
    });
  }

  removeField(int i) {
    setState(() {
      subtopics.removeAt(i);
    });
  }

  // save goal in db

  Future<void> _previewGoal() async {
    if (_formKey.currentState!.validate()) {
      final subtopicList = subtopics
          .map((controller) => Subtopic()..name = controller.text)
          .toList();

      final newGoal = Goal()
        ..goalName = _goal.text
        ..start = DateFormat('MM/dd/yyyy').parse(_start.text)
        ..end = DateFormat('MM/dd/yyyy').parse(_end.text)
        ..difficulty = _difficulty
        ..subtopics = subtopicList;

      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewStudyGoal(goal: newGoal),
            ));
      }
    }
  }
}

class DifficultySelector extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;

  const DifficultySelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> difficulties = ['Easy', 'Medium', 'Difficult'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: difficulties.map((level) {
        final bool isSelected = selected == level;

        return ChoiceChip(
          label: Text(level),
          selected: isSelected,
          onSelected: (_) => onSelected(level),
          showCheckmark: false,
          selectedColor: Colors.white,
          backgroundColor: Colors.grey[900],
          labelStyle: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
