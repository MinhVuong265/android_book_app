import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/features/library/data/datasources/library_remote_data_source.dart';

class BookReaderPage extends StatefulWidget {
  final BookEntity book;
  const BookReaderPage({super.key, required this.book});

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  double _fontSize = 16;
  bool _isDarkTheme = false;
  final _libraryDataSource = LibraryRemoteDataSource();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _addToReadingHistory();
    _checkFavorite();
  }

  Future<void> _addToReadingHistory() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await _libraryDataSource.addToReadingHistory(userId, widget.book);
      }
    } catch (e) {
      debugPrint('Error adding to reading history: $e');
    }
  }

  Future<void> _checkFavorite() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final fav = await _libraryDataSource.isFavorite(userId, widget.book.id);
        setState(() {
          _isFavorite = fav;
        });
      }
    } catch (e) {
      debugPrint('Error checking favorite: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để lưu sách yêu thích.'),
        ),
      );
      return;
    }

    try {
      if (_isFavorite) {
        await _libraryDataSource.removeFromFavorites(userId, widget.book.id);
        setState(() => _isFavorite = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gỡ khỏi sách yêu thích')),
        );
      } else {
        await _libraryDataSource.addToFavorites(userId, widget.book);
        setState(() => _isFavorite = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm vào sách yêu thích')),
        );
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _isDarkTheme ? Colors.black : Colors.white;
    final textColor = _isDarkTheme ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        title: Text(
          widget.book.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _isDarkTheme ? Colors.grey[900] : Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.font_download),
            tooltip: "Tăng cỡ chữ",
            onPressed: () {
              setState(() => _fontSize += 2);
            },
          ),
          IconButton(
            icon: const Icon(Icons.font_download_outlined),
            tooltip: "Giảm cỡ chữ",
            onPressed: () {
              setState(() {
                if (_fontSize > 12) _fontSize -= 2;
              });
            },
          ),
          IconButton(
            icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            tooltip: "Chuyển theme",
            onPressed: () {
              setState(() => _isDarkTheme = !_isDarkTheme);
            },
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            tooltip: _isFavorite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích',
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            Center(
              child: Column(
                children: [
                  Text(
                    widget.book.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "By ${widget.book.author}",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Nội dung truyện
            Text(
              widget.book.content,
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.6,
                color: textColor,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),

      // 🔹 Thanh công cụ dưới cùng
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: _isDarkTheme ? Colors.grey[850] : Colors.brown[50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dark theme toggle
            Row(
              children: [
                const Text("Dark Theme"),
                Switch(
                  value: _isDarkTheme,
                  onChanged: (val) {
                    setState(() => _isDarkTheme = val);
                  },
                ),
              ],
            ),

            // Font size adjust
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_fontSize > 12) _fontSize -= 2;
                    });
                  },
                ),
                Text("A", style: TextStyle(fontSize: _fontSize)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() => _fontSize += 2);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
