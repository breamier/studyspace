import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/study-session/study-session-rewards.dart';
import '../models/goal.dart';
import '../models/session.dart';
import '../services/isar_service.dart';
import '../services/scheduler.dart';

class StudySessionEnd extends StatefulWidget {
  final Id goalId;
  final int duration;
  final String imgLoc;
  final DateTime start;
  final DateTime end;

  const StudySessionEnd(
      {super.key,
      required this.start,
      required this.end,
      required this.goalId,
      required this.duration,
      required this.imgLoc});

  @override
  State<StudySessionEnd> createState() => _StudySessionEndState();
}

class _StudySessionEndState extends State<StudySessionEnd>
    with SingleTickerProviderStateMixin {
  String _difficulty = "Easy";
  final IsarService _isarService = IsarService();
  Goal? _goal;
  bool _isLoading = true;
  late double sizeQuery;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    setState(() => _isLoading = true);
    try {
      final goal = await _isarService.getGoalById(widget.goalId);
      if (mounted) {
        setState(() {
          _goal = goal;
          setState(() => _isLoading = false);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> saveSession() async {
    _isarService.addSession(
        await _isarService.createSessionObj(widget.start, widget.end,
            widget.duration, widget.imgLoc, _difficulty, _goal!),
        _goal!);
    print("DONE");


      if (_goal == null || _goal!.upcomingSessionDates.isEmpty) {
        print("Goal or sessions not found.");
        return;
      }
      await Scheduler().completeStudySession(
        goal: _goal!,
        completedDate: widget.end,
        newDifficulty: _difficulty,
      );

  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    sizeQuery = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          _buildUI(),
        ],
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_circle_left_outlined,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildUI() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Congratulations!",
                  style: TextStyle(fontFamily: 'Amino', fontSize: 20),
                ),
                Text(
                  "You finished a session on",
                  style: TextStyle(fontFamily: 'Amino', fontSize: 20),
                ),
                Text(
                  _goal!.goalName.toString(),
                  style: TextStyle(fontFamily: 'Amino', fontSize: 20),
                ),
              ],
            ),
            Column(
              children: [
                studyTime(),
                Text(
                  "Total Time Studied",
                  style: TextStyle(fontFamily: "BrunoAceSC", fontSize: 18),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: SizedBox(
                  height: MediaQuery.sizeOf(context).width * 0.5,
                  child: Image.file(File(widget.imgLoc))),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: sizeQuery * 0.045),
                child: Text(
                  "How is your understanding of the topic after the session?",
                  style: TextStyle(fontFamily: 'Amino', fontSize: 18),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            DifficultySelector(
              selected: _difficulty,
              onSelected: (value) {
                setState(() {
                  _difficulty = value;
                });
              },
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "*This will affect the time until the next study session.",
                    style: TextStyle(
                      fontFamily: 'Amino',
                      fontSize: 12,
                    ))),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  //update data and send data
                  _goal!.difficulty = _difficulty;
                  _isarService.updateGoal(_goal!);
                  saveSession();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudySessionRewards(
                                goalId: widget.goalId,
                              )));
                });
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                  )),
                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.25,
                      vertical: MediaQuery.sizeOf(context).height * 0.02))),
              child: Text("End Study Session",
                  style: TextStyle(
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.sizeOf(context).width * 0.04,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget studyTime() {
    int seconds = widget.duration % 60;
    int minutes = (widget.duration ~/ 60) % 60;
    int hours = widget.duration ~/ (60 * 60) % 24;

    String strSec = seconds.toString().padLeft(2, '0');
    String strMin = minutes.toString().padLeft(2, '0');
    String strHrs = hours.toString().padLeft(2, '0');

    String strDuration = '$strHrs:$strMin:$strSec';
    String secDuration = strSec;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          textAlign: TextAlign.center,
          strDuration,
          textScaler: TextScaler.linear(sizeQuery * 0.009),
          style: TextStyle(fontFamily: 'Amino', fontWeight: FontWeight.w800),
        ),
      ],
    );
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
          selectedColor: switch (level) {
            "Easy" => Colors.green,
            "Medium" => Colors.orange,
            "Difficult" => Colors.red,
            _ => Colors.white
          },
          backgroundColor: switch (level) {
            "Easy" => Colors.green,
            "Medium" => Colors.orange,
            "Difficult" => Colors.red,
            _ => Colors.white,
          },
          labelStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              width: 2,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
