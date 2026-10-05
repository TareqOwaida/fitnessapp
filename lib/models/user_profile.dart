import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.dailyCalorieGoal = 2000,
    this.preferredWorkoutLocation,
    this.age,
    this.heightCm,
    this.weightKg,
    this.preferredExercises = const [],
    this.onboardingCompleted = false,
  });

  final String id;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int dailyCalorieGoal;
  final String? preferredWorkoutLocation;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final List<String> preferredExercises;
  final bool onboardingCompleted;

  UserProfile copyWith({
    String? displayName,
    int? dailyCalorieGoal,
    String? preferredWorkoutLocation,
    int? age,
    double? heightCm,
    double? weightKg,
    List<String>? preferredExercises,
    bool? onboardingCompleted,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      preferredWorkoutLocation:
          preferredWorkoutLocation ?? this.preferredWorkoutLocation,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      preferredExercises: preferredExercises ?? this.preferredExercises,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  factory UserProfile.fromFirestore(String id, Map<String, dynamic> data) {
    final rawExercises = data['preferredExercises'] as List<dynamic>?;
    return UserProfile(
      id: id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      createdAt: _readTimestamp(data['createdAt']),
      updatedAt: _readTimestamp(data['updatedAt']),
      dailyCalorieGoal: (data['dailyCalorieGoal'] as num?)?.toInt() ?? 2000,
      preferredWorkoutLocation: data['preferredWorkoutLocation'] as String?,
      age: (data['age'] as num?)?.toInt(),
      heightCm: (data['heightCm'] as num?)?.toDouble(),
      weightKg: (data['weightKg'] as num?)?.toDouble(),
      preferredExercises: rawExercises?.map((e) => e as String).toList() ?? [],
      onboardingCompleted: data['onboardingCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'dailyCalorieGoal': dailyCalorieGoal,
      if (preferredWorkoutLocation != null)
        'preferredWorkoutLocation': preferredWorkoutLocation,
      if (age != null) 'age': age,
      if (heightCm != null) 'heightCm': heightCm,
      if (weightKg != null) 'weightKg': weightKg,
      if (preferredExercises.isNotEmpty) 'preferredExercises': preferredExercises,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  static DateTime _readTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    return DateTime.now();
  }

  static const _exerciseLabels = {
    'strength': 'Strength training',
    'cardio': 'Cardio',
    'hiit': 'HIIT',
    'flexibility': 'Flexibility',
    'upper_body': 'Upper body',
    'lower_body': 'Lower body',
  };

  /// Compact profile summary injected into AI prompts for personalization.
  String get aiContextSummary {
    final parts = <String>[];

    if (displayName.isNotEmpty) {
      parts.add('Name: $displayName');
    }
    if (age != null) {
      parts.add('Age: $age years');
    }
    if (heightCm != null) {
      parts.add('Height: ${heightCm!.toStringAsFixed(0)} cm');
    }
    if (weightKg != null) {
      parts.add('Weight: ${weightKg!.toStringAsFixed(1)} kg');
    }
    if (heightCm != null && weightKg != null && heightCm! > 0) {
      final heightM = heightCm! / 100;
      final bmi = weightKg! / (heightM * heightM);
      parts.add('BMI: ${bmi.toStringAsFixed(1)}');
    }
    parts.add('Daily calorie goal: $dailyCalorieGoal kcal');
    if (preferredWorkoutLocation != null) {
      final location = preferredWorkoutLocation == 'home' ? 'Home' : 'Gym';
      parts.add('Preferred workout location: $location');
    }
    if (preferredExercises.isNotEmpty) {
      final labels = preferredExercises
          .map((id) => _exerciseLabels[id] ?? id)
          .join(', ');
      parts.add('Preferred exercise types: $labels');
    }

    return parts.join('\n');
  }
}
