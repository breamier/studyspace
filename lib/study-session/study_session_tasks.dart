import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/services/isar_service.dart';

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
  Goal? _goal;
  bool _isLoading = true;
  final List<TextEditingController> _subtopicControllers = [];
  final FocusNode _newSubtopicFocusNode = FocusNode();

  // subtopics to delete
  final List<Subtopic> _selectedSubtopicsToDelete = [];

  late double deviceHeight;
  late double deviceWidth;
  late bool isSmallScreen;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    isSmallScreen = deviceWidth < 600;
  }

  Future<void> _loadGoal() async {
    setState(() => _isLoading = true);
    try {
      final goal = await _isarService.getGoalById(widget.goalId);
      if (mounted) {
        setState(() {
          _goal = goal;
          if (goal != null) {
            _initializeControllers(goal.subtopics);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _initializeControllers(List<Subtopic> subtopics) {
    _subtopicControllers.clear();
    for (var subtopic in subtopics) {
      _subtopicControllers.add(TextEditingController(text: subtopic.name));
    }
  }

  Future<void> _saveSubtopics() async {
    if (_goal == null) return;

    final newSubtopics = _subtopicControllers
        .where((c) => c.text.trim().isNotEmpty)
        .map((controller) {
      final existing = _goal!.subtopics.firstWhere(
        (s) => s.name == controller.text.trim(),
        orElse: () => Subtopic()..name = controller.text.trim(),
      );
      return existing..name = controller.text.trim();
    }).toList();

    _goal!.subtopics = newSubtopics;
    await _isarService.updateGoal(_goal!);
    if (mounted) setState(() {});
  }

  void _addNewSubtopicField() {
    setState(() => _subtopicControllers.add(TextEditingController()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_newSubtopicFocusNode);
    });
  }

  void _toggleSubtopicCompletion(int index) async {
    if (_goal == null || index >= _goal!.subtopics.length) return;

    setState(() {
      _goal!.subtopics[index].completed = !_goal!.subtopics[index].completed;
    });
    await _isarService.updateGoal(_goal!);
  }

  void _showDeleteSubtopicDialog() {
    final selectedSubtopics =
        _goal!.subtopics.where((s) => !s.completed).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 22, 22, 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.white, width: 2.0),
              ),
              title: Text(
                'Select Subtopics to Delete',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Arimo',
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectedSubtopics.length,
                  itemBuilder: (context, index) {
                    final subtopic = selectedSubtopics[index];
                    return CheckboxListTile(
                      title: Text(
                        subtopic.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Arimo',
                        ),
                      ),
                      value: _selectedSubtopicsToDelete.contains(subtopic),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedSubtopicsToDelete.add(subtopic);
                          } else {
                            _selectedSubtopicsToDelete.remove(subtopic);
                          }
                        });
                      },
                      activeColor: const Color.fromRGBO(176, 152, 228, 1),
                      checkColor: Colors.white,
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Arimo',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedSubtopicsToDelete.isNotEmpty) {
                      await _deleteSelectedSubtopics();
                      // Reload the goal after deletion
                      await _loadGoal();
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(194, 109, 68, 221),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white, width: 1.5),
                    ),
                  ),
                  child: Text(
                    'Delete Selected',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Arimo',
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteSelectedSubtopics() async {
    if (_goal == null || _selectedSubtopicsToDelete.isEmpty) return;

    try {
      // call deleteSubtopics
      await _isarService.deleteSubtopics(_goal!, _selectedSubtopicsToDelete);

      // update
      setState(() {
        // remove from goal's subtopics
        _goal!.subtopics.removeWhere(
            (subtopic) => _selectedSubtopicsToDelete.contains(subtopic));

        // remove deleted subtopics controllers
        _subtopicControllers.removeWhere((controller) =>
            _selectedSubtopicsToDelete
                .any((subtopic) => subtopic.name == controller.text));

        // clear list
        _selectedSubtopicsToDelete.clear();
      });

      // show message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Subtopics deleted successfully',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Arimo',
            ),
          ),
          backgroundColor: const Color.fromARGB(194, 109, 68, 221),
        ),
      );
    } catch (e) {
      // show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete subtopics',
            style: TextStyle(fontFamily: 'Arimo'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center();
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtopics"),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete))
          ],
        ),
        ..._subtopicControllers.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final controller = entry.value;
            final isNew = index >= _goal!.subtopics.length;
            final subtopic = isNew ? null : _goal!.subtopics[index];

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.04,
                vertical: deviceHeight * 0.00,
              ),
              child: Row(
                children: [
                  if (!isNew)
                    SizedBox(
                      width: deviceWidth * 0.04,
                      height: deviceWidth * 0.04,
                      child: Checkbox(
                        value: subtopic?.completed ?? false,
                        onChanged: (value) => _toggleSubtopicCompletion(index),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                  if (!isNew) SizedBox(width: deviceWidth * 0.03),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceWidth * 0.04,
                        fontFamily: 'Arimo',
                      ),
                      decoration: InputDecoration(
                        hintText: isNew ? "New subtopic" : null,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: deviceWidth * 0.04,
                          fontFamily: 'Arimo',
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => _saveSubtopics(),
                      focusNode:
                          isNew && index == _subtopicControllers.length - 1
                              ? _newSubtopicFocusNode
                              : null,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
            padding: EdgeInsets.only(
              left: deviceWidth * 0.02,
              right: deviceWidth * 0.04,
              top: deviceHeight * 0.01,
            ),
            child: TextButton(
              onPressed:  _addNewSubtopicField,
              child: Row(
                children: [
                  SizedBox(
                    width: deviceWidth * 0.03,
                    height: deviceWidth * 0.09,
                    child: Container(
                      child: Icon(
                          Icons.add,
                          size: deviceWidth * 0.08,
                          color: const Color.fromARGB(187, 187, 187, 187),
                        )
                      ),
                    ),
                  SizedBox(width: deviceWidth * 0.06),
                  Text(
                    "Add a subtopic",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth * 0.04,
                      fontFamily: 'Arimo',
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
