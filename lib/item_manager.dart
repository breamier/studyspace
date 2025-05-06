import 'package:flutter/material.dart';

class ItemManager {
  static final ItemManager _instance = ItemManager._internal();
  factory ItemManager() => _instance;
  ItemManager._internal();
  
  int _userPoints = 100;

  int get userPoints => _userPoints;
  
  final List<Map<String, dynamic>> _transactions = [];
  
  List<Map<String, dynamic>> get transactions => 
      List<Map<String, dynamic>>.from(_transactions);
  
  final ValueNotifier<bool> itemChangedNotifier = ValueNotifier<bool>(false);
  
  final List<Map<String, dynamic>> _astronauts = [
    {
      'name': 'Blue Astronaut',
      'image': 'assets/blue_astronaut.png',
      'selected_image': 'assets/blue_astronaut.png',
      'unlocked': true,
      'type': 'astronaut',
      'color': Colors.blue,
    },
    {
      'name': 'Orange Astronaut',
      'image': 'assets/orange_astronaut.png',
      'selected_image': 'assets/orange_astronaut.png',
      'unlocked': false,
      'type': 'astronaut',
      'color': Colors.orange,
    },
    {
      'name': 'Green Astronaut',
      'image': 'assets/green_astronaut.png',
      'selected_image': 'assets/green_astronaut.png',
      'unlocked': false,
      'type': 'astronaut',
      'color': Colors.green,
    },
    {
      'name': 'Purple Astronaut',
      'image': 'assets/purple_astronaut.png',
      'selected_image': 'assets/purple_astronaut.png',
      'unlocked': false,
      'type': 'astronaut',
      'color': Colors.purple,
    },
    {
      'name': 'Black Astronaut',
      'image': 'assets/black_astronaut.png',
      'selected_image': 'assets/black_astronaut.png',
      'unlocked': false,
      'type': 'astronaut',
      'color': Colors.grey[800],
    },
  ];

  final List<Map<String, dynamic>> _spaceships = [
    {
      'name': 'White Spaceship',
      'image': 'assets/white_spaceship.png',
      'selected_image': 'assets/white_spaceship.png',
      'unlocked': true,
      'type': 'spaceship',
      'color': Colors.white,
    },
    {
      'name': 'Orange Spaceship',
      'image': 'assets/orange_spaceship.png',
      'selected_image': 'assets/orange_spaceship.png',
      'unlocked': false,
      'type': 'spaceship',
      'color': Colors.orange,
    },
    {
      'name': 'Black Spaceship',
      'image': 'assets/black_spaceship.png',
      'selected_image': 'assets/black_spaceship.png',
      'unlocked': false,
      'type': 'spaceship',
      'color': Colors.grey[800],
    },
    {
      'name': 'Blue Spaceship',
      'image': 'assets/blue_spaceship.png',
      'selected_image': 'assets/blue_spaceship.png',
      'unlocked': false,
      'type': 'spaceship',
      'color': Colors.blue,
    },
    {
      'name': 'Purple Spaceship',
      'image': 'assets/purple_spaceship.png',
      'selected_image': 'assets/purple_spaceship.png',
      'unlocked': false,
      'type': 'spaceship',
      'color': Colors.purple,
    },
  ];

  List<Map<String, dynamic>> get astronauts => 
      List<Map<String, dynamic>>.from(_astronauts);

  List<Map<String, dynamic>> get spaceships => 
      List<Map<String, dynamic>>.from(_spaceships);

  List<Map<String, dynamic>> get unlockedAstronauts => 
      _astronauts.where((item) => item['unlocked'] == true).toList();

  List<Map<String, dynamic>> get unlockedSpaceships => 
      _spaceships.where((item) => item['unlocked'] == true).toList();

  void unlockItem(String name, String type) {
    final items = type == 'astronaut' ? _astronauts : _spaceships;
    final index = items.indexWhere((item) => item['name'] == name);
    
    if (index != -1) {
      items[index]['unlocked'] = true;
      itemChangedNotifier.value = !itemChangedNotifier.value;
    }
  }

  void setCurrentItem(String name, String type) {
    final items = type == 'astronaut' ? _astronauts : _spaceships;
    
    for (final item in items) {
      item['current'] = false;
    }
    
    final index = items.indexWhere((item) => item['name'] == name);
    if (index != -1) {
      items[index]['current'] = true;
    }
    
    itemChangedNotifier.value = !itemChangedNotifier.value;
  }
  
  void addPoints(int amount, {String? reason}) {
    if (amount <= 0) return;
    
    _userPoints += amount;
    
    _transactions.add({
      'type': 'credit',
      'amount': amount,
      'reason': reason ?? 'Added points',
      'timestamp': DateTime.now(),
    });
  }
  
  bool deductPoints(int amount, {String? reason}) {
    if (_userPoints < amount) return false;
    
    _userPoints -= amount;
    
    _transactions.add({
      'type': 'debit',
      'amount': amount,
      'reason': reason ?? 'Deducted points',
      'timestamp': DateTime.now(),
    });
    
    return true;
  }
  
  Map<String, dynamic>? getCurrentAstronaut() {
    try {
      return _astronauts.firstWhere((item) => item['current'] == true);
    } catch (_) {
      return _astronauts.firstWhere((item) => item['unlocked'] == true, orElse: () => _astronauts[0]);
    }
  }
  
  Map<String, dynamic>? getCurrentSpaceship() {
    try {
      return _spaceships.firstWhere((item) => item['current'] == true);
    } catch (_) {
      return _spaceships.firstWhere((item) => item['unlocked'] == true, orElse: () => _spaceships[0]);
    }
  }
}