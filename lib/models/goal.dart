class Goal {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String lifeArea;
  final double momentum;
  final String status;
  final DateTime createdAt;

  Goal({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.lifeArea,
    required this.momentum,
    required this.status,
    required this.createdAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'] ?? '',
      lifeArea: json['life_area'] ?? 'Health',
      momentum: (json['momentum'] ?? 0).toDouble(),
      status: json['status'] ?? 'ON TRACK',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'life_area': lifeArea,
      'momentum': momentum,
      'status': status,
    };
  }
}
