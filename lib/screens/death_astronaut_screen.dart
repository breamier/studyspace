import 'package:flutter/material.dart';
import 'marketplace_screen.dart';
import 'edit_astronaut_screen.dart';
import '../services/isar_service.dart';
import 'package:studyspace/item_manager.dart';

class DeathAstronautScreen extends StatefulWidget {
  final IsarService isar;
  const DeathAstronautScreen({Key? key, required this.isar})
      : super(key: key);

  @override
  State<DeathAstronautScreen> createState() =>
      _DeathAstronautScreenState();
}

class _DeathAstronautScreenState extends State<DeathAstronautScreen>
    with TickerProviderStateMixin {
  bool _showReviveDialog = false;
  bool _isRevived = false;
  final ItemManager _itemManager = ItemManager();
  Map<String, dynamic>? _currentAstronaut;

  // Animation controllers
  late AnimationController _deathAnimationController;
  late AnimationController _reviveAnimationController;
  late AnimationController _dialogAnimationController;
  late AnimationController _hpBarAnimationController;
  late AnimationController _floatingAnimationController;

  // Animations
  late Animation<double> _deathFadeAnimation;
  late Animation<double> _deathScaleAnimation;
  late Animation<double> _reviveScaleAnimation;
  late Animation<double> _reviveGlowAnimation;
  late Animation<double> _dialogScaleAnimation;
  late Animation<double> _dialogOpacityAnimation;
  late Animation<double> _hpBarAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _getCurrentAstronaut();
    _initializeAnimations();
    _startDeathAnimation();

    // Show revive dialog after death animation completes
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_isRevived) {
        _showReviveDialogWithAnimation();
      }
    });
  }

  void _initializeAnimations() {
    // Death animation controller
    _deathAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Revive animation controller
    _reviveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Dialog animation controller
    _dialogAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // HP bar animation controller
    _hpBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Floating animation controller
    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Death animations
    _deathFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _deathAnimationController,
      curve: Curves.easeInOut,
    ));

    _deathScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _deathAnimationController,
      curve: Curves.easeInOut,
    ));

    // Revive animations
    _reviveScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _reviveAnimationController,
      curve: Curves.elasticOut,
    ));

    _reviveGlowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _reviveAnimationController,
      curve: Curves.easeInOut,
    ));

    // Dialog animations
    _dialogScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.elasticOut,
    ));

    _dialogOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.easeInOut,
    ));

    // HP bar animation
    _hpBarAnimation = Tween<double>(
      begin: 0.0,
      end: 0.30,
    ).animate(CurvedAnimation(
      parent: _hpBarAnimationController,
      curve: Curves.easeInOut,
    ));

    // Floating animation
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start continuous floating animation when revived
    _floatingAnimationController.repeat(reverse: true);
  }

  void _startDeathAnimation() {
    _deathAnimationController.forward();
  }

  void _showReviveDialogWithAnimation() {
    setState(() {
      _showReviveDialog = true;
    });
    _dialogAnimationController.forward();
  }

  void _startReviveAnimation() {
    _dialogAnimationController.reverse().then((_) {
      setState(() {
        _showReviveDialog = false;
        _isRevived = true;
      });
      _reviveAnimationController.forward();
      _hpBarAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _deathAnimationController.dispose();
    _reviveAnimationController.dispose();
    _dialogAnimationController.dispose();
    _hpBarAnimationController.dispose();
    _floatingAnimationController.dispose();
    super.dispose();
  }

  void _getCurrentAstronaut() {
    setState(() {
      _currentAstronaut = _itemManager.getCurrentAstronaut();
    });
  }

  String _getDeadAstronautImage() {
    if (_currentAstronaut == null) {
      return 'assets/dead_astronaut.png';
    }

    String currentImage = _currentAstronaut!['image'];

    // Map current astronaut images to their dead counterparts
    switch (currentImage) {
      case 'assets/orange_astronaut.png':
        return 'assets/dead_orange_astronaut.png';
      case 'assets/blue_astronaut.png':
        return 'assets/dead_blue_astronaut.png';
      case 'assets/green_astronaut.png':
        return 'assets/dead_green_astronaut.png';
      case 'assets/black_astronaut.png':
        return 'assets/dead_black_astronaut.png';
      case 'assets/purple_astronaut.png':
        return 'assets/dead_purple_astronaut.png';
      default:
        return 'assets/dead_astronaut.png';
    }
  }

  String _getRevivedAstronautImage() {
    if (_currentAstronaut == null) {
      return 'assets/revived_astronaut.png';
    }

    String currentImage = _currentAstronaut!['image'];

    // Map current astronaut images to their revived counterparts
    switch (currentImage) {
      case 'assets/orange_astronaut.png':
        return 'assets/revived_orange_astronaut.png';
      case 'assets/blue_astronaut.png':
        return 'assets/revived_blue_astronaut.png';
      case 'assets/green_astronaut.png':
        return 'assets/revived_green_astronaut.png';
      case 'assets/black_astronaut.png':
        return 'assets/revived_black_astronaut.png';
      case 'assets/purple_astronaut.png':
        return 'assets/revived_purple_astronaut.png';
      default:
        return 'assets/revived_astronaut.png';
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
        title: Text(
          _isRevived ? "Home" : "Character Death",
          style: const TextStyle(
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _hpBarAnimation,
                    builder: (context, child) {
                      return _buildProgressBar(
                        'assets/astronaut_icon.png',
                        'HP',
                        _isRevived ? _hpBarAnimation.value : 0.0,
                        _isRevived ? Colors.green.shade700 : Colors.red.shade700,
                        _isRevived ? Colors.green.shade400 : Colors.red.shade400,
                        Colors.white,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProgressBar(
                    'assets/rocket_icon.png',
                    'Progress',
                    0.85,
                    Colors.grey.shade500,
                    Colors.grey.shade400,
                    Colors.black,
                  ),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      _isRevived
                          ? "YOUR ASTRONAUT HAS BEEN MIRACULOUSLY REVIVED!"
                          : "YOUR ASTRONAUT DIDN'T MAKE IT...",
                      key: ValueKey(_isRevived),
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                        color: _isRevived ? const Color(0xFFFFD700) : Colors.red.shade400, 
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        shadows: _isRevived ? [
                          Shadow(
                            color: Colors.amber.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: Center(
                      child: _buildAnimatedAstronaut(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Revive Dialog Overlay
          if (_showReviveDialog && !_isRevived)
            AnimatedBuilder(
              animation: _dialogAnimationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _dialogOpacityAnimation.value,
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                    child: Center(
                      child: Transform.scale(
                        scale: _dialogScaleAnimation.value,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyan.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TweenAnimationBuilder(
                                duration: const Duration(seconds: 2),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (context, double value, child) {
                                  return Transform.rotate(
                                    angle: value * 2 * 3.14159,
                                    child: const Icon(
                                      Icons.help_outline,
                                      color: Colors.cyan,
                                      size: 48,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "REVIVE ASTRONAUT?",
                                style: TextStyle(
                                  fontFamily: 'BrunoAceSC',
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TweenAnimationBuilder(
                                    duration: const Duration(milliseconds: 1500),
                                    tween: Tween<double>(begin: 0.8, end: 1.2),
                                    builder: (context, double value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: Image.asset(
                                          'assets/shooting_star.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "10",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              GestureDetector(
                                onTap: () {
                                  // Deduct points for revival if there are enough points
                                  if (_itemManager.deductPoints(10,
                                      reason: 'Astronaut Revival')) {
                                    _startReviveAnimation();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Insufficient points for revival!'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: TweenAnimationBuilder(
                                  duration: const Duration(milliseconds: 1000),
                                  tween: Tween<double>(begin: 0.9, end: 1.1),
                                  builder: (context, double value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Container(
                                        width: 120,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(25),
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.cyan.withOpacity(0.5),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "YES",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedAstronaut() {
    if (_isRevived) {
      return AnimatedBuilder(
        animation: Listenable.merge([
          _reviveAnimationController,
          _floatingAnimationController,
        ]),
        builder: (context, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Main astronaut image
              Transform.translate(
                offset: Offset(0, -_floatingAnimation.value),
                child: Transform.scale(
                  scale: _reviveScaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(_reviveGlowAnimation.value * 0.0), 
                          blurRadius: 25,
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: Colors.amber.withOpacity(_reviveGlowAnimation.value * 0.2),
                          blurRadius: 40,
                          spreadRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      _getRevivedAstronautImage(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Sparkles
              ..._buildSparkles(),
            ],
          );
        },
      );
    } else {
      return AnimatedBuilder(
        animation: _deathAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _deathScaleAnimation.value,
            child: Opacity(
              opacity: _deathFadeAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  _getDeadAstronautImage(),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  List<Widget> _buildSparkles() {
    if (!_isRevived) return [];
    
    final sparkles = <Widget>[];
    final sparklePositions = [
      {'x': -50.0, 'y': -30.0, 'delay': 0.0, 'size': 8.0},
      {'x': 40.0, 'y': -50.0, 'delay': 0.3, 'size': 6.0},
      {'x': -30.0, 'y': 20.0, 'delay': 0.6, 'size': 10.0},
      {'x': 60.0, 'y': 10.0, 'delay': 0.9, 'size': 7.0},
      {'x': 0.0, 'y': -60.0, 'delay': 1.2, 'size': 9.0},
      {'x': -60.0, 'y': -10.0, 'delay': 0.4, 'size': 5.0},
      {'x': 35.0, 'y': 40.0, 'delay': 0.8, 'size': 8.0},
      {'x': -20.0, 'y': -45.0, 'delay': 1.0, 'size': 6.0},
    ];

    for (final pos in sparklePositions) {
      sparkles.add(
        Positioned(
          left: pos['x']! as double,
          top: pos['y']! as double,
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 2000),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, double value, child) {
              final delayedValue = ((value - (pos['delay']! as double)).clamp(0.0, 1.0));
              final sparkleOpacity = delayedValue < 0.5 
                  ? delayedValue * 2 
                  : (1.0 - delayedValue) * 2;
              final sparkleScale = delayedValue < 0.5 
                  ? delayedValue * 2 
                  : 2.0 - (delayedValue * 2);
              
              return Transform.scale(
                scale: sparkleScale,
                child: Opacity(
                  opacity: sparkleOpacity.clamp(0.0, 1.0),
                  child: Container(
                    width: pos['size']! as double,
                    height: pos['size']! as double,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white,
                          const Color(0xFFFFD700), 
                          Colors.amber.shade300,
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: (pos['size']! as double) * 0.3,
                            height: (pos['size']! as double) * 0.3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white,
                                  const Color(0xFFFFD700), 
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Cross sparkle effect
                        Center(
                          child: Container(
                            width: pos['size']! as double,
                            height: 1.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white,
                                  const Color(0xFFFFD700), 
                                  Colors.white,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 1.5,
                            height: pos['size']! as double,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.white,
                                  const Color(0xFFFFD700), 
                                  Colors.white,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return sparkles;
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