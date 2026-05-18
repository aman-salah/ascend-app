class HabitLog {
  final String id;
  final String habitId;
  final String userId;
  final DateTime completedDate;

  HabitLog({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.completedDate,
  });

  factory HabitLog.fromJson(Map<String, dynamic> json) {
    return HabitLog(
      id: json['id'],
      habitId: json['habit_id'],
      userId: json['user_id'],
      completedDate: DateTime.parse(json['completed_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'habit_id': habitId,
      'user_id': userId,
      'completed_date': completedDate.toIso8601String().split('T')[0],
    };
  }
}
