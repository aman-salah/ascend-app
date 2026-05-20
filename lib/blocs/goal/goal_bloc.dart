import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/goal.dart';
import '../../models/milestone.dart';
import '../../services/goal_service.dart';
import '../../services/milestone_service.dart';
import '../../services/supabase_service.dart';
import 'goal_event.dart';
import 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc() : super(GoalInitialState()) {
    on<LoadGoalsEvent>(_onLoadGoals);
    on<AddGoalEvent>(_onAddGoal);
    on<DeleteGoalEvent>(_onDeleteGoal);
    on<LoadMilestonesEvent>(_onLoadMilestones);
    on<AddMilestoneEvent>(_onAddMilestone);
    on<ToggleMilestoneEvent>(_onToggleMilestone);
    on<DeleteMilestoneEvent>(_onDeleteMilestone);
  }

  Future<void> _onLoadGoals(
    LoadGoalsEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(GoalLoadingState());
    try {
      final goals = await GoalService.getGoals();
      emit(GoalLoadedState(goals: goals));
    } catch (e) {
      emit(GoalErrorState(message: e.toString()));
    }
  }

  Future<void> _onAddGoal(AddGoalEvent event, Emitter<GoalState> emit) async {
    try {
      final goal = Goal(
        id: '',
        userId: SupabaseService.client.auth.currentUser!.id,
        title: event.title,
        description: event.description,
        lifeArea: event.lifeArea,
        momentum: 0.0,
        status: 'ON TRACK',
        createdAt: DateTime.now(),
      );
      await GoalService.addGoal(goal);
      add(LoadGoalsEvent());
    } catch (e) {
      emit(GoalErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeleteGoal(
    DeleteGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    try {
      await GoalService.deleteGoal(event.goalId);
      add(LoadGoalsEvent());
    } catch (e) {
      emit(GoalErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadMilestones(
    LoadMilestonesEvent event,
    Emitter<GoalState> emit,
  ) async {
    if (state is GoalLoadedState) {
      final currentState = state as GoalLoadedState;
      try {
        final milestones = await MilestoneService.getMilestones(event.goalId);
        final updatedMilestones = Map<String, List<Milestone>>.from(
          currentState.milestones,
        );
        updatedMilestones[event.goalId] = milestones;
        emit(
          GoalLoadedState(
            goals: currentState.goals,
            milestones: updatedMilestones,
          ),
        );
      } catch (e) {
        emit(GoalErrorState(message: e.toString()));
      }
    }
  }

  Future<void> _onAddMilestone(
    AddMilestoneEvent event,
    Emitter<GoalState> emit,
  ) async {
    try {
      final milestone = Milestone(
        id: '',
        goalId: event.goalId,
        userId: SupabaseService.client.auth.currentUser!.id,
        title: event.title,
        createdAt: DateTime.now(),
      );
      await MilestoneService.addMilestone(milestone);
      add(LoadMilestonesEvent(goalId: event.goalId));
      add(LoadGoalsEvent());
    } catch (e) {
      emit(GoalErrorState(message: e.toString()));
    }
  }

  Future<void> _onToggleMilestone(
    ToggleMilestoneEvent event,
    Emitter<GoalState> emit,
  ) async {
    try {
      await MilestoneService.toggleMilestone(
        event.milestoneId,
        event.isCompleted,
        event.goalId,
      );
      add(LoadMilestonesEvent(goalId: event.goalId));
      add(LoadGoalsEvent());
    } catch (e) {
      emit(GoalErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeleteMilestone(
    DeleteMilestoneEvent event,
    Emitter<GoalState> emit,
  ) async {
    try {
      await MilestoneService.deleteMilestone(event.milestoneId, event.goalId);
      add(LoadMilestonesEvent(goalId: event.goalId));
      add(LoadGoalsEvent());
    } catch (e) {
      emit(GoalErrorState(message: e.toString()));
    }
  }
}
