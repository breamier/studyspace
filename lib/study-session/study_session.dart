import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/screens/dashboard_screen.dart';
import 'package:studyspace/study-session/study-session-end.dart';
import 'package:studyspace/study-session/study_session_tasks.dart';

import '../models/goal.dart';
import '../services/isar_service.dart';

class StudySession extends StatefulWidget {
  final Id goalId;
  final String imgLoc;
  final IsarService isarService;

  const StudySession(
      {super.key,
      required this.goalId,
      required this.imgLoc,
      required this.isarService});

  @override
  State<StudySession> createState() {
    return _StateStudySession();
  }
}

class _StateStudySession extends State<StudySession>
    with TickerProviderStateMixin {
  final IsarService _isarService = IsarService();
  late Future<Goal?> goal;
  Timer? timer;
  int time = 3599;
  late String goalName;
  bool isActive = true;
  bool _isLoading = true;
  DateTime start = DateTime.now();
  bool showPopUp = false;
  bool dontShowCheckIns = false;
  bool showEndSession = false;
  bool showCancelSession = false;
  String headerText = "";
  String questionText = "";
  String yesButtonText = "";
  String noButtonText = "";
  int promptIndex = 0;
  List<String> headers = [
    'Just Checking In....',
    'Hey human!',
    "You've been studying so long!",
  ];
  List<String> questions = [
    'Are you still studying?',
    'Are ya still there?',
    "Take a break?",
  ];
  List<String> yesButtons = [
    'Yes, I am',
    'Yes, I am',
    "Sure!",
  ];
  List<String> noButtons = [
    'End Session',
    'End Session',
    "No, Thanks",
  ];

  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void dispose() {
    timer?.cancel();
    _floatingController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    goal = _isarService.getGoalById(widget.goalId);
    goal.then((value) {
      if (value == null) {
        print("Goal not found for id: ${widget.goalId}");
        setState(() {
          _isLoading = false;
        });
        // Optionally, show an error dialog or navigate back
        return;
      }
      goalName = value.goalName;
      setState(() {
        _isLoading = false;
      });
    });
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -6.0, end: 6.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_floatingController);

    _rotationAnimation = Tween<double>(begin: -0.2, end: -0.1)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_floatingController);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (goalName.isEmpty) {
      return const Center(child: Text("Goal not found."));
    }
    timer ??= Timer.periodic(const Duration(seconds: 1), (Timer t) {
      handleTick();
    });
    return Scaffold(
      body: Stack(
        children: [
          _buildUI(),
          if (showPopUp) _buildPopUp(),
          if (showEndSession) _buildEndSessionNotif(),
          if (showCancelSession) _buildCancelSessionPopup()
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
              onPressed: () {
                setState(() {
                  showCancelSession = true;
                });
              },
            ),
          ),
        ),

        backgroundColor: Colors.transparent, // transparent app bar
        elevation: 0, // remove shadow
      ),
      backgroundColor: const Color(0xFF0A001F), // darker background
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
              SizedBox(
                  height: MediaQuery.sizeOf(context).height *
                      0.1), // Add space below the app bar
              timerStack(),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
              Text("current session",
                  style: TextStyle(
                    fontFamily: "Amino",
                    fontSize: 18,
                  )),
              Text(
                goalName,
                style: TextStyle(
                  fontFamily: "Amino",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                        isActive = false;
                        showEndSession = true;
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Main timer (HH:MM)
        Text(
          strDuration,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Digital-7",
            // Use a digital font if available
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 16,
                color: Colors.deepPurpleAccent.withValues(alpha: 0.7),
                offset: Offset(0, 0),
              ),
            ],
            letterSpacing: 2,
          ),
        ),
        // Seconds, smaller and offset
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            strSec,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Digital-7",
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.deepPurpleAccent.withOpacity(0.7),
                  offset: Offset(0, 0),
                ),
              ],
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget timerContainer() {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.65,
      height: MediaQuery.sizeOf(context).width * 0.65,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade900,
            Colors.deepPurple.shade700,
            Colors.deepPurple,
            Colors.deepPurpleAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.5),
            blurRadius: 32,
            spreadRadius: 4,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: studyTimer(),
    );
  }

  Widget timerButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isActive = !isActive;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.5),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: null,
          // Disable the button's onPressed, handled by GestureDetector
          style: ButtonStyle(
            shape: WidgetStateProperty.all(CircleBorder()),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(0),
            minimumSize: WidgetStateProperty.all(Size(
                MediaQuery.sizeOf(context).width * 0.15,
                MediaQuery.sizeOf(context).width * 0.15)),
            overlayColor:
                WidgetStateProperty.all(Colors.white.withOpacity(0.1)),
          ),
          child: Icon(
            isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
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
          left: MediaQuery.sizeOf(context).width * 0.15,
          top: MediaQuery.sizeOf(context).height * -0.1,
          child: _buildLayeredDisplay(),
        ),
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
    if (!dontShowCheckIns && time % 3600 == 0 && !showPopUp && isActive) {
      setState(() {
        isActive = false;
        promptIndex = Random().nextInt(3);
        headerText = headers[promptIndex];
        questionText = questions[promptIndex];
        yesButtonText = yesButtons[promptIndex];
        noButtonText = noButtons[promptIndex];
        showPopUp = true;
      });
    }
  }

  Widget _buildPopUp() {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(width: 1, color: Colors.white),
                horizontal: BorderSide(width: 1, color: Colors.white)),
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(headerText,
                  style: TextStyle(fontFamily: "BrunoAceSC", fontSize: 12)),
              Text(
                questionText,
                style: TextStyle(fontFamily: "Amino", fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/austronaut.png",
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).width * 0.1,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showPopUp = false;
                                if (promptIndex == 2) {
                                  isActive = false;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              elevation: 3,
                            ),
                            child: Text(yesButtonText),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).width * 0.1,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showPopUp = false;
                                if (promptIndex == 0 || promptIndex == 1) {
                                  showEndSession = true;
                                } else if (promptIndex == 2) {
                                  isActive = true;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              elevation: 3,
                            ),
                            child: Text(noButtonText),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: dontShowCheckIns,
                              onChanged: (value) {
                                setState(() {
                                  dontShowCheckIns = value!;
                                });
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                            Flexible(
                              child: Text("Don't show again for this session.",
                                  style: TextStyle(
                                      fontFamily: "Amino",
                                      fontSize: 10,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEndSessionNotif() {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Thanks for studying with me",
                  style: TextStyle(fontFamily: "BrunoAceSC", fontSize: 12)),
              Text(
                "End the session?",
                style: TextStyle(fontFamily: "Amino", fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/austronaut.png",
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Column(children: [
                    ElevatedButton(
                      onPressed: () {
                        timer?.cancel();
                        isActive = false;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudySessionEnd(
                                    goalId: widget.goalId,
                                    duration: time,
                                    imgLoc: widget.imgLoc,
                                    start: start,
                                    end: DateTime.now())));
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                          minimumSize: Size(
                              MediaQuery.sizeOf(context).width * 0.4,
                              MediaQuery.sizeOf(context).width * 0.1),
                          elevation: 3),
                      child: Text(
                        "Yes",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => showEndSession = false),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          minimumSize: Size(
                              MediaQuery.sizeOf(context).width * 0.4,
                              MediaQuery.sizeOf(context).width * 0.1),
                          elevation: 3),
                      child: Text(
                        "Cancel",
                      ),
                    ),
                  ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelSessionPopup() {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Leaving so soon?",
                  style: TextStyle(fontFamily: "BrunoAceSC", fontSize: 12)),
              Text(
                "Returning to main menu will cancel the session.",
                style: TextStyle(fontFamily: "Amino", fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/austronaut.png",
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Column(children: [
                    ElevatedButton(
                      onPressed: () {
                        timer?.cancel();
                        isActive = false;

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) =>
                                DashboardScreen(isar: _isarService),
                          ),
                          (route) => false,
                        );
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                          minimumSize: Size(
                              MediaQuery.sizeOf(context).width * 0.4,
                              MediaQuery.sizeOf(context).width * 0.1),
                          elevation: 3),
                      child: Text(
                        "Main Menu",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => showCancelSession = false),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          minimumSize: Size(
                              MediaQuery.sizeOf(context).width * 0.4,
                              MediaQuery.sizeOf(context).width * 0.1),
                          elevation: 3),
                      child: Text(
                        "Stay",
                      ),
                    ),
                  ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayeredDisplay() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return SizedBox(
                  child: Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Hero(
                    tag: 'selected-image',
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          child: Image.asset(
                            'assets/purple_astronaut.png',
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
            },
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.4,
              child: AnimatedBuilder(
            animation: AnimationController(
              duration: const Duration(seconds: 3),
              vsync: this,
            )..repeat(reverse: true),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: DefaultTextStyle(
                  softWrap: true,
                  textWidthBasis: TextWidthBasis.values[1],
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: "BrunoAceSC",
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 7.0,
                        color: Colors.white,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText("Keep up the great work!"),
                      TyperAnimatedText("You're doing amazing!"),
                      TyperAnimatedText("Stay focused, you're almost there!"),
                      TyperAnimatedText("Every minute counts, keep going!"),
                      TyperAnimatedText(
                          "You're making progress, don't stop now!"),
                      TyperAnimatedText("Your future self will thank you!"),
                    ],
                    isRepeatingAnimation: true,
                    pause: const Duration(minutes: 10),
                    repeatForever: true,
                  ),
                ),
              );
            },
          ))
        ]);
  }
}
