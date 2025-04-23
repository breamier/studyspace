import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/study-session/study-session-end.dart';
import 'package:studyspace/study-session/study_session_tasks.dart';

class StudySession extends StatefulWidget {
  final Id goalId;

  const StudySession({super.key, required this.goalId});

  @override
  State<StudySession> createState() {
    return _StateStudySession();
  }
}

class _StateStudySession extends State<StudySession> {
  Timer? timer;
  int time = 0;
  bool isActive = false;
  late double sizeQuery;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeQuery = MediaQuery.of(context).size.width;
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          timerStack(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
          StudySessionTasks(
            goalId: widget.goalId,
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.2,
          ),
          Padding(
          padding:EdgeInsets.symmetric(horizontal: sizeQuery * 0.045),
          child:ElevatedButton(
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
                backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.15,
                    vertical: MediaQuery.sizeOf(context).height * 0.02))),
            child: Text("Finish Study Session",
                style: TextStyle(
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.sizeOf(context).width * 0.04,
                    color: Colors.white)),
          )),
        ],
      ),
    );
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
          textScaler: TextScaler.linear(sizeQuery * 0.009),
        ),
        Text(
          textAlign: TextAlign.center,
          secDuration,
          textScaler: TextScaler.linear(sizeQuery * 0.004),
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
      child: Icon(isActive ? Icons.pause_rounded : Icons.play_arrow_rounded),
      style: ButtonStyle(
        shape: WidgetStateProperty.all(CircleBorder()),
        shadowColor: WidgetStateProperty.all(Color(Colors.white.hashCode)),
        minimumSize: WidgetStateProperty.all(Size(
            MediaQuery.sizeOf(context).width * 0.15,
            MediaQuery.sizeOf(context).width * 0.15)),
      ),
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
