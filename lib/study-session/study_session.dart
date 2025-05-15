import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/study-session/study-session-end.dart';
import 'package:studyspace/study-session/study_session_tasks.dart';

import '../models/goal.dart';
import '../services/isar_service.dart';

class StudySession extends StatefulWidget {
  final Id goalId;
  final String imgLoc;

  const StudySession({super.key, required this.goalId, required this.imgLoc});

  @override
  State<StudySession> createState() {
    return _StateStudySession();
  }
}

class _StateStudySession extends State<StudySession> {
  final IsarService _isarService = IsarService();
  late Future<Goal?> goal;
  Timer? timer;
  int time = 0;
  late String goalName;
  bool isActive = false;
  bool _isLoading = true;
  DateTime start = DateTime.now();

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    goal = _isarService.getGoalById(widget.goalId);
    goal.then((value) {
      goalName = value!.goalName;
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading){
      return CircularProgressIndicator();
    }
    timer ??= Timer.periodic(const Duration(seconds: 1), (Timer t) {
      handleTick();
    });
    return Scaffold(
      body: _buildUI(),
      appBar: AppBar(
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
    );
  }

  Widget _buildUI() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              timerStack(),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
              Text("current session",
                  style: TextStyle(
                    fontFamily: "Amino",
                    fontSize: 18,
                  )),
              Text(goalName,style: TextStyle(
                fontFamily: "Amino",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),),
              StudySessionTasks(
                goalId: widget.goalId,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.1,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.040),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        timer?.cancel();
                        isActive = false;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudySessionEnd(
                                      goalId: widget.goalId,
                                      duration: time,
                                      imgLoc: widget.imgLoc, start: start,
                                  end:DateTime.now()
                                    )));
                      });
                    },
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: BorderSide(
                            width: 1,
                            color: Colors.white,
                          ),
                        )),
                        backgroundColor:
                            WidgetStateProperty.all(Colors.deepPurple),
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).width * 0.15,
                            vertical:
                                MediaQuery.sizeOf(context).height * 0.02))),
                    child: Text("Finish Study Session",
                        style: TextStyle(
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.sizeOf(context).width * 0.04,
                            color: Colors.white)),
                  )),
            ],
          ),
        ));
  }

  Widget studyTimer() {
    int seconds = time % 60;
    int minutes = (time ~/ 60) % 60;
    int hours = time ~/ (60 * 60) % 24;

    String strSec = seconds.toString().padLeft(2, '0');
    String strMin = minutes.toString().padLeft(2, '0');
    String strHrs = hours.toString().padLeft(2, '0');

    String strDuration = '$strHrs:$strMin';
    String secDuration = strSec;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          textAlign: TextAlign.center,
          strDuration,
          textScaler:
              TextScaler.linear(MediaQuery.of(context).size.width * 0.009),
        ),
        Text(
          textAlign: TextAlign.center,
          secDuration,
          textScaler:
              TextScaler.linear(MediaQuery.of(context).size.width * 0.004),
        )
      ],
    );
  }

  Widget timerContainer() {
    return Container(
      width: 300.0,
      height: 300.0,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        shape: BoxShape.circle,
      ),
      child: studyTimer(),
    );
  }

  Widget timerButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isActive = !isActive;
        });
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all(CircleBorder()),
        shadowColor: WidgetStateProperty.all(Color(Colors.white.hashCode)),
        minimumSize: WidgetStateProperty.all(Size(
            MediaQuery.sizeOf(context).width * 0.15,
            MediaQuery.sizeOf(context).width * 0.15)),
      ),
      child: Icon(isActive ? Icons.pause_rounded : Icons.play_arrow_rounded),
    );
  }

  Widget timerStack() {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        timerContainer(),
        Positioned(
          bottom: MediaQuery.sizeOf(context).height * -0.03,
          child: timerButton(),
        ),
      ],
    );
  }

  void handleTick() {
    if (isActive) {
      setState(() {
        time++;
      });
    }
  }
}
