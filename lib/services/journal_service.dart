import '../models/journal_entry.dart';
import 'supabase_service.dart';

class JournalService {
  static final _client = SupabaseService.client;

  // Get all journal entries
  static Future<List<JournalEntry>> getEntries() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('journal_entries')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => JournalEntry.fromJson(json))
        .toList();
  }

  // Save journal entry
  static Future<void> saveEntry(JournalEntry entry) async {
    await _client.from('journal_entries').insert(entry.toJson());
  }

  // Delete journal entry
  static Future<void> deleteEntry(String entryId) async {
    await _client.from('journal_entries').delete().eq('id', entryId);
  }
}
