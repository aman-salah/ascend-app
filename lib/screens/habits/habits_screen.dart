import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

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
                  Icon(
                    Icons.notifications_outlined,
                    color: const Color(0xFF2E3230).withOpacity(0.5),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Analysis label
              Text(
                'ANALYSIS',
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly AI Digest',
                    style: GoogleFonts.literata(
                      color: const Color(0xFF2E3230),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Updated 2h ago',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF2E3230).withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // AI digest card
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
                child: Text(
                  'This week, your consistency in morning meditation has reached a new peak, showing a 40% improvement in focus metrics during work hours. You\'ve successfully integrated the "Quiet Start" routine which seems to be shielding you from early-day stress spikes.\n\nHowever, we noticed a slight slip in your physical activity. Your evening walks are frequently being skipped when your workday extends past 6:00 PM.',
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF2E3230).withOpacity(0.7),
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Habit Ecosystem
              Text(
                'Habit Ecosystem',
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _HabitEcosystemTile(
                emoji: '🌅',
                title: 'Morning Flow',
                subtitle: 'YOGA + MEDITATION',
                percent: 85,
              ),
              _HabitEcosystemTile(
                emoji: '☀️',
                title: 'Midday Focus',
                subtitle: 'READING + HYDRATION',
                percent: 92,
              ),
              _HabitEcosystemTile(
                emoji: '🌙',
                title: 'Evening Wind-down',
                subtitle: 'GRATITUDE + TEA',
                percent: 78,
              ),

              const SizedBox(height: 24),

              // Consistency Insight
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consistency Insight',
                      style: GoogleFonts.literata(
                        color: const Color(0xFF2E3230),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _InsightStat(
                            label: 'Longest Streak',
                            value: '14 Days',
                          ),
                        ),
                        Expanded(
                          child: _InsightStat(
                            label: 'This Month',
                            value: '18 / 21',
                          ),
                        ),
                        Expanded(
                          child: _InsightStat(
                            label: 'Skips Remaining',
                            value: '2 / 4',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF6F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '"The goal is not perfection, but the courage to keep coming back."',
                        style: GoogleFonts.literata(
                          color: const Color(0xFF2E3230).withOpacity(0.6),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Goal Alignment
              Text(
                'Goal Alignment',
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _GoalAlignmentCard(
                emoji: '🧘',
                title: 'Physical Vitality',
                description:
                    "You've completed 42 yoga sessions toward your 100-session milestone.",
                aiCompleted: true,
                onTarget: false,
              ),

              const SizedBox(height: 24),

              // AI Suggestion card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7C59).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF4A7C59).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🚶', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          'Evening Walk Adjustment?',
                          style: GoogleFonts.literata(
                            color: const Color(0xFF2E3230),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You've missed your evening walk three times this week due to late meetings. Would you like to shift your activity target to a 15-minute \"Sunrise Stretch\" for the next few days?",
                      style: GoogleFonts.nunitoSans(
                        color: const Color(0xFF2E3230).withOpacity(0.6),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A7C59),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Shift to Morning',
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: const Color(0xFF4A7C59).withOpacity(0.4),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Remind me later',
                              style: GoogleFonts.nunitoSans(
                                color: const Color(0xFF4A7C59),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Stalled Goal alert
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF705C30).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF705C30).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('⚠️', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          'Stalled Goal',
                          style: GoogleFonts.literata(
                            color: const Color(0xFF705C30),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'READING • 8 PAGES/MONTH',
                          style: GoogleFonts.nunitoSans(
                            color: const Color(0xFF705C30).withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No progress detected in 12 days. Is the current book not resonating, or should we break the goal into 5-page daily sprints?',
                      style: GoogleFonts.nunitoSans(
                        color: const Color(0xFF2E3230).withOpacity(0.6),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Adjust Goal →',
                        style: GoogleFonts.nunitoSans(
                          color: const Color(0xFF705C30),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Reflection Insights
              Text(
                'Reflection Insights',
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _ReflectionCard(
                tag: 'MOOD PATTERN',
                tagColor: const Color(0xFF4A7C59),
                title: 'The "Mid-Week Slump"',
                description:
                    'Your journal entries on Wednesdays often mention "mental fog." Try scheduling a creative task or special coffee break during that window.',
              ),

              _ReflectionCard(
                tag: 'DAILY PRIORITY',
                tagColor: const Color(0xFF705C30),
                title: 'Unfinished Business',
                description:
                    'You mentioned "anxious energy" about a project today. What is one tiny thing you can do tomorrow to feel more in control?',
              ),

              const SizedBox(height: 24),

              // Ask AI card
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
                    Text(
                      'Have a specific question?',
                      style: GoogleFonts.literata(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your AI coach is ready to help you navigate specific challenges or refine your routines in real-time.',
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _questionController,
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'How can I improve my sleep quality tonight?',
                                hintStyle: GoogleFonts.nunitoSans(
                                  color: Colors.white.withOpacity(0.3),
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A7C59),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
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

class _HabitEcosystemTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final int percent;

  const _HabitEcosystemTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
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
                Text(
                  subtitle,
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF2E3230).withOpacity(0.4),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$percent%',
            style: GoogleFonts.literata(
              color: const Color(0xFF4A7C59),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightStat extends StatelessWidget {
  final String label;
  final String value;

  const _InsightStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.literata(
            color: const Color(0xFF4A7C59),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(
            color: const Color(0xFF2E3230).withOpacity(0.4),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _GoalAlignmentCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final bool aiCompleted;
  final bool onTarget;

  const _GoalAlignmentCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.aiCompleted,
    required this.onTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4A7C59).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.literata(
                    color: const Color(0xFF2E3230),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF2E3230).withOpacity(0.5),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Badge(
                      label: 'AI COMPLETED',
                      color: const Color(0xFF4A7C59),
                    ),
                    const SizedBox(width: 8),
                    _Badge(label: 'ON TARGET', color: const Color(0xFF705C30)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunitoSans(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  final String tag;
  final Color tagColor;
  final String title;
  final String description;

  const _ReflectionCard({
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.description,
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
            color: const Color(0xFF2E3230).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '✦ $tag',
              style: GoogleFonts.nunitoSans(
                color: tagColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.literata(
              color: const Color(0xFF2E3230),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.5),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
