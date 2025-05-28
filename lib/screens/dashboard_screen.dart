import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:studyspace/models/goal.dart';
import 'package:studyspace/models/mission.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/screens/information_screen.dart';
import 'package:studyspace/screens/astronaut_pet_screen.dart';
import 'package:studyspace/item_manager.dart';
import '../study-session/study_session_camera.dart';
import '../widgets/navbar.dart';
import '../dev_tools_screen.dart';
import '../models/astronaut_pet.dart';

// Font styles
final TextStyle kHeadingFont = const TextStyle(
  fontFamily: 'BrunoAceSC',
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(
      blurRadius: 10.0,
      color: Colors.white,
      offset: Offset(0, 0),
    ),
    Shadow(
      blurRadius: 20.0,
      color: kPurple,
      offset: Offset(0, 0),
    ),
  ],
);

final TextStyle noGlowHeading = kHeadingFont.copyWith(
  fontSize: 14,
  shadows: [],
);

final TextStyle kBodyFont = const TextStyle(
  fontFamily: 'Arimo',
  fontSize: 14,
  color: Colors.white,
);

// Color variables
const Color kPurple = Color(0xFF6C44DD);
const Color kOnyx = Color(0xFF0E0E0E);
const Color kWhite = Colors.white;

class DashboardScreen extends StatefulWidget {
  final IsarService isar;
  const DashboardScreen({super.key, required this.isar});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final ItemManager _itemManager = ItemManager();
  late Future<List<Goal>> _goalsFuture;
  late Future<List<Mission>> _missionsFuture;
  late Future<AstronautPet?> _currentPet;
  Map<String, dynamic>? _currentAstronaut;
  Map<String, dynamic>? _currentSpaceship;
  late final ValueNotifier<bool> _itemChangeNotifier;
  bool _hasArrivedOnNewPlanet = false;

  // Animation controllers for floating effect
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _refreshGoals();
    _refreshMissions();
    _getCurrentItems();
    _checkPlanetStatus();
    _itemChangeNotifier = _itemManager.itemChangedNotifier;
    _itemChangeNotifier.addListener(_handleItemChanged);

