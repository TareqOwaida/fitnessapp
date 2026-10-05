import 'package:cloud_firestore/cloud_firestore.dart';

class CalorieEntry {
  CalorieEntry({
    required this.id,
    required this.userId,
    required this.description,
    required this.calories,
    required this.date,
    required this.createdAt,
    this.mealType,
    this.aiNotes,
  });

  final String id;
  final String userId;
  final String description;
  final int calories;
  final DateTime date;
  final DateTime createdAt;
  final String? mealType;
  final String? aiNotes;

  factory CalorieEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CalorieEntry(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      description: data['description'] as String? ?? '',
      calories: (data['calories'] as num?)?.toInt() ?? 0,
      date: _readDate(data['date']),
      createdAt: _readTimestamp(data['createdAt']),
      mealType: data['mealType'] as String?,
      aiNotes: data['aiNotes'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'description': description,
      'calories': calories,
      'date': Timestamp.fromDate(_dateOnly(date)),
      'createdAt': Timestamp.fromDate(createdAt),
      if (mealType != null) 'mealType': mealType,
      if (aiNotes != null) 'aiNotes': aiNotes,
    };
  }

  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    return DateTime.now();
  }

  static DateTime _readTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    return DateTime.now();
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}

class DailyCalorieSummary {
  DailyCalorieSummary({required this.date, required this.entries});

  final DateTime date;
  final List<CalorieEntry> entries;

  int get totalCalories =>
      entries.fold(0, (total, entry) => total + entry.calories);
}
