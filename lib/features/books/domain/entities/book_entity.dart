class BookEntity {
  final String id;
  final String title;
  final String author;
  final String? description;
  final String coverImageUrl;
  final String? publisher;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookEntity({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    required this.coverImageUrl,
    this.publisher,
    required this.createdAt,
    required this.updatedAt,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'publisher': publisher,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory BookEntity.fromMap(Map<String, dynamic> map) {
    return BookEntity(
      id: map['id'],
      title: map['title'],
      author: map['author'] ?? 'Đang cập nhật',
      description: map['description'] ?? 'Chưa có mô tả',
      coverImageUrl: map['coverImageUrl'] ?? 'https://example.com/default-cover.jpg',
      publisher: map['publisher'] ?? 'Đang cập nhật',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

