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
  bool _addMode = false;
  final TextEditingController textController = TextEditingController();

  void callback(int index) async {
    await _isarService.deleteSubtopicAtIndex(current!, index);
    _isarService.deleteBlankSubtopic(widget.goalId);
    final updatedGoal = _isarService.getGoalById(widget.goalId);
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
                // return const Center(child: CircularProgressIndicator());
              }
              final subtopics = snapshot.data?.subtopics.toList();
              if (subtopics == null) {
                return const Center();
              }
              return Column(
                children: [
                  if (subtopics.isEmpty && _deleteMode)
                    const Center(
                      child: Text("No subtopics to delete"),
                    ),
                  for (int i = 0; i < subtopics.length; i++)
                    _deleteMode
                        ? TaskItemWidget(
                            subtopic: subtopics[i],
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
            }),
        !_deleteMode
            ? !_addMode
                ? TextFormField(
                    readOnly: true,
                    onTap: () => setState(() {
                      _addMode = true;
                      // current!.subtopics =
                      //     current!.subtopics + [Subtopic()..name = "\u200c"];
                      // _isarService.updateGoal(current!);
                    }),
                    decoration: InputDecoration(
                      hintText: "Add a subtopic/lesson",
                      prefixIcon: const Icon(Icons.add_box),
                      border: InputBorder.none,
                    ),
                  )
                : TextFormField(
                    controller: textController,
                    readOnly: false,
                    onTapOutside: (event) {
                      setState(() {
                        _addMode = false;
                        textController.clear();
                        FocusScope.of(context).unfocus();
                      });
                    },
                    onFieldSubmitted: (text) => setState(() {
                      if (text == "") {
                        _addMode = false;
                      } else {
                        current!.subtopics =
                            current!.subtopics + [Subtopic()..name = text];
                        _isarService.updateGoal(current!);
                        textController.clear();
                        _addMode = false;
                      }
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
