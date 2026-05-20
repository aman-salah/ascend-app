import '../../models/habit.dart';

abstract class HabitState {}

class HabitInitialState extends HabitState {}

class HabitLoadingState extends HabitState {}

class HabitLoadedState extends HabitState {
  final List<Habit> habits;
  HabitLoadedState({required this.habits});
}

class HabitErrorState extends HabitState {
  final String message;
  HabitErrorState({required this.message});
}
