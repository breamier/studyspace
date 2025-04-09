import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddStudyGoal extends StatefulWidget {
  const AddStudyGoal({super.key});

  @override
  State<AddStudyGoal> createState() => _AddStudyGoalState();
}

class _AddStudyGoalState extends State<AddStudyGoal> {
  final TextEditingController _goal = TextEditingController();
  final TextEditingController _start = TextEditingController();
  final TextEditingController _end = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create a Learning Goal",
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
                        prefixIcon: const Icon(Icons.calendar_today),
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
                          text:
                              _end.text.isEmpty ? '' : _end.text.split(' ')[0]),
                      decoration: InputDecoration(
                        hintText: _end.text.isEmpty ? 'MM/DD/YYYY' : _end.text,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
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
                    const SizedBox(height: 15),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "What specific study goals do you have for this learning goal?",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        )),
                  ],
                ),
              )),
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
}
