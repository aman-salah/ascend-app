import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning 🌱',
                        style: GoogleFonts.nunitoSans(
                          color: const Color(0xFF705C30),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome to Ascend',
                        style: GoogleFonts.literata(
                          color: const Color(0xFF2E3230),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A7C59).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF4A7C59),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Daily Check-in Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7C59),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Check-in',
                      style: GoogleFonts.nunitoSans(
                        color: const Color(0xFFFAF6F0).withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How are you showing\nup today?',
                      style: GoogleFonts.literata(
                        color: const Color(0xFFFAF6F0),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF6F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Start Check-in →',
                        style: GoogleFonts.nunitoSans(
                          color: const Color(0xFF4A7C59),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Today's Habits
              Text(
                "Today's Habits",
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _HabitTile(
                emoji: '💧',
                title: 'Drink Water',
                subtitle: '8 glasses',
                done: true,
              ),
              _HabitTile(
                emoji: '📖',
                title: 'Read',
                subtitle: '20 pages',
                done: false,
              ),
              _HabitTile(
                emoji: '🧘',
                title: 'Meditate',
                subtitle: '10 minutes',
                done: false,
              ),

              const SizedBox(height: 28),

              // Quick Actions
              Text(
                'Quick Actions',
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(emoji: '📓', label: 'Journal'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(emoji: '🎯', label: 'Goals'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(emoji: '📚', label: 'Library'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HabitTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool done;

  const _HabitTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E3230).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF2E3230),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF705C30),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: done
                  ? const Color(0xFF4A7C59)
                  : const Color(0xFF4A7C59).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: done
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String emoji;
  final String label;

  const _QuickActionCard({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E3230).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
