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

class _DeathAstronautScreenState
    extends State<DeathAstronautScreen> {
  bool _showReviveDialog = false;
  bool _isRevived = false;
  final ItemManager _itemManager = ItemManager();
  Map<String, dynamic>? _currentAstronaut;

  @override
  void initState() {
    super.initState();
    _getCurrentAstronaut();
    // Show revive dialog after 3 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_isRevived) {
        setState(() {
          _showReviveDialog = true;
        });
      }
    });
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
                  _buildProgressBar(
                    'assets/astronaut_icon.png', 
                    'HP', 
                    _isRevived ? 0.30 : 0.0,
                    _isRevived ? Colors.green.shade700 : Colors.red.shade700, 
                    _isRevived ? Colors.green.shade400 : Colors.red.shade400, 
                    Colors.white
                  ),
                  const SizedBox(height: 12),
                  _buildProgressBar('assets/rocket_icon.png', 'Progress', 0.85,
                      Colors.grey.shade500, Colors.grey.shade400, Colors.black),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  Text(
                    _isRevived 
                        ? "YOUR ASTRONAUT HAS BEEN MIRACULOUSLY REVIVED!" 
                        : "YOUR ASTRONAUT DIDN'T MAKE IT...",
                    style: const TextStyle(
                      fontFamily: 'BrunoAceSC',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: Center(
                      child: Image.asset(
                        _isRevived ? _getRevivedAstronautImage() : _getDeadAstronautImage(),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Revive Dialog Overlay
          if (_showReviveDialog && !_isRevived)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 48,
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
                          Image.asset(
                            'assets/shooting_star.png',
                            width: 20,
                            height: 20,
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
                            if (_itemManager.deductPoints(10, reason: 'Astronaut Revival')) {
                              setState(() {
                                _showReviveDialog = false;
                                _isRevived = true;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Insufficient points for revival!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        child: Container(
                          width: 120,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade300, width: 1),
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
                      ),
                    ],
                  ),
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