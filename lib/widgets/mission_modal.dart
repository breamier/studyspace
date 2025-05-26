import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:studyspace/models/mission.dart';

class MissionCompleteModal extends StatelessWidget {
  final Mission mission;
  final VoidCallback onContinue;

  const MissionCompleteModal({
    super.key,
    required this.mission,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: deviceWidth * 0.85,
            minWidth: 200,
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 22, 22, 22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              padding: EdgeInsets.all(deviceWidth * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Mission Complete!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth * 0.06,
                      fontFamily: 'Arimo',
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  Text(
                    mission.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth * 0.045,
                      fontFamily: 'Arimo',
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  Image.asset(
                    "assets/astro_mission.png",
                    width: deviceWidth * 0.4,
                    height: deviceHeight * 0.18,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  Text(
                    "Reward: ${mission.rewardPoints} points",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth * 0.045,
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.03),
                  ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(194, 109, 68, 221),
                      minimumSize: Size(deviceWidth * 0.5, deviceHeight * 0.07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      "Continue Studying",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceWidth * 0.045,
                        fontFamily: 'Arimo',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
