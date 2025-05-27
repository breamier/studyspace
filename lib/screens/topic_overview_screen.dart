import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/services/scheduler.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import 'package:studyspace/study-session/study_session_camera.dart';
import 'package:studyspace/study-session/study_session_tasks.dart';

class TopicOverview extends StatefulWidget {
  final Id goalId;

  const TopicOverview({
    super.key,
    required this.goalId,
  });

  @override
  State<TopicOverview> createState() => _TopicOverviewState();
}

class _TopicOverviewState extends State<TopicOverview> {
  final IsarService _isarService = IsarService();
  Goal? _goal;
  bool _isLoading = true;
  final List<TextEditingController> _subtopicControllers = [];
  final FocusNode _newSubtopicFocusNode = FocusNode();

  // subtopics to delete
  final List<Subtopic> _selectedSubtopicsToDelete = [];

  late double deviceHeight;
  late double deviceWidth;
  late bool isSmallScreen;
  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    isSmallScreen = deviceWidth < 600;
  }

  Future<void> _loadGoal() async {
    setState(() => _isLoading = true);
    try {
      final goal = await _isarService.getGoalById(widget.goalId);
      if (mounted) {
        setState(() {
          _goal = goal;
          if (goal != null) {
            _initializeControllers(goal.subtopics);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _initializeControllers(List<Subtopic> subtopics) {
    _subtopicControllers.clear();
    for (var subtopic in subtopics) {
      _subtopicControllers.add(TextEditingController(text: subtopic.name));
    }
  }

  Future<void> _saveSubtopics() async {
    if (_goal == null) return;

    final newSubtopics = _subtopicControllers
        .where((c) => c.text.trim().isNotEmpty)
        .map((controller) {
      final existing = _goal!.subtopics.firstWhere(
        (s) => s.name == controller.text.trim(),
        orElse: () => Subtopic()..name = controller.text.trim(),
      );
      return existing..name = controller.text.trim();
    }).toList();

    _goal!.subtopics = newSubtopics;
    await _isarService.updateGoal(_goal!);
    if (mounted) setState(() {});
  }

  void _addNewSubtopicField() {
    setState(() => _subtopicControllers.add(TextEditingController()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_newSubtopicFocusNode);
    });
  }

  void _toggleSubtopicCompletion(int index) async {
    if (_goal == null || index >= _goal!.subtopics.length) return;

    setState(() {
      _goal!.subtopics[index].completed = !_goal!.subtopics[index].completed;
    });
    await _isarService.updateGoal(_goal!);
  }

  Future<void> _showDeleteGoalDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white, width: 2.0),
        ),
        title: const Text(
          'Delete Goal?',
          style: TextStyle(color: Colors.white, fontFamily: 'Arimo'),
        ),
        content: const Text(
          'Are you sure you want to delete this goal? This action cannot be undone.',
          style: TextStyle(color: Colors.white70, fontFamily: 'Arimo'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
              child: const Text('Delete',
                  style: TextStyle(color: Colors.redAccent)),
              onPressed: () => {
                    Navigator.pop(context, true),
                  }),
        ],
      ),
    );
    if (confirm == true && _goal != null) {
      await _isarService.deleteGoal(_goal!);
      if (mounted) {
        Navigator.pop(context); // Go back after deletion
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Goal deleted.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showDeleteSubtopicDialog() {
    final selectedSubtopics =
        _goal!.subtopics.where((s) => !s.completed).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 22, 22, 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.white, width: 2.0),
              ),
              title: Text(
                'Select Subtopics to Delete',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: deviceWidth * 0.05,
                  fontFamily: 'Arimo',
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectedSubtopics.length,
                  itemBuilder: (context, index) {
                    final subtopic = selectedSubtopics[index];
                    return CheckboxListTile(
                      title: Text(
                        subtopic.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceWidth * 0.04,
                          fontFamily: 'Arimo',
                        ),
                      ),
                      value: _selectedSubtopicsToDelete.contains(subtopic),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedSubtopicsToDelete.add(subtopic);
                          } else {
                            _selectedSubtopicsToDelete.remove(subtopic);
                          }
                        });
                      },
                      activeColor: const Color.fromRGBO(176, 152, 228, 1),
                      checkColor: Colors.white,
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth * 0.04,
                      fontFamily: 'Arimo',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedSubtopicsToDelete.isNotEmpty) {
                      await _deleteSelectedSubtopics();
                      // Reload the goal after deletion
                      await _loadGoal();
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(194, 109, 68, 221),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white, width: 1.5),
                    ),
                  ),
                  child: Text(
                    'Delete Selected',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth * 0.04,
                      fontFamily: 'Arimo',
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteSelectedSubtopics() async {
    if (_goal == null || _selectedSubtopicsToDelete.isEmpty) return;

    try {
      // call deleteSubtopics
      await _isarService.deleteSubtopics(_goal!, _selectedSubtopicsToDelete);

      // update
      setState(() {
        // remove from goal's subtopics
        _goal!.subtopics.removeWhere(
            (subtopic) => _selectedSubtopicsToDelete.contains(subtopic));

        // remove deleted subtopics controllers
        _subtopicControllers.removeWhere((controller) =>
            _selectedSubtopicsToDelete
                .any((subtopic) => subtopic.name == controller.text));

        // clear list
        _selectedSubtopicsToDelete.clear();
      });

      // show message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Subtopics deleted successfully',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Arimo',
            ),
          ),
          backgroundColor: const Color.fromARGB(194, 109, 68, 221),
        ),
      );
    } catch (e) {
      // show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete subtopics',
            style: TextStyle(fontFamily: 'Arimo'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String> _getTotalStudyTime() async {
    if (_goal == null) return "00:00";
    await _goal!.sessions.load();
    final sessions = _goal!.sessions.toList();
    int totalSeconds = sessions.fold(0, (sum, s) => sum + (s.duration ?? 0));
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else {
      return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }

  // postpone dialog
  void _postponeNotification() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextSession = _goal!.upcomingSessionDates
        .where((d) => !d.isBefore(today))
        .toList()
      ..sort((a, b) => a.compareTo(b));
    final nextSessionDate = nextSession.isNotEmpty
        ? nextSession.first.add(const Duration(days: 1))
        : null;

    final nextSessionDisplay = nextSessionDate != null
        ? DateFormat('dd/MM/yyyy').format(nextSessionDate)
        : "No upcoming session";

    showPopupCard(
      context: context,
      alignment: const Alignment(0, -0.20),
      builder: (context) {
        return PopScope(
          canPop: false,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: deviceWidth * 0.85,
                    minWidth: 200,
                  ),
                  child: PopupCard(
                    elevation: 8,
                    color: const Color.fromARGB(255, 22, 22, 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white, width: 2.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(deviceWidth * 0.05),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delay your mission?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: deviceWidth * 0.05,
                              fontFamily: 'Arimo',
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.02),
                          Text(
                            "I'll move your mission to $nextSessionDisplay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceWidth * 0.035,
                              fontFamily: 'Arimo',
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Image.asset(
                                  "assets/astro_notification.png",
                                  width: deviceWidth * 0.4,
                                  height: deviceHeight * 0.25,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await Scheduler().postponeStudySession(
                                          goalId: widget.goalId);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TopicOverview(
                                              goalId: widget.goalId),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        194,
                                        109,
                                        68,
                                        221,
                                      ),
                                      minimumSize: Size(
                                        deviceWidth * 0.3,
                                        deviceHeight * 0.07,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: deviceWidth * 0.04,
                                        fontFamily: 'Arimo',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: deviceHeight * 0.02),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        106,
                                        105,
                                        105,
                                      ),
                                      minimumSize: Size(
                                        deviceWidth * 0.3,
                                        deviceHeight * 0.07,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: deviceWidth * 0.04,
                                        fontFamily: 'Arimo',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _subtopicControllers) {
      controller.dispose();
    }
    _newSubtopicFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_goal == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text('Goal not found')),
      );
    }

    final dateFormat = DateFormat('dd/MM/yyyy');
    final targetDate = dateFormat.format(_goal!.end);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextSession = _goal!.upcomingSessionDates
        .where((d) => !d.isBefore(today))
        .toList()
      ..sort((a, b) => a.compareTo(b));
    final nextSessionDate = nextSession.isNotEmpty
        ? DateFormat('dd/MM/yyyy').format(nextSession.first)
        : "No upcoming session";

    return WillPopScope(
      onWillPop: () async {
        await _saveSubtopics();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Goals",
            style: TextStyle(
              color: Colors.white,
              fontSize: deviceWidth * 0.05,
              fontFamily: 'BrunoAceSC',
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: deviceWidth * 0.06,
            ),
            onPressed: () async {
              await _saveSubtopics();
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent, size: deviceWidth * 0.065),
                onPressed: _showDeleteGoalDialog,
              ),
            )
          ],
        ),
        body: Container(
          width: deviceWidth,
          height: deviceHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backGroundScreen.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(deviceWidth * 0.04),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        deviceHeight - MediaQuery.of(context).padding.top,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: deviceHeight * 0.05),
                      Text(
                        _goal!.goalName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceWidth * 0.07,
                          fontFamily: 'Arimo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "target end date",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceWidth * 0.04,
                                  fontFamily: 'BrunoAceSC',
                                ),
                              ),
                              Text(
                                targetDate,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceWidth * 0.05,
                                  fontFamily: 'Arimo',
                                ),
                              ),
                            ],
                          ),
                          if (!isSmallScreen)
                            SizedBox(width: deviceWidth * 0.1),
                          Column(
                            children: [
                              Text(
                                "next session",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceWidth * 0.04,
                                  fontFamily: 'BrunoAceSC',
                                ),
                              ),
                              Text(
                                nextSessionDate,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceWidth * 0.05,
                                  fontFamily: 'Arimo',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      Text(
                        "total study time",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceWidth * 0.04,
                          fontFamily: 'BrunoAceSC',
                        ),
                      ),
                      FutureBuilder<String>(
                        future: _getTotalStudyTime(),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? "00:00",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceWidth * 0.1,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Arimo',
                            ),
                          );
                        },
                      ),
                      SizedBox(height: deviceHeight * 0.04),
                      _buildPhotoCard(),
                      SizedBox(height: deviceHeight * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.04,
                        ),
                        child: StudySessionTasks(goalId: _goal!.id),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: deviceWidth * 0.02,
                          right: deviceWidth * 0.04,
                          top: deviceHeight * 0.01,
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.04),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.04,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionButton(
                              text: "Start Session",
                              color: const Color.fromARGB(194, 109, 68, 221),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StudySessionCamera(
                                                goalId: widget.goalId,
                                                isarService: _isarService)));
                              },
                              deviceWidth: deviceWidth,
                              deviceHeight: deviceHeight,
                            ),
                            SizedBox(width: deviceWidth * 0.05),
                            _buildActionButton(
                              text: "Postpone Session",
                              color: const Color.fromARGB(185, 195, 29, 32),
                              onPressed: _postponeNotification,
                              deviceWidth: deviceWidth,
                              deviceHeight: deviceHeight,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoCard() {
    final sessions = _goal?.sessions.toList() ?? [];
    final images = sessions
        .map((s) => s.imgPath)
        .where((path) => path != null && path.isNotEmpty)
        .toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(deviceWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Photos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: deviceWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arimo',
                ),
              ),
              Text(
                "${images.length} photos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: deviceWidth * 0.035,
                  fontFamily: 'Arimo',
                ),
              ),
              SizedBox(height: deviceHeight * 0.01),
              Container(
                height: deviceHeight * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[200]?.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: images.isEmpty
                    ? Center(
                        child: Text(
                          "No photos yet.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Arimo',
                            fontSize: deviceWidth * 0.04,
                          ),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: deviceWidth > 600 ? 4 : 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final imgPath = images[index];
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.4),
                                barrierDismissible: true,
                                builder: (_) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 8, sigmaY: 8),
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: InteractiveViewer(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Image.file(
                                                  File(imgPath),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(imgPath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    required double deviceWidth,
    required double deviceHeight,
  }) {
    return SizedBox(
      width: deviceWidth * 0.35,
      height: deviceHeight * 0.075,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: deviceWidth * 0.035,
            fontFamily: 'Arimo',
          ),
        ),
      ),
    );
  }
}
