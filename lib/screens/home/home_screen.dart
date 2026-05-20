import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../blocs/habit/habit_bloc.dart';
import '../../blocs/habit/habit_event.dart';
import '../../blocs/habit/habit_state.dart';
import '../../models/habit.dart';
import '../../services/supabase_service.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load habits when screen opens
    context.read<HabitBloc>().add(LoadHabitsEvent());

    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        final habits = state is HabitLoadedState ? state.habits : <Habit>[];
        final isLoading = state is HabitLoadingState;
        final morningHabits = habits
            .where((h) => h.timeOfDay == 'morning')
            .toList();
        final afternoonHabits = habits
            .where((h) => h.timeOfDay == 'afternoon')
            .toList();
        final eveningHabits = habits
            .where((h) => h.timeOfDay == 'evening')
            .toList();
        final completedCount = habits.where((h) => h.isCompleted).length;
        final totalCount = habits.length;
        final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

        return Scaffold(
          backgroundColor: const Color(0xFFFAF6F0),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<HabitBloc>().add(LoadHabitsEvent());
              },
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
                              onTap: () {
                                context.read<AuthBloc>().add(AuthLogoutEvent());
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/onboarding',
                                );
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
                                    color: const Color(
                                      0xFF2E3230,
                                    ).withOpacity(0.5),
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
                          onTap: () => _showAddHabitSheet(context),
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

                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4A7C59),
                        ),
                      )
                    else if (habits.isEmpty)
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
                            onToggle: () => context.read<HabitBloc>().add(
                              ToggleHabitEvent(
                                habitId: habit.id,
                                isCompleted: !habit.isCompleted,
                              ),
                            ),
                            onEdit: () => _showEditHabitSheet(context, habit),
                            onDelete: () => context.read<HabitBloc>().add(
                              DeleteHabitEvent(habitId: habit.id),
                            ),
                          ),
                        ),
                      ],
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
                            onToggle: () => context.read<HabitBloc>().add(
                              ToggleHabitEvent(
                                habitId: habit.id,
                                isCompleted: !habit.isCompleted,
                              ),
                            ),
                            onEdit: () => _showEditHabitSheet(context, habit),
                            onDelete: () => context.read<HabitBloc>().add(
                              DeleteHabitEvent(habitId: habit.id),
                            ),
                          ),
                        ),
                      ],
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
                            onToggle: () => context.read<HabitBloc>().add(
                              ToggleHabitEvent(
                                habitId: habit.id,
                                isCompleted: !habit.isCompleted,
                              ),
                            ),
                            onEdit: () => _showEditHabitSheet(context, habit),
                            onDelete: () => context.read<HabitBloc>().add(
                              DeleteHabitEvent(habitId: habit.id),
                            ),
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
      },
    );
  }

  void _showAddHabitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<HabitBloc>(),
        child: const _AddHabitSheet(),
      ),
    );
  }

  void _showEditHabitSheet(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<HabitBloc>(),
        child: _AddHabitSheet(existingHabit: habit),
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

// Ritual tile
class _RitualTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RitualTile({
    required this.habit,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
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
          Text(habit.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF2E3230),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (habit.streak > 0)
                  Row(
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 3),
                      Text(
                        '${habit.streak} day streak',
                        style: GoogleFonts.nunitoSans(
                          color: const Color(0xFF705C30),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Start your streak today',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF2E3230).withOpacity(0.3),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => _HabitOptionsSheet(
                  habit: habit,
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
              );
            },
            child: GestureDetector(
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
          ),
        ],
      ),
    );
  }
}

// Habit options sheet
class _HabitOptionsSheet extends StatelessWidget {
  final Habit habit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HabitOptionsSheet({
    required this.habit,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAF6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
            habit.title,
            style: GoogleFonts.literata(
              color: const Color(0xFF2E3230),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, color: Color(0xFF4A7C59)),
                  const SizedBox(width: 12),
                  Text(
                    'Edit Habit',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF2E3230),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, color: Colors.red),
                  const SizedBox(width: 12),
                  Text(
                    'Delete Habit',
                    style: GoogleFonts.nunitoSans(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Add/Edit habit sheet
class _AddHabitSheet extends StatefulWidget {
  final Habit? existingHabit;

  const _AddHabitSheet({this.existingHabit});

  @override
  State<_AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<_AddHabitSheet> {
  late TextEditingController _titleController;
  late String _selectedEmoji;
  late String _selectedTime;

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
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingHabit?.title ?? '',
    );
    _selectedEmoji = widget.existingHabit?.emoji ?? '✅';
    _selectedTime = widget.existingHabit?.timeOfDay ?? 'morning';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.existingHabit != null;

  void _saveHabit() {
    if (_titleController.text.trim().isEmpty) return;

    if (_isEditing) {
      context.read<HabitBloc>().add(
        EditHabitEvent(
          habitId: widget.existingHabit!.id,
          title: _titleController.text.trim(),
          emoji: _selectedEmoji,
          timeOfDay: _selectedTime,
        ),
      );
    } else {
      context.read<HabitBloc>().add(
        AddHabitEvent(
          title: _titleController.text.trim(),
          emoji: _selectedEmoji,
          timeOfDay: _selectedTime,
        ),
      );
    }

    Navigator.pop(context);
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
            _isEditing ? 'Edit Habit' : 'New Habit',
            style: GoogleFonts.literata(
              color: const Color(0xFF2E3230),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveHabit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isEditing ? 'Update Habit' : 'Save Habit',
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
