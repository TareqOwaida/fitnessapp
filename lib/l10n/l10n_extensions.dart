import '../models/exercise.dart';
import 'app_localizations.dart';

extension AppLocalizationsX on AppLocalizations {
  String weekday(WorkoutDay day) {
    switch (day) {
      case WorkoutDay.monday:
        return monday;
      case WorkoutDay.tuesday:
        return tuesday;
      case WorkoutDay.wednesday:
        return wednesday;
      case WorkoutDay.thursday:
        return thursday;
      case WorkoutDay.friday:
        return friday;
      case WorkoutDay.saturday:
        return saturday;
      case WorkoutDay.sunday:
        return sunday;
    }
  }

  String mealTypeLabel(String? mealType) {
    final type = (mealType ?? '').trim().toLowerCase();
    if (type.contains('breakfast')) {
      return mealTypeBreakfast;
    }
    if (type.contains('lunch')) {
      return mealTypeLunch;
    }
    if (type.contains('dinner')) {
      return mealTypeDinner;
    }
    if (type.contains('snack')) {
      return mealTypeSnack;
    }
    if (type.isEmpty) {
      return meal;
    }
    return mealTypeLabelCapitalized(mealType!);
  }

  String mealTypeLabelCapitalized(String mealType) {
    final normalized = mealType.trim().toLowerCase();
    if (normalized.isEmpty) {
      return meal;
    }
    return mealTypeLabel(normalized);
  }

  String workoutLocationLabel(String? location) {
    switch (location) {
      case 'gym':
        return gym;
      case 'home':
        return home;
      default:
        return any;
    }
  }

  String onboardingExerciseLabel(String id) {
    switch (id) {
      case 'strength':
        return strength;
      case 'cardio':
        return cardio;
      case 'hiit':
        return hiit;
      case 'flexibility':
        return flexibility;
      case 'upper_body':
        return upperBody;
      case 'lower_body':
        return lowerBody;
      default:
        return id;
    }
  }
}
