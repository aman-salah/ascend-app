import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/habit.dart';
import 'supabase_service.dart';

class HabitService {
  static final _client = SupabaseService.client;

  // Get all habits for current user
  static Future<List<Habit>> getHabits() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('habits')
        .select()
        .eq('user_id', userId)
        .order('created_at');

    return (response as List).map((json) => Habit.fromJson(json)).toList();
  }

  // Add new habit
  static Future<void> addHabit(Habit habit) async {
    await _client.from('habits').insert(habit.toJson());
  }

  // Toggle habit completion
  static Future<void> toggleHabit(String habitId, bool isCompleted) async {
    await _client
        .from('habits')
        .update({'is_completed': isCompleted})
        .eq('id', habitId);
  }

  // Delete habit
  static Future<void> deleteHabit(String habitId) async {
    await _client.from('habits').delete().eq('id', habitId);
  }
}
