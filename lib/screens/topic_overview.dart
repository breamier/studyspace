import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'dart:ui';

class TopicOverview extends StatefulWidget {
  final String topicTitle;
  final String targetDate;

  const TopicOverview({
    super.key,
    required this.topicTitle,
    required this.targetDate,
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
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    minWidth: 200,
                  ),
                  child: PopupCard(
                    elevation: 8,
                    color: const Color.fromARGB(255, 22, 22, 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white, width: 2.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                          const SizedBox(height: 15),
                          Text(
                            "I'll move your mission to --/--/--",
                            style: GoogleFonts.arimo(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Image.asset(
                                  "images/astro_notification.png",
                                  width: 180,
                                  height: 210,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          194, 109, 68, 221),
                                      minimumSize: const Size(135, 60),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                            color: Colors.white, width: 1.5),
                                      ),
                                    ),
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
                                      ),
                                    ),
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
            ),
          ),
        );
      },
    );
  }

  String nextSessionDate = '12/09/24';
  String totalStudyTime = '00:00';

  List<SubTopic> subTopics = [
    SubTopic(title: "Conditional Probability", completed: false),
    SubTopic(title: "Probability Function", completed: false),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Goals",
          style: GoogleFonts.arimo(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/backGroundScreen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    widget.topicTitle,
                    style: GoogleFonts.arimo(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "target end date",
                            style: GoogleFonts.brunoAce(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            widget.targetDate,
                            style: GoogleFonts.brunoAce(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      if (!isSmallScreen) const SizedBox(width: 40),
                      Column(
                        children: [
                          Text(
                            "next session",
                            style: GoogleFonts.brunoAce(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            nextSessionDate,
                            style: GoogleFonts.brunoAce(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "total study time",
                    style: GoogleFonts.brunoAce(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    totalStudyTime,
                    style: GoogleFonts.brunoAce(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const PhotoCard(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtopics",
                          style: GoogleFonts.arimo(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromRGBO(176, 152, 228, 1),
                            size: 30,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  ...subTopics.map((subTopic) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
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
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                subTopic.title,
                                style: GoogleFonts.arimo(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 13),
                        Transform.scale(
                          scale: 1.5,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(187, 187, 187, 187),
                                width: 1.5,
                              ),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.add,
                                size: 16,
                                color: Color.fromARGB(187, 187, 187, 187),
                              ),
                              onPressed: () {
                                setState(() {
                                  subTopics.add(SubTopic(
                                      title: "New Subtopic", completed: false));
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
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
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildActionButton(
                          text: "Start Session",
                          color: const Color.fromARGB(194, 109, 68, 221),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 30),
                        _buildActionButton(
                          text: "Postpone Session",
                          color: const Color.fromARGB(185, 195, 29, 32),
                          onPressed: _postponeNotification,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 160,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.arimo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(176, 152, 228, 1),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "# photos, # videos",
              style: GoogleFonts.arimo(
                color: const Color.fromARGB(255, 68, 67, 67),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 68, 67, 67),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
