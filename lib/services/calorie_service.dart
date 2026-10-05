import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/calorie_entry.dart';

class CalorieService {
  CalorieService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _entries =>
      _firestore.collection('calorie_entries');

  Future<void> addEntry(CalorieEntry entry) async {
    await _entries.add(entry.toFirestore());
  }

  Stream<List<CalorieEntry>> streamTodayEntries(String userId) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    return _entries.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      final entries = snapshot.docs
          .map(CalorieEntry.fromFirestore)
          .where((entry) => _isSameDay(entry.date, todayStart))
          .toList();
      entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return entries;
    });
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Stream<List<DailyCalorieSummary>> streamHistory(String userId) {
    return _entries.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      final entries = snapshot.docs.map(CalorieEntry.fromFirestore).toList();
      final grouped = <DateTime, List<CalorieEntry>>{};

      for (final entry in entries) {
        final day = DateTime(entry.date.year, entry.date.month, entry.date.day);
        grouped.putIfAbsent(day, () => []).add(entry);
      }

      final summaries = grouped.entries
          .map(
            (entry) => DailyCalorieSummary(
              date: entry.key,
              entries: entry.value
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
            ),
          )
          .toList();

      summaries.sort((a, b) => b.date.compareTo(a.date));
      return summaries;
    });
  }

  Future<void> deleteEntry(String entryId) async {
    await _entries.doc(entryId).delete();
  }
}
