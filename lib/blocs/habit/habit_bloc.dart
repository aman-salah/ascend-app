import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/habit.dart';
import '../../services/habit_service.dart';
import '../../services/supabase_service.dart';
import 'habit_event.dart';
import 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc() : super(HabitInitialState()) {
    on<LoadHabitsEvent>(_onLoadHabits);
    on<AddHabitEvent>(_onAddHabit);
    on<ToggleHabitEvent>(_onToggleHabit);
    on<EditHabitEvent>(_onEditHabit);
    on<DeleteHabitEvent>(_onDeleteHabit);
  }

  Future<void> _onLoadHabits(
    LoadHabitsEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoadingState());
    try {
      final habits = await HabitService.getHabits();
      emit(HabitLoadedState(habits: habits));
    } catch (e) {
      emit(HabitErrorState(message: e.toString()));
    }
  }

  Future<void> _onAddHabit(
    AddHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    try {
      final habit = Habit(
        id: '',
        userId: SupabaseService.client.auth.currentUser!.id,
        title: event.title,
        emoji: event.emoji,
        timeOfDay: event.timeOfDay,
      );
      await HabitService.addHabit(habit);
      add(LoadHabitsEvent());
    } catch (e) {
      emit(HabitErrorState(message: e.toString()));
    }
  }

  Future<void> _onToggleHabit(
    ToggleHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await HabitService.toggleHabit(event.habitId, event.isCompleted);
      add(LoadHabitsEvent());
    } catch (e) {
      emit(HabitErrorState(message: e.toString()));
    }
  }

  Future<void> _onEditHabit(
    EditHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await HabitService.editHabit(
        event.habitId,
        event.title,
        event.emoji,
        event.timeOfDay,
      );
      add(LoadHabitsEvent());
    } catch (e) {
      emit(HabitErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeleteHabit(
    DeleteHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await HabitService.deleteHabit(event.habitId);
      add(LoadHabitsEvent());
    } catch (e) {
      emit(HabitErrorState(message: e.toString()));
    }
  }
}
