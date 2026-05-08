import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
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
                      Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: const Color(0xFF2E3230).withOpacity(0.5),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.notifications_outlined,
                            color: const Color(0xFF2E3230).withOpacity(0.5),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Life Areas title
                  Text(
                    'Life Areas',
                    style: GoogleFonts.literata(
                      color: const Color(0xFF2E3230),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cultivate balance across your core foundations.',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF2E3230).withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Life Area cards row
                  Row(
                    children: [
                      Expanded(
                        child: _LifeAreaCard(
                          emoji: '❤️',
                          title: 'Health',
                          goalCount: 4,
                          isActive: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _LifeAreaCard(
                          emoji: '💼',
                          title: 'Career',
                          goalCount: 2,
                          isActive: false,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Focused on label
                  Row(
                    children: [
                      Text(
                        'FOCUSED ON',
                        style: GoogleFonts.nunitoSans(
                          color: const Color(0xFF2E3230).withOpacity(0.4),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Health & Vitality',
                    style: GoogleFonts.literata(
                      color: const Color(0xFF2E3230),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Goal cards
                  _GoalCard(
                    title: 'Marathon Ready',
                    description: 'Complete a 42km run by Dec.',
                    status: 'ON TRACK',
                    statusColor: const Color(0xFF4A7C59),
                    momentum: 0.84,
                    currentMilestone: 'Daily 5k morning run',
                    nextMilestone: '15km Endurance Run',
                    nextMilestoneDate: 'Target: Next Sunday',
                    done: true,
                  ),

                  const SizedBox(height: 12),

                  _GoalCard(
                    title: 'Mindfulness Master',
                    description: 'Daily meditation practice.',
                    status: 'NEEDS FOCUS',
                    statusColor: const Color(0xFF705C30),
                    momentum: 0.42,
                    currentMilestone: '10 min breathing work',
                    nextMilestone: '7-Day Streak',
                    nextMilestoneDate: '47 days completed',
                    done: false,
                  ),

                  const SizedBox(height: 12),

                  // Flexibility Pro card (dark)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3230),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Flexibility Pro',
                              style: GoogleFonts.literata(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Achieve full splits by October',
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.89,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF4A7C59),
                            ),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '89%',
                          style: GoogleFonts.nunitoSans(
                            color: const Color(0xFF4A7C59),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A7C59),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              'Check Milestones',
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Consistency card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                        // Circle progress
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: 0.75,
                                strokeWidth: 4,
                                backgroundColor: const Color(
                                  0xFF4A7C59,
                                ).withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4A7C59),
                                ),
                              ),
                              Text(
                                '75%',
                                style: GoogleFonts.literata(
                                  color: const Color(0xFF4A7C59),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Consistency is Key',
                                style: GoogleFonts.literata(
                                  color: const Color(0xFF2E3230),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "You've hit your health-related habits 5 days in a row.",
                                style: GoogleFonts.nunitoSans(
                                  color: const Color(
                                    0xFF2E3230,
                                  ).withOpacity(0.5),
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _StatChip(
                                    label: 'ACTIVE STREAK',
                                    value: '12 Days',
                                  ),
                                  const SizedBox(width: 12),
                                  _StatChip(
                                    label: 'GOALS COMPLETED',
                                    value: '08',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Floating New Goal button
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7C59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: Text(
                  'New Goal',
                  style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Life Area Card
class _LifeAreaCard extends StatelessWidget {
  final String emoji;
  final String title;
  final int goalCount;
  final bool isActive;

  const _LifeAreaCard({
    required this.emoji,
    required this.title,
    required this.goalCount,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF4A7C59).withOpacity(0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? const Color(0xFF4A7C59).withOpacity(0.3)
              : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E3230).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.literata(
              color: const Color(0xFF2E3230),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$goalCount ACTIVE GOALS',
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Goal Card
class _GoalCard extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final Color statusColor;
  final double momentum;
  final String currentMilestone;
  final String nextMilestone;
  final String nextMilestoneDate;
  final bool done;

  const _GoalCard({
    required this.title,
    required this.description,
    required this.status,
    required this.statusColor,
    required this.momentum,
    required this.currentMilestone,
    required this.nextMilestone,
    required this.nextMilestoneDate,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Title + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.nunitoSans(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.5),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 14),

          // Momentum score label
          Text(
            'MOMENTUM SCORE',
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
              value: momentum,
              backgroundColor: const Color(0xFF4A7C59).withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                momentum > 0.6
                    ? const Color(0xFF4A7C59)
                    : const Color(0xFF705C30),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(momentum * 100).toInt()}%',
            style: GoogleFonts.nunitoSans(
              color: momentum > 0.6
                  ? const Color(0xFF4A7C59)
                  : const Color(0xFF705C30),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          // Current milestone
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: done ? const Color(0xFF4A7C59) : Colors.transparent,
                  border: Border.all(
                    color: done
                        ? const Color(0xFF4A7C59)
                        : const Color(0xFF2E3230).withOpacity(0.2),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: done
                    ? const Icon(Icons.check, color: Colors.white, size: 12)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                currentMilestone,
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Next milestone
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UPCOMING MILESTONE',
                      style: GoogleFonts.nunitoSans(
                        color: const Color(0xFF2E3230).withOpacity(0.4),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextMilestone,
                      style: GoogleFonts.nunitoSans(
                        color: const Color(0xFF2E3230),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      nextMilestoneDate,
                      style: GoogleFonts.nunitoSans(
                        color: const Color(0xFF2E3230).withOpacity(0.4),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF4A7C59),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Stat chip
class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            color: const Color(0xFF2E3230).withOpacity(0.4),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.literata(
            color: const Color(0xFF2E3230),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
