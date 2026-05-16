import '../models/goal.dart';
import 'supabase_service.dart';

class GoalService {
  static final _client = SupabaseService.client;

  // Get all goals
  static Future<List<Goal>> getGoals() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('goals')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Goal.fromJson(json)).toList();
  }

  // Add new goal
  static Future<void> addGoal(Goal goal) async {
    await _client.from('goals').insert(goal.toJson());
  }

  // Update goal momentum
  static Future<void> updateMomentum(String goalId, double momentum) async {
    await _client.from('goals').update({'momentum': momentum}).eq('id', goalId);
  }

  // Update goal status
  static Future<void> updateStatus(String goalId, String status) async {
    await _client.from('goals').update({'status': status}).eq('id', goalId);
  }

  // Delete goal
  static Future<void> deleteGoal(String goalId) async {
    await _client.from('goals').delete().eq('id', goalId);
  }
}
