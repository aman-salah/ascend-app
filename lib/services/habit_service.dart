import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import 'supabase_service.dart';

class HabitService {
  static final _client = SupabaseService.client;

  // Get all habits for current user
  static Future<List<Habit>> getHabits() async {
    final userId = _client.auth.currentUser!.id;
    final today = DateTime.now().toIso8601String().split('T')[0];

    // Get habits with today's log status
    final habitsResponse = await _client
        .from('habits')
        .select()
        .eq('user_id', userId)
        .order('created_at');

    final logsResponse = await _client
        .from('habit_logs')
        .select()
        .eq('user_id', userId)
        .eq('completed_date', today);

    final completedToday = (logsResponse as List)
        .map((l) => l['habit_id'] as String)
        .toSet();

    return (habitsResponse as List).map((json) {
      final habit = Habit.fromJson(json);
      habit.isCompleted = completedToday.contains(habit.id);
      return habit;
    }).toList();
  }

  // Add new habit
  static Future<void> addHabit(Habit habit) async {
    await _client.from('habits').insert(habit.toJson());
  }

  // Toggle habit completion
  static Future<void> toggleHabit(String habitId, bool isCompleted) async {
    final userId = _client.auth.currentUser!.id;
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (isCompleted) {
      // Add log for today
      try {
        await _client.from('habit_logs').insert({
          'habit_id': habitId,
          'user_id': userId,
          'completed_date': today,
        });
      } catch (e) {
        // Already logged today — ignore duplicate
        debugPrint('Already logged today: $e');
      }
    } else {
      // Remove log for today
      await _client
          .from('habit_logs')
          .delete()
          .eq('habit_id', habitId)
          .eq('completed_date', today);
    }

    // Recalculate streak
    await _updateStreak(habitId, userId);
  }

  // Calculate and update streak
  static Future<void> _updateStreak(String habitId, String userId) async {
    final logs = await _client
        .from('habit_logs')
        .select('completed_date')
        .eq('habit_id', habitId)
        .eq('user_id', userId)
        .order('completed_date', ascending: false);

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (final log in logs) {
      final logDate = DateTime.parse(log['completed_date']);
      final difference = checkDate.difference(logDate).inDays;

      if (difference <= 1) {
        streak++;
        checkDate = logDate;
      } else {
        break;
      }
    }

    // Update streak in habits table
    await _client.from('habits').update({'streak': streak}).eq('id', habitId);
  }

  // Delete habit
  static Future<void> deleteHabit(String habitId) async {
    await _client.from('habits').delete().eq('id', habitId);
  }

  // Edit habit
  static Future<void> editHabit(
    String habitId,
    String title,
    String emoji,
    String timeOfDay,
  ) async {
    await _client
        .from('habits')
        .update({'title': title, 'emoji': emoji, 'time_of_day': timeOfDay})
        .eq('id', habitId);
  }
}
