import 'package:ascend/models/milestone.dart';
import 'package:ascend/services/milestone_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/goal.dart';
import '../../services/goal_service.dart';
import '../../services/supabase_service.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Goal> _goals = [];
  bool _isLoading = true;
  String _selectedArea = 'All';
  final List<String> _lifeAreas = [
    'All',
    'Health',
    'Career',
    'Relationships',
    'Finance',
    'Personal',
  ];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    setState(() => _isLoading = true);
    try {
      final goals = await GoalService.getGoals();
      setState(() => _goals = goals);
    } catch (e) {
      debugPrint('Error loading goals: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Goal> get _filteredGoals {
    if (_selectedArea == 'All') return _goals;
    return _goals.where((g) => g.lifeArea == _selectedArea).toList();
  }

  Map<String, int> get _lifeAreaCounts {
    final counts = <String, int>{};
    for (final goal in _goals) {
      counts[goal.lifeArea] = (counts[goal.lifeArea] ?? 0) + 1;
    }
    return counts;
  }

  void _showAddGoalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddGoalSheet(onGoalAdded: _loadGoals),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadGoals,
              color: const Color(0xFF4A7C59),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
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
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Life Areas',
                        style: GoogleFonts.literata(
                          color: const Color(0xFF2E3230),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Cultivate balance across your core foundations.',
                        style: GoogleFonts.nunitoSans(
                          color: const Color(0xFF2E3230).withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Life area cards
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      clipBehavior: Clip.none,
                      child: Row(
                        children:
                            [
                              'Health',
                              'Career',
                              'Relationships',
                              'Finance',
                              'Personal',
                            ].map((area) {
                              final count = _lifeAreaCounts[area] ?? 0;
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
                                        style: const TextStyle(fontSize: 28),
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

                    // Goals list
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4A7C59),
                        ),
                      )
                    else if (_filteredGoals.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text('🎯', style: TextStyle(fontSize: 40)),
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
                                  color: const Color(0xFF2E3230).withOpacity(0.5),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._filteredGoals.map(
                        (goal) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _GoalCard(goal: goal, onDeleted: _loadGoals),
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
                onPressed: _showAddGoalSheet,
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
}

// Goal Card
class _GoalCard extends StatefulWidget {
  final Goal goal;
  final VoidCallback onDeleted;

  const _GoalCard({required this.goal, required this.onDeleted});

  @override
  State<_GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<_GoalCard> {
  List<Milestone> _milestones = [];
  bool _isExpanded = false;
  bool _isLoading = false;

  Future<void> _loadMilestones() async {
    setState(() => _isLoading = true);
    try {
      final milestones = await MilestoneService.getMilestones(widget.goal.id);
      setState(() => _milestones = milestones);
    } catch (e) {
      debugPrint('Error loading milestones: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAddMilestoneSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddMilestoneSheet(
        goalId: widget.goal.id,
        onMilestoneAdded: () async {
          await _loadMilestones();
          widget.onDeleted();
        },
      ),
    );
  }

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
                    onTap: () async {
                      await GoalService.deleteGoal(widget.goal.id);
                      widget.onDeleted();
                    },
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
            onTap: () async {
              setState(() => _isExpanded = !_isExpanded);
              if (_isExpanded && _milestones.isEmpty) {
                await _loadMilestones();
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

            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4A7C59),
                  strokeWidth: 2,
                ),
              )
            else if (_milestones.isEmpty)
              Text(
                'No milestones yet. Add one below.',
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.4),
                  fontSize: 13,
                ),
              )
            else
              ..._milestones.map(
                (milestone) => _MilestoneTile(
                  milestone: milestone,
                  onToggle: () async {
                    await MilestoneService.toggleMilestone(
                      milestone.id,
                      !milestone.isCompleted,
                      widget.goal.id,
                    );
                    await _loadMilestones();
                    widget.onDeleted();
                  },
                  onDelete: () async {
                    await MilestoneService.deleteMilestone(
                      milestone.id,
                      widget.goal.id,
                    );
                    await _loadMilestones();
                    widget.onDeleted();
                  },
                ),
              ),

            const SizedBox(height: 10),

            // Add milestone button
            GestureDetector(
              onTap: _showAddMilestoneSheet,
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
  final VoidCallback onMilestoneAdded;

  const _AddMilestoneSheet({
    required this.goalId,
    required this.onMilestoneAdded,
  });

  @override
  State<_AddMilestoneSheet> createState() => _AddMilestoneSheetState();
}

class _AddMilestoneSheetState extends State<_AddMilestoneSheet> {
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveMilestone() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final milestone = Milestone(
        id: '',
        goalId: widget.goalId,
        userId: SupabaseService.client.auth.currentUser!.id,
        title: _titleController.text.trim(),
        createdAt: DateTime.now(),
      );

      await MilestoneService.addMilestone(milestone);
      if (mounted) Navigator.pop(context);
      widget.onMilestoneAdded();
    } catch (e) {
      debugPrint('Error saving milestone: $e');
    } finally {
      setState(() => _isLoading = false);
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
              onPressed: _isLoading ? null : _saveMilestone,
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
  final VoidCallback onGoalAdded;

  const _AddGoalSheet({required this.onGoalAdded});

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedArea = 'Health';
  bool _isLoading = false;

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

  Future<void> _saveGoal() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final goal = Goal(
        id: '',
        userId: SupabaseService.client.auth.currentUser!.id,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        lifeArea: _selectedArea,
        momentum: 0.0,
        status: 'ON TRACK',
        createdAt: DateTime.now(),
      );

      await GoalService.addGoal(goal);
      if (mounted) Navigator.pop(context);
      widget.onGoalAdded();
    } catch (e) {
      debugPrint('Error saving goal: $e');
    } finally {
      setState(() => _isLoading = false);
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

          // Title
          _SheetInputField(
            controller: _titleController,
            label: 'GOAL TITLE',
            hint: 'e.g. Run a 5K by December',
          ),

          const SizedBox(height: 14),

          // Description
          _SheetInputField(
            controller: _descController,
            label: 'DESCRIPTION',
            hint: 'e.g. Train 3 times a week',
            maxLines: 3,
          ),

          const SizedBox(height: 20),

          // Life area
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
              onPressed: _isLoading ? null : _saveGoal,
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
