import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../blocs/goal/goal_bloc.dart';
import '../../blocs/goal/goal_event.dart';
import '../../blocs/goal/goal_state.dart';
import '../../models/goal.dart';
import '../../models/milestone.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String _selectedArea = 'All';

  @override
  void initState() {
    super.initState();
    context.read<GoalBloc>().add(LoadGoalsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalBloc, GoalState>(
      builder: (context, state) {
        final goals = state is GoalLoadedState ? state.goals : <Goal>[];
        final isLoading = state is GoalLoadingState;

        final filteredGoals = _selectedArea == 'All'
            ? goals
            : goals.where((g) => g.lifeArea == _selectedArea).toList();

        final lifeAreaCounts = <String, int>{};
        for (final goal in goals) {
          lifeAreaCounts[goal.lifeArea] =
              (lifeAreaCounts[goal.lifeArea] ?? 0) + 1;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFAF6F0),
          body: SafeArea(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    context.read<GoalBloc>().add(LoadGoalsEvent());
                  },
                  color: const Color(0xFF4A7C59),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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

                        // Life area cards
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                [
                                  'Health',
                                  'Career',
                                  'Relationships',
                                  'Finance',
                                  'Personal',
                                ].map((area) {
                                  final count = lifeAreaCounts[area] ?? 0;
                                  final isActive = _selectedArea == area;
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedArea = area),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? const Color(
                                                0xFF4A7C59,
                                              ).withOpacity(0.08)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isActive
                                              ? const Color(
                                                  0xFF4A7C59,
                                                ).withOpacity(0.3)
                                              : Colors.transparent,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF2E3230,
                                            ).withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _areaEmoji(area),
                                            style: const TextStyle(
                                              fontSize: 28,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            area,
                                            style: GoogleFonts.literata(
                                              color: const Color(0xFF2E3230),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$count GOALS',
                                            style: GoogleFonts.nunitoSans(
                                              color: const Color(
                                                0xFF2E3230,
                                              ).withOpacity(0.4),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        if (isLoading)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF4A7C59),
                            ),
                          )
                        else if (filteredGoals.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '🎯',
                                  style: TextStyle(fontSize: 40),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No goals yet',
                                  style: GoogleFonts.literata(
                                    color: const Color(0xFF2E3230),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap + New Goal to add your first goal',
                                  style: GoogleFonts.nunitoSans(
                                    color: const Color(
                                      0xFF2E3230,
                                    ).withOpacity(0.5),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...filteredGoals.map(
                            (goal) => _GoalCard(
                              goal: goal,
                              milestones: state is GoalLoadedState
                                  ? (state.milestones[goal.id] ?? [])
                                  : [],
                            ),
                          ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

                // Floating button
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddGoalSheet(context),
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
      },
    );
  }

  String _areaEmoji(String area) {
    switch (area) {
      case 'Health':
        return '❤️';
      case 'Career':
        return '💼';
      case 'Relationships':
        return '🤝';
      case 'Finance':
        return '💰';
      case 'Personal':
        return '🌱';
      default:
        return '🎯';
    }
  }

  void _showAddGoalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<GoalBloc>(),
        child: const _AddGoalSheet(),
      ),
    );
  }
}

// Goal Card
class _GoalCard extends StatefulWidget {
  final Goal goal;
  final List<Milestone> milestones;

  const _GoalCard({required this.goal, required this.milestones});

  @override
  State<_GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<_GoalCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Title + status + delete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.goal.title,
                  style: GoogleFonts.literata(
                    color: const Color(0xFF2E3230),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.goal.status == 'ON TRACK'
                          ? const Color(0xFF4A7C59).withOpacity(0.1)
                          : widget.goal.status == 'NEEDS FOCUS'
                          ? const Color(0xFF705C30).withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.goal.status,
                      style: GoogleFonts.nunitoSans(
                        color: widget.goal.status == 'ON TRACK'
                            ? const Color(0xFF4A7C59)
                            : widget.goal.status == 'NEEDS FOCUS'
                            ? const Color(0xFF705C30)
                            : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => context.read<GoalBloc>().add(
                      DeleteGoalEvent(goalId: widget.goal.id),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: const Color(0xFF2E3230).withOpacity(0.3),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (widget.goal.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              widget.goal.description,
              style: GoogleFonts.nunitoSans(
                color: const Color(0xFF2E3230).withOpacity(0.5),
                fontSize: 13,
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Momentum
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
              value: widget.goal.momentum,
              backgroundColor: const Color(0xFF4A7C59).withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.goal.momentum >= 0.7
                    ? const Color(0xFF4A7C59)
                    : widget.goal.momentum >= 0.3
                    ? const Color(0xFF705C30)
                    : Colors.red,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(widget.goal.momentum * 100).toInt()}%',
                style: GoogleFonts.nunitoSans(
                  color: widget.goal.momentum >= 0.7
                      ? const Color(0xFF4A7C59)
                      : const Color(0xFF705C30),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                widget.goal.lifeArea,
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Milestones toggle
          GestureDetector(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
              if (_isExpanded) {
                context.read<GoalBloc>().add(
                  LoadMilestonesEvent(goalId: widget.goal.id),
                );
              }
            },
            child: Row(
              children: [
                Text(
                  'MILESTONES',
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF4A7C59),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF4A7C59),
                  size: 16,
                ),
              ],
            ),
          ),

          // Expanded milestones
          if (_isExpanded) ...[
            const SizedBox(height: 12),

            if (widget.milestones.isEmpty)
              Text(
                'No milestones yet. Add one below.',
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.4),
                  fontSize: 13,
                ),
              )
            else
              ...widget.milestones.map(
                (milestone) => _MilestoneTile(
                  milestone: milestone,
                  onToggle: () => context.read<GoalBloc>().add(
                    ToggleMilestoneEvent(
                      milestoneId: milestone.id,
                      goalId: widget.goal.id,
                      isCompleted: !milestone.isCompleted,
                    ),
                  ),
                  onDelete: () => context.read<GoalBloc>().add(
                    DeleteMilestoneEvent(
                      milestoneId: milestone.id,
                      goalId: widget.goal.id,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // Add milestone button
            GestureDetector(
              onTap: () => _showAddMilestoneSheet(context),
              child: Row(
                children: [
                  const Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFF4A7C59),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Add Milestone',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF4A7C59),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddMilestoneSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<GoalBloc>(),
        child: _AddMilestoneSheet(goalId: widget.goal.id),
      ),
    );
  }
}

// Milestone tile
class _MilestoneTile extends StatelessWidget {
  final Milestone milestone;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _MilestoneTile({
    required this.milestone,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: milestone.isCompleted
                    ? const Color(0xFF4A7C59)
                    : Colors.transparent,
                border: Border.all(
                  color: milestone.isCompleted
                      ? const Color(0xFF4A7C59)
                      : const Color(0xFF2E3230).withOpacity(0.2),
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: milestone.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              milestone.title,
              style: GoogleFonts.nunitoSans(
                color: milestone.isCompleted
                    ? const Color(0xFF2E3230).withOpacity(0.4)
                    : const Color(0xFF2E3230),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: milestone.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              color: const Color(0xFF2E3230).withOpacity(0.2),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// Add Milestone Sheet
class _AddMilestoneSheet extends StatefulWidget {
  final String goalId;
  const _AddMilestoneSheet({required this.goalId});

  @override
  State<_AddMilestoneSheet> createState() => _AddMilestoneSheetState();
}

class _AddMilestoneSheetState extends State<_AddMilestoneSheet> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveMilestone() {
    if (_titleController.text.trim().isEmpty) return;
    context.read<GoalBloc>().add(
      AddMilestoneEvent(
        goalId: widget.goalId,
        title: _titleController.text.trim(),
      ),
    );
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
            'Add Milestone',
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
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. Run 2km without stopping',
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
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveMilestone,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Save Milestone',
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

// Add Goal Sheet
class _AddGoalSheet extends StatefulWidget {
  const _AddGoalSheet();

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedArea = 'Health';

  final List<String> _areas = [
    'Health',
    'Career',
    'Relationships',
    'Finance',
    'Personal',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveGoal() {
    if (_titleController.text.trim().isEmpty) return;
    context.read<GoalBloc>().add(
      AddGoalEvent(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        lifeArea: _selectedArea,
      ),
    );
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
            'New Goal',
            style: GoogleFonts.literata(
              color: const Color(0xFF2E3230),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _SheetInputField(
            controller: _titleController,
            label: 'GOAL TITLE',
            hint: 'e.g. Run a 5K by December',
          ),
          const SizedBox(height: 14),
          _SheetInputField(
            controller: _descController,
            label: 'DESCRIPTION',
            hint: 'e.g. Train 3 times a week',
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'LIFE AREA',
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _areas.map((area) {
              final isSelected = _selectedArea == area;
              return GestureDetector(
                onTap: () => setState(() => _selectedArea = area),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4A7C59) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4A7C59)
                          : const Color(0xFF2E3230).withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    area,
                    style: GoogleFonts.nunitoSans(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF2E3230).withOpacity(0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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
              onPressed: _saveGoal,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Save Goal',
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

class _SheetInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;

  const _SheetInputField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            color: const Color(0xFF2E3230).withOpacity(0.4),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
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
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
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
      ],
    );
  }
}
