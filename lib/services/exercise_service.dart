import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/exercise.dart';

class ExerciseService {
  ExerciseService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _plans =>
      _firestore.collection('exercise_plans');

  Future<void> seedDefaultPlans(String userId) async {
    final existing = await _plans.where('userId', isEqualTo: userId).limit(1).get();
    if (existing.docs.isNotEmpty) {
      return;
    }

    final defaults = _defaultPlans(userId);
    final batch = _firestore.batch();
    for (final plan in defaults) {
      batch.set(_plans.doc(), plan.toFirestore());
    }
    await batch.commit();
  }

  Stream<List<WorkoutPlan>> streamPlans(String userId) {
    return _plans.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      final plans = snapshot.docs
          .map((doc) => WorkoutPlan.fromFirestore(doc.id, doc.data()))
          .toList();
      plans.sort((a, b) => a.day.index.compareTo(b.day.index));
      return plans;
    });
  }

  List<WorkoutPlan> _defaultPlans(String userId) {
    return [
      WorkoutPlan(
        id: '',
        userId: userId,
        title: 'Upper Body Strength',
        location: WorkoutLocation.gym,
        day: WorkoutDay.monday,
        durationMinutes: 50,
        exercises: [
          ExerciseItem(name: 'Bench Press', sets: 4, reps: '8-10', restSeconds: 90),
          ExerciseItem(name: 'Lat Pulldown', sets: 3, reps: '10-12', restSeconds: 75),
          ExerciseItem(name: 'Shoulder Press', sets: 3, reps: '10', restSeconds: 75),
          ExerciseItem(name: 'Cable Rows', sets: 3, reps: '12', restSeconds: 60),
        ],
      ),
      WorkoutPlan(
        id: '',
        userId: userId,
        title: 'Lower Body Power',
        location: WorkoutLocation.gym,
        day: WorkoutDay.wednesday,
        durationMinutes: 55,
        exercises: [
          ExerciseItem(name: 'Barbell Squat', sets: 4, reps: '6-8', restSeconds: 120),
          ExerciseItem(name: 'Romanian Deadlift', sets: 3, reps: '8-10', restSeconds: 90),
          ExerciseItem(name: 'Leg Press', sets: 3, reps: '12', restSeconds: 75),
          ExerciseItem(name: 'Calf Raises', sets: 4, reps: '15', restSeconds: 45),
        ],
      ),
      WorkoutPlan(
        id: '',
        userId: userId,
        title: 'Full Body Conditioning',
        location: WorkoutLocation.gym,
        day: WorkoutDay.friday,
        durationMinutes: 45,
        exercises: [
          ExerciseItem(name: 'Deadlift', sets: 3, reps: '5', restSeconds: 120),
          ExerciseItem(name: 'Pull-ups', sets: 3, reps: 'Max', restSeconds: 90),
          ExerciseItem(name: 'Dumbbell Lunges', sets: 3, reps: '12/leg', restSeconds: 60),
          ExerciseItem(name: 'Plank', sets: 3, reps: '45 sec', restSeconds: 45),
        ],
      ),
      WorkoutPlan(
        id: '',
        userId: userId,
        title: 'Home HIIT',
        location: WorkoutLocation.home,
        day: WorkoutDay.tuesday,
        durationMinutes: 30,
        exercises: [
          ExerciseItem(name: 'Jumping Jacks', sets: 3, reps: '45 sec', restSeconds: 30),
          ExerciseItem(name: 'Push-ups', sets: 3, reps: '12-15', restSeconds: 45),
          ExerciseItem(name: 'Mountain Climbers', sets: 3, reps: '40 sec', restSeconds: 30),
          ExerciseItem(name: 'Bodyweight Squats', sets: 3, reps: '20', restSeconds: 45),
        ],
      ),
      WorkoutPlan(
        id: '',
        userId: userId,
        title: 'Home Core & Mobility',
        location: WorkoutLocation.home,
        day: WorkoutDay.thursday,
        durationMinutes: 35,
        exercises: [
          ExerciseItem(name: 'Dead Bug', sets: 3, reps: '12/side', restSeconds: 40),
          ExerciseItem(name: 'Glute Bridge', sets: 3, reps: '15', restSeconds: 40),
          ExerciseItem(name: 'Bird Dog', sets: 3, reps: '10/side', restSeconds: 40),
          ExerciseItem(name: 'World\'s Greatest Stretch', sets: 2, reps: '8/side', restSeconds: 30),
        ],
      ),
      WorkoutPlan(
        id: '',
        userId: userId,
        title: 'Active Recovery Walk',
        location: WorkoutLocation.home,
        day: WorkoutDay.saturday,
        durationMinutes: 40,
        exercises: [
          ExerciseItem(
            name: 'Brisk Walk',
            sets: 1,
            reps: '30-40 min',
            restSeconds: 0,
            notes: 'Keep heart rate moderate and focus on posture.',
          ),
          ExerciseItem(name: 'Foam Rolling', sets: 1, reps: '10 min', restSeconds: 0),
        ],
      ),
    ];
  }
}
