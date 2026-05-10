import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  int _selectedMood = 2;
  final List<String> _energyTags = ['restless', 'foggy', 'calm'];
  final List<String> _selectedTags = ['calm'];
  final TextEditingController _writingController = TextEditingController();
  int _selectedMode = 0;

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

  final List<Map<String, String>> _recentEntries = [
    {
      'date': 'OCT 24',
      'title': 'Morning Clarity Sessions',
      'preview':
          'The forest trail was particularly quiet today. I felt a profound sense...',
      'mood': 'INSPIRED',
      'words': '842 WORDS',
    },
    {
      'date': 'OCT 22',
      'title': 'Evening Reflections',
      'preview':
          'Grateful for the feedback on the project today. It wasn\'t easy to hear.',
      'mood': 'CALM',
      'words': '319 WORDS',
    },
  ];

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

              // Title
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

              // Date + Focus mode
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Wednesday, Oct 25',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF2E3230).withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A7C59).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 14,
                          color: Color(0xFF4A7C59),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Focus Mode',
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
                child: TextField(
                  controller: _writingController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText:
                        "What's on your mind today? Start writing your reflection here...",
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
              ),

              const SizedBox(height: 20),

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

              // Mood emojis
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

              // Energy markers
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

              const SizedBox(height: 20),

              // Motivation card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7C59).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4A7C59).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keep going, Alex! 🌱',
                      style: GoogleFonts.literata(
                        color: const Color(0xFF2E3230),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "You've journaled 5 days straight. Self-reflection is the soil of personal growth.",
                      style: GoogleFonts.nunitoSans(
                        color: const Color(0xFF2E3230).withOpacity(0.6),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"The goal is not perfection, but the courage to keep coming back."',
                      style: GoogleFonts.literata(
                        color: const Color(0xFF4A7C59),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7C59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Save Entry',
                    style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

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
                    'View Archive →',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF4A7C59),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ..._recentEntries.map((entry) => _HistoryCard(entry: entry)),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Mood emoji widget
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

// History card widget
class _HistoryCard extends StatelessWidget {
  final Map<String, String> entry;

  const _HistoryCard({required this.entry});

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
                entry['date']!,
                style: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            entry['title']!,
            style: GoogleFonts.literata(
              color: const Color(0xFF2E3230),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry['preview']!,
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
                  entry['mood']!,
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF4A7C59),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entry['words']!,
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
