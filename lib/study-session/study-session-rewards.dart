import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/main.dart';

import '../models/goal.dart';
import '../models/mission.dart';
import '../services/isar_service.dart';

class StudySessionRewards extends StatefulWidget {
  final Id goalId;

  const StudySessionRewards({super.key, required this.goalId});

  @override
  State<StudySessionRewards> createState() => _StudySessionRewardsState();
}

class _StudySessionRewardsState extends State<StudySessionRewards>
    with SingleTickerProviderStateMixin {
  final IsarService _isarService = IsarService();
  Goal? _goal;
  bool _isLoading = true;
  late Future<List<Mission>> _missionsFuture;
  final List<String> _allMissions = [
    'Study 30 minutes straight',
    'Take a picture',
    'Study a total of 1 hour',
    'Drink water every 30 mins',
    'Study after 9 PM',
    'Complete 3 study sessions',
  ];
  final List<String> _allRewards = [
    'Exploration Credits',
    'Resource Points',
    'Experience Points',
  ];

  @override
  void initState() {
    super.initState();
    _loadGoal();
    // _isarService.initializeDailyMissions(_allMissions);
    _missionsFuture = _isarService.getMissions();
  }

  Future<void> _loadGoal() async {
    setState(() => _isLoading = false);
    try {
      final goal = await _isarService.getGoalById(widget.goalId);
      if (mounted) {
        setState(() {
          _goal = goal;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
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
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Summary and Rewards",
              style: TextStyle(
                fontFamily: 'Amino',
                fontSize: 20,
              ),
            ),
            Text(
              "next study session schedule",
              style: TextStyle(fontFamily: 'BrunoAceSC', fontSize: 18),
            ),
            Text(
                '${_goal!.start.day}/${_goal!.start.month}/${_goal!.start.year}',
                style: TextStyle(
                  fontFamily: 'BrunoAceSC',
                  fontSize: 18,
                )),
            // Mission Board
            Spacer(),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.045),
                child: FutureBuilder<List<Mission>>(
                  future: _missionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final missions = snapshot.data ?? [];
                    final displayedMissions = missions.take(3).toList();
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: const Color.fromARGB(40, 189, 183, 183),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Completed Missions',
                              style: TextStyle(
                                fontFamily: 'BrunoAceSC',
                                fontSize: 18,
                              )),
                          for (var i = 0; i < displayedMissions.length; i++)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, left: 10),
                              child: Row(children: [
                                Icon(Icons.arrow_right, size: 18),
                                Text(
                                  displayedMissions[i].text,
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Amino'),
                                ),
                              ]),
                            ),
                        ],
                      ),
                    );
                  },
                )),
            // Mission Board
            const SizedBox(height: 30),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.045),
                child: FutureBuilder<List<Mission>>(
                  future: _missionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final missions = snapshot.data ?? [];
                    final displayedMissions = missions.take(3).toList();
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: const Color.fromARGB(40, 189, 183, 183),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Icon(Icons.star),
                            Text('Rewards',
                                style: TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                  fontSize: 18,
                                ))
                          ]),
                          SizedBox(height: 10),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, top: 8, left: 10),
                                child: Row(children: [
                                  Icon(Icons.rocket_launch_outlined, size: 18),
                                  Text(
                                    "Experience",
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'Amino'),
                                  ),
                                  Spacer(),
                                  Text("+10")
                                ]),
                              )),
                          SizedBox(height: 10),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, top: 8, left: 10),
                                child: Row(children: [
                                  Icon(Icons.map_outlined, size: 18),
                                  Text(
                                    "Experience",
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'Amino'),
                                  ),
                                  Spacer(),
                                  Text("+10")
                                ]),
                              )),
                          SizedBox(height: 10),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, top: 8, left: 10),
                                child: Row(children: [
                                  Icon(Icons.stars_outlined, size: 18),
                                  Text(
                                    "Resource Points",
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'Amino'),
                                  ),
                                  Spacer(),
                                  Text("+10")
                                ]),
                              )),
                        ],
                      ),
                    );
                  },
                )),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  //update data and send data
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
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
              child: Text("Claim Rewards",
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
}
