import 'dart:math';
import 'package:flutter/material.dart';
import 'package:studyspace/screens/dashboard_screen.dart';
import 'package:studyspace/widgets/custom_toast.dart';
import 'edit_astronaut_screen.dart';
import 'package:studyspace/item_manager.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _SpaceExpressMarketplaceState();
}

class _SpaceExpressMarketplaceState extends State<MarketplaceScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, bool> _clickedButtons = {};
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showRoulette = false;
  String _currentRouletteId = '';
  String? _selectedItem;
  int? _selectedIndex;
  bool _showResult = false;

  final int _itemCost = 50;

  List<Map<String, dynamic>> _rouletteItems = [];

  final ItemManager _itemManager = ItemManager();

  bool _allAstronautsUnlocked = false;
  bool _allSpaceshipsUnlocked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.addStatusListener((status) {
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: _buildAppBar(),
      body: _showRoulette ? _buildRouletteView() : _buildBody(),
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
              if (_showRoulette) {
                setState(() {
                  _showRoulette = false;
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
          Text(
            '${_itemManager.userPoints}',
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
          ),
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
                      _buildRouletteItem(
                        id: 'astronaut_roulette',
                        image: 'assets/astronaut_roulette1.png',
                        title: 'Astronaut Roulette',
                        onBuy: () =>
                            _attemptPurchase('astronaut_roulette', 'astronaut'),
                        allUnlocked: _allAstronautsUnlocked,
                      ),
                      const SizedBox(height: 24),
                      _buildRouletteItem(
                        id: 'spaceship_roulette',
                        image: 'assets/astronaut_roulette2.png',
                        title: 'Spaceship Roulette',
                        onBuy: () =>
                            _attemptPurchase('spaceship_roulette', 'spaceship'),
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

  void _attemptPurchase(String id, String itemType) {
    if (_itemManager.userPoints < _itemCost) {
      _showInsufficientPointsDialog();
      return;
    }

    bool success = _itemManager.deductPoints(_itemCost,
        reason: 'Purchased $itemType roulette');

    if (!success) {
      _showInsufficientPointsDialog();
      return;
    }

    setState(() {});

    _startRoulette(id, itemType);
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

  void _startRoulette(String id, String itemType) {
    _toggleButtonState(id);

    _rouletteItems = [];

    if (itemType == 'astronaut') {
      _rouletteItems = _itemManager.astronauts;
    } else {
      _rouletteItems = _itemManager.spaceships;
    }

    final lockedItems =
        _rouletteItems.where((item) => item['unlocked'] == false).toList();

    if (lockedItems.isEmpty) {
      showCustomToast(context, 'You have unlocked all items in this category!');

      setState(() {
        _showRoulette = false;
        _clickedButtons[id] = false;
      });
      return;
    }

    final random = Random();
    final randomIndex = random.nextInt(lockedItems.length);
    _selectedItem = lockedItems[randomIndex]['name'];
    _selectedIndex =
        _rouletteItems.indexWhere((item) => item['name'] == _selectedItem);

    setState(() {
      _showRoulette = true;
      _currentRouletteId = id;
      _showResult = false;
    });

    _controller.reset();
    _controller.forward();
  }

  Widget _buildRouletteView() {
    return Stack(
      children: [
        Image.asset(
          'assets/stars.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),

        // Roulette content
        Container(
          color: Colors.black.withOpacity(0.7),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                'ITEM ROULETTE',
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
                    _showResult ? _buildResultView() : _buildSpinningRoulette(),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: _showResult ? _navigateToEditScreen : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _showResult ? const Color(0xFF9CDE7A) : Colors.grey,
                    minimumSize: const Size(200, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    _showResult ? 'CONTINUE' : 'SPINNING...',
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

  Widget _buildSpinningRoulette() {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value * 10 * pi,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFF212121),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (int i = 0; i < _rouletteItems.length; i++)
                    _buildRouletteSegment(i, _rouletteItems[i]['name'],
                        _rouletteItems[i]['image'], _rouletteItems[i]['color']),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRouletteSegment(
      int index, String name, String imagePath, Color? itemColor) {
    final double angle = (2 * pi / _rouletteItems.length) * index;
    final double segmentAngle = 2 * pi / _rouletteItems.length;

    final Color segmentColor =
        itemColor ?? (index % 2 == 0 ? Colors.purple[800]! : Colors.blue[800]!);
    final Color darkVariant = HSLColor.fromColor(segmentColor)
        .withLightness(
          (HSLColor.fromColor(segmentColor).lightness - 0.2).clamp(0.0, 1.0),
        )
        .toColor();

    return Transform.rotate(
      angle: angle,
      child: ClipPath(
        clipper: RouletteSegmentClipper(segmentAngle),
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [segmentColor, darkVariant],
            ),
            border:
                Border.all(color: Colors.white.withOpacity(0.5), width: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    if (_selectedIndex == null || _selectedIndex! >= _rouletteItems.length) {
      return const Center(
        child: Text('Error: Invalid selection',
            style: TextStyle(color: Colors.white)),
      );
    }

    final selectedItem = _rouletteItems[_selectedIndex!];
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
            'You got:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 200,
            height: 200,
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
    if (_selectedIndex == null || _selectedIndex! >= _rouletteItems.length)
      return;

    final selectedItem =
        Map<String, dynamic>.from(_rouletteItems[_selectedIndex!]);

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
            Icons.backpack,
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
                  builder: (context) => const EditAstronautScreen()),
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

  Widget _buildRouletteItem({
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
            child: _buildRouletteImage(image),
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
                  "50",
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

  Widget _buildRouletteImage(String image) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700, width: 1),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            image,
            height: 140,
            fit: BoxFit.contain,
          ),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                "?",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RouletteSegmentClipper extends CustomClipper<Path> {
  final double angle;

  RouletteSegmentClipper(this.angle);

  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx, 0);
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

void showCustomToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: -40,
      left: 0,
      right: 0,
      child: Center(child: AnimatedToast(message: message)),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
