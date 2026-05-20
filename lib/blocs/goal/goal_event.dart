abstract class GoalEvent {}

class LoadGoalsEvent extends GoalEvent {}

class AddGoalEvent extends GoalEvent {
  final String title;
  final String description;
  final String lifeArea;

  AddGoalEvent({
    required this.title,
    required this.description,
    required this.lifeArea,
  });
}

class DeleteGoalEvent extends GoalEvent {
  final String goalId;
  DeleteGoalEvent({required this.goalId});
}

class LoadMilestonesEvent extends GoalEvent {
  final String goalId;
  LoadMilestonesEvent({required this.goalId});
}

class AddMilestoneEvent extends GoalEvent {
  final String goalId;
  final String title;

  AddMilestoneEvent({required this.goalId, required this.title});
}

class ToggleMilestoneEvent extends GoalEvent {
  final String milestoneId;
  final String goalId;
  final bool isCompleted;

  ToggleMilestoneEvent({
    required this.milestoneId,
    required this.goalId,
    required this.isCompleted,
  });
}

class DeleteMilestoneEvent extends GoalEvent {
  final String milestoneId;
  final String goalId;

  DeleteMilestoneEvent({required this.milestoneId, required this.goalId});
}
