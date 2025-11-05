class BookEntity {
  final String id;
  final String title;
  final String author;
  final String description;
  final String publisher;
  final String coverImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.publisher,
    required this.coverImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}
