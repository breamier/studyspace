import 'package:flutter/material.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/widgets/navbar.dart';
import 'marketplace_screen.dart';
import 'edit_astronaut_screen.dart';
import 'package:studyspace/item_manager.dart';

import '../services/astro_hp_service.dart';
import '../models/astronaut_pet.dart';
import '../services/isar_service.dart';

enum TravelState { initial, traveling, arrived }

class AstronautTravelScreen extends StatefulWidget {
  final IsarService isar;
  final bool forceArrived;
  const AstronautTravelScreen(
      {Key? key, required this.isar, this.forceArrived = false})
      : super(key: key);

  @override
  State<AstronautTravelScreen> createState() => _AstronautTravelScreenState();
}

class _AstronautTravelScreenState extends State<AstronautTravelScreen>
    with TickerProviderStateMixin {
  final ItemManager _itemManager = ItemManager();

  // set pet travel state to has arrived
  TravelState _travelState = TravelState.arrived;
  late final ValueNotifier<bool> _itemChangeNotifier;

  Map<String, dynamic>? _currentAstronaut;
  Map<String, dynamic>? _currentSpaceship;

  late AnimationController _sizeController;
  late AnimationController _positionController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _positionAnimation;
  late Animation<double> _rotationAnimation;

  // Controller for arrival animation
  late AnimationController _arrivalController;
  late Animation<double> _flagWaveAnimation;
  late Animation<double> _bounceAnimation;

  final IsarService _isarService = IsarService();
  late Future<AstronautPet?> _currentPet;

  @override
  void initState() {
    super.initState();

    _itemChangeNotifier = _itemManager.itemChangedNotifier;
    _itemChangeNotifier.addListener(_handleItemChanged);

    _getCurrentItems();

    _currentPet = widget.isar.getCurrentPet();
    _currentPet.then((pet) {
      if (pet != null) {
        setState(() {
          if (widget.forceArrived) {
            _travelState = TravelState.arrived;
          } else if (pet.isTraveling) {
            _travelState = TravelState.traveling;
            Future.delayed(const Duration(seconds: 5), () async {
              if (mounted) {
                setState(() {
                  _travelState = TravelState.arrived;
                });
                pet.isTraveling = false;
                await widget.isar.updatePet(pet);
              }
            });
          } else {
            _travelState = TravelState.arrived;
          }
        });
      }
    });

    // Animation for astronaut size
    _sizeController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.8)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 60.0,
      ),
    ]).animate(_sizeController);

    _sizeController.forward();

    // Animation for astronaut movement
    _positionController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _positionAnimation = Tween<double>(begin: -20.0, end: 20.0)
        .chain(CurveTween(curve: Curves.easeInOutBack))
        .animate(_positionController);

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.05)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_positionController);

    // Animation for arrival effects
    _arrivalController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _flagWaveAnimation = Tween<double>(begin: -0.1, end: 0.1)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_arrivalController);

    _bounceAnimation = Tween<double>(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_arrivalController);

    // Automatically transition to arrived state after traveling
    if (_travelState == TravelState.traveling) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _travelState = TravelState.arrived;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _itemChangeNotifier.removeListener(_handleItemChanged);
    _sizeController.dispose();
    _positionController.dispose();
    _arrivalController.dispose();
    super.dispose();
  }

  void _handleItemChanged() {
    if (mounted) {
      _getCurrentItems();
      setState(() {
        // Trigger rebuild to update user points display
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
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _buildCurrentView(),
          ),
        ],
      ),
      bottomNavigationBar: _travelState != TravelState.arrived
          ? CustomBottomNavBar(
              currentIndex: -1,
              isar: widget.isar,
            )
          : null,
    );
  }

  Widget _buildCurrentView() {
    switch (_travelState) {
      case TravelState.initial:
        return _buildLaunchView();
      case TravelState.traveling:
        return _buildTravelingView();
      case TravelState.arrived:
        return _buildArrivedView();
      default:
        return _buildLaunchView();
    }
  }

  Widget _buildLaunchView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProgressSection(),
          _buildStatsSection(),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              "Tap To Launch OFF",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'BrunoAceSC',
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _travelState = TravelState.traveling;
                  // Auto transition to arrived state after 5 seconds
                  Future.delayed(const Duration(seconds: 10), () async {
                    if (mounted) {
                      setState(() {
                        _travelState = TravelState.arrived;
                      });
                      final pet = await widget.isar.getCurrentPet();
                      if (pet != null) {
                        pet.isTraveling = false;
                        await widget.isar.updatePet(pet);
                      }
                    }
                  });
                });
              },
              child: Center(
                child: _buildLayeredDisplay(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return FutureBuilder<AstronautPet?>(
      future: widget.isar.getCurrentPet(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        }
        final pet = snapshot.data!;
        final hpPercent = pet.hp / 100.0;
        final progress = pet.progress;

        widget.isar.updatePet(pet);

        if (_travelState == TravelState.arrived && progress >= 1.0) {
          Future.microtask(() async {
            pet.progress = 0.0;
            pet.isTraveling = false;

            await widget.isar.updatePet(pet);
            if (mounted) {
              setState(() {
                _travelState = TravelState.traveling;
              });
              Future.delayed(const Duration(seconds: 5), () async {
                if (mounted) {
                  setState(() {
                    _travelState = TravelState.arrived;
                  });
                  final updatedPet = await widget.isar.getCurrentPet();
                  if (updatedPet != null) {
                    updatedPet.isTraveling = false;
                    await widget.isar.updatePet(updatedPet);
                  }
                }
              });
            }
          });
          return SizedBox.shrink();
        }

        return Column(
          children: [
            _buildProgressBar(
              'assets/astronaut_icon.png',
              'HP: ${pet.hp.toStringAsFixed(0)}%',
              hpPercent,
              AstroHpService.getHpColor(hpPercent),
              AstroHpService.getHpColor(hpPercent),
              Colors.white,
            ),
            const SizedBox(height: 12),
            _buildProgressBar(
              'assets/rocket_icon.png',
              'Progress: ${(progress * 100).toStringAsFixed(0)}%',
              progress,
              Colors.blue,
              Colors.green,
              Colors.white,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTravelingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "YOUR ASTRONAUT IS\nTRAVELLING...",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'BrunoAceSC',
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          // Animated astronaut
          Stack(
            alignment: Alignment.center,
            children: [
              _buildDistantStars(),

              // Main astronaut animation
              AnimatedBuilder(
                animation:
                    Listenable.merge([_sizeController, _positionController]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_positionAnimation.value, 0),
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Transform.scale(
                        scale: _sizeAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/traveling_astronaut.png',
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
              ),

              _buildSpaceParticles(),
            ],
          ),
        ],
      ),
    );
  }

  // NEW PLANET 2 - Updated to show Saturn with layered display
  Widget _buildArrivedView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProgressSection(),
          _buildStatsSection(),
          const SizedBox(height: 24),
          const Text(
            "YOUR ASTRONAUT HAS\nARRIVED ON A NEW PLANET!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'BrunoAceSC',
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: Center(
              child: _buildSaturnLayeredDisplay(),
            ),
          ),
        ],
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
          if (_currentAstronaut != null &&
              _currentAstronaut!['current'] == true)
            _buildAstronautPosition(_currentAstronaut!),
          if (_currentSpaceship != null &&
              _currentSpaceship!['current'] == true)
            _buildSpaceshipPosition(_currentSpaceship!),
        ],
      ),
    );
  }

  Widget _buildSaturnLayeredDisplay() {
    return AnimatedBuilder(
      animation: _arrivalController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value * 0.5),
          child: Hero(
            tag: 'saturn-scene',
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: Image.asset(
                    'assets/saturn.png',
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                ),
                if (_currentAstronaut != null &&
                    _currentAstronaut!['current'] == true)
                  _buildAstronautPosition(_currentAstronaut!),
                if (_currentSpaceship != null &&
                    _currentSpaceship!['current'] == true)
                  _buildSpaceshipPosition(_currentSpaceship!),
              ],
            ),
          ),
        );
      },
    );
  }

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
          'rotation': 15.0,
        };

      case 'assets/purple_astronaut.png':
        return {
          'top': 0.05,
          'right': 0.18,
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
          'right': 0.23,
          'height': 0.13,
          'width': 0.26,
          'rotation': 10.0,
        };

      default:
        return {
          'top': 0.01,
          'right': 0.18,
          'height': 0.13,
          'width': 0.26,
          'rotation': -7.0,
        };
    }
  }

  // Define custom positions for each spaceship type
  Map<String, double> _getSpaceshipPosition(String imagePath) {
    switch (imagePath) {
      case 'assets/white_spaceship.png':
        return {
          'top': 0.10,
          'left': 0.15,
          'height': 0.12,
          'width': 0.25,
          'rotation': -40.0,
        };

      case 'assets/purple_spaceship.png':
        return {
          'top': -0.02,
          'left': 0.10,
          'height': 0.14,
          'width': 0.27,
          'rotation': -18.0,
        };

      case 'assets/orange_spaceship.png':
        return {
          'top': 0.10,
          'left': 0.15,
          'height': 0.12,
          'width': 0.25,
          'rotation': -40.0,
        };

      case 'assets/black_spaceship.png':
        return {
          'top': 0.08,
          'left': 0.15,
          'height': 0.12,
          'width': 0.25,
          'rotation': -45.0,
        };

      case 'assets/blue_spaceship.png':
        return {
          'top': -0.02,
          'left': 0.10,
          'height': 0.13,
          'width': 0.26,
          'rotation': -40.0,
        };

      default:
        return {
          'top': 0.10,
          'left': 0.08,
          'height': 0.12,
          'width': 0.25,
          'rotation': -16.0,
        };
    }
  }

  Widget _buildDistantStars() {
    return AnimatedBuilder(
      animation: _sizeController,
      builder: (context, child) {
        final animValue = (_sizeController.value * 4) % 2;
        final scale = animValue < 1 ? animValue : 2 - animValue;

        return Opacity(
          opacity: 0.7 * scale,
          child: Transform.scale(
            scale: 0.5 + (scale * 0.5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/stars.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpaceParticles() {
    return AnimatedBuilder(
      animation: _positionController,
      builder: (context, child) {
        return Opacity(
          opacity: 0.4,
          child: Transform.translate(
            offset: Offset(-_positionAnimation.value * 2, 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              child: CustomPaint(
                painter: SpaceParticlesPainter(
                  animationValue: _positionController.value,
                ),
              ),
            ),
          ),
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

class SpaceParticlesPainter extends CustomPainter {
  final double animationValue;

  SpaceParticlesPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round;

    final random = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < 100; i++) {
      final seed = (i * random) % 1000;
      final x = seed % size.width;
      final y = (seed * 0.7) % size.height;
      final speed = ((i % 5) + 1) * 0.2;
      final adjustedX = (x + (animationValue * 100 * speed)) % size.width;

      paint.strokeWidth = (i % 3) * 0.8 + 0.5;

      paint.color = Colors.white.withOpacity(0.3 + ((i % 5) * 0.14));

      canvas.drawCircle(Offset(adjustedX, y), 0.8, paint);
    }
  }

  @override
  bool shouldRepaint(SpaceParticlesPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
