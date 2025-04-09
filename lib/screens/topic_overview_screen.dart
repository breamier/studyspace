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

  SubTopic({required this.title, required this.completed});
}

class _TopicOverviewState extends State<TopicOverview> {
  late double deviceHeight;
  late double deviceWidth;
  late bool isSmallScreen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    isSmallScreen = deviceWidth < 600;
  }

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
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: deviceWidth * 0.85,
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
                      padding: EdgeInsets.all(deviceWidth * 0.05),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delay your mission?",
                            style: GoogleFonts.arimo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: deviceWidth * 0.05,
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.02),
                          Text(
                            "I'll move your mission to --/--/--",
                            style: GoogleFonts.arimo(
                              color: Colors.white,
                              fontSize: deviceWidth * 0.035,
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Image.asset(
                                  "assets/astro_notification.png",
                                  width: deviceWidth * 0.4,
                                  height: deviceHeight * 0.25,
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
                                        194,
                                        109,
                                        68,
                                        221,
                                      ),
                                      minimumSize: Size(
                                        deviceWidth * 0.3,
                                        deviceHeight * 0.07,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Confirm",
                                      style: GoogleFonts.arimo(
                                        color: Colors.white,
                                        fontSize: deviceWidth * 0.04,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: deviceHeight * 0.02),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        106,
                                        105,
                                        105,
                                      ),
                                      minimumSize: Size(
                                        deviceWidth * 0.3,
                                        deviceHeight * 0.07,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: GoogleFonts.arimo(
                                        color: Colors.white,
                                        fontSize: deviceWidth * 0.04,
                                      ),
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Goals",
          style: GoogleFonts.arimo(
            color: Colors.white,
            fontSize: deviceWidth * 0.05,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: deviceWidth * 0.06,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backGroundScreen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(deviceWidth * 0.04),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: deviceHeight - MediaQuery.of(context).padding.top,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: deviceHeight * 0.05),
                    Text(
                      widget.topicTitle,
                      style: GoogleFonts.arimo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: deviceWidth * 0.07,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: deviceHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "target end date",
                              style: GoogleFonts.brunoAce(
                                color: Colors.white,
                                fontSize: deviceWidth * 0.03,
                              ),
                            ),
                            Text(
                              widget.targetDate,
                              style: GoogleFonts.brunoAce(
                                color: Colors.white,
                                fontSize: deviceWidth * 0.04,
                              ),
                            ),
                          ],
                        ),
                        if (!isSmallScreen) SizedBox(width: deviceWidth * 0.1),
                        Column(
                          children: [
                            Text(
                              "next session",
                              style: GoogleFonts.brunoAce(
                                color: Colors.white,
                                fontSize: deviceWidth * 0.03,
                              ),
                            ),
                            Text(
                              nextSessionDate,
                              style: GoogleFonts.brunoAce(
                                color: Colors.white,
                                fontSize: deviceWidth * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: deviceHeight * 0.03),
                    Text(
                      "total study time",
                      style: GoogleFonts.brunoAce(
                        color: Colors.white,
                        fontSize: deviceWidth * 0.03,
                      ),
                    ),
                    Text(
                      totalStudyTime,
                      style: GoogleFonts.brunoAce(
                        color: Colors.white,
                        fontSize: deviceWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.04),
                    PhotoCard(
                      deviceWidth: deviceWidth,
                      deviceHeight: deviceHeight,
                    ),
                    SizedBox(height: deviceHeight * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: deviceWidth * 0.04,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtopics",
                            style: GoogleFonts.arimo(
                              color: Colors.white,
                              fontSize: deviceWidth * 0.06,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: const Color.fromRGBO(176, 152, 228, 1),
                              size: deviceWidth * 0.07,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    ...subTopics.map(
                      (subTopic) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.04,
                          vertical: deviceHeight * 0.01,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: deviceWidth * 0.04,
                              height: deviceWidth * 0.04,
                              child: Checkbox(
                                value: subTopic.completed,
                                onChanged: (value) {
                                  setState(() {
                                    subTopic.completed = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.03),
                            Expanded(
                              child: Text(
                                subTopic.title,
                                style: GoogleFonts.arimo(
                                  color: Colors.white,
                                  fontSize: deviceWidth * 0.04,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: deviceWidth * 0.04,
                        right: deviceWidth * 0.04,
                        top: deviceHeight * 0.01,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: deviceWidth * 0.04,
                            height: deviceWidth * 0.04,
                            child: Container(
                              width: deviceWidth * 0.05,
                              height: deviceWidth * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    187,
                                    187,
                                    187,
                                    187,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.add,
                                  size: deviceWidth * 0.03,
                                  color: const Color.fromARGB(
                                    187,
                                    187,
                                    187,
                                    187,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    subTopics.add(
                                      SubTopic(
                                        title: "New Subtopic",
                                        completed: false,
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: deviceWidth * 0.04),
                          Text(
                            "Add a subtopic",
                            style: GoogleFonts.arimo(
                              color: Colors.white,
                              fontSize: deviceWidth * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.04),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: deviceWidth * 0.04,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _actionButton(
                            text: "Start Session",
                            color: const Color.fromARGB(194, 109, 68, 221),
                            onPressed: () {},
                            deviceWidth: deviceWidth,
                            deviceHeight: deviceHeight,
                          ),
                          SizedBox(width: deviceWidth * 0.05),
                          _actionButton(
                            text: "Postpone Session",
                            color: const Color.fromARGB(185, 195, 29, 32),
                            onPressed: _postponeNotification,
                            deviceWidth: deviceWidth,
                            deviceHeight: deviceHeight,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.03),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    required double deviceWidth,
    required double deviceHeight,
  }) {
    return SizedBox(
      width: deviceWidth * 0.35,
      height: deviceHeight * 0.075,
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
            fontSize: deviceWidth * 0.035,
          ),
        ),
      ),
    );
  }
}

class PhotoCard extends StatelessWidget {
  final double deviceWidth;
  final double deviceHeight;

  const PhotoCard({
    super.key,
    required this.deviceWidth,
    required this.deviceHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(176, 152, 228, 1),
      margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
      child: Padding(
        padding: EdgeInsets.all(deviceWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Photos",
              style: GoogleFonts.arimo(
                color: const Color.fromARGB(255, 68, 67, 67),
                fontSize: deviceWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "# photos, # videos",
              style: GoogleFonts.arimo(
                color: const Color.fromARGB(255, 68, 67, 67),
                fontSize: deviceWidth * 0.035,
              ),
            ),
            SizedBox(height: deviceHeight * 0.01),
            Container(
              height: deviceHeight * 0.25,
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
