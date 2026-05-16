import '../models/milestone.dart';
import 'supabase_service.dart';
import 'goal_service.dart';

class MilestoneService {
  static final _client = SupabaseService.client;

  // Get milestones for a goal
  static Future<List<Milestone>> getMilestones(String goalId) async {
    final response = await _client
        .from('milestones')
        .select()
        .eq('goal_id', goalId)
        .order('created_at');

    return (response as List).map((json) => Milestone.fromJson(json)).toList();
  }

  // Add milestone
  static Future<void> addMilestone(Milestone milestone) async {
    await _client.from('milestones').insert(milestone.toJson());
    await _updateGoalMomentum(milestone.goalId);
  }

  // Toggle milestone completion
  static Future<void> toggleMilestone(
    String milestoneId,
    bool isCompleted,
    String goalId,
  ) async {
    await _client
        .from('milestones')
        .update({'is_completed': isCompleted})
        .eq('id', milestoneId);
    await _updateGoalMomentum(goalId);
  }

  // Delete milestone
  static Future<void> deleteMilestone(String milestoneId, String goalId) async {
    await _client.from('milestones').delete().eq('id', milestoneId);
    await _updateGoalMomentum(goalId);
  }

  // Auto update goal momentum based on milestones
  static Future<void> _updateGoalMomentum(String goalId) async {
    final milestones = await getMilestones(goalId);
    if (milestones.isEmpty) return;

    final completed = milestones.where((m) => m.isCompleted).length;
    final momentum = completed / milestones.length;

    // Update status based on momentum
    String status;
    if (momentum >= 0.7) {
      status = 'ON TRACK';
    } else if (momentum >= 0.3) {
      status = 'NEEDS FOCUS';
    } else {
      status = 'STALLED';
    }

    await GoalService.updateMomentum(goalId, momentum);
    await GoalService.updateStatus(goalId, status);
  }
}
