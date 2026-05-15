import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/journal_entry.dart';
import '../../services/journal_service.dart';
import '../../services/supabase_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  int _selectedMood = 2;
  final List<String> _energyTags = [
    'restless',
    'foggy',
    'calm',
    'inspired',
    'anxious',
    'energised',
  ];
  final List<String> _selectedTags = [];
  final TextEditingController _writingController = TextEditingController();
  int _selectedMode = 0;
  bool _isSaving = false;
  bool _isLoading = true;
  bool _isFocusMode = false;
  List<JournalEntry> _entries = [];

  final List<Map<String, String>> _writingModes = [
    {
      'emoji': '🌅',
      'title': 'Morning Pages',
      'subtitle': 'Unfiltered stream of consciousness for clarity.',
    },
    {
      'emoji': '🌙',
      'title': 'Evening Reflection',
      'subtitle': 'Review your wins and learnings from the day.',
    },
    {
      'emoji': '✨',
      'title': 'Free Write',
      'subtitle': 'No prompt, just you and the blank canvas.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() => _isLoading = true);
    try {
      final entries = await JournalService.getEntries();
      setState(() => _entries = entries);
    } catch (e) {
      debugPrint('Error loading entries: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveEntry() async {
    if (_writingController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final wordCount = _writingController.text.trim().split(' ').length;

      final entry = JournalEntry(
        id: '',
        userId: SupabaseService.client.auth.currentUser!.id,
        writingMode: _writingModes[_selectedMode]['title']!,
        content: _writingController.text.trim(),
        mood: _selectedMood,
        energyTags: _selectedTags,
        wordCount: wordCount,
        createdAt: DateTime.now(),
      );

      await JournalService.saveEntry(entry);

      // Clear form
      setState(() {
        _writingController.clear();
        _selectedMood = 2;
        _selectedTags.clear();
      });

      // Reload entries
      await _loadEntries();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Entry saved! 🌱',
              style: GoogleFonts.nunitoSans(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF4A7C59),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving entry: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteEntry(String id) async {
    try {
      await JournalService.deleteEntry(id);
      await _loadEntries();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Entry deleted',
              style: GoogleFonts.nunitoSans(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF4A7C59),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error deleting entry: $e');
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  void dispose() {
    _writingController.dispose();
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
              if (!_isFocusMode) ...[
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
                "Today's Writing",
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Writing mode cards
              ..._writingModes.asMap().entries.map((entry) {
                final index = entry.key;
                final mode = entry.value;
                final isSelected = _selectedMode == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMode = index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4A7C59).withOpacity(0.08)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4A7C59).withOpacity(0.4)
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
                    child: Row(
                      children: [
                        Text(
                          mode['emoji']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mode['title']!,
                                style: GoogleFonts.literata(
                                  color: const Color(0xFF2E3230),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                mode['subtitle']!,
                                style: GoogleFonts.nunitoSans(
                                  color: const Color(
                                    0xFF2E3230,
                                  ).withOpacity(0.5),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF4A7C59),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),
              ],

              // Date and Focus Mode Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(DateTime.now()),
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF2E3230).withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isFocusMode = !_isFocusMode),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isFocusMode ? const Color(0xFF4A7C59) : const Color(0xFF4A7C59).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isFocusMode ? Icons.fullscreen_exit : Icons.fullscreen,
                            size: 16,
                            color: _isFocusMode ? Colors.white : const Color(0xFF4A7C59),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isFocusMode ? 'Exit Focus' : 'Focus Mode',
                            style: GoogleFonts.nunitoSans(
                              color: _isFocusMode ? Colors.white : const Color(0xFF4A7C59),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Writing area
              Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _writingController,
                      maxLines: _isFocusMode ? null : 6,
                      minLines: _isFocusMode ? 15 : 6,
                      onChanged: (val) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "What's on your mind today? Start writing...",
                        hintStyle: GoogleFonts.literata(
                          color: const Color(0xFF2E3230).withOpacity(0.3),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.literata(
                        color: const Color(0xFF2E3230),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    // Word count
                    Text(
                      '${_writingController.text.trim().isEmpty ? 0 : _writingController.text.trim().split(' ').length} words',
                      style: GoogleFonts.nunitoSans(
                        color: const Color(0xFF2E3230).withOpacity(0.3),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (!_isFocusMode) ...[
                // Mood check
                Text(
                'How are you feeling?',
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MoodEmoji(
                    emoji: '😔',
                    index: 0,
                    selected: _selectedMood,
                    onTap: (i) => setState(() => _selectedMood = i),
                  ),
                  _MoodEmoji(
                    emoji: '😕',
                    index: 1,
                    selected: _selectedMood,
                    onTap: (i) => setState(() => _selectedMood = i),
                  ),
                  _MoodEmoji(
                    emoji: '😊',
                    index: 2,
                    selected: _selectedMood,
                    onTap: (i) => setState(() => _selectedMood = i),
                  ),
                  _MoodEmoji(
                    emoji: '😄',
                    index: 3,
                    selected: _selectedMood,
                    onTap: (i) => setState(() => _selectedMood = i),
                  ),
                  _MoodEmoji(
                    emoji: '🤩',
                    index: 4,
                    selected: _selectedMood,
                    onTap: (i) => setState(() => _selectedMood = i),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                'ENERGY MARKERS',
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
                children: _energyTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedTags.remove(tag);
                        } else {
                          _selectedTags.add(tag);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF4A7C59).withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4A7C59).withOpacity(0.4)
                              : const Color(0xFF2E3230).withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.nunitoSans(
                          color: isSelected
                              ? const Color(0xFF4A7C59)
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
              ],

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7C59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Save Entry',
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              if (!_isFocusMode) ...[
                const SizedBox(height: 24),

                // Recent history
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent History',
                    style: GoogleFonts.literata(
                      color: const Color(0xFF2E3230),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'View All →',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF4A7C59),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Loading or entries
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4A7C59)),
                )
              else if (_entries.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text('📓', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 12),
                      Text(
                        'No entries yet',
                        style: GoogleFonts.literata(
                          color: const Color(0xFF2E3230),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Write your first entry above',
                        style: GoogleFonts.nunitoSans(
                          color: const Color(0xFF2E3230).withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._entries
                    .take(5)
                    .map(
                      (entry) => _HistoryCard(
                        entry: entry,
                        formatDate: _formatDate,
                        onDelete: () => _deleteEntry(entry.id),
                      ),
                    ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodEmoji extends StatelessWidget {
  final String emoji;
  final int index;
  final int selected;
  final Function(int) onTap;

  const _MoodEmoji({
    required this.emoji,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4A7C59).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A7C59).withOpacity(0.4)
                : Colors.transparent,
          ),
        ),
        child: Text(emoji, style: TextStyle(fontSize: isSelected ? 32 : 26)),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final JournalEntry entry;
  final String Function(DateTime) formatDate;
  final VoidCallback onDelete;

  const _HistoryCard({
    required this.entry,
    required this.formatDate,
    required this.onDelete,
  });

  String get _moodEmoji {
    const emojis = ['😔', '😕', '😊', '😄', '🤩'];
    return emojis[entry.mood.clamp(0, 4)];
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDate(entry.createdAt),
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              Row(
                children: [
                  Text(_moodEmoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Entry'),
                          content: const Text('Are you sure you want to delete this journal entry?'),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.nunitoSans(
                                  color: const Color(0xFF2E3230),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onDelete();
                              },
                              child: Text(
                                'Delete',
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: const Color(0xFF2E3230).withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            entry.writingMode,
            style: GoogleFonts.literata(
              color: const Color(0xFF2E3230),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.content,
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.5),
              fontSize: 12,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (entry.energyTags.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A7C59).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    entry.energyTags.first.toUpperCase(),
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF4A7C59),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                '${entry.wordCount} WORDS',
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
