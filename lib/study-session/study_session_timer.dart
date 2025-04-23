import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudySessionTimer extends StatefulWidget{
  @override
  State<StudySessionTimer> createState(){
    return _StateStudySessionTimer();
  }
}

class _StateStudySessionTimer extends State<StudySessionTimer>{
  Timer? timer;
  int time = 0;
  bool isActive = false;
  late double sizeQuery;

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    sizeQuery = MediaQuery.of(context).size.width;
    timer ??= Timer.periodic(const Duration(seconds: 1), (Timer t) {handleTick();});
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        timerStack()
      ],
    );

  }

  void handleTick(){
    if(isActive){
      setState(() {
        time++;

      });
    }
  }

  Widget studyTimer(){

    int seconds  = time %60;
    int minutes = (time ~/ 60) % 60;
    int hours = time ~/ (60 * 60) % 24;

    String strSec = seconds.toString().padLeft(2, '0');
    String strMin = minutes.toString().padLeft(2, '0');
    String strHrs = hours.toString().padLeft(2, '0');

    String strDuration = '$strHrs:$strMin';
    String secDuration  =strSec;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          textAlign: TextAlign.center,
          strDuration,
          textScaler:
          TextScaler.linear(sizeQuery* 0.009),
        ),
        Text(
          textAlign: TextAlign.center,
          secDuration,
          textScaler: TextScaler.linear(sizeQuery*0.004),
        )
      ],
    );
  }


  Widget timerContainer(){
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
  Widget timerButton(){
    return ElevatedButton(onPressed: (){
      setState(() {
        isActive = !isActive;
      });
    }, child: Icon(isActive? Icons.pause_rounded:Icons.play_arrow_rounded),
      style: ButtonStyle(
        shape: WidgetStateProperty.all(CircleBorder()),
        shadowColor: WidgetStateProperty.all(Color(Colors.white.hashCode)),
        minimumSize: WidgetStateProperty.all(Size(MediaQuery.sizeOf(context).width*0.15, MediaQuery.sizeOf(context).width*0.15)),
    )
      ,);
  }

  Widget timerStack(){
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
          timerContainer(),
          Positioned(
            bottom: MediaQuery.sizeOf(context).height *-0.03,
            child: timerButton(),
          ),
      ],
    );
  }
}