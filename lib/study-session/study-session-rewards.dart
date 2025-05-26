import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:isar/isar.dart';

import '../models/goal.dart';
import '../models/mission.dart';
import '../models/session.dart';
import '../services/isar_service.dart';
import '../services/astro_hp_service.dart';

class StudySessionRewards extends StatefulWidget {
  final Id goalId;
  final int? study30MinReward;
  final Session session;

  const StudySessionRewards({
    super.key,
    required this.goalId,
    this.study30MinReward,
    required this.session,
  });

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
    _missionsFuture = _isarService.getMissions();
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
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
                  // find the 30-min mission if completed
                  final filtered = missions.where(
                    (m) => m.text == 'Study 30 minutes straight' && m.completed,
                  );
                  final study30MinMission =
                      filtered.isNotEmpty ? filtered.first : null;

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
                        SizedBox(height: 10),
                        if (study30MinMission != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              study30MinMission.text,
                              style: TextStyle(
                                  fontFamily: 'Amino',
                                  fontSize: 18,
                                  color: Colors.green),
                            ),
                          )
                        else
                          Text(
                            "You have not completed any mission",
                            style: TextStyle(
                                fontFamily: 'Amino',
                                fontSize: 18,
                                color: Colors.red),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            // Rewards Board
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
                  // find the 30-min mission if completed
                  final study30MinMission = missions
                      .where((m) =>
                          m.text == 'Study 30 minutes straight' && m.completed)
                      .cast<Mission?>()
                      .firstWhere((_) => true, orElse: () => null);
                  // calculate hp increase for this session
                  return FutureBuilder<double>(
                    future: _goal != null
                        ? AstroHpService(_isarService).calculateHpIncrease(
                            session: widget.session,
                            goal: _goal!,
                          )
                        : Future.value(0.0),
                    builder: (context, hpSnapshot) {
                      final hpIncrease = hpSnapshot.data ?? 0.0;
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
                            // hp increase by fetching hpIncrease from the hp_service
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
                                    "Health Points",
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'Amino'),
                                  ),
                                  Spacer(),
                                  Text("+${hpIncrease.toStringAsFixed(1)} HP")
                                ]),
                              ),
                            ),
                            SizedBox(height: 10),
                            // reward points by fetching reward points from the mission
                            if (study30MinMission != null) ...[
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
                                      "Lumix",
                                      style: TextStyle(
                                          fontSize: 14, fontFamily: 'Amino'),
                                    ),
                                    Spacer(),
                                    Text(
                                        "+${study30MinMission.rewardPoints} pts")
                                  ]),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  //update data and send data
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
