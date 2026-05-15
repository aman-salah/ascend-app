class JournalEntry {
  final String id;
  final String userId;
  final String writingMode;
  final String content;
  final int mood;
  final List<String> energyTags;
  final int wordCount;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.writingMode,
    required this.content,
    required this.mood,
    required this.energyTags,
    required this.wordCount,
    required this.createdAt,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      userId: json['user_id'],
      writingMode: json['writing_mode'] ?? 'Morning Pages',
      content: json['content'] ?? '',
      mood: json['mood'] ?? 2,
      energyTags: List<String>.from(json['energy_tags'] ?? []),
      wordCount: json['word_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'writing_mode': writingMode,
      'content': content,
      'mood': mood,
      'energy_tags': energyTags,
      'word_count': wordCount,
    };
  }
}
