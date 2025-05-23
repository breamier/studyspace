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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white, width: 2.0),
        ),
        title: Text(
          "Mission Complete!",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Arimo',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mission.text,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Arimo',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Reward: ${mission.rewardPoints} points",
              style: TextStyle(
                color: Colors.green,
                fontFamily: 'Arimo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              "assets/austronaut.png",
              width: 100,
              height: 100,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: onContinue,
            child: Text(
              "Continue Studying",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Arimo',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
