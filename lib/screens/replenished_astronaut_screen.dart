import 'package:flutter/material.dart';
import 'marketplace_screen.dart';
import 'edit_astronaut_screen.dart';
import '../services/isar_service.dart';
import 'package:studyspace/item_manager.dart';

class ReplenishedAstronautScreen extends StatefulWidget {
  final IsarService isar;
  const ReplenishedAstronautScreen({Key? key, required this.isar})
      : super(key: key);

  @override
  State<ReplenishedAstronautScreen> createState() =>
      _ReplenishedAstronautScreenState();
}

class _ReplenishedAstronautScreenState extends State<ReplenishedAstronautScreen>
    with TickerProviderStateMixin {
  final ItemManager _itemManager = ItemManager();
  Map<String, dynamic>? _currentAstronaut;
  Map<String, dynamic>? _currentSpaceship;

  // Animation controllers
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _getCurrentItems();

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
    _floatingController.dispose();
    super.dispose();
  }

  void _getCurrentItems() {
    setState(() {
      _currentAstronaut = _itemManager.getCurrentAstronaut();
      _currentSpaceship = _itemManager.getCurrentSpaceship();
    });
  }

  // Method to get the replenished astronaut image based on current selection
  String _getReplenishedAstronautImage() {
    if (_currentAstronaut == null) {
      return 'assets/replenished_blue_astronaut.png'; // Default fallback
    }

    switch (_currentAstronaut!['image']) {
      case 'assets/blue_astronaut.png':
        return 'assets/replenished_blue_astronaut.png';
      case 'assets/orange_astronaut.png':
        return 'assets/replenished_orange_astronaut.png';
      case 'assets/green_astronaut.png':
        return 'assets/replenished_green_astronaut.png';
      case 'assets/purple_astronaut.png':
        return 'assets/replenished_purple_astronaut.png';
      case 'assets/black_astronaut.png':
        return 'assets/replenished_black_astronaut.png';
      default:
        return 'assets/replenished_blue_astronaut.png'; // Default fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
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
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProgressBar('assets/astronaut_icon.png', 'HP', 1.0,
                      Colors.red.shade700, Colors.red.shade400, Colors.white),
                  const SizedBox(height: 12),
                  _buildProgressBar('assets/rocket_icon.png', 'Progress', 0.85,
                      Colors.grey.shade500, Colors.grey.shade400, Colors.black),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatHeader(
                    'assets/planet_icon.png', 'Planets Visited:', '2'),
                const SizedBox(height: 24),
                _buildActionButton(
                  Icons.shopping_basket,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MarketplaceScreen(isar: widget.isar),
                      ),
                    );
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
                    );
                  },
                ),
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
            _buildReplenishedAstronautPosition(_currentAstronaut!),
          if (_currentSpaceship != null)
            _buildSpaceshipPosition(_currentSpaceship!),
        ],
      ),
    );
  }

  // Custom positioning for replenished astronauts based on their type
  Widget _buildReplenishedAstronautPosition(Map<String, dynamic> astronaut) {
    Map<String, double> position = _getAstronautPosition(astronaut['image']);

    return Positioned(
      top: MediaQuery.of(context).size.height * position['top']!,
      right: MediaQuery.of(context).size.width * position['right']!,
      child: Transform.rotate(
        angle: position['rotation']! * 3.14159 / 180,
        child: Image.asset(
          _getReplenishedAstronautImage(),
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
          'top': 0.00,
          'right': 0.20,
          'height': 0.14,
          'width': 0.26,
          'rotation': -7.0,
        };

      case 'assets/orange_astronaut.png':
        return {
          'top': 0.00,
          'right': 0.20,
          'height': 0.15,
          'width': 0.28,
          'rotation': -7.0,
        };

      case 'assets/purple_astronaut.png':
        return {
          'top': 0.01,
          'right': 0.20,
          'height': 0.15,
          'width': 0.27,
          'rotation': -1.0,
        };

      case 'assets/black_astronaut.png':
        return {
          'top': 0.00,
          'right': 0.20,
          'height': 0.15,
          'width': 0.26,
          'rotation': -7.0,
        };

      case 'assets/green_astronaut.png':
        return {
          'top': 0.01,
          'right': 0.20,
          'height': 0.15,
          'width': 0.26,
          'rotation': -1.0,
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
}
