import 'package:flutter/material.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/widgets/navbar.dart';
import 'marketplace_screen.dart';
import 'edit_astronaut_screen.dart';
import 'package:studyspace/item_manager.dart';

enum TravelState { initial, traveling, arrived }

class AstronautTravelScreen extends StatefulWidget {
  final IsarService isar;
  const AstronautTravelScreen({Key? key, required this.isar}) : super(key: key);

  @override
  State<AstronautTravelScreen> createState() => _AstronautTravelScreenState();
}

class _AstronautTravelScreenState extends State<AstronautTravelScreen> with TickerProviderStateMixin {
  final ItemManager _itemManager = ItemManager();
  TravelState _travelState = TravelState.initial;
  late final ValueNotifier<bool> _itemChangeNotifier;
  
  late AnimationController _sizeController;
  late AnimationController _positionController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _positionAnimation;
  late Animation<double> _rotationAnimation;
  
  // Controller for arrival animation
  late AnimationController _arrivalController;
  late Animation<double> _flagWaveAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    
    _itemChangeNotifier = _itemManager.itemChangedNotifier;
    _itemChangeNotifier.addListener(_handleItemChanged);
    
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
      setState(() {
        // Trigger rebuild to update user points display
      });
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
      // Only show bottom navigation bar when not in "arrived" state
      bottomNavigationBar: _travelState != TravelState.arrived ? CustomBottomNavBar(
        currentIndex: -1,
        isar: widget.isar,
      ) : null,
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
        return _buildLaunchView(); // Default case to handle any potential issues
    }
  }

  Widget _buildLaunchView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProgressBar('assets/astronaut_icon.png', 'HP', 1.0,
              Colors.red.shade700, Colors.red.shade400, Colors.white),
          const SizedBox(height: 12),
          _buildProgressBar('assets/rocket_icon.png', 'Progress', 1.0,
              Colors.grey.shade500, Colors.grey.shade400, Colors.black),
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
                  Future.delayed(const Duration(seconds: 5), () {
                    if (mounted) {
                      setState(() {
                        _travelState = TravelState.arrived;
                      });
                    }
                  });
                });
              },
              child: Center(
                child: Image.asset(
                  'assets/moon_with_spaceship.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
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
                animation: Listenable.merge([_sizeController, _positionController]),
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
  
  Widget _buildArrivedView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProgressBar('assets/astronaut_icon.png', 'HP', 1.0,
              Colors.red.shade700, Colors.red.shade400, Colors.white),
          const SizedBox(height: 12),
          _buildProgressBar('assets/rocket_icon.png', 'Progress', 1.0,
              Colors.grey.shade500, Colors.grey.shade400, Colors.black),
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
            child: AnimatedBuilder(
              animation: _arrivalController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value * 0.5),
                  child: Image.asset(
                    'assets/new_planet.png',
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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
                  Icons.backpack,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MarketplaceScreen(),
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
                        builder: (context) => const EditAstronautScreen(),
                      ),
                    );
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