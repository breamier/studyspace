import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyspace/study-session/study_session_tasks.dart';
import 'package:studyspace/study-session/study_session_timer.dart';

class StudySession extends StatefulWidget{
  @override
  State<StudySession> createState(){
    return _StateStudySession();
  }
}

class _StateStudySession extends State<StudySession>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:_buildUI(),
      appBar:AppBar(
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
  Widget _buildUI(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StudySessionTimer(),
        Spacer(),
        StudySessionTasks(),
        ElevatedButton(onPressed: (){}, child: Text("End Study Session"))
      ],
    );
  }
}