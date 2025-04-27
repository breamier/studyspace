import 'package:flutter/material.dart';
import 'marketplace_screen.dart';

class EditAstronautScreen extends StatefulWidget {
  const EditAstronautScreen({Key? key}) : super(key: key);

  @override
  State<EditAstronautScreen> createState() => _EditAstronautScreenState();
}

class _EditAstronautScreenState extends State<EditAstronautScreen> {
  String _selectedCategory = 'astronaut';
  bool _showSelectedImage = false;
  
  final List<Map<String, dynamic>> _astronauts = [
    {
      'name': 'Orange Astronaut',
      'image': 'assets/orange_astronaut.png',
      'selected_image': 'assets/moon_with_orange_astronaut.png',
    },
    {
      'name': 'Blue Astronaut',
      'image': 'assets/blue_astronaut.png',
      'selected_image': 'assets/moon_with_blue_astronaut.png',
    },
  ];

  final List<Map<String, dynamic>> _spaceships = [
    {
      'name': 'White Spaceship',
      'image': 'assets/white_spaceship.png',
      'selected_image': 'assets/moon_with_white_spaceship.png',
    },
    {
      'name': 'Orange Spaceship',
      'image': 'assets/orange_spaceship.png',
      'selected_image': 'assets/moon_with_orange_spaceship.png',
    },
  ];

  int _currentAstronautIndex = 0;
  int _currentSpaceshipIndex = 0;
  
  List<Map<String, dynamic>> get _currentList => 
      _selectedCategory == 'astronaut' ? _astronauts : _spaceships;

  int get _currentItemIndex => 
      _selectedCategory == 'astronaut' ? _currentAstronautIndex : _currentSpaceshipIndex;

  set _currentItemIndex(int value) {
    if (_selectedCategory == 'astronaut') {
      _currentAstronautIndex = value;
    } else {
      _currentSpaceshipIndex = value;
    }
  }

  void _switchToPreviousItem() {
    setState(() {
      _showSelectedImage = false;
      _currentItemIndex = _currentItemIndex == 0 
          ? _currentList.length - 1 
          : _currentItemIndex - 1;
    });
  }

  void _switchToNextItem() {
    setState(() {
      _showSelectedImage = false;
      _currentItemIndex = (_currentItemIndex + 1) % _currentList.length;
    });
  }

  void _selectCurrentItem() {
    setState(() {
      _showSelectedImage = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${_currentList[_currentItemIndex]['name']}'),
        duration: const Duration(seconds: 1),
      ),
    );
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
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
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
              const Text('93', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    final screenHeight = MediaQuery.of(context).size.height;
    
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
              _buildProgressBar(
                'assets/astronaut_icon.png',
                'HP',
                0.75,
                Colors.red.shade700,
                Colors.red.shade400,
                Colors.white
              ),
              
              const SizedBox(height: 12),
              _buildProgressBar(
                'assets/rocket_icon.png',
                'Progress',
                0.85,
                Colors.grey.shade500,
                Colors.grey.shade400,
                Colors.black
              ),
              
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
                          _showSelectedImage 
                              ? _currentList[_currentItemIndex]['selected_image']
                              : _currentList[_currentItemIndex]['image'],
                          height: screenHeight * 0.4, 
                        ),
                      ),
                    ),

                    if (!_showSelectedImage)
                      _buildNavigationButtons(),
                  ],
                ),
              ),
              
              if (!_showSelectedImage)
                _buildDotsIndicator(),
              
              _buildActionButton(),

              if (!_showSelectedImage)
                _buildCategorySelectors(),
                
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
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 40),
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
                icon: const Icon(Icons.chevron_right, color: Colors.white, size: 40),
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

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: _showSelectedImage 
          ? () => setState(() => _showSelectedImage = false)
          : _selectCurrentItem,
      style: ElevatedButton.styleFrom(
        backgroundColor: _showSelectedImage ? Colors.blue : const Color(0xFF8BC34A), 
        foregroundColor: Colors.black,
        minimumSize: const Size(150, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        _showSelectedImage ? 'BACK' : 'SELECT',
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
              icon: Icons.person, 
              label: 'Astronaut',
              category: 'astronaut'
            ),
            const SizedBox(width: 20),
            _buildCategoryIcon(
              icon: Icons.rocket, 
              label: 'Spaceship',
              category: 'spaceship'
            ),
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
                _buildStatHeader('assets/planet_icon.png', 'Planets Visited:', '2'),
                
                const SizedBox(height: 24),
                _buildActionIcon(
                  Icons.backpack, 
                  () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const MarketplaceScreen(),
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

          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Image.asset('assets/Satellite_icon.png', width: 24, height: 24),
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
          child: Image.asset(iconPath, width: 24, height: 24),
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

  Widget _buildActionIcon(IconData icon, VoidCallback onPressed, {Color backgroundColor = const Color(0xFF333333)}) {
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

  Widget _buildCategoryIcon({
    required IconData icon, 
    required String label, 
    required String category
  }) {
    final bool isSelected = _selectedCategory == category;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
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