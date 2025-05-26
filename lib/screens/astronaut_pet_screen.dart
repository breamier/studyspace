import 'package:flutter/material.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/widgets/navbar.dart';
import 'marketplace_screen.dart';
import 'edit_astronaut_screen.dart';
import 'package:studyspace/item_manager.dart';
import 'package:studyspace/services/astro_hp_service.dart';
import '../models/astronaut_pet.dart';
import 'astronaut_traveling_screen.dart';
import 'death_astronaut_screen.dart';

class AstronautPetScreen extends StatefulWidget {
  final IsarService isar;
  const AstronautPetScreen({Key? key, required this.isar}) : super(key: key);

  @override
  State<AstronautPetScreen> createState() => _AstronautPetScreenState();
}

// track pet travel state
enum PetTravelState { idle, readyToLaunch, traveling, arrived }

class _AstronautPetScreenState extends State<AstronautPetScreen>
    with TickerProviderStateMixin {
  final ItemManager _itemManager = ItemManager();
  Map<String, dynamic>? _currentAstronaut;
  Map<String, dynamic>? _currentSpaceship;

  // use to update pet for hp and mission progress
  late Future<AstronautPet?> _currentPet;
  late final ValueNotifier<bool> _itemChangeNotifier;

  // Animation controllers
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;

  // default pet travel state is idle
  PetTravelState _petTravelState = PetTravelState.idle;
  @override
  void initState() {
    super.initState();
    _currentPet = widget.isar.getCurrentPet();
    _getCurrentItems();
    //_itemChangeNotifier = _itemManager.itemChangedNotifier;
    //_itemChangeNotifier.addListener(_handleItemChanged);

    // for item manager
    _itemChangeNotifier = ItemManager().itemChangedNotifier;
    _itemChangeNotifier.addListener(_onPointsChanged);

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
    _itemChangeNotifier.removeListener(_onPointsChanged);

    _floatingController.dispose();
    super.dispose();
  }

  void _handleItemChanged() {
    if (mounted) {
      setState(() {
        _getCurrentItems();
        _currentPet = widget.isar.getCurrentPet();
      });
    }
  }

  void _getCurrentItems() {
    setState(() {
      _currentAstronaut = _itemManager.getCurrentAstronaut();
      _currentSpaceship = _itemManager.getCurrentSpaceship();

      // Debug prints to help troubleshoot
      print('Current Astronaut: $_currentAstronaut');
      print('Current Spaceship: $_currentSpaceship');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _currentPet = widget.isar.getCurrentPet();
    });
  }

  void _onPointsChanged() {
    if (mounted) setState(() {}); // This will rebuild the FutureBuilder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(),
        automaticallyImplyLeading: false,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFF2A2A2A),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/shooting_star.png',
                  width: 25,
                  height: 25,
                ),
                const SizedBox(width: 6),
                FutureBuilder<int>(
                  future: ItemManager().getUserPoints(),
                  builder: (context, snapshot) {
                    final points = snapshot.data ?? 0;
                    return Text(
                      '$points',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/stars.png', fit: BoxFit.cover),
          ),
          Container(
            color: Colors.black.withValues(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHpProgressBar(),
                  const SizedBox(height: 12),
                  _buildMissionProgressBar(),
                  const SizedBox(height: 12),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _floatingController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatingAnimation.value),
                            child: Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: _buildLayeredDisplay(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        isar: widget.isar,
      ),
    );
  }

  Widget _buildLayeredDisplay() {
    return Hero(
      tag: 'selected-image',
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Image.asset(
              'assets/moon.png',
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
          ),
          if (_currentAstronaut != null)
            _buildAstronautPosition(_currentAstronaut!),
          if (_currentSpaceship != null)
            _buildSpaceshipPosition(_currentSpaceship!),
        ],
      ),
    );
  }

  // Custom positioning for astronauts based on their type
  Widget _buildAstronautPosition(Map<String, dynamic> astronaut) {
    Map<String, double> position = _getAstronautPosition(astronaut['image']);

    return Positioned(
      top: MediaQuery.of(context).size.height * position['top']!,
      right: MediaQuery.of(context).size.width * position['right']!,
      child: Transform.rotate(
        angle: position['rotation']! * 3.14159 / 180,
        child: Image.asset(
          astronaut['image'],
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * position['height']!,
          width: MediaQuery.of(context).size.width * position['width']!,
        ),
      ),
    );
  }

  // Custom positioning for spaceships based on their type
  Widget _buildSpaceshipPosition(Map<String, dynamic> spaceship) {
    Map<String, double> position = _getSpaceshipPosition(spaceship['image']);

    return Positioned(
      top: MediaQuery.of(context).size.height * position['top']!,
      left: MediaQuery.of(context).size.width * position['left']!,
      child: Transform.rotate(
        angle: position['rotation']! * 3.14159 / 180,
        child: Image.asset(
          spaceship['image'],
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * position['height']!,
          width: MediaQuery.of(context).size.width * position['width']!,
        ),
      ),
    );
  }

  // Define custom positions for each astronaut type
  Map<String, double> _getAstronautPosition(String imagePath) {
    switch (imagePath) {
      case 'assets/blue_astronaut.png':
        return {
          'top': 0.01,
          'right': 0.18,
          'height': 0.13,
          'width': 0.26,
          'rotation': -7.0,
        };

      case 'assets/orange_astronaut.png':
        return {
          'top': 0.03,
          'right': 0.20,
          'height': 0.14,
          'width': 0.28,
          'rotation': 25.0,
        };

      case 'assets/purple_astronaut.png':
        return {
          'top': 0.05,
          'right': 0.20,
          'height': 0.15,
          'width': 0.27,
          'rotation': 2.0,
        };

      case 'assets/black_astronaut.png':
        return {
          'top': 0.01,
          'right': 0.18,
          'height': 0.13,
          'width': 0.26,
          'rotation': -7.0,
        };

      case 'assets/green_astronaut.png':
        return {
          'top': 0.02,
          'right': 0.28,
          'height': 0.13,
          'width': 0.26,
          'rotation': 3.0,
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

  // Define custom positions for each spaceship type
  Map<String, double> _getSpaceshipPosition(String imagePath) {
    switch (imagePath) {
      case 'assets/white_spaceship.png':
        return {
          'top': 0.10,
          'left': 0.10,
          'height': 0.12,
          'width': 0.25,
          'rotation': -40.0,
        };

      case 'assets/purple_spaceship.png':
        return {
          'top': -0.02,
          'left': 0.07,
          'height': 0.13,
          'width': 0.26,
          'rotation': -31.0,
        };

      case 'assets/orange_spaceship.png':
        return {
          'top': 0.10,
          'left': 0.08,
          'height': 0.12,
          'width': 0.25,
          'rotation': -45.0,
        };

      case 'assets/black_spaceship.png':
        return {
          'top': 0.10,
          'left': 0.08,
          'height': 0.12,
          'width': 0.25,
          'rotation': -45.0,
        };

      case 'assets/blue_spaceship.png':
        return {
          'top': -0.02,
          'left': 0.07,
          'height': 0.13,
          'width': 0.26,
          'rotation': -31.0,
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

  Widget _buildHpProgressBar() {
    return FutureBuilder<AstronautPet?>(
      future: _currentPet,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Text("please add your first goal",
              style: TextStyle(color: Colors.white));
        }

        final pet = snapshot.data!;
        final hpPercent = pet.hp / 100.0;
        final hpColor = AstroHpService.getHpColor(hpPercent);

        // if pet is ded, rip r/whoosh
        if (pet.hp <= 0) {
          pet.isAlive = false;
          Future.microtask(() {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DeathAstronautScreen(isar: widget.isar),
                ),
              );
            }
          });
          return SizedBox.shrink();
        }

        return _buildProgressBar(
          'assets/astronaut_icon.png',
          'HP: ${(pet.hp).toStringAsFixed(0)}%',
          hpPercent,
          hpColor.withValues(),
          hpColor.withValues(),
          Colors.white,
        );
      },
    );
  }

  Widget _buildMissionProgressBar() {
    return FutureBuilder<AstronautPet?>(
      future: _currentPet,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text("please add your first goal",
              style: TextStyle(color: Colors.white));
        }
        final pet = snapshot.data!;
        final progress = pet.progress;

        // If pet is traveling, always go to traveling screen
        if (pet.isTraveling) {
          Future.microtask(() {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AstronautTravelScreen(isar: widget.isar),
                ),
              );
            }
          });

          return SizedBox.shrink();
        }

        // If progress is full , not travelling,
        if (pet.hp > 1.0 && progress >= 1.0 && !pet.isTraveling) {
          Future.microtask(() async {
            pet.progress = 0.0;
            pet.isTraveling = true;
            pet.planetsCount += 1;

            await widget.isar.updatePet(pet);
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AstronautTravelScreen(isar: widget.isar),
                ),
              );
            }
          });
        }

        // If pet has arrived, show the progress bar
        return _buildProgressBar(
          'assets/rocket_icon.png',
          'Progress: ${(progress * 100).toStringAsFixed(0)}%',
          progress,
          Colors.blue,
          Colors.green,
          Colors.white,
        );
      },
    );
  }

  Widget _buildProgressBar(String iconPath, String label, double progress,
      Color startColor, Color endColor, Color textColor) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 28,
          height: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [startColor, endColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        label,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder<AstronautPet?>(
              future: _currentPet,
              builder: (context, snapshot) {
                final count = snapshot.data?.planetsCount ?? 0;
                return _buildStatHeader(
                  'assets/planet_icon.png',
                  'Planets Visited:',
                  count.toString(),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          _buildActionButton(
            Icons.shopping_basket,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarketplaceScreen(isar: widget.isar),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            Icons.edit,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAstronautScreen(isar: widget.isar),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatHeader(String iconPath, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconPath,
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'BrunoAceSC',
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'BrunoAceSC',
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 1),
            color: const Color(0xFF333333),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildMissionProgress(String missionName, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          missionName,
          style: const TextStyle(
            fontFamily: 'Arimo',
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.black,
            color: Colors.white,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
