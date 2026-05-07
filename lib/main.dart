import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const AscendApp());
}

class AscendApp extends StatelessWidget {
  const AscendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ascend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A7C59)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final String _title = 'Ascend';
  final String _tagline = 'Show up. Every day.';
  String _displayedTitle = '';
  String _displayedTagline = '';
  bool _showTagline = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    await _typeText(_title, isTitle: true);

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _showTagline = true);
    await _typeText(_tagline, isTitle: false);

    // Auto navigate to onboarding after splash
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  Future<void> _typeText(String text, {required bool isTitle}) async {
    for (int i = 0; i <= text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      if (mounted) {
        setState(() {
          if (isTitle) {
            _displayedTitle = text.substring(0, i);
          } else {
            _displayedTagline = text.substring(0, i);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text('🌱', style: TextStyle(fontSize: 64)),
            ),
            const SizedBox(height: 24),
            Text(
              _displayedTitle,
              style: GoogleFonts.literata(
                color: const Color(0xFF4A7C59),
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            AnimatedOpacity(
              opacity: _showTagline ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                _displayedTagline,
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF705C30),
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
