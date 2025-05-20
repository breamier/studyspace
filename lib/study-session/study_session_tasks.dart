import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
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
  void callback(int index) async {
    await _isarService.deleteSubtopicAtIndex(current!, index);
    setState(() {
      goal = _isarService.getGoalById(widget.goalId);
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
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtopics"),
            IconButton(onPressed: () {
              setState(() {
                _deleteMode = !_deleteMode;
              });
            }, icon: Icon(_deleteMode ? Icons.check_box:Icons.delete))
          ],
        ),
        FutureBuilder(
            future: goal,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center();
              }
              final subtopics = snapshot.data?.subtopics.toList();
              return Column(
                children:
                  [

                    for(int i = 0; i < subtopics!.length; i++)

                      _deleteMode? TaskItemWidget(subtopic: subtopics![i], goalId: widget.goalId,deleteMode:true, notifyParent:callback,index:i): TaskItemWidget(subtopic: subtopics![i], goalId: widget.goalId,deleteMode:false,notifyParent:callback,index:i)

                  ]
                ,
              );
              return Text("error");
            }),
        TextFormField(
          readOnly: true,
          onTap: () =>setState(() {
            current!.subtopics = current!.subtopics + [Subtopic()..name="new subtopic" ];
            _isarService.updateGoal(current!);
          }),
          decoration: InputDecoration(
            hintText: "Add a subtopic/lesson",
            prefixIcon: const Icon(Icons.add_box),
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }
}
