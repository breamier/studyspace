import 'package:flutter/material.dart';
import 'edit_astronaut_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _SpaceExpressMarketplaceState();
}

class _SpaceExpressMarketplaceState extends State<MarketplaceScreen> {
  final Map<String, bool> _clickedButtons = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
          const Text(
            '93', 
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        SingleChildScrollView(
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
                      id: 'roulette1',
                      image: 'assets/astronaut_roulette1.png',
                      title: 'Astronaut Roulette',
                      onBuy: () => _toggleButtonState('roulette1'),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildRouletteItem(
                      id: 'roulette2',
                      image: 'assets/astronaut_roulette2.png',
                      title: 'Astronaut Roulette',
                      onBuy: () => _toggleButtonState('roulette2'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
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
              MaterialPageRoute(builder: (context) => const EditAstronautScreen()),
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
    required VoidCallback onBuy
  }) {
    final bool isClicked = _clickedButtons[id] ?? false;
    final Color buttonColor = isClicked 
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
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Buy',
                style: TextStyle(
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