import '../models/book.dart';
import 'supabase_service.dart';

class BookService {
  static final _client = SupabaseService.client;

  // Get all books
  static Future<List<Book>> getBooks() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('books')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Book.fromJson(json)).toList();
  }

  // Get books by shelf
  static Future<List<Book>> getBooksByShelf(String shelf) async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('books')
        .select()
        .eq('user_id', userId)
        .eq('shelf', shelf)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Book.fromJson(json)).toList();
  }

  // Add new book
  static Future<void> addBook(Book book) async {
    await _client.from('books').insert(book.toJson());
  }

  // Update reading progress
  static Future<void> updateProgress(String bookId, int currentPage) async {
    await _client
        .from('books')
        .update({'current_page': currentPage})
        .eq('id', bookId);
  }

  // Move book to different shelf
  static Future<void> moveToShelf(String bookId, String shelf) async {
    await _client.from('books').update({'shelf': shelf}).eq('id', bookId);
  }

  // Delete book
  static Future<void> deleteBook(String bookId) async {
    await _client.from('books').delete().eq('id', bookId);
  }
}
