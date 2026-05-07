import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/habits/habits_screen.dart';
import 'screens/goals/goals_screen.dart';
import 'screens/journal/journal_screen.dart';
import 'screens/library/library_screen.dart';

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
        '/home': (context) => const MainShell(),
      },
    );
  }
}

// Main shell with bottom nav
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const GoalsScreen(),
    const JournalScreen(),
    const LibraryScreen(),
    const HabitsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E3230).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.wb_sunny_outlined,
                  activeIcon: Icons.wb_sunny,
                  label: 'Today',
                  index: 0,
                  currentIndex: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                ),
                _NavItem(
                  icon: Icons.track_changes_outlined,
                  activeIcon: Icons.track_changes,
                  label: 'Goals',
                  index: 1,
                  currentIndex: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                ),
                _NavItem(
                  icon: Icons.edit_note_outlined,
                  activeIcon: Icons.edit_note,
                  label: 'Journal',
                  index: 2,
                  currentIndex: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                ),
                _NavItem(
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book,
                  label: 'Library',
                  index: 3,
                  currentIndex: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                ),
                _NavItem(
                  icon: Icons.self_improvement_outlined,
                  activeIcon: Icons.self_improvement,
                  label: 'Coach',
                  index: 4,
                  currentIndex: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF4A7C59).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? const Color(0xFF4A7C59)
                  : const Color(0xFF2E3230).withOpacity(0.4),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                color: isActive
                    ? const Color(0xFF4A7C59)
                    : const Color(0xFF2E3230).withOpacity(0.4),
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Splash screen stays here
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
