import 'package:flutter/material.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/widgets/navbar.dart';
import 'package:studyspace/services/notif_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

// Color variables
const Color kPurple = Color(0xFF6C44DD);
const Color kOnyx = Color(0xFF0E0E0E);
const Color kWhite = Colors.white;

final TextStyle kHeadingFont = TextStyle(
  fontFamily: 'BrunoAceSC',
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(blurRadius: 10.0, color: Colors.white, offset: Offset(0, 0)),
    Shadow(blurRadius: 20.0, color: kPurple, offset: Offset(0, 0)),
  ],
);

class Settings extends StatefulWidget {
  final IsarService isar;

  const Settings({super.key, required this.isar});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotifPref();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadNotifPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _setNotifPref(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOnyx,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Settings', style: kHeadingFont),
      ),
      body: Stack(
        children: [
          //stars background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/stars.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.transparent,
                  kOnyx.withOpacity(0.7),
                  kOnyx.withOpacity(0.8),
                ],
                stops: const [0.1, 0.6, 1.0],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  const SizedBox(height: 30),

                  // Setting Cards
                  _buildSettingCard(
                    icon: Icons.notifications,
                    title: "Notifications",
                    description: "Receive daily study reminders",
                    trailing: Switch(
                      value: _notificationsEnabled,
                      activeColor: kPurple,
                      activeTrackColor: kPurple.withOpacity(0.3),
                      inactiveTrackColor: Colors.grey.withOpacity(0.3),
                      inactiveThumbColor: Colors.grey.shade400,
                      onChanged: (val) async {
                        setState(() {
                          _notificationsEnabled = val;
                        });
                        await _setNotifPref(val);
                        if (!val) {
                          await NotifService().cancelAllNotifications();
                        } else {
                          await NotifService()
                              .scheduleDailyCustomNotifications();
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildSettingCard(
                    icon: Icons.restart_alt,
                    title: "Clear Database",
                    description: "Delete all your study data",
                    iconColor: Colors.redAccent,
                    textColor: Colors.white,
                    trailing: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent.withOpacity(0.2),
                      ),
                      child: IconButton(
                        icon:
                            Icon(Icons.delete_forever, color: Colors.redAccent),
                        onPressed: () async {
                          _showDeleteConfirmation();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          CustomBottomNavBar(currentIndex: 4, isar: widget.isar),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String description,
    required Widget trailing,
    Color iconColor = kPurple,
    Color textColor = kWhite,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arimo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 12,
                          fontFamily: 'Arimo',
                        ),
                      ),
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() async {
    String confirmText = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kOnyx,
          title: Text(
            "Confirm Deletion",
            style: TextStyle(color: Colors.white, fontFamily: 'Arimo'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Type 'clear' to confirm deletion of all data.",
                style: TextStyle(color: Colors.white70, fontFamily: 'Arimo'),
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                style: TextStyle(color: Colors.white),
                onChanged: (val) => confirmText = val,
                decoration: InputDecoration(
                  hintText: "Type 'clear' here",
                  hintStyle: TextStyle(color: Colors.white38),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPurple),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.redAccent)),
              onPressed: () async {
                if (confirmText.trim().toLowerCase() == "clear") {
                  await widget.isar.clearDb();
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Database cleared.",
                          style: TextStyle(fontFamily: 'Arimo')),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Type 'clear' to confirm.",
                          style: TextStyle(
                              fontFamily: 'Arimo', color: Colors.white)),
                      backgroundColor: Colors.grey[800],
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
