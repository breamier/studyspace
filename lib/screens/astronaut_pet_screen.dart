import 'package:flutter/material.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/widgets/navbar.dart';
import 'marketplace_screen.dart';
import 'edit_astronaut_screen.dart';
import 'package:studyspace/item_manager.dart';
import 'package:studyspace/services/astro_hp_service.dart';
import 'package:studyspace/services/isar_service.dart';

import '../models/astronaut_pet.dart';
import 'astronaut_traveling_screen.dart';

class AstronautPetScreen extends StatefulWidget {
  final IsarService isar;
  const AstronautPetScreen({Key? key, required this.isar}) : super(key: key);

  @override
  State<AstronautPetScreen> createState() => _AstronautPetScreenState();
}

class _AstronautPetScreenState extends State<AstronautPetScreen>
    with TickerProviderStateMixin {
  final ItemManager _itemManager = ItemManager();
  final IsarService _isarService = IsarService();
  Map<String, dynamic>? _currentAstronaut;
  Map<String, dynamic>? _currentSpaceship;

  // use to update pet for hp and mission progress
  late Future<AstronautPet?> _currentPet;
  late final ValueNotifier<bool> _itemChangeNotifier;

  // Animation controllers
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _currentPet = widget.isar.getCurrentPet();
    _getCurrentItems();
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
      setState(() {
        _getCurrentItems();
        _currentPet = _isarService.getCurrentPet();
      });
    }
  }

  void _getCurrentItems() {
    setState(() {
      _currentAstronaut = _itemManager.getCurrentAstronaut();
      _currentSpaceship = _itemManager.getCurrentSpaceship();
    });
  }

  // object has changed value
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // refresh pet data every time the screen is shown
    setState(() {
      _currentPet = widget.isar.getCurrentPet();
    });
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
                Text(
                  '${_itemManager.userPoints}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
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
                              child: Hero(
                                tag: 'selected-image',
                                child: Image.asset(
                                  _getDisplayImage(),
                                  fit: BoxFit.contain,
                                ),
                              ),
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

  Widget _buildHpProgressBar() {
    return FutureBuilder<AstronautPet?>(
      future: _currentPet,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Text("No pet found", style: TextStyle(color: Colors.white));
        }

        final pet = snapshot.data!;
        final hpPercent = pet.hp / 100.0;
        final hpColor = AstroHpService.getHpColor(hpPercent);

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
          return Text("No pet found", style: TextStyle(color: Colors.white));
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

        // If progress is full and not already traveling/arrived, go to traveling screen
        if (progress >= 1.0 && !pet.isTraveling && !pet.hasArrived) {
          Future.microtask(() async {
            pet.progress = 0.0;
            pet.isTraveling = true;
            pet.hasArrived = false;
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

  String _getDisplayImage() {
    if (_currentAstronaut == null && _currentSpaceship == null) {
      return 'assets/moon_with_astronaut.png';
    }

    final astronaut = _currentAstronaut;
    final spaceship = _currentSpaceship;

    String? astronautColor = astronaut != null && astronaut['current'] == true
        ? astronaut['name'].split(' ')[0].toLowerCase()
        : null;

    String? spaceshipColor = spaceship != null && spaceship['current'] == true
        ? spaceship['name'].split(' ')[0].toLowerCase()
        : null;

    if (spaceshipColor != null) {
      return 'assets/moon_with_${spaceshipColor}_spaceship.png';
    }

    if (astronautColor != null) {
      return 'assets/moon_with_${astronautColor}_astronaut.png';
    }

    return 'assets/moon_with_astronaut.png';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<AstronautPet?>(
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
                const SizedBox(height: 24),
                _buildActionButton(
                  Icons.backpack,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MarketplaceScreen(isar: widget.isar),
                      ),
                    ).then((_) => setState(() {}));
                  },
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  Icons.edit,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditAstronautScreen(isar: widget.isar),
                      ),
                    ).then((_) => setState(() {}));
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        'assets/Satellite_icon.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const Text(
                      "Missions:",
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                _buildMissionsBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatHeader(String iconPath, String label, String value) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'BrunoAceSC',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'BrunoAceSC',
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
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

  Widget _buildMissionsBox() {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 25),
      padding: const EdgeInsets.all(12),
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMissionProgress("Mission 1", 0.9),
          const SizedBox(height: 12),
          _buildMissionProgress("Mission 2", 0.4),
          const SizedBox(height: 12),
          _buildMissionProgress("Mission 3", 0.6),
        ],
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