    // Initialize floating animation
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -6.0, end: 6.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_floatingController);

    _rotationAnimation = Tween<double>(begin: -0.03, end: 0.03)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_floatingController);
  }

  @override
  void dispose() {
    _itemChangeNotifier.removeListener(_handleItemChanged);
    _floatingController.dispose();
    super.dispose();
  }

  void _handleItemChanged() {
    if (mounted) {
      _getCurrentItems();
      _checkPlanetStatus();
    }
  }

  void _getCurrentItems() {
    setState(() {
      _currentAstronaut = _itemManager.getCurrentAstronaut();
      _currentSpaceship = _itemManager.getCurrentSpaceship();
    });
  }

  void _checkPlanetStatus() {
    _currentPet = widget.isar.getCurrentPet();
    _currentPet.then((pet) {
      if (mounted && pet != null) {
        setState(() {
          _hasArrivedOnNewPlanet =
              pet.isTraveling == false && pet.planetsCount >= 1;
        });
      }
    });
  }

  // Build the layered display - shows Saturn if astronaut has arrived on new planet
  Widget _buildLayeredDisplay() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Show Saturn if astronaut has arrived on new planet, otherwise show Moon
                Image.asset(
                  _hasArrivedOnNewPlanet
                      ? 'assets/saturn.png'
                      : 'assets/moon.png',
                  fit: BoxFit.contain,
                  height: 280,
                ),

                if (_currentAstronaut != null)
                  _buildAstronautPosition(_currentAstronaut!),

                if (_currentSpaceship != null)
                  _buildSpaceshipPosition(_currentSpaceship!),
              ],
            ),
          ),
        );
      },
    );
  }

  // Custom positioning for astronauts based on their type
  Widget _buildAstronautPosition(Map<String, dynamic> astronaut) {
    Map<String, double> position = _getAstronautPosition(astronaut['image']);

    return Positioned(
      top: 280 * position['top']!,
      right: 280 * position['right']!,
      child: Transform.rotate(
        angle: position['rotation']! * 3.14159 / 180,
        child: Image.asset(
          astronaut['image'],
          fit: BoxFit.contain,
          height: 280 * position['height']!,
          width: 280 * position['width']!,
        ),
      ),
    );
  }

  // Custom positioning for spaceships based on their type
  Widget _buildSpaceshipPosition(Map<String, dynamic> spaceship) {
    Map<String, double> position = _getSpaceshipPosition(spaceship['image']);

    return Positioned(
      top: 280 * position['top']!,
      left: 280 * position['left']!,
      child: Transform.rotate(
        angle: position['rotation']! * 3.14159 / 180,
        child: Image.asset(
          spaceship['image'],
          fit: BoxFit.contain,
          height: 280 * position['height']!,
          width: 280 * position['width']!,
        ),
      ),
    );
  }

  Map<String, double> _getAstronautPosition(String imagePath) {
    // If on Saturn, use different positioning
    if (_hasArrivedOnNewPlanet) {
      return _getSaturnAstronautPosition(imagePath);
    }

    // Original Moon positions
    switch (imagePath) {
      case 'assets/blue_astronaut.png':
        return {
          'top': -0.05,
          'right': 0.25,
          'height': 0.50,
          'width': 0.30,
          'rotation': -7.0,
        };

      case 'assets/orange_astronaut.png':
        return {
          'top': -0.12,
          'right': 0.20,
          'height': 0.70,
          'width': 0.40,
          'rotation': 25.0,
        };

      case 'assets/purple_astronaut.png':
        return {
          'top': 0.05,
          'right': 0.20,
          'height': 0.50,
          'width': 0.40,
          'rotation': 2.0,
        };

      case 'assets/black_astronaut.png':
        return {
          'top': -0.05,
          'right': 0.25,
          'height': 0.50,
          'width': 0.28,
          'rotation': -7.0,
        };

      case 'assets/green_astronaut.png':
        return {
          'top': -0.05,
          'right': 0.30,
          'height': 0.50,
          'width': 0.30,
          'rotation': 10.0,
        };

      default:
        return {
          'top': 0.13,
          'right': 0.08,
          'height': 0.12,
          'width': 0.25,
          'rotation': 0.0,
        };
    }
  }

  // Saturn-specific astronaut positions
  Map<String, double> _getSaturnAstronautPosition(String imagePath) {
    switch (imagePath) {
      case 'assets/blue_astronaut.png':
        return {
          'top': -0.02,
          'right': 0.28,
          'height': 0.35,
          'width': 0.25,
          'rotation': -7.0,
        };

      case 'assets/orange_astronaut.png':
        return {
          'top': -0.05,
          'right': 0.25,
          'height': 0.40,
          'width': 0.30,
          'rotation': 15.0,
        };

      case 'assets/purple_astronaut.png':
        return {
          'top': 0.02,
          'right': 0.28,
          'height': 0.35,
          'width': 0.28,
          'rotation': 2.0,
        };

      case 'assets/black_astronaut.png':
        return {
          'top': -0.02,
          'right': 0.28,
          'height': 0.35,
          'width': 0.25,
          'rotation': -7.0,
        };

      case 'assets/green_astronaut.png':
        return {
          'top': -0.01,
          'right': 0.32,
          'height': 0.35,
          'width': 0.25,
          'rotation': 10.0,
        };

      default:
        return {
          'top': -0.02,
          'right': 0.28,
          'height': 0.35,
          'width': 0.25,
          'rotation': -7.0,
        };
    }
  }

  Map<String, double> _getSpaceshipPosition(String imagePath) {
    // If on Saturn, use different positioning
    if (_hasArrivedOnNewPlanet) {
      return _getSaturnSpaceshipPosition(imagePath);
    }

    // Original Moon positions
    switch (imagePath) {
      case 'assets/white_spaceship.png':
        return {
          'top': 0.13,
          'left': 0.15,
          'height': 0.50,
          'width': 0.25,
          'rotation': -40.0,
        };

      case 'assets/purple_spaceship.png':
        return {
          'top': -0.18,
          'left': 0.07,
          'height': 0.50,
          'width': 0.30,
          'rotation': -31.0,
        };

      case 'assets/orange_spaceship.png':
        return {
          'top': 0.18,
          'left': 0.15,
          'height': 0.40,
          'width': 0.25,
          'rotation': -40.0,
        };

      case 'assets/black_spaceship.png':
        return {
          'top': 0.18,
          'left': 0.15,
          'height': 0.40,
          'width': 0.25,
          'rotation': -40.0,
        };

      case 'assets/blue_spaceship.png':
        return {
          'top': -0.10,
          'left': 0.10,
          'height': 0.50,
          'width': 0.30,
          'rotation': -40.0,
        };

      default:
        return {
          'top': 0.5,
          'left': 0.08,
          'height': 0.12,
          'width': 0.25,
          'rotation': -16.0,
        };
    }
  }

  // Saturn-specific spaceship positions
  Map<String, double> _getSaturnSpaceshipPosition(String imagePath) {
    switch (imagePath) {
      case 'assets/white_spaceship.png':
        return {
          'top': 0.08,
          'left': 0.18,
          'height': 0.35,
          'width': 0.22,
          'rotation': -40.0,
        };

      case 'assets/purple_spaceship.png':
        return {
          'top': -0.08,
          'left': 0.12,
          'height': 0.38,
          'width': 0.25,
          'rotation': -18.0,
        };

      case 'assets/orange_spaceship.png':
        return {
          'top': 0.08,
          'left': 0.18,
          'height': 0.35,
          'width': 0.22,
          'rotation': -40.0,
        };

      case 'assets/black_spaceship.png':
        return {
          'top': 0.06,
          'left': 0.18,
          'height': 0.35,
          'width': 0.22,
          'rotation': -45.0,
        };

      case 'assets/blue_spaceship.png':
        return {
          'top': -0.06,
          'left': 0.12,
          'height': 0.37,
          'width': 0.24,
          'rotation': -40.0,
        };

      default:
        return {
          'top': 0.08,
          'left': 0.12,
          'height': 0.35,
          'width': 0.22,
          'rotation': -16.0,
        };
    }
  }

  Future<List<Goal>> _fetchGoals() async {
    final isar = await widget.isar.db;
    return await isar.goals.where().findAll();
  }

  void _refreshGoals() {
    setState(() {
      _goalsFuture = _fetchGoals();
    });
  }

  // missions
  Future<List<Mission>> _loadMissions() async {
    // Get today's missions
    return await widget.isar.getMissions();
  }

  Future<void> _refreshMissions() async {
    setState(() {
      _missionsFuture = _loadMissions();
    });
  }

  Future<void> _completeMission(int missionId) async {
    await widget.isar.completeMission(missionId);
    _refreshMissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kOnyx,
        appBar: AppBar(
          backgroundColor: kOnyx,
          elevation: 0,
          title: Text(
            'Study Space',
            style: kHeadingFont,
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh, color: kWhite),
                onPressed: () {
                  _refreshGoals();
                  _refreshMissions();
                  _checkPlanetStatus(); // Also refresh planet status
                }),
            IconButton(
              icon: const Icon(Icons.help_outline, color: kWhite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InformationScreen()),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/stars.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder<List<Goal>>(
            future: _goalsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final goals = snapshot.data ?? [];
              final currentGoals = goals.where((g) => g.isCurrent).toList();
              final upcomingGoals = goals.where((g) => g.isUpcoming).toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DevToolsScreen(isar: widget.isar)),
                        );
                      },
                      child: const Text('Go to Developer Tools'),
                    ),
                    // Current Study Goals
                    if (currentGoals.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      sectionTitle("Today's Study Goal"),
                      const SizedBox(height: 10),
                      for (final goal in currentGoals)
                        studyGoalTile(
                          '📖 ${goal.goalName}',
                          'Study Now',
                          goal.id,
                          date: DateFormat('dd / MM / yyyy').format(goal.end),
                          isToday:
                              DateUtils.isSameDay(goal.end, DateTime.now()),
                        )
                    ] else ...[
                      // Today's Study Goals
                      const SizedBox(height: 10),
                      sectionTitle("Today's Study Goal"),
                      const SizedBox(height: 10),
                      const Text(
                        'No study goals today',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],

                    // Upcoming Study Goals
                    if (upcomingGoals.isNotEmpty) ...[
                      const SizedBox(height: 30),
                      sectionTitle('Upcoming Study Goals'),
                      const SizedBox(height: 10),
                      for (final goal in upcomingGoals)
                        studyGoalTile(
                          '📖 ${goal.goalName}',
                          'View',
                          goal.id,
                          date: DateFormat('dd / MM / yyyy').format(goal.start),
                        ),
                    ] else ...[
                      const SizedBox(height: 30),
                      sectionTitle('Upcoming Study Goals'),
                      const SizedBox(height: 10),
                      const Text(
                        'No upcoming study goals',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],

                    // Mission Board
                    const SizedBox(height: 30),
                    sectionTitle('Mission Board'),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Mission>>(
                      future: _missionsFuture,
                      builder: (context, missionsSnapshot) {
                        if (missionsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final missions = missionsSnapshot.data ?? [];
                        final displayedMissions = missions.take(3).toList();

                        if (missions.isEmpty) {
                          return Column(
                            children: [
                              Icon(Icons.flag_outlined,
                                  color: Colors.white54, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                "No missions yet.",
                                style: kBodyFont.copyWith(
                                    fontSize: 16, color: Colors.white54),
                              ),
                            ],
                          );
                        }

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: kWhite),
                            color: const Color.fromARGB(40, 189, 183, 183),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 0; i < displayedMissions.length; i++)
                                missionTile(displayedMissions[i], i + 1),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 30.0),
                                      child: Image.asset(
                                        'assets/austronaut.png',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AstronautPetScreen(
                                                    isar: widget.isar),
                                          ),
                                        );
                                        _refreshMissions();
                                        setState(() {});
                                      },
                                      label: Text(
                                        'Visit your\nAstronaut >>',
                                        style: noGlowHeading.copyWith(
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Layered display of astronaut and spaceship
                    const SizedBox(height: 30),

                    Center(
                      child: _buildLayeredDisplay(),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 0,
          isar: widget.isar,
        ));
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: kHeadingFont.copyWith(
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget studyGoalTile(String title, String buttonText, Id goalId,
      {String? date, bool isToday = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isToday
            ? const Color.fromARGB(201, 244, 244, 244).withOpacity(0.1)
            : Colors.transparent,
        border: Border.all(
          color: isToday ? kPurple : kWhite,
          width: isToday ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 229, 220, 255).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          if (isToday)
            const Padding(
              padding: EdgeInsets.only(right: 8),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kBodyFont.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
                ),
                if (date != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Due on $date',
                      style: kBodyFont.copyWith(
                        fontSize: 12,
                        color: const Color(0xB3FFFFFF),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kOnyx,
              side: const BorderSide(color: kWhite),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudySessionCamera(
                            goalId: goalId,
                            isarService: widget.isar,
                          )));
            },
            child: Text(buttonText, style: kBodyFont),
          )
        ],
      ),
    );
  }

  Widget missionTile(Mission mission, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Mission $index: ${mission.text}',
              style: kBodyFont.copyWith(
                fontSize: 14,
                color: mission.completed ? Colors.green : Colors.white,
              ),
            ),
          ),
          if (mission.completed)
            const Icon(Icons.check, size: 20, color: Colors.green),
        ],
      ),
    );
  }

  Widget missionText(String mission) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          mission,
          style: kBodyFont.copyWith(fontSize: 14),
        ),
      ),
    );
  }
}
