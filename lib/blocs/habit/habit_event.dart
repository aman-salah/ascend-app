abstract class HabitEvent {}

class LoadHabitsEvent extends HabitEvent {}

class AddHabitEvent extends HabitEvent {
  final String title;
  final String emoji;
  final String timeOfDay;

  AddHabitEvent({
    required this.title,
    required this.emoji,
    required this.timeOfDay,
  });
}

class ToggleHabitEvent extends HabitEvent {
  final String habitId;
  final bool isCompleted;

  ToggleHabitEvent({required this.habitId, required this.isCompleted});
}

class EditHabitEvent extends HabitEvent {
  final String habitId;
  final String title;
  final String emoji;
  final String timeOfDay;

  EditHabitEvent({
    required this.habitId,
    required this.title,
    required this.emoji,
    required this.timeOfDay,
  });
}

class DeleteHabitEvent extends HabitEvent {
  final String habitId;
  DeleteHabitEvent({required this.habitId});
}
