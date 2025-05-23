import 'package:flutter/material.dart';

class AnimatedToast extends StatefulWidget {
  final String message;

  const AnimatedToast({super.key, required this.message});

  @override
  State<AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<AnimatedToast>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // Hide after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _controller.reverse().then((_) {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: 40,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 50,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            color: Color(0xFF161616),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.message,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'BrunoAceSC'),
          ),
        ),
      ),
    );
  }
}
