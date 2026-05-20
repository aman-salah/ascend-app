import '../../models/goal.dart';
import '../../models/milestone.dart';

abstract class GoalState {}

class GoalInitialState extends GoalState {}

class GoalLoadingState extends GoalState {}

class GoalLoadedState extends GoalState {
  final List<Goal> goals;
  final Map<String, List<Milestone>> milestones;

  GoalLoadedState({required this.goals, this.milestones = const {}});
}

class GoalErrorState extends GoalState {
  final String message;
  GoalErrorState({required this.message});
}
