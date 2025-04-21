import 'dart:async';

import 'package:flutter/cupertino.dart';

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

    String strDuration = '$strHrs:$strMin:$strSec';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          strDuration,
          textScaler:
          TextScaler.linear(sizeQuery* 0.009),
        )
      ],
    );
  }


}