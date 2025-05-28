import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/study-session/task_item_widget.dart';

import '../models/goal.dart';

class StudySessionTasks extends StatefulWidget {
  final Id goalId;

  const StudySessionTasks({super.key, required this.goalId});

  @override
  State<StudySessionTasks> createState() {
    return _StateStudySessionTasks();
  }
}

class _StateStudySessionTasks extends State<StudySessionTasks> {
  final IsarService _isarService = IsarService();
  late Future<Goal?> goal;
  late Goal? current;
  bool _isLoading = true;
  bool _deleteMode = false;
  final TextEditingController textController = TextEditingController();

  void callback(int index) async {
    await _isarService.deleteSubtopicAtIndex(current!, index);
    final updatedGoal = _isarService.getGoalById(widget.goalId);
    _isarService.deleteBlankSubtopic(widget.goalId);
    final updatedCurrent = await updatedGoal;
    setState(() {
      goal = updatedGoal;
      current = updatedCurrent;
    });
  }

  @override
  void initState() {
    goal = _isarService.getGoalById(widget.goalId);
    goal.then((data) {
      setState(() {
        current = data;
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // return Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtopics"),
            IconButton(
                onPressed: () {
                  setState(() {
                    _deleteMode = !_deleteMode;
                  });
                },
                icon: Icon(_deleteMode ? Icons.check_box : Icons.delete))
          ],
        ),
        FutureBuilder(
            future: goal,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final subtopics = snapshot.data?.subtopics.toList();
              return Column(
                children: [
                  if ((subtopics == null || subtopics.isEmpty) && _deleteMode)
                    const Text("No subtopics added yet."),
                  for (int i = 0; i < subtopics!.length; i++)
                    _deleteMode
                        ? TaskItemWidget(
                            subtopic: subtopics![i],
                            goalId: widget.goalId,
                            deleteMode: true,
                            notifyParent: callback,
                            index: i)
                        : TaskItemWidget(
                            subtopic: subtopics![i],
                            goalId: widget.goalId,
                            deleteMode: false,
                            notifyParent: callback,
                            index: i)
                ],
              );
              return Text("error");
            }),
        !_deleteMode
            ? TextFormField(
                controller: textController,
                readOnly: false,
                onTapOutside: (event) {
                  setState(() {
                    textController.clear();
                    FocusScope.of(context).unfocus();
                  });
                },
                onFieldSubmitted: (text) => setState(() {
                  if(text.isEmpty || text == "\u200c") {
                    textController.clear();
                    FocusScope.of(context).unfocus();
                    return;
                  }
                  current!.subtopics =
                      current!.subtopics + [Subtopic()..name = "\u200c" + text];
                  _isarService.updateGoal(current!);
                  textController.clear();
                }),
                decoration: InputDecoration(
                  hintText: "Add a subtopic/lesson",
                  prefixIcon: const Icon(Icons.add_box),
                  border: InputBorder.none,
                ),
              )
            : Container(),
      ],
    );
  }
}
