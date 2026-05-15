class Habit {
  final String id;
  final String userId;
  final String title;
  final String emoji;
  final String timeOfDay;
  bool isCompleted;
  int streak;

  Habit({
    required this.id,
    required this.userId,
    required this.title,
    required this.emoji,
    required this.timeOfDay,
    this.isCompleted = false,
    this.streak = 0,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      emoji: json['emoji'] ?? '✅',
      timeOfDay: json['time_of_day'] ?? 'morning',
      isCompleted: json['is_completed'] ?? false,
      streak: json['streak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'emoji': emoji,
      'time_of_day': timeOfDay,
      'is_completed': isCompleted,
      'streak': streak,
    };
  }
}
