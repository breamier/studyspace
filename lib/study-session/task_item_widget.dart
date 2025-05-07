import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../models/goal.dart';
import '../services/isar_service.dart';

class TaskItemWidget extends StatefulWidget {
  final Subtopic subtopic;
  final Id goalId;

  const TaskItemWidget(
      {super.key, required this.subtopic, required this.goalId});

  @override
  State<TaskItemWidget> createState() {
    return _StateTaskItemWidget();
  }
}

class _StateTaskItemWidget extends State<TaskItemWidget> {
  bool showTextField = false;
  String subtopic = 'Enter an activity name';
  final TextEditingController _textEditingController = TextEditingController();
  final IsarService _isarService = IsarService();
  late Future<Goal?> goal;
  late Goal? current;
  bool _isLoading = true;

  @override
  void initState() {
    goal = _isarService.getGoalById(widget.goalId);
    _textEditingController.text = widget.subtopic.name;
    goal.then((data) {
      setState(() {
        current = data;
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container();
    }
    return Row(
      children: [
        Checkbox(
            value: widget.subtopic.completed,
            onChanged: (value) {
              setState(() {
                widget.subtopic.completed = value!;
              });
            }),
        Expanded(child: activityInputField()),
      ],
    );
  }

  Widget activityInputField() {
    return TextFormField(
        controller: _textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onTapOutside: (event) {
          setState(() {
            _updateGoal(widget.subtopic.name, _textEditingController.text, widget.subtopic.completed);
            widget.subtopic.name = _textEditingController.text;
            FocusScope.of(context).unfocus();
          });
        },
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 16, fontFamily: "Amino"));
  }
  _updateGoal(String old,String updated,bool completed) async {
    widget.subtopic.name = updated;
    _isarService.updateSubtopic(current!, widget.subtopic);
    await _isarService.updateGoal(current!);
  }
}
