import 'dart:math';
import 'package:flutter/material.dart';
import 'edit_astronaut_screen.dart';
import 'package:studyspace/item_manager.dart';
import '../services/isar_service.dart';

class MarketplaceScreen extends StatefulWidget {
  final IsarService isar;
  const MarketplaceScreen({Key? key, required this.isar}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _SpaceExpressMarketplaceState();
}

class _SpaceExpressMarketplaceState extends State<MarketplaceScreen>
    with TickerProviderStateMixin {
  final Map<String, bool> _clickedButtons = {};

  // Animation controllers for the loot box
  late AnimationController _boxController;
  late AnimationController _shakeController;
  late AnimationController _openController;
  late AnimationController _glowController;
  late AnimationController _particleController;

  // Animations
  late Animation<double> _boxScale;
  late Animation<double> _shakeAnimation;
  late Animation<double> _lidRotation;
  late Animation<double> _lidOffset;
  late Animation<double> _glowOpacity;
  late Animation<double> _particleAnimation;

  bool _showLootBox = false;
  String _currentLootBoxId = '';
  String? _selectedItem;
  int? _selectedIndex;
  bool _showResult = false;
  bool _isShaking = false;
  bool _isOpening = false;

  final int _itemCost = 10;
  List<Map<String, dynamic>> _lootBoxItems = [];
  final ItemManager _itemManager = ItemManager();

  bool _allAstronautsUnlocked = false;
  bool _allSpaceshipsUnlocked = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _boxController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _openController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _boxScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _boxController, curve: Curves.elasticOut),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    _lidRotation = Tween<double>(begin: 0.0, end: -0.6).animate(
      CurvedAnimation(parent: _openController, curve: Curves.easeOutBack),
    );

    _lidOffset = Tween<double>(begin: 0.0, end: -30.0).animate(
      CurvedAnimation(parent: _openController, curve: Curves.easeOutBack),
    );

