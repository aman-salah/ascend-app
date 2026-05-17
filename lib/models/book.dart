class Book {
  final String id;
  final String userId;
  final String title;
  final String author;
  final int totalPages;
  int currentPage;
  final String shelf;
  final DateTime createdAt;

  Book({
    required this.id,
    required this.userId,
    required this.title,
    required this.author,
    required this.totalPages,
    required this.currentPage,
    required this.shelf,
    required this.createdAt,
  });

  double get progress => totalPages > 0 ? currentPage / totalPages : 0.0;

  String get progressPercent => '${(progress * 100).toInt()}%';

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      author: json['author'] ?? '',
      totalPages: json['total_pages'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      shelf: json['shelf'] ?? 'Currently Reading',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'author': author,
      'total_pages': totalPages,
      'current_page': currentPage,
      'shelf': shelf,
    };
  }
}
