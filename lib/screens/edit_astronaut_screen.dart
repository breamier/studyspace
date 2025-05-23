import 'package:flutter/material.dart';
import 'package:studyspace/screens/astronaut_traveling_screen.dart';
import 'marketplace_screen.dart';
import 'package:studyspace/item_manager.dart';

import '../models/astronaut_pet.dart';
import '../services/astro_hp_service.dart';
import '../services/isar_service.dart';

class EditAstronautScreen extends StatefulWidget {
  final Map<String, dynamic>? unlockedItem;
  final IsarService isar;
  const EditAstronautScreen({Key? key, this.unlockedItem, required this.isar})
      : super(key: key);

  @override
  State<EditAstronautScreen> createState() => _EditAstronautScreenState();
}

class _EditAstronautScreenState extends State<EditAstronautScreen> {
  String _selectedCategory = 'astronaut';
  bool _showSelectedImage = false;
  int _currentItemIndex = 0;

  late List<Map<String, dynamic>> _astronauts;
  late List<Map<String, dynamic>> _spaceships;
  final ItemManager _itemManager = ItemManager();

  // use to update pet for hp and mission progress
  late Future<AstronautPet?> _currentPet;

  @override
  void initState() {
    super.initState();
    _currentPet = widget.isar.getCurrentPet();
    _astronauts = _itemManager.astronauts;
    _spaceships = _itemManager.spaceships;

    if (widget.unlockedItem != null) {
      _processUnlockedItem(widget.unlockedItem!);
    }
  }

  void _processUnlockedItem(Map<String, dynamic> unlockedItem) {
    final String itemType = unlockedItem['type'] ?? 'astronaut';
    final String itemName = unlockedItem['name'];

    _itemManager.unlockItem(itemName, itemType);

    setState(() {
      _astronauts = _itemManager.astronauts;
      _spaceships = _itemManager.spaceships;
      _selectedCategory = itemType;
      _currentItemIndex = _findItemIndexInUnlockedList(
          itemName, itemType == 'astronaut' ? _astronauts : _spaceships);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New $itemName unlocked! You can now select it.'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  int _findItemIndexInUnlockedList(
      String itemName, List<Map<String, dynamic>> fullList) {
    final unlockedList = fullList.where((item) => item['unlocked']).toList();
    for (int i = 0; i < unlockedList.length; i++) {
      if (unlockedList[i]['name'] == itemName) {
        return i;
      }
    }
    return 0;
  }

  List<Map<String, dynamic>> get _currentList {
    final fullList =
        _selectedCategory == 'astronaut' ? _astronauts : _spaceships;
    return fullList.where((item) => item['unlocked']).toList();
  }

  void _switchToPreviousItem() {
    if (_currentList.length <= 1) return;

    setState(() {
      _showSelectedImage = false;
      _currentItemIndex =
          (_currentItemIndex - 1 + _currentList.length) % _currentList.length;
    });
  }

  void _switchToNextItem() {
    if (_currentList.length <= 1) return;

    setState(() {
      _showSelectedImage = false;
      _currentItemIndex = (_currentItemIndex + 1) % _currentList.length;
    });
  }

  void _selectCurrentItem() {
    final String selectedName = _currentList[_currentItemIndex]['name'];

    _itemManager.setCurrentItem(selectedName, _selectedCategory);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${_currentList[_currentItemIndex]['name']}'),
        duration: const Duration(milliseconds: 800),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
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
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: const Text(
        "Home",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
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
              Image.asset('assets/shooting_star.png', width: 25, height: 25),
              const SizedBox(width: 6),
              Text('${_itemManager.userPoints}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    final screenHeight = MediaQuery.of(context).size.height;

    if (_currentItemIndex >= _currentList.length && _currentList.isNotEmpty) {
      _currentItemIndex = 0;
    }

    final currentItem = _currentList.isNotEmpty
        ? _currentList[_currentItemIndex]
        : {
            'name': 'No Item',
            'image': 'assets/placeholder.png',
            'current': false
          };

    final bool isCurrent = currentItem['current'] == true;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/stars.png', fit: BoxFit.cover),
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              _buildHpProgressBar(),
              const SizedBox(height: 12),
              _buildMissionProgressBar(),
              _buildStatsSection(),
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: _showSelectedImage
                            ? 'selected-image'
                            : '${_selectedCategory}-${_currentItemIndex}',
                        child: Image.asset(
                          _showSelectedImage &&
                                  currentItem.containsKey('selected_image')
                              ? currentItem['selected_image']
                              : currentItem['image'],
                          height: screenHeight * 0.4,
                        ),
                      ),
                    ),
                    if (!_showSelectedImage && _currentList.length > 1)
                      _buildNavigationButtons(),
                  ],
                ),
              ),
              if (!_showSelectedImage && _currentList.length > 1)
                _buildDotsIndicator(),
              _buildActionButton(isCurrent),
              if (!_showSelectedImage) _buildCategorySelectors(),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_left,
                    color: Colors.white, size: 40),
                onPressed: _switchToPreviousItem,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_right,
                    color: Colors.white, size: 40),
                onPressed: _switchToNextItem,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDotsIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_currentList.length, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentItemIndex == index ? Colors.white : Colors.grey,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActionButton(bool isCurrent) {
    final Color lightGreen = const Color(0xFFA7CF75);
    final Color darkGreen = const Color(0xFF7C9061);

    return ElevatedButton(
      onPressed: _showSelectedImage
          ? () => setState(() => _showSelectedImage = false)
          : isCurrent
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This is your current item!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              : _selectCurrentItem,
      style: ElevatedButton.styleFrom(
        backgroundColor: _showSelectedImage
            ? Colors.blue
            : isCurrent
                ? darkGreen
                : lightGreen,
        foregroundColor: Colors.black,
        minimumSize: const Size(150, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        _showSelectedImage
            ? 'BACK'
            : isCurrent
                ? 'CURRENT'
                : 'SELECT',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildCategorySelectors() {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCategoryIcon(
                icon: Icons.person, label: 'Astronaut', category: 'astronaut'),
            const SizedBox(width: 20),
            _buildCategoryIcon(
                icon: Icons.rocket, label: 'Spaceship', category: 'spaceship'),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar(String iconPath, String label, double progress,
      Color startColor, Color endColor, Color textColor) {
    return Row(
      children: [
        Image.asset(iconPath, width: 28, height: 28),
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
        if (progress >= 1.0 && !pet.isTraveling) {
          Future.microtask(() async {
            pet.progress = 0.0;
            pet.isTraveling = true;

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

  Widget _buildStatsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
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
                _buildActionIcon(
                  Icons.backpack,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MarketplaceScreen(isar: widget.isar),
                      )),
                ),
                const SizedBox(height: 16),
                _buildActionIcon(
                  Icons.edit,
                  () {},
                  backgroundColor: Colors.black,
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

  Widget _buildActionIcon(IconData icon, VoidCallback onPressed,
      {Color backgroundColor = const Color(0xFF333333)}) {
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
            color: backgroundColor,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
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

  Widget _buildCategoryIcon(
      {required IconData icon,
      required String label,
      required String category}) {
    final bool isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _currentItemIndex = 0;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