    _glowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeOut),
    );

    // Animation listeners
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startBoxOpening();
      }
    });

    _openController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showResult = true;
        });
      }
    });

    _checkAllItemsUnlocked();
  }

  void _checkAllItemsUnlocked() {
    final astronauts = _itemManager.astronauts;
    final spaceships = _itemManager.spaceships;

    _allAstronautsUnlocked =
        astronauts.every((item) => item['unlocked'] == true);

    _allSpaceshipsUnlocked =
        spaceships.every((item) => item['unlocked'] == true);
  }

  @override
  void dispose() {
    _boxController.dispose();
    _shakeController.dispose();
    _openController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: _buildAppBar(),
      body: _showLootBox ? _buildLootBoxView() : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
            onPressed: () {
              if (_showLootBox) {
                setState(() {
                  _showLootBox = false;
                  _resetAnimations();
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      title: const Text(
        "Home",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      actions: [
        _buildPointsCounter(),
      ],
    );
  }

  Widget _buildPointsCounter() {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF2A2A2A),
      ),
      child: Row(
        children: [
          Image.asset('assets/shooting_star.png', width: 25, height: 25),
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
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Image.asset(
          'assets/stars.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Center(
                    child: Text(
                      'SPACE EXPRESS',
                      style: TextStyle(
                        fontFamily: 'BrunoAceSC',
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 70.0, right: 16.0),
                  child: Column(
                    children: [
                      _buildLootBoxItem(
                        id: 'astronaut_lootbox',
                        image: 'assets/astronaut_lootbox.png',
                        title: 'Astronaut Loot Box',
                        onBuy: () =>
                            _attemptPurchase('astronaut_lootbox', 'astronaut'),
                        allUnlocked: _allAstronautsUnlocked,
                      ),
                      const SizedBox(height: 24),
                      _buildLootBoxItem(
                        id: 'spaceship_lootbox',
                        image: 'assets/spaceship_lootbox.png',
                        title: 'Spaceship Loot Box',
                        onBuy: () =>
                            _attemptPurchase('spaceship_lootbox', 'spaceship'),
                        allUnlocked: _allSpaceshipsUnlocked,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  void _toggleButtonState(String id) {
    setState(() {
      _clickedButtons[id] = !(_clickedButtons[id] ?? false);
    });
  }

  void _attemptPurchase(String id, String itemType) async {
    int points = await _itemManager.getUserPoints();
    if (points < _itemCost) {
      _showInsufficientPointsDialog();
      return;
    }

    bool success = await _itemManager.deductPoints(_itemCost,
        reason: 'Purchased $itemType loot box');
    if (!success) {
      _showInsufficientPointsDialog();
      return;
    }

    setState(() {});
    _startLootBox(id, itemType);
  }

  void _showInsufficientPointsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF212121),
          title: const Text(
            'Insufficient Points',
            style: TextStyle(color: Colors.white, fontFamily: 'BrunoAceSC'),
          ),
          content: const Text(
            'You need at least 50 points to buy an item.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFF9CDE7A))),
            ),
          ],
        );
      },
    );
  }

  void _startLootBox(String id, String itemType) {
    _toggleButtonState(id);

    _lootBoxItems = [];

    if (itemType == 'astronaut') {
      _lootBoxItems = _itemManager.astronauts;
    } else {
      _lootBoxItems = _itemManager.spaceships;
    }

    final lockedItems =
        _lootBoxItems.where((item) => item['unlocked'] == false).toList();

    if (lockedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have unlocked all items in this category!'),
          duration: Duration(seconds: 3),
        ),
      );
      setState(() {
        _showLootBox = false;
        _clickedButtons[id] = false;
      });
      return;
    }

    final random = Random();
    final randomIndex = random.nextInt(lockedItems.length);
    _selectedItem = lockedItems[randomIndex]['name'];
    _selectedIndex =
        _lootBoxItems.indexWhere((item) => item['name'] == _selectedItem);

    setState(() {
      _showLootBox = true;
      _currentLootBoxId = id;
      _showResult = false;
      _isShaking = false;
      _isOpening = false;
    });

    _resetAnimations();
    _startBoxAnimation();
  }

  void _resetAnimations() {
    _boxController.reset();
    _shakeController.reset();
    _openController.reset();
    _glowController.reset();
    _particleController.reset();
  }

  void _startBoxAnimation() {
    _boxController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _startBoxShaking();
      });
    });
  }

  void _startBoxShaking() {
    setState(() {
      _isShaking = true;
    });
    _shakeController.forward();
  }

  void _startBoxOpening() {
    setState(() {
      _isShaking = false;
      _isOpening = true;
    });
    _openController.forward();
    _glowController.repeat(reverse: true);
    _particleController.forward();
  }

  Widget _buildLootBoxView() {
    return Stack(
      children: [
        Image.asset(
          'assets/stars.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.7),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                'LOOT BOX',
                style: TextStyle(
                  fontFamily: 'BrunoAceSC',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child:
                    _showResult ? _buildResultView() : _buildAnimatedLootBox(),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: _showResult
                      ? _navigateToEditScreen
                      : (_isShaking ? null : _startBoxShaking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showResult
                        ? const Color(0xFF9CDE7A)
                        : (_isShaking ? Colors.grey : const Color(0xFFFFD700)),
                    minimumSize: const Size(200, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    _showResult
                        ? 'CONTINUE'
                        : _isShaking
                            ? 'OPENING...'
                            : _isOpening
                                ? 'OPENING...'
                                : 'OPEN BOX',
                    style: const TextStyle(
                      fontFamily: 'BrunoAceSC',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedLootBox() {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _boxController,
          _shakeController,
          _openController,
          _glowController,
          _particleController,
        ]),
        builder: (context, child) {
          double shakeOffset = 0;
          if (_isShaking) {
            shakeOffset = sin(_shakeAnimation.value * pi * 20) * 8;
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              // Particle effects
              if (_isOpening) ..._buildParticleEffects(),

              // Glow effect
              if (_isOpening)
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellowAccent
                                .withOpacity(_glowOpacity.value * 0.6),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    );
                  },
                ),

              // Main loot box
              Transform.scale(
                scale: _boxScale.value,
                child: Transform.translate(
                  offset: Offset(shakeOffset, 0),
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Box body
                        Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF8B4513),
                                Color(0xFF654321),
                                Color(0xFF4A2C17),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: _isOpening && _showResult
                              ? Center(
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.yellowAccent, width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.asset(
                                        _lootBoxItems[_selectedIndex!]['image'],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                        ),

                        // Box lid
                        Positioned(
                          top: 20 + _lidOffset.value,
                          child: Transform.rotate(
                            angle: _lidRotation.value,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 220,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFA0522D),
                                    Color(0xFF8B4513),
                                  ],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                border:
                                    Border.all(color: Colors.amber, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 60,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.orange, width: 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        if (!_isOpening)
                          Positioned(
                            bottom: 80,
                            child: Container(
                              width: 30,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: Colors.orange, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.lock,
                                color: Colors.brown,
                                size: 20,
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
        },
      ),
    );
  }

  List<Widget> _buildParticleEffects() {
    final particles = <Widget>[];
    final random = Random();

    for (int i = 0; i < 15; i++) {
      final angle = (2 * pi / 15) * i;
      final distance = 100 * _particleAnimation.value;
      final x = cos(angle) * distance;
      final y = sin(angle) * distance;

      particles.add(
        Positioned(
          left: 200 + x,
          top: 200 + y,
          child: Transform.scale(
            scale: 1.0 - _particleAnimation.value,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: [
                  Colors.yellow,
                  Colors.orange,
                  Colors.amber
                ][random.nextInt(3)],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.6),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return particles;
  }

  Widget _buildResultView() {
    if (_selectedIndex == null || _selectedIndex! >= _lootBoxItems.length) {
      return const Center(
        child: Text('Error: Invalid selection',
            style: TextStyle(color: Colors.white)),
      );
    }

    final selectedItem = _lootBoxItems[_selectedIndex!];
    final itemColor = selectedItem['color'] as Color?;

    final Color baseColor = itemColor ?? Colors.purple;
    final Color darkVariant = HSLColor.fromColor(baseColor)
        .withLightness(
            (HSLColor.fromColor(baseColor).lightness - 0.2).clamp(0.0, 1.0))
        .toColor();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'CONGRATULATIONS!',
            style: TextStyle(
              fontFamily: 'BrunoAceSC',
              color: Colors.yellowAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'You found:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [baseColor, darkVariant],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellowAccent.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  selectedItem['image'],
                  height: 140,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Text(
                  selectedItem['name'],
                  style: const TextStyle(
                    fontFamily: 'BrunoAceSC',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditScreen() {
    if (_selectedIndex == null || _selectedIndex! >= _lootBoxItems.length)
      return;

    final selectedItem =
        Map<String, dynamic>.from(_lootBoxItems[_selectedIndex!]);

    selectedItem['unlocked'] = true;
    selectedItem['selected_image'] = selectedItem['image'];

    _itemManager.unlockItem(selectedItem['name'], selectedItem['type']);

    setState(() {
      _checkAllItemsUnlocked();
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditAstronautScreen(
          isar: widget.isar,
          unlockedItem: selectedItem,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      left: 16,
      top: 90,
      child: Column(
        children: [
          _buildActionButton(
            Icons.shopping_basket,
            () {},
            backgroundColor: Colors.black,
            borderColor: Colors.white,
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            Icons.edit,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditAstronautScreen(
                        isar: widget.isar,
                      )),
            ),
            backgroundColor: const Color(0xFF333333),
            borderColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    VoidCallback onPressed, {
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildLootBoxItem({
    required String id,
    required String image,
    required String title,
    required VoidCallback onBuy,
    required bool allUnlocked,
  }) {
    final bool isClicked = _clickedButtons[id] ?? false;

    final Color buttonColor = allUnlocked || isClicked
        ? const Color(0xFF7C9061)
        : const Color(0xFF9CDE7A);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF212121),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildLootBoxImage(image),
          ),

          Text(
            title,
            style: const TextStyle(
              fontFamily: 'BrunoAceSC',
              color: Colors.grey,
              fontSize: 14,
            ),
          ),

          // Item cost display
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/shooting_star.png', width: 18, height: 18),
                const SizedBox(width: 4),
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
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: allUnlocked ? null : onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                disabledBackgroundColor: const Color(0xFF7C9061),
                disabledForegroundColor: Colors.black,
              ),
              child: Text(
                allUnlocked ? 'All Unlocked' : 'Buy',
                style: const TextStyle(
                  fontFamily: 'BrunoAceSC',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLootBoxImage(String image) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700, width: 1),
      ),
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          image,
          width: 120,
          height: 100,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
