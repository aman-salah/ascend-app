import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../models/habit.dart';
import '../../services/habit_service.dart';
import '../../services/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    setState(() => _isLoading = true);
    try {
      final habits = await HabitService.getHabits();
      setState(() => _habits = habits);
    } catch (e) {
      debugPrint('Error loading habits: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleHabit(Habit habit) async {
    await HabitService.toggleHabit(habit.id, !habit.isCompleted);
    _loadHabits();
  }

  void _showAddHabitSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddHabitSheet(onHabitAdded: _loadHabits),
    );
  }

  @override
  Widget build(BuildContext context) {
    final morningHabits = _habits
        .where((h) => h.timeOfDay == 'morning')
        .toList();
    final afternoonHabits = _habits
        .where((h) => h.timeOfDay == 'afternoon')
        .toList();
    final eveningHabits = _habits
        .where((h) => h.timeOfDay == 'evening')
        .toList();
    final completedCount = _habits.where((h) => h.isCompleted).length;
    final totalCount = _habits.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadHabits,
          color: const Color(0xFF4A7C59),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          color: const Color(0xFF2E3230).withOpacity(0.5),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () async {
                            await SupabaseService.client.auth.signOut();
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/onboarding',
                              );
                            }
                          },
                          child: Icon(
                            Icons.logout,
                            color: const Color(0xFF2E3230).withOpacity(0.5),
                          ),
                        ),
                      ],
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
                          painter: _RingPainter(progress: progress),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(progress * 100).toInt()}%',
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
                    'Good Morning 🌱',
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
                    totalCount > 0
                        ? 'You\'re ${totalCount - completedCount} habits away from a perfect start.'
                        : 'Add your first habit to get started.',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF2E3230).withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Daily Rituals header
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
                    GestureDetector(
                      onTap: _showAddHabitSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7C59),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+ Add',
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Loading state
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4A7C59)),
                  )
                else if (_habits.isEmpty)
                  // Empty state
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text('🌱', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text(
                          'No habits yet',
                          style: GoogleFonts.literata(
                            color: const Color(0xFF2E3230),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap + Add to create your first habit',
                          style: GoogleFonts.nunitoSans(
                            color: const Color(0xFF2E3230).withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  // Morning habits
                  if (morningHabits.isNotEmpty) ...[
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
                    ...morningHabits.map(
                      (habit) => _RitualTile(
                        habit: habit,
                        onToggle: () => _toggleHabit(habit),
                      ),
                    ),
                  ],

                  // Afternoon habits
                  if (afternoonHabits.isNotEmpty) ...[
                    const SizedBox(height: 12),
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
                    ...afternoonHabits.map(
                      (habit) => _RitualTile(
                        habit: habit,
                        onToggle: () => _toggleHabit(habit),
                      ),
                    ),
                  ],

                  // Evening habits
                  if (eveningHabits.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      '◎ EVENING',
                      style: GoogleFonts.nunitoSans(
                        color: const Color(0xFF2E3230).withOpacity(0.4),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...eveningHabits.map(
                      (habit) => _RitualTile(
                        habit: habit,
                        onToggle: () => _toggleHabit(habit),
                      ),
                    ),
                  ],
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Ring painter
class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final bgPaint = Paint()
      ..color = const Color(0xFF4A7C59).withOpacity(0.1)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

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

// Ritual tile with real habit data
class _RitualTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;

  const _RitualTile({required this.habit, required this.onToggle});

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
          Text(habit.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              habit.title,
              style: GoogleFonts.nunitoSans(
                color: const Color(0xFF2E3230),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: habit.isCompleted
                    ? const Color(0xFF4A7C59)
                    : Colors.transparent,
                border: Border.all(
                  color: habit.isCompleted
                      ? const Color(0xFF4A7C59)
                      : const Color(0xFF2E3230).withOpacity(0.2),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: habit.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// Add Habit Bottom Sheet
class _AddHabitSheet extends StatefulWidget {
  final VoidCallback onHabitAdded;

  const _AddHabitSheet({required this.onHabitAdded});

  @override
  State<_AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<_AddHabitSheet> {
  final TextEditingController _titleController = TextEditingController();
  String _selectedEmoji = '✅';
  String _selectedTime = 'morning';
  bool _isLoading = false;

  final List<String> _emojis = [
    '✅',
    '💧',
    '📖',
    '🧘',
    '🏃',
    '💪',
    '🥗',
    '😴',
    '✍️',
    '🎯',
    '🌅',
    '🚶',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final habit = Habit(
        id: '',
        userId: SupabaseService.client.auth.currentUser!.id,
        title: _titleController.text.trim(),
        emoji: _selectedEmoji,
        timeOfDay: _selectedTime,
      );

      await HabitService.addHabit(habit);
      widget.onHabitAdded();

      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint('Error saving habit: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAF6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF2E3230).withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'New Habit',
            style: GoogleFonts.literata(
              color: const Color(0xFF2E3230),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Habit title
          Container(
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
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'e.g. Morning Meditation',
                hintStyle: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.3),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: GoogleFonts.nunitoSans(
                color: const Color(0xFF2E3230),
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Emoji picker
          Text(
            'PICK AN EMOJI',
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _emojis.map((emoji) {
              final isSelected = _selectedEmoji == emoji;
              return GestureDetector(
                onTap: () => setState(() => _selectedEmoji = emoji),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4A7C59).withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4A7C59)
                          : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Time of day
          Text(
            'TIME OF DAY',
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: ['morning', 'afternoon', 'evening'].map((time) {
              final isSelected = _selectedTime == time;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTime = time),
                  child: Container(
                    margin: EdgeInsets.only(right: time != 'evening' ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4A7C59)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4A7C59)
                            : const Color(0xFF2E3230).withOpacity(0.1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        time[0].toUpperCase() + time.substring(1),
                        style: GoogleFonts.nunitoSans(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF2E3230).withOpacity(0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveHabit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Save Habit',
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
