import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/study-session/study_session.dart';

import '../mission_manager.dart';
import '../models/mission.dart';
import '../services/isar_service.dart';
import '../widgets/mission_modal.dart';

class StudySessionCamera extends StatefulWidget {
  final Id goalId;
  final IsarService isarService;

  const StudySessionCamera(
      {super.key, required this.goalId, required this.isarService});

  @override
  State<StudySessionCamera> createState() => _StudySessionCameraState();
}

class _StudySessionCameraState extends State<StudySessionCamera>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  CameraController? cameraController;
  bool showingTutorial = true;
  bool isAnimating = false;
  bool picTaken = false;
  late String goalName;
  File? imgFile;
  XFile? picture;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTutorial();
    _setupCameraController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 0.6),
        weight: 40,
      ),
    ]).animate(_animationController);

    _colorAnimation = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.white,
    ).animate(_animationController);

    _fetchGoalName();
  }

  Future<void> _loadTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      showingTutorial = prefs.getBool('showingTutorial') ?? true;
    });
  }

  Future<void> _fetchGoalName() async {
    final goal = await widget.isarService.getGoalById(widget.goalId);
    setState(() {
      goalName = goal?.goalName ?? '';
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildUI(),
          if (showingTutorial) _buildTutorialOverlay(),
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
    if (cameraController?.value.isInitialized != true) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Study Goal Session",
                  style: GoogleFonts.arimo(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  goalName,
                  style: GoogleFonts.arimo(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "Probing for life...",
              style: GoogleFonts.brunoAce(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              "Take a picture for this study session!",
              style: GoogleFonts.brunoAce(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            picTaken
                ? SizedBox.square(
                    dimension: MediaQuery.of(context).size.width * 0.8,
                    child: Image.file(imgFile!,
                        height: MediaQuery.of(context).size.width * 0.8),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: buildCameraPreview(cameraController!)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            picTaken
                ? Column(
                    children: [
                      Text(
                        "Satisfied with the picture?",
                        style:
                            TextStyle(fontSize: 18, fontFamily: "BrunoAceSC"),
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              debugPrint('Continue button pressed');
                              //Gal.putImage(imgFile!.path);

                              // check and complete selfie mission

                              final missionManager =
                                  MissionManager(widget.isarService);
                              debugPrint('About to check mission completion');
                              final completedMission = await missionManager
                                  .checkMissionCompletion(MissionType.selfie);
                              debugPrint(
                                  'Completed mission: $completedMission');

                              if (completedMission != null && mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => MissionCompleteModal(
                                    mission: completedMission,
                                    onContinue: () async {
                                      Navigator.of(context)
                                          .pop(); // close the modal

                                      // Fetch the goal from the database to ensure it exists
                                      final goal = await widget.isarService
                                          .getGoalById(widget.goalId);
                                      if (goal == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Goal not found. Please create a goal first.")),
                                        );
                                        return;
                                      }
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => StudySession(
                                            goalId: widget.goalId,
                                            imgLoc: imgFile!.path,
                                            isarService: widget.isarService,
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                // no mission to complete, just go to study session
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => StudySession(
                                      goalId: widget.goalId,
                                      imgLoc: imgFile!.path,
                                      isarService: widget.isarService,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              }

                              // go to study session
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => StudySession(
                              //               goalId: widget.goalId,
                              //               imgLoc: imgFile!.path,
                              //             )));
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.deepPurple),
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side:
                                            BorderSide(color: Colors.white)))),
                            child: Text("Continue",
                                style: TextStyle(
                                    fontFamily: "Arimo", fontSize: 16)),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  debugPrint('Setting picTaken to true');
                                  picTaken = false;
                                });
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.white24),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(
                                              color: Colors.white)))),
                              child: Text("Retake",
                                  style: TextStyle(
                                      fontFamily: "Arimo", fontSize: 16))),
                        ],
                      )
                    ],
                  )
                : AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, _) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: GestureDetector(
                          onTap: isAnimating ? null : _takePicture,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                              border: Border.all(
                                color:
                                    _colorAnimation.value ?? Colors.deepPurple,
                                width: 5,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _colorAnimation.value?.withOpacity(0.8) ??
                                          Colors.deepPurple.withOpacity(0.8),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => StudySession(
                        goalId: widget.goalId,
                        imgLoc: "",
                        isarService: widget.isarService,
                      ),
                    ),
                    (route) => false,
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: const Size(100, 30),
                  ),
                  child: Text(
                    "Can't take photo now. Skip",
                    style: GoogleFonts.brunoAce(
                      color: Colors.white,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "This will damage astronaut's health",
                  style: GoogleFonts.brunoAce(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialOverlay() {
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
            children: [
              Text(
                "Camera Guide",
                style: GoogleFonts.brunoAce(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _tutorialStep(
                "1",
                "Each study session needs a photo to track your progress.",
              ),
              const SizedBox(height: 10),
              _tutorialStep(
                "2",
                "Take a picture of your study space, materials, or yourself.",
              ),
              const SizedBox(height: 10),
              _tutorialStep(
                "3",
                "Photos help your astronaut's health grow.",
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('showingTutorial', false);
                      setState(() => showingTutorial = false);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                    ),
                    child: Text(
                      "HIDE",
                      style: GoogleFonts.brunoAce(fontSize: 14),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => showingTutorial = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "GOT IT",
                      style: GoogleFonts.brunoAce(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tutorialStep(String number, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: GoogleFonts.brunoAce(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            description,
            style: GoogleFonts.arimo(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _setupCameraController() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      cameraController = CameraController(cameras.first, ResolutionPreset.high);
      await cameraController?.initialize();
      if (mounted) setState(() {});
    }
  }

  Widget buildCameraPreview(CameraController cameraController) {
    final double previewAspectRatio = 1;
    return AspectRatio(
      aspectRatio: 1 / previewAspectRatio,
      child: ClipRect(
        child: Transform.scale(
          scale: cameraController.value.aspectRatio / previewAspectRatio,
          child: Center(
            child: CameraPreview(cameraController),
          ),
        ),
      ),
    );
  }

  void _takePicture() {
    if (isAnimating) return;

    setState(() => isAnimating = true);
    _animationController.forward().then((_) {
      _animationController.reverse();
      setState(() => isAnimating = false);
    });
    Future.delayed(const Duration(milliseconds: 150), () async {
      picture = await cameraController!.takePicture();
      var decodedImage =
          await decodeImageFromList(File(picture!.path).readAsBytesSync());

      var cropSize = min(decodedImage.width, decodedImage.height);
      var offsetX =
          (decodedImage.width - min(decodedImage.width, decodedImage.height)) ~/
              2;
      var offsetY = (decodedImage.height -
              min(decodedImage.width, decodedImage.height)) ~/
          2;

      final imageBytes =
          img.decodeImage(File(picture!.path).readAsBytesSync())!;

      img.Image cropOne = img.copyCrop(imageBytes,
          x: offsetX, y: offsetY, width: cropSize, height: cropSize);
      print(cropOne.height);
      print(cropOne.width);

      imgFile = await File(picture!.path).writeAsBytes(img.encodePng(cropOne));
      setState(() {
        picTaken = true;
      });
    });
  }
}
