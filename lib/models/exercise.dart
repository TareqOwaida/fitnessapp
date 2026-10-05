enum WorkoutLocation { gym, home }

enum WorkoutDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension WorkoutDayLabel on WorkoutDay {
  String get label {
    switch (this) {
      case WorkoutDay.monday:
        return 'Monday';
      case WorkoutDay.tuesday:
        return 'Tuesday';
      case WorkoutDay.wednesday:
        return 'Wednesday';
      case WorkoutDay.thursday:
        return 'Thursday';
      case WorkoutDay.friday:
        return 'Friday';
      case WorkoutDay.saturday:
        return 'Saturday';
      case WorkoutDay.sunday:
        return 'Sunday';
    }
  }
}

class ExerciseItem {
  ExerciseItem({
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.notes,
  });

  final String name;
  final int sets;
  final String reps;
  final int restSeconds;
  final String? notes;

  factory ExerciseItem.fromMap(Map<String, dynamic> map) {
    return ExerciseItem(
      name: map['name'] as String? ?? '',
      sets: (map['sets'] as num?)?.toInt() ?? 3,
      reps: map['reps'] as String? ?? '10',
      restSeconds: (map['restSeconds'] as num?)?.toInt() ?? 60,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'restSeconds': restSeconds,
      if (notes != null) 'notes': notes,
    };
  }
}

class WorkoutPlan {
  WorkoutPlan({
    required this.id,
    required this.userId,
    required this.title,
    required this.location,
    required this.day,
    required this.exercises,
    required this.durationMinutes,
  });

  final String id;
  final String userId;
  final String title;
  final WorkoutLocation location;
  final WorkoutDay day;
  final List<ExerciseItem> exercises;
  final int durationMinutes;

  factory WorkoutPlan.fromFirestore(String id, Map<String, dynamic> data) {
    final rawExercises = data['exercises'] as List<dynamic>? ?? [];
    return WorkoutPlan(
      id: id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      location: WorkoutLocation.values.firstWhere(
        (value) => value.name == data['location'],
        orElse: () => WorkoutLocation.home,
      ),
      day: WorkoutDay.values.firstWhere(
        (value) => value.name == data['day'],
        orElse: () => WorkoutDay.monday,
      ),
      exercises: rawExercises
          .map((item) => ExerciseItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      durationMinutes: (data['durationMinutes'] as num?)?.toInt() ?? 45,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'location': location.name,
      'day': day.name,
      'exercises': exercises.map((item) => item.toMap()).toList(),
      'durationMinutes': durationMinutes,
    };
  }
}
