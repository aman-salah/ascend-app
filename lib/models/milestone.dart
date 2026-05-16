class Milestone {
  final String id;
  final String goalId;
  final String userId;
  final String title;
  bool isCompleted;
  final DateTime createdAt;

  Milestone({
    required this.id,
    required this.goalId,
    required this.userId,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'],
      goalId: json['goal_id'],
      userId: json['user_id'],
      title: json['title'],
      isCompleted: json['is_completed'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal_id': goalId,
      'user_id': userId,
      'title': title,
      'is_completed': isCompleted,
    };
  }
}
