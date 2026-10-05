import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

class UserService {
  UserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<void> ensureUserDocument({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    final ref = _users.doc(uid);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (displayName.isNotEmpty) {
        updates['displayName'] = displayName;
      }
      if (!data.containsKey('onboardingCompleted')) {
        updates['onboardingCompleted'] = false;
      }
      await ref.update(updates);
      return;
    }

    final now = Timestamp.now();
    await ref.set({
      'email': email,
      'displayName': displayName,
      'createdAt': now,
      'updatedAt': now,
      'dailyCalorieGoal': 2000,
      'onboardingCompleted': false,
    });
  }

  Stream<UserProfile?> streamProfile(String uid) {
    return _users.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return UserProfile.fromFirestore(snapshot.id, snapshot.data()!);
    });
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _users.doc(profile.id).update({
      'displayName': profile.displayName,
      'dailyCalorieGoal': profile.dailyCalorieGoal,
      'preferredWorkoutLocation': profile.preferredWorkoutLocation,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> completeOnboarding({
    required String uid,
    required int dailyCalorieGoal,
    required int age,
    required double heightCm,
    required double weightKg,
    required List<String> preferredExercises,
    required String preferredWorkoutLocation,
  }) async {
    await _users.doc(uid).update({
      'dailyCalorieGoal': dailyCalorieGoal,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'preferredExercises': preferredExercises,
      'preferredWorkoutLocation': preferredWorkoutLocation,
      'onboardingCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
