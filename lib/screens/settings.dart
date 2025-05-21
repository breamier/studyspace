import 'package:flutter/material.dart';
import 'package:studyspace/services/isar_service.dart';
import 'package:studyspace/widgets/navbar.dart';
import 'package:studyspace/services/notif_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(
        backgroundColor: kOnyx,
        elevation: 0,
        title: Text('Settings', style: kHeadingFont.copyWith(fontSize: 18)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/stars.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Arimo',
                    ),
                  ),
                  Spacer(),
                  Switch(
                    value: _notificationsEnabled,
                    activeColor: kPurple,
                    onChanged: (val) async {
                      setState(() {
                        _notificationsEnabled = val;
                      });
                      await _setNotifPref(val);
                      if (!val) {
                        await NotifService().cancelAllNotifications();
                      } else {
                        await NotifService().scheduleDailyCustomNotifications();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    "Clear Database",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontFamily: 'Arimo',
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.delete_forever, color: Colors.redAccent),
                    onPressed: () async {
                      String confirmText = '';
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: kOnyx,
                            title: Text(
                              "Confirm Deletion",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Arimo'),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Type 'clear' to confirm deletion of all data.",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontFamily: 'Arimo'),
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
                                      borderSide:
                                          BorderSide(color: Colors.white24),
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
                                child: Text("Cancel",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text("Delete",
                                    style: TextStyle(color: Colors.redAccent)),
                                onPressed: () async {
                                  if (confirmText.trim().toLowerCase() ==
                                      "clear") {
                                    await widget.isar.clearDb();
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Database cleared.",
                                            style:
                                                TextStyle(fontFamily: 'Arimo')),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Type 'clear' to confirm.",
                                            style: TextStyle(
                                                fontFamily: 'Arimo',
                                                color: Colors.white)),
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
                    },
                  )
                ],
              )
            ],
          )),
      bottomNavigationBar:
          CustomBottomNavBar(currentIndex: 4, isar: widget.isar),
    );
  }
}
