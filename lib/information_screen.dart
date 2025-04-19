import 'package:flutter/material.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  int _selectedIndex = 0;
  String? _currentDetailPage;

  @override
  Widget build(BuildContext context) {
    if (_currentDetailPage != null) {
      return _buildDetailPage(context, _currentDetailPage!);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildLogo(),
              GestureDetector(
                onTap: () => setState(() => _currentDetailPage = 'About Us'),
                child: _buildInfoCard(
                  'assets/mascot5.png',
                  'About Us',
                  'Study Space combines the power of Spaced Repetition with personalized reminders to help you master any subject faster and retain information longer.',
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _currentDetailPage = 'Science Behind Study Space'),
                child: _buildInfoCard(
                  'assets/mascot6.png',
                  'Science Behind\nStudy Space',
                  'Spacing out study sessions helps your brain retain information longer and reduce the need for cramming.',
                ),
              ),
              
              const SizedBox(height: 24),
              _buildSectionTitle('How can we help you?'),
              
              _buildSearchBar(),
              
              const SizedBox(height: 24),
              _buildSectionTitle('FAQs'),
              
              const SizedBox(height: 10),
              FAQItem(
                question: 'How does the app know when to send study reminder?',
                answer: 'The app uses spaced repetition algorithms to determine the optimal time for sending reminders based on your learning patterns and memory retention curve.',
              ),
              FAQItem(
                question: 'Can I customize my study schedule?',
                answer: 'Yes, you can set preferred study times, adjust reminder frequency, and specify days when you want to study specific subjects.',
              ),
              FAQItem(
                question: 'Is the app suitable for all learners?',
                answer: 'Study Space is designed to benefit learners of all ages and across various subjects, from languages to sciences to professional skills.',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
  
  Widget _buildDetailPage(BuildContext context, String pageName) {
    String content = '';
    
    if (pageName == 'About Us') {
      content = '''Study space combines the power of Spaced Repetition with personalized reminders to help you master any subject faster and retain information longer..

This application introduces novices to this concept and helps learners sustain their study habits. By automatically scheduling study sessions based on the lessons' difficulty level, providing real-time progress reports, and designing quests to motivate users to study, Study Space offers an engaging and fun approach to learning that adapts to the users' needs and goals.

Study Space is aimed at university students and lifelong learners whose goal is to improve their study habits and retain information long-term. The application increases the users' learning capacity and productivity by providing a sense of accountability without the added pressure. Like an accountability buddy, Study Space encourages the user by checking on progress, giving rewards, and reminding users in a friendly manner.''';
    } else if (pageName == 'Science Behind Study Space') {
      content = '''Our app is built on the science of Spaced Repetition, a method proven to enhance memory retention and boost learning efficiency. By spacing out study sessions, your brain strengthens connections, helping you retain information longer and reduce the need for cramming.

Study Space takes this proven method to the next level by adapting the schedule based on the difficulty of the material. The app automatically adjusts the intervals for reviewing content, so you focus more on what you struggle with and less on what you've already mastered. This targeted approach helps maximize learning in less time. Coupled with real-time progress tracking and motivating features like quests, Study Space ensures that your study routine is both effective and enjoyable, making it easier to build long-term retention habits that stick.''';
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => setState(() => _currentDetailPage = null),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Information',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                pageName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color:  Colors.grey[900]!,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[900]!, width: 1),
                  ),
                  child: Text(
                    content,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Home',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLogo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
        child: Image.asset(
          'assets/logo.png',
          height: 65,
          width: 200,
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(String imagePath, String title, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, height: 100, width: 100),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search help',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
  
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[600],
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Study Goals'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40), label: 'Add Goal'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            widget.question,
            style: const TextStyle(
              color: Colors.black, 
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.black, 
          ),
          onExpansionChanged: (expanded) => setState(() => _expanded = expanded),
          backgroundColor: Colors.white,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
              ),
              child: Text(
                widget.answer,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}