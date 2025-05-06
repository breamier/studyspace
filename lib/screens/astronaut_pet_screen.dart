import 'package:flutter/material.dart';
import 'marketplace_screen.dart'; 
import 'edit_astronaut_screen.dart';
import 'package:studyspace/item_manager.dart';

class AstronautPetScreen extends StatefulWidget {
  const AstronautPetScreen({Key? key}) : super(key: key);

  @override
  State<AstronautPetScreen> createState() => _AstronautPetScreenState();
}

class _AstronautPetScreenState extends State<AstronautPetScreen> {
  final ItemManager _itemManager = ItemManager();
  Map<String, dynamic>? _currentAstronaut;
  Map<String, dynamic>? _currentSpaceship;
  
  late final ValueNotifier<bool> _itemChangeNotifier;
  
  @override
  void initState() {
    super.initState();
    _getCurrentItems();
    
    _itemChangeNotifier = _itemManager.itemChangedNotifier;
    _itemChangeNotifier.addListener(_handleItemChanged);
  }
  
  @override
  void dispose() {
    _itemChangeNotifier.removeListener(_handleItemChanged);
    super.dispose();
  }
  
  void _handleItemChanged() {
    if (mounted) {
      _getCurrentItems();
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
                    fontWeight: FontWeight.w500
                  ),
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
                  const SizedBox(height: 24),
 
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: Center(
                      child: Hero(
                        tag: 'selected-image',
                        child: Image.asset(
                          _getDisplayImage(),
                          fit: BoxFit.contain, 
                        ),
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
  
  String _getDisplayImage() {
    if (_currentAstronaut == null && _currentSpaceship == null) {
      return 'assets/moon_with_astronaut.png';
    }
    
    final astronaut = _currentAstronaut;
    final spaceship = _currentSpaceship;
    
    String? astronautColor = astronaut != null && astronaut['current'] == true ? 
        astronaut['name'].split(' ')[0].toLowerCase() : null;
    
    String? spaceshipColor = spaceship != null && spaceship['current'] == true ? 
        spaceship['name'].split(' ')[0].toLowerCase() : null;
    
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
                _buildStatHeader('assets/planet_icon.png', 'Planets Visited:', '2'),
                
                const SizedBox(height: 24),
                _buildActionButton(
                  Icons.backpack,
                  () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MarketplaceScreen(),
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
                        builder: (context) => const EditAstronautScreen(),
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