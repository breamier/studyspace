import 'package:flutter/material.dart';
import 'package:studyspace/screens/dashboard_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  final TextStyle _titleStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'BrunoAceSC',
  );

  final TextStyle _bodyStyle = TextStyle(
    color: Colors.white,
    fontSize: 29,
    fontFamily: 'Arimo',
  );

  void _goToDashboard() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => DashboardScreen()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage('assets/stars.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _buildWelcomePage(),
                _buildSpacedRepetitionPage(),
                _buildAutomaticSchedulingPage(),
                _buildGamifiedLearningPage(),
              ],
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        _totalPages,
                        (i) => Container(
                              width: i == _currentPage ? 10 : 8,
                              height: i == _currentPage ? 10 : 8,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == i
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                              ),
                            )),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: _currentPage == 3
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage != 3)
                          TextButton(
                            onPressed: _goToDashboard,
                            style: TextButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                            ),
                            child: Text(
                              'Skip',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(
                                horizontal: _currentPage == 3 ? 30 : 40,
                                vertical: 12),
                            minimumSize:
                                _currentPage == 3 ? Size(180, 45) : null,
                          ),
                          onPressed: _currentPage == 3
                              ? _goToDashboard
                              : () => _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  ),
                          child: Text(
                            _currentPage == 3 ? "Let's do it!" : 'Next',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: _currentPage == 3
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WELCOME\nLEARNER,',
                      style: _titleStyle.copyWith(fontSize: 28)),
                ],
              ),
              Image.asset('assets/mascot1.png', height: 120),
            ],
          ),
          Spacer(flex: 1),
          RichText(
            text: TextSpan(
              style: _bodyStyle,
              children: [
                TextSpan(
                    text: 'Study Space ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'helps you achieve your learning goals through the '),
                TextSpan(
                  text: 'Spaced Repetition Technique',
                  style: TextStyle(
                    color: Colors.purple,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildSpacedRepetitionPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(flex: 2),
          Text('SPACED REPETITION\nSTUDY TECHNIQUE',
              style: _titleStyle.copyWith(fontSize: 28)),
          Center(child: Image.asset('assets/mascot2.png', height: 220)),
          Text(
            'A scientifically proven study method that helps information retention by studying in intervals over a period of time',
            textAlign: TextAlign.right,
            style: _bodyStyle,
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildAutomaticSchedulingPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(flex: 2),
          Text('AUTOMATIC\nSCHEDULING',
              style: _titleStyle.copyWith(fontSize: 29)),
          Center(child: Image.asset('assets/mascot3.png', height: 250)),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Schedule your study sessions based on the difficulty of your learning goals',
              textAlign: TextAlign.right,
              style: _bodyStyle,
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildGamifiedLearningPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(flex: 2),
          Text('GAMIFIED LEARNING\nExperience',
              style: _titleStyle.copyWith(fontSize: 29)),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'YOUR\nASTRONAUT IS\nTRAVELLING...',
                  style: TextStyle(
                    fontFamily: 'BrunoAceSC',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Image.asset('assets/mascot4.png', height: 200),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Help your astronaut finish quests and travel by doing your study sessions',
              textAlign: TextAlign.right,
              style: _bodyStyle,
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}
