import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../models/goal.dart';
import '../services/isar_service.dart';

class TaskItemWidget extends StatefulWidget {
  final Subtopic subtopic;
  final Id goalId;
  final bool deleteMode;
  final int index;
  final Function(int index) notifyParent;

  const TaskItemWidget(
      {super.key,
      required this.subtopic,
      required this.goalId,
      required this.deleteMode,
      required this.notifyParent,
      required this.index});

  @override
  State<TaskItemWidget> createState() {
    return _StateTaskItemWidget();
  }
}

class _StateTaskItemWidget extends State<TaskItemWidget> {
  bool showTextField = false;
  String subtopic = '';
  final TextEditingController _textEditingController = TextEditingController();
  final IsarService _isarService = IsarService();
  late Future<Goal?> goal;
  late Goal? current;
  bool _isLoading = true;
  bool _deleteMode = false;

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
        widget.deleteMode
            ? IconButton(
                onPressed: () {
                  _deleteSubtopic();
                  setState(() {});
                },
                icon: Icon(Icons.remove_circle))
            : Checkbox(
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
        onChanged: (text) => setState(() {
              if (text == "") {
                _deleteSubtopic();
              }
              _updateGoal(
                  widget.subtopic.name, text, widget.subtopic.completed);
              widget.subtopic.name = text;
            }),
        readOnly: widget.deleteMode,
        controller: _textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onTapOutside: (event) {
          setState(() {
            if (_textEditingController.text == "\u200c") {
              _deleteSubtopic();
            }
            _updateGoal(widget.subtopic.name, _textEditingController.text,
                widget.subtopic.completed);
            widget.subtopic.name = _textEditingController.text;

            FocusScope.of(context).unfocus();
          });
        },
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 16, fontFamily: "Amino"));
  }

  _updateGoal(String old, String updated, bool completed) async {
    goal = _isarService.getGoalById(widget.goalId);
    widget.subtopic.name = updated;
    _isarService.updateSubtopic(
        await goal.then((g) => g!), widget.index, widget.subtopic);
  }

  _deleteSubtopic() {
    widget.notifyParent(widget.index);
  }

  void setDeleteMode() {
    setState(() {
      _deleteMode = !_deleteMode;
    });
  }
}
