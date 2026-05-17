import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';
import '../../services/supabase_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Currently Reading', 'Want to Read', 'Finished'];
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    try {
      final books = await BookService.getBooks();
      setState(() => _books = books);
    } catch (e) {
      debugPrint('Error loading books: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Book> get _filteredBooks {
    return _books.where((b) => b.shelf == _tabs[_selectedTab]).toList();
  }

  List<Book> get _currentlyReading {
    return _books.where((b) => b.shelf == 'Currently Reading').toList();
  }

  void _showAddBookSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddBookSheet(onBookAdded: _loadBooks),
    );
  }

  void _showLogProgressSheet(Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _LogProgressSheet(book: book, onProgressUpdated: _loadBooks),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadBooks,
              color: const Color(0xFF4A7C59),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
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
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Library',
                        style: GoogleFonts.literata(
                          color: const Color(0xFF2E3230),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tab selector
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      clipBehavior: Clip.none,
                      child: Row(
                        children: _tabs.asMap().entries.map((entry) {
                          final isSelected = _selectedTab == entry.key;
                          final count = _books
                              .where((b) => b.shelf == entry.value)
                              .length;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedTab = entry.key),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF4A7C59)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF2E3230,
                                    ).withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                '${entry.value} ($count)',
                                style: GoogleFonts.nunitoSans(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(
                                          0xFF2E3230,
                                        ).withOpacity(0.5),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Currently reading featured card
                    if (_selectedTab == 0 && _currentlyReading.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _FeaturedBookCard(
                          book: _currentlyReading.first,
                          onLogProgress: () =>
                              _showLogProgressSheet(_currentlyReading.first),
                          onDelete: () async {
                            await BookService.deleteBook(
                              _currentlyReading.first.id,
                            );
                            _loadBooks();
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Books list
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4A7C59),
                        ),
                      )
                    else if (_filteredBooks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text('📚', style: TextStyle(fontSize: 40)),
                              const SizedBox(height: 12),
                              Text(
                                _selectedTab == 0
                                    ? 'Not reading anything yet'
                                    : _selectedTab == 1
                                    ? 'No books in your wishlist'
                                    : 'No finished books yet',
                                style: GoogleFonts.literata(
                                  color: const Color(0xFF2E3230),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap + Add Book to get started',
                                style: GoogleFonts.nunitoSans(
                                  color: const Color(0xFF2E3230).withOpacity(0.5),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._filteredBooks
                          .skip(
                            _selectedTab == 0 && _currentlyReading.isNotEmpty
                                ? 1
                                : 0,
                          )
                          .map(
                            (book) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: _BookTile(
                                book: book,
                                onLogProgress: () => _showLogProgressSheet(book),
                                onDelete: () async {
                                  await BookService.deleteBook(book.id);
                                  _loadBooks();
                                },
                                onMoveShelf: (shelf) async {
                                  await BookService.moveToShelf(book.id, shelf);
                                  _loadBooks();
                                },
                              ),
                            ),
                          ),

                    // Reading stats
                    if (_books.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _ReadingStats(books: _books),
                      ),
                    ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Floating Add Book button
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton.icon(
                onPressed: _showAddBookSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7C59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: Text(
                  'Add Book',
                  style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Featured book card for currently reading
class _FeaturedBookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onLogProgress;
  final VoidCallback onDelete;

  const _FeaturedBookCard({
    required this.book,
    required this.onLogProgress,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E3230).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENTLY READING',
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.4),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7C59),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    book.title.isNotEmpty ? book.title[0].toUpperCase() : '📖',
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: GoogleFonts.literata(
                        color: const Color(0xFF2E3230),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by ${book.author}',
                      style: GoogleFonts.nunitoSans(
                        color: const Color(0xFF2E3230).withOpacity(0.5),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${book.progressPercent} Completed',
                          style: GoogleFonts.nunitoSans(
                            color: const Color(0xFF4A7C59),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${book.currentPage} / ${book.totalPages}',
                          style: GoogleFonts.nunitoSans(
                            color: const Color(0xFF2E3230).withOpacity(0.4),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: book.progress,
                        backgroundColor: const Color(
                          0xFF4A7C59,
                        ).withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4A7C59),
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onLogProgress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7C59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text(
                    'Log Progress',
                    style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.withOpacity(0.6),
                    size: 16,
                  ),
                  label: Text(
                    'Remove',
                    style: GoogleFonts.nunitoSans(
                      color: Colors.red.withOpacity(0.6),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Book tile for list
class _BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onLogProgress;
  final VoidCallback onDelete;
  final Function(String) onMoveShelf;

  const _BookTile({
    required this.book,
    required this.onLogProgress,
    required this.onDelete,
    required this.onMoveShelf,
  });

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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF4A7C59).withOpacity(0.8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                book.title.isNotEmpty ? book.title[0].toUpperCase() : '📖',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: GoogleFonts.literata(
                    color: const Color(0xFF2E3230),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  book.author,
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF2E3230).withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                if (book.shelf == 'Currently Reading') ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: book.progress,
                      backgroundColor: const Color(0xFF4A7C59).withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4A7C59),
                      ),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${book.progressPercent} — ${book.currentPage}/${book.totalPages} pages',
                    style: GoogleFonts.nunitoSans(
                      color: const Color(0xFF4A7C59),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: const Color(0xFF2E3230).withOpacity(0.4),
              size: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              if (book.shelf != 'Currently Reading')
                const PopupMenuItem(
                  value: 'Currently Reading',
                  child: Text('Move to Currently Reading'),
                ),
              if (book.shelf != 'Want to Read')
                const PopupMenuItem(
                  value: 'Want to Read',
                  child: Text('Move to Want to Read'),
                ),
              if (book.shelf != 'Finished')
                const PopupMenuItem(
                  value: 'Finished',
                  child: Text('Mark as Finished'),
                ),
              if (book.shelf == 'Currently Reading')
                const PopupMenuItem(value: 'log', child: Text('Log Progress')),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                onDelete();
              } else if (value == 'log') {
                onLogProgress();
              } else {
                onMoveShelf(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

// Reading stats
class _ReadingStats extends StatelessWidget {
  final List<Book> books;

  const _ReadingStats({required this.books});

  @override
  Widget build(BuildContext context) {
    final finished = books.where((b) => b.shelf == 'Finished').length;
    final currentlyReading = books
        .where((b) => b.shelf == 'Currently Reading')
        .length;
    final totalPages = books.fold<int>(0, (sum, b) => sum + b.currentPage);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E3230).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                'Reading Stats',
                style: GoogleFonts.literata(
                  color: const Color(0xFF2E3230),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(value: '$finished', label: 'BOOKS\nFINISHED'),
              _StatDivider(),
              _StatItem(
                value: '$currentlyReading',
                label: 'CURRENTLY\nREADING',
              ),
              _StatDivider(),
              _StatItem(value: '$totalPages', label: 'TOTAL\nPAGES READ'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.literata(
            color: const Color(0xFF4A7C59),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(
            color: const Color(0xFF2E3230).withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: const Color(0xFF2E3230).withOpacity(0.1),
    );
  }
}

// Log Progress Sheet
class _LogProgressSheet extends StatefulWidget {
  final Book book;
  final VoidCallback onProgressUpdated;

  const _LogProgressSheet({
    required this.book,
    required this.onProgressUpdated,
  });

  @override
  State<_LogProgressSheet> createState() => _LogProgressSheetState();
}

class _LogProgressSheetState extends State<_LogProgressSheet> {
  late TextEditingController _pageController;
  late double _progress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = TextEditingController(
      text: widget.book.currentPage.toString(),
    );
    _progress = widget.book.progress;
  }

  void _updateProgress(String value) {
    final int? page = int.tryParse(value);
    if (page != null && page <= widget.book.totalPages) {
      setState(() {
        _progress = page / widget.book.totalPages;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAF6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF2E3230).withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Log Reading Progress',
            style: GoogleFonts.literata(
              color: const Color(0xFF2E3230),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.book.title,
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _progress,
                        strokeWidth: 5,
                        backgroundColor: const Color(
                          0xFF4A7C59,
                        ).withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4A7C59),
                        ),
                      ),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: GoogleFonts.literata(
                          color: const Color(0xFF4A7C59),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_progress * widget.book.totalPages).toInt()} of ${widget.book.totalPages} pages',
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF2E3230).withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'CURRENT PAGE',
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
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
              controller: _pageController,
              keyboardType: TextInputType.number,
              onChanged: _updateProgress,
              decoration: InputDecoration(
                hintText: 'Enter current page',
                hintStyle: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.3),
                  fontSize: 14,
                ),
                suffixText: '/ ${widget.book.totalPages}',
                suffixStyle: GoogleFonts.nunitoSans(
                  color: const Color(0xFF2E3230).withOpacity(0.4),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: GoogleFonts.nunitoSans(
                color: const Color(0xFF2E3230),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      final page =
                          int.tryParse(_pageController.text) ??
                          widget.book.currentPage;
                      await BookService.updateProgress(widget.book.id, page);
                      
                      if (page >= widget.book.totalPages && widget.book.shelf != 'Finished') {
                        await BookService.moveToShelf(widget.book.id, 'Finished');
                      }
                      
                      widget.onProgressUpdated();
                      if (mounted) Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Save Progress',
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// Add Book Sheet
class _AddBookSheet extends StatefulWidget {
  final VoidCallback onBookAdded;

  const _AddBookSheet({required this.onBookAdded});

  @override
  State<_AddBookSheet> createState() => _AddBookSheetState();
}

class _AddBookSheetState extends State<_AddBookSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController();
  int _selectedShelf = 0;
  bool _isLoading = false;
  final List<String> _shelves = [
    'Currently Reading',
    'Want to Read',
    'Finished',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final book = Book(
        id: '',
        userId: SupabaseService.client.auth.currentUser!.id,
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        totalPages: int.tryParse(_pagesController.text) ?? 0,
        currentPage: 0,
        shelf: _shelves[_selectedShelf],
        createdAt: DateTime.now(),
      );

      await BookService.addBook(book);
      if (mounted) Navigator.pop(context);
      widget.onBookAdded();
    } catch (e) {
      debugPrint('Error saving book: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAF6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF2E3230).withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Add New Book',
            style: GoogleFonts.literata(
              color: const Color(0xFF2E3230),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _SheetInput(
            controller: _titleController,
            label: 'BOOK TITLE',
            hint: 'e.g. Atomic Habits',
          ),
          const SizedBox(height: 14),
          _SheetInput(
            controller: _authorController,
            label: 'AUTHOR',
            hint: 'e.g. James Clear',
          ),
          const SizedBox(height: 14),
          _SheetInput(
            controller: _pagesController,
            label: 'TOTAL PAGES',
            hint: 'e.g. 320',
            isNumber: true,
          ),
          const SizedBox(height: 20),
          Text(
            'ADD TO SHELF',
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230).withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: _shelves.asMap().entries.map((entry) {
              final isSelected = _selectedShelf == entry.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedShelf = entry.key),
                  child: Container(
                    margin: EdgeInsets.only(right: entry.key < 2 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4A7C59)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4A7C59)
                            : const Color(0xFF2E3230).withOpacity(0.1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunitoSans(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF2E3230).withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveBook,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Add to Library',
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _SheetInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isNumber;

  const _SheetInput({
    required this.controller,
    required this.label,
    required this.hint,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            color: const Color(0xFF2E3230).withOpacity(0.4),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Container(
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
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.nunitoSans(
                color: const Color(0xFF2E3230).withOpacity(0.3),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: GoogleFonts.nunitoSans(
              color: const Color(0xFF2E3230),
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
