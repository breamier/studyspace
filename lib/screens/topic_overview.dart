import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'dart:ui';

class TopicOverview extends StatefulWidget {
  final String topicTitle;
  final String targetDate;
  // final String sessionDate;

  const TopicOverview({
    super.key,
    required this.topicTitle,
    required this.targetDate,
    // required this.sessionDate
  });

  @override
  State<TopicOverview> createState() => _TopicOverviewState();
}

class SubTopic {
  String title;
  bool completed;

  SubTopic({
    required this.title,
    required this.completed,
  });
}

class _TopicOverviewState extends State<TopicOverview> {
  void _postponeNotification() {
    showPopupCard(
      context: context,
      alignment: const Alignment(0, -0.20),
      builder: (context) {
        return PopScope(
          canPop: false,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 350,
                maxHeight: 315,
                minWidth: 200,
                minHeight: 200,
              ),
              child: PopupCard(
                elevation: 8,
                color: const Color.fromARGB(255, 22, 22, 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  // Main padding for entire card
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delay your mission?",
                        style: GoogleFonts.arimo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 15), // Space between texts
                      Text(
                        "I'll move your mission to --/--/--",
                        style: GoogleFonts.arimo(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      // Space before buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset("images/astro_notification.png",
                              width: 180, height: 210),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                // to edit laterr
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(194, 109, 68, 221),
                                    minimumSize: const Size(135, 60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                          color: Colors.white, width: 1.5),
                                    )),
                                child: Text(
                                  "Confirm",
                                  style: GoogleFonts.arimo(
                                      color: Colors.white, fontSize: 22),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 106, 105, 105),
                                    minimumSize: const Size(135, 60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                          color: Colors.white, width: 1.5),
                                    )),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.arimo(
                                      color: Colors.white, fontSize: 22),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // declared variables
  String nextSessionDate = '12/09/24';
  String totalStudyTime = '00:00';

  List<SubTopic> subTopics = [
    SubTopic(title: "Conditional Probability", completed: false),
    SubTopic(title: "Probability Function", completed: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        title: Text(
          "Goals",
          style: GoogleFonts.arimo(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/backGroundScreen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 75),
              Text(
                widget.topicTitle,
                style: GoogleFonts.arimo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              Row(
                children: [
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "target end date",
                        style: GoogleFonts.brunoAce(
                            color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        widget.targetDate,
                        style: GoogleFonts.brunoAce(
                            color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(width: 80),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "next session",
                        style: GoogleFonts.brunoAce(
                            color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        nextSessionDate,
                        style: GoogleFonts.brunoAce(
                            color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                "total study time",
                style: GoogleFonts.brunoAce(color: Colors.white, fontSize: 15),
              ),
              Text(
                totalStudyTime,
                style: GoogleFonts.brunoAce(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 10),
              const PhotoCard(),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 15),
                  Text(
                    "Subtopics",
                    style: GoogleFonts.arimo(color: Colors.white, fontSize: 25),
                  ),
                  const SizedBox(width: 220),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Color.fromRGBO(176, 152, 228, 1), size: 30),
                    // disregard muna | TO EDIT LATER
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              ...subTopics.map((subTopic) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            value: subTopic.completed,
                            onChanged: (value) {
                              setState(() {
                                subTopic.completed = value ?? false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            side: const BorderSide(
                                color: Colors.white, width: 1.5),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(subTopic.title,
                            style: GoogleFonts.arimo(
                                color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  )),
              TextButton(
                onPressed: () {
                  setState(() {
                    // for edit later
                    subTopics
                        .add(SubTopic(title: "New Subtopic", completed: false));
                  });
                },
                child: Row(
                  children: [
                    const SizedBox(width: 2),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromARGB(187, 187, 187, 187),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Color.fromARGB(187, 187, 187, 187),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "Add a subtopic",
                      style: GoogleFonts.arimo(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Row(children: [
                  const SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: () {
                        // start session
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(194, 109, 68, 221),
                        minimumSize: const Size(180, 75),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Text(
                        "Start Session",
                        style: GoogleFonts.arimo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    // Postpone session
                    onPressed: _postponeNotification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(185, 195, 29, 32),
                      minimumSize: const Size(180, 75),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      "Postpone Session",
                      style: GoogleFonts.arimo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ]),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 500,
      child: Card(
        color: const Color.fromRGBO(176, 152, 228, 1),
        margin: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Photos",
                style: GoogleFonts.arimo(
                    color: const Color.fromARGB(255, 68, 67, 67),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text("# photos, # videos",
                  style: GoogleFonts.arimo(
                      color: const Color.fromARGB(255, 68, 67, 67),
                      fontSize: 15)),
              const SizedBox(
                height: 10,
              ),
              const Expanded(
                child: SizedBox(
                  height: 200,
                  width: 450,
                  child: Card(
                    color: Color.fromARGB(255, 68, 67, 67),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NonDismissiblePopupCard extends StatelessWidget {
  final Widget child;

  const NonDismissiblePopupCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button dismissal
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Absorb all taps
        onTap: () {}, // Do nothing when tapping outside
        child: child,
      ),
    );
  }
}
