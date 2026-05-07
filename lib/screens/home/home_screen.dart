import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7C59),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Ascend',
                        style: GoogleFonts.literata(
                          color: const Color(0xFF2E3230),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.notifications_outlined,
                    color: const Color(0xFF2E3230).withOpacity(0.5),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Morning Pulse Ring
              Center(
                child: SizedBox(
                  width: 130,
                  height: 130,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(130, 130),
                        painter: _RingPainter(progress: 0.70),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '70%',
                            style: GoogleFonts.literata(
                              color: const Color(0xFF4A7C59),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'MORNING PULSE',
                            style: GoogleFonts.nunitoSans(
                              color: const Color(0xFF2E3230).withOpacity(0.5),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Good Morning
              Center(
                child: Text(
                  'Good Morning, Aman',
                  style: GoogleFonts.literata(
                    color: const Color(0xFF2E3230),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  "You're 4 habits away from a perfect start.",
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF2E3230).withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Today's Focus Card
              Container(
                width: double.infinity,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🌟', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          "Today's Focus",
                          style: GoogleFonts.nunitoSans(
                            color: const Color(0xFF705C30),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"How can I be more intentional\nwith my energy during the\nafternoon lull?"',
                      style: GoogleFonts.literata(
                        color: const Color(0xFF2E3230),
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          size: 14,
                          color: Color(0xFF4A7C59),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Reflect on this',
                          style: GoogleFonts.nunitoSans(
                            color: const Color(0xFF4A7C59),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Daily Rituals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Rituals',
                    style: GoogleFonts.literata(
                      color: const Color(0xFF2E3230),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'View All',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF4A7C59),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Morning label
              Text(
                '◎ MORNING',
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 8),

              _RitualTile(
                emoji: '💧',
                title: 'Hydrate (500ml)',
                subtitle: 'Immediate upon waking',
                done: true,
                locked: false,
              ),
              _RitualTile(
                emoji: '🧘',
                title: 'Morning Meditation',
                subtitle: '10 minutes session',
                done: false,
                locked: false,
              ),

              const SizedBox(height: 12),

              // Afternoon label
              Text(
                '◎ AFTERNOON',
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 8),

              _RitualTile(
                emoji: '🚶',
                title: 'Quick Stretch Break',
                subtitle: '',
                done: false,
                locked: true,
              ),

              const SizedBox(height: 24),

              // Top Priorities
              Text(
                'Top Priorities',
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _PriorityTile(
                title: 'Submit the garden design proposal',
                done: false,
              ),
              _PriorityTile(
                title: 'Call the local community center',
                done: false,
              ),
              _PriorityTile(title: 'Review weekly expenses', done: true),

              const SizedBox(height: 24),

              // Reading Journey
              Text(
                'Reading Journey',
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Container(
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
                    Container(
                      width: 56,
                      height: 76,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A7C59),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deep Work',
                            style: GoogleFonts.literata(
                              color: const Color(0xFF2E3230),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Cal Newport',
                            style: GoogleFonts.nunitoSans(
                              color: const Color(0xFF2E3230).withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'CHAPTER 4 OF 12',
                            style: GoogleFonts.nunitoSans(
                              color: const Color(0xFF2E3230).withOpacity(0.4),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: 0.45,
                              backgroundColor: const Color(
                                0xFF4A7C59,
                              ).withOpacity(0.1),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF4A7C59),
                              ),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '45%',
                            style: GoogleFonts.nunitoSans(
                              color: const Color(0xFF4A7C59),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Ring painter for morning pulse
class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Background ring
    final bgPaint = Paint()
      ..color = const Color(0xFF4A7C59).withOpacity(0.1)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    final progressPaint = Paint()
      ..color = const Color(0xFF4A7C59)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// Ritual tile
class _RitualTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool done;
  final bool locked;

  const _RitualTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E3230).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF2E3230),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF2E3230).withOpacity(0.45),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          locked
              ? Icon(
                  Icons.lock_outline,
                  color: const Color(0xFF2E3230).withOpacity(0.3),
                  size: 20,
                )
              : Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: done ? const Color(0xFF4A7C59) : Colors.transparent,
                    border: Border.all(
                      color: done
                          ? const Color(0xFF4A7C59)
                          : const Color(0xFF2E3230).withOpacity(0.2),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: done
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
        ],
      ),
    );
  }
}

// Priority tile
class _PriorityTile extends StatelessWidget {
  final String title;
  final bool done;

  const _PriorityTile({required this.title, required this.done});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: done ? const Color(0xFF4A7C59) : Colors.transparent,
              border: Border.all(
                color: done
                    ? const Color(0xFF4A7C59)
                    : const Color(0xFF2E3230).withOpacity(0.3),
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: done
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.nunitoSans(
              color: done
                  ? const Color(0xFF2E3230).withOpacity(0.4)
                  : const Color(0xFF2E3230),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: done ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}
