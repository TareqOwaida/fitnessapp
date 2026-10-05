import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';

import '../models/user_profile.dart';

class CalorieAnalysis {
  CalorieAnalysis({
    required this.calories,
    required this.mealType,
    required this.notes,
    this.description,
  });

  final int calories;
  final String mealType;
  final String notes;
  final String? description;
}

class AiService {
  AiService();

  GenerativeModel get _model {
    final googleAI = FirebaseAI.googleAI();
    return googleAI.generativeModel(model: 'gemini-flash-latest');
  }

  Future<CalorieAnalysis> analyzeFood(
    String description, {
    UserProfile? profile,
    int? caloriesConsumedToday,
  }) async {
    final userContext = _buildUserContext(
      profile: profile,
      caloriesConsumedToday: caloriesConsumedToday,
    );

    final prompt =
        '''
Estimate calories for this food/meal description.
When a user profile is provided, tailor mealType and notes to their daily calorie goal and intake so far.
Respond with JSON only:
{"calories": number, "mealType": "breakfast|lunch|dinner|snack", "notes": "short explanation", "description": "brief food name"}
$userContext
Food: $description
''';

    return _parseAnalysisResponse(
      await _model.generateContent([Content.text(prompt)]),
    );
  }

  Future<CalorieAnalysis> analyzeFoodImage(
    Uint8List imageBytes,
    String mimeType, {
    String? description,
    UserProfile? profile,
    int? caloriesConsumedToday,
  }) async {
    final userContext = _buildUserContext(
      profile: profile,
      caloriesConsumedToday: caloriesConsumedToday,
    );

    final extraContext = description?.trim().isNotEmpty == true
        ? '\nUser notes: $description'
        : '';

    final prompt =
        '''
Identify the food in this image and estimate calories for the visible meal or portion.
When a user profile is provided, tailor mealType and notes to their daily calorie goal and intake so far.
Respond with JSON only:
{"calories": number, "mealType": "breakfast|lunch|dinner|snack", "notes": "short explanation", "description": "brief food name"}
$userContext$extraContext
''';

    return _parseAnalysisResponse(
      await _model.generateContent([
        Content.multi([
          InlineDataPart(mimeType, imageBytes),
          TextPart(prompt),
        ]),
      ]),
    );
  }

  CalorieAnalysis _parseAnalysisResponse(GenerateContentResponse response) {
    final text = response.text?.trim() ?? '';
    final jsonText = _extractJson(text);

    try {
      final map = jsonDecode(jsonText) as Map<String, dynamic>;
      return CalorieAnalysis(
        calories: (map['calories'] as num?)?.toInt() ?? 0,
        mealType: map['mealType'] as String? ?? 'snack',
        notes: map['notes'] as String? ?? 'Estimated by AI',
        description: map['description'] as String?,
      );
    } catch (_) {
      return CalorieAnalysis(
        calories: 300,
        mealType: 'snack',
        notes: 'Could not parse AI response. Default estimate applied.',
      );
    }
  }

  ChatSession startFitnessChat({UserProfile? profile}) {
    final userContext = _buildUserContext(profile: profile);
    final greetingName = profile?.displayName.trim().isNotEmpty == true
        ? profile!.displayName.trim()
        : null;

    return _model.startChat(
      history: [
        Content.text(
          'You are Fitenne, a friendly fitness and nutrition coach. '
          'Give practical, safe advice about workouts, meals, and recovery. '
          'Keep answers concise and encouraging. '
          'Always personalize recommendations using the user profile below when it is provided. '
          'Reference their calorie goal, body stats, and exercise preferences in your advice.'
          '$userContext',
        ),
        Content.model([
          TextPart(
            greetingName != null
                ? 'Hi $greetingName! I\'m Fitenne, your fitness coach. '
                    'I\'ve got your profile — ask me about meals, workouts, or recovery anytime.'
                : 'Hi! I\'m Fitenne, your fitness coach. Ask me about meals, '
                    'workouts, or recovery anytime.',
          ),
        ]),
      ],
    );
  }

  String _buildUserContext({
    UserProfile? profile,
    int? caloriesConsumedToday,
  }) {
    if (profile == null) {
      return '';
    }

    final buffer = StringBuffer('\n\nUser profile:\n${profile.aiContextSummary}');

    if (caloriesConsumedToday != null) {
      final remaining = profile.dailyCalorieGoal - caloriesConsumedToday;
      buffer.writeln('Calories consumed today: $caloriesConsumedToday kcal');
      buffer.writeln('Calories remaining today: $remaining kcal');
    }

    return buffer.toString();
  }

  String _extractJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start == -1 || end == -1 || end <= start) {
      return text;
    }
    return text.substring(start, end + 1);
  }
}
