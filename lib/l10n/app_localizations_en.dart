// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fitenne';

  @override
  String get appTagline => 'Your AI fitness companion';

  @override
  String get loginTagline => 'Train smarter. Eat better. Live stronger.';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInSubtitle => 'Sign in to continue your fitness journey';

  @override
  String get emailAddress => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get signIn => 'Sign In';

  @override
  String get orDivider => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get calories => 'Calories';

  @override
  String get workouts => 'Workouts';

  @override
  String get aiCoach => 'AI Coach';

  @override
  String get joinFitenne => 'Join Fitenne';

  @override
  String get signupSubtitle => 'Create your account and start tracking today';

  @override
  String get fullName => 'Full name';

  @override
  String get atLeast6Characters => 'At least 6 characters';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get passwordMin6 => 'Password must be at least 6 characters';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get checkYourInbox => 'Check your inbox';

  @override
  String get verificationSentTo => 'We sent a verification link to';

  @override
  String get verifyEmailBeforeSignIn =>
      'Verify your email before signing in to unlock your full fitness experience.';

  @override
  String get signInToResend =>
      'Sign in once with your password to resend the verification email.';

  @override
  String get verificationEmailSent =>
      'Verification email sent. Check your inbox.';

  @override
  String get resendVerificationEmail => 'Resend verification email';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get insights => 'Insights';

  @override
  String get profile => 'Profile';

  @override
  String get ai => 'AI';

  @override
  String get todaysCalories => 'Today\'s Calories';

  @override
  String get mealsToday => 'Meals today';

  @override
  String get logged => 'Logged';

  @override
  String get logAMeal => 'Log a meal';

  @override
  String get logAMealSubtitle =>
      'Type, speak, or snap a photo — AI estimates calories';

  @override
  String get loadingYourMeals => 'Loading your meals...';

  @override
  String get noMealsLoggedYet => 'No meals logged yet';

  @override
  String get noMealsLoggedHint =>
      'Type, speak, or photograph what you ate and AI will estimate the calories for you.';

  @override
  String dailyGoalKcal(int goal) {
    return 'Daily goal: $goal kcal';
  }

  @override
  String couldNotLoadMeals(String error) {
    return 'Could not load meals: $error';
  }

  @override
  String get voiceInputFailed =>
      'Voice input failed. Try again or type your meal.';

  @override
  String get voiceInputRestartLong =>
      'Voice input needs a full app restart. Stop the app, then run flutter run again.';

  @override
  String get voiceInputUnavailable =>
      'Voice input is not available on this device.';

  @override
  String get voiceInputCouldNotStart =>
      'Voice input could not start. Try typing your meal instead.';

  @override
  String get microphoneDenied =>
      'Microphone permission denied or voice input unavailable.';

  @override
  String couldNotLoadImage(String error) {
    return 'Could not load image: $error';
  }

  @override
  String couldNotAnalyzeFood(String error) {
    return 'Could not analyze food: $error';
  }

  @override
  String get mealFromPhoto => 'Meal from photo';

  @override
  String get whatDidYouEat => 'What did you eat?';

  @override
  String get listeningDescribeMeal => 'Listening... describe your meal';

  @override
  String get mealHintExample => 'e.g. 2 eggs, toast, and black coffee';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get stop => 'Stop';

  @override
  String get voice => 'Voice';

  @override
  String get analyzePhotoAndLog => 'Analyze Photo & Log';

  @override
  String get analyzeAndLog => 'Analyze & Log';

  @override
  String get recognizingFoodInPhoto => 'Recognizing food in photo...';

  @override
  String get analyzingWithAi => 'Analyzing with AI...';

  @override
  String get kcal => 'kcal';

  @override
  String get overDailyGoal => 'Over daily goal';

  @override
  String get onTrack => 'On track';

  @override
  String totalOfGoalKcal(int total, int goal) {
    return '$total of $goal kcal';
  }

  @override
  String get remaining => 'Remaining';

  @override
  String get goal => 'Goal';

  @override
  String get meal => 'Meal';

  @override
  String get mealDetected => 'Meal detected';

  @override
  String get reviewBeforeAdding => 'Review before adding to today\'s log';

  @override
  String get estimatedCalories => 'ESTIMATED CALORIES';

  @override
  String get notNow => 'Not now';

  @override
  String get addMeal => 'Add meal';

  @override
  String get gymTrainingPlan => 'Gym training plan';

  @override
  String get homeTrainingPlan => 'Home training plan';

  @override
  String get loadingWorkouts => 'Loading workouts...';

  @override
  String get noWorkoutsYet => 'No workouts yet';

  @override
  String get noWorkoutsHint =>
      'Your personalized workout plan will appear here once it\'s ready.';

  @override
  String get gym => 'Gym';

  @override
  String get home => 'Home';

  @override
  String get today => 'TODAY';

  @override
  String exercisesCountMinutes(int count, int minutes) {
    return '$count exercises · $minutes min';
  }

  @override
  String get exercises => 'Exercises';

  @override
  String get duration => 'Duration';

  @override
  String get intensity => 'Intensity';

  @override
  String get high => 'High';

  @override
  String get med => 'Med';

  @override
  String minutesShort(int minutes) {
    return '${minutes}m';
  }

  @override
  String get thisWeek => 'This week';

  @override
  String get yourPlan => 'Your plan';

  @override
  String get sessions => 'SESSIONS';

  @override
  String workoutDaySummary(String day, int minutes, int count) {
    return '$day · $minutes min · $count exercises';
  }

  @override
  String setsCount(int count) {
    return '$count sets';
  }

  @override
  String restSeconds(int seconds) {
    return '${seconds}s rest';
  }

  @override
  String get trackProgress => 'Track your progress over time';

  @override
  String get nutritionTrends => 'Your nutrition trends';

  @override
  String get loadingInsights => 'Loading insights...';

  @override
  String get noDataYet => 'No data yet';

  @override
  String get noDataHint =>
      'Log meals on the Calories tab to build your nutrition history and see trends.';

  @override
  String lastNDays(int days) {
    return 'Last $days days';
  }

  @override
  String get kcalAvg => 'kcal avg';

  @override
  String get dailyBreakdown => 'Daily breakdown';

  @override
  String get days => 'DAYS';

  @override
  String mealsLoggedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meals logged',
      one: '1 meal logged',
    );
    return '$_temp0';
  }

  @override
  String caloriesKcal(int calories) {
    return '$calories kcal';
  }

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get settingUpProfile => 'Setting up your profile...';

  @override
  String get fitenneUser => 'Fitenne User';

  @override
  String get yourProfile => 'Your profile';

  @override
  String get dailyGoal => 'Daily goal';

  @override
  String get workout => 'Workout';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get displayName => 'Display name';

  @override
  String get dailyCalorieGoal => 'Daily calorie goal';

  @override
  String get preferredWorkoutLocation => 'Preferred workout location';

  @override
  String get enterDailyGoalRange => 'Enter a daily goal between 500 and 10,000';

  @override
  String get profileSaved => 'Profile saved successfully';

  @override
  String couldNotSaveProfile(String error) {
    return 'Could not save profile: $error';
  }

  @override
  String get saveChanges => 'Save changes';

  @override
  String get signOut => 'Sign out';

  @override
  String get any => 'Any';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get welcomeToFitenne => 'Welcome to Fitenne';

  @override
  String get personalizeExperience => 'Let\'s personalize your experience';

  @override
  String get aboutYou => 'About you';

  @override
  String get calorieGoalStep => 'Calorie goal';

  @override
  String get yourWorkouts => 'Your workouts';

  @override
  String get aboutYouHint =>
      'Tell us a bit about yourself so we can tailor your plan.';

  @override
  String get age => 'Age';

  @override
  String get years => 'years';

  @override
  String get height => 'Height';

  @override
  String get cm => 'cm';

  @override
  String get weight => 'Weight';

  @override
  String get kg => 'kg';

  @override
  String get calorieGoalQuestion =>
      'How many calories do you want to consume per day?';

  @override
  String presetKcal(int value) {
    return '$value kcal';
  }

  @override
  String get exerciseTypesQuestion =>
      'What types of exercises are you interested in?';

  @override
  String get workoutLocationQuestion => 'Where do you prefer to work out?';

  @override
  String get strength => 'Strength';

  @override
  String get cardio => 'Cardio';

  @override
  String get hiit => 'HIIT';

  @override
  String get flexibility => 'Flexibility';

  @override
  String get upperBody => 'Upper body';

  @override
  String get lowerBody => 'Lower body';

  @override
  String get enterValidAge => 'Enter a valid age (13–120)';

  @override
  String get enterValidHeight => 'Enter height in cm (100–250)';

  @override
  String get enterValidWeight => 'Enter weight in kg (30–300)';

  @override
  String get enterDailyGoalRangeKcal =>
      'Enter a daily goal between 500 and 10,000 kcal';

  @override
  String get selectExerciseType => 'Select at least one exercise type';

  @override
  String get couldNotSavePreferences =>
      'Could not save your preferences. Please try again.';

  @override
  String get back => 'Back';

  @override
  String get continueButton => 'Continue';

  @override
  String get getStarted => 'Get started';

  @override
  String get saving => 'Saving...';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get checkWifiOrMobile => 'Check your Wi‑Fi or mobile data.';

  @override
  String get loadingYourCoach => 'Loading your coach...';

  @override
  String get personalizedFitnessGuidance => 'Personalized fitness guidance';

  @override
  String coachGreetingWithProfile(String name, int goal) {
    return 'Hey $name! I\'ve loaded your profile — ask me about workouts, meal ideas, your $goal kcal goal, or recovery tips.';
  }

  @override
  String get coachGreetingDefault =>
      'Hey! I\'m your AI fitness coach. Ask me about workouts, meal ideas, calorie goals, or recovery tips.';

  @override
  String get promptHighProteinBreakfast =>
      'Suggest a high-protein breakfast for my goal';

  @override
  String promptWorkoutPlan(String location) {
    return 'Plan a 30-min $location workout for me';
  }

  @override
  String promptCalorieGoal(int goal) {
    return 'How am I doing on my $goal kcal goal?';
  }

  @override
  String get promptRecoveryTips => 'Best post-workout recovery tips for me';

  @override
  String get coach => 'Coach';

  @override
  String get coachIsThinking => 'Coach is thinking...';

  @override
  String get askYourCoach => 'Ask your fitness coach...';

  @override
  String get noResponse => 'No response.';

  @override
  String coachError(String error) {
    return 'Sorry, I could not respond right now. ($error)';
  }

  @override
  String get authVerifyEmailBeforeSignIn =>
      'Verify your email before signing in.';

  @override
  String get authEmailAlreadyVerified =>
      'Your email is verified. Sign in to continue.';

  @override
  String get authInvalidEmail => 'Enter a valid email address.';

  @override
  String get authIncorrectCredentials => 'Incorrect email or password.';

  @override
  String get authEmailInUse => 'An account already exists for this email.';

  @override
  String get authWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get authFailed => 'Authentication failed.';

  @override
  String get authAccountExistsDifferentCredential =>
      'An account already exists with this email using a different sign-in method.';

  @override
  String get authGoogleNotConfigured =>
      'Google Sign-In is not configured yet. Enable Google in Firebase Authentication, add your Android SHA-1 fingerprint, then re-download google-services.json.';

  @override
  String get authAccountNotFound => 'Account not found.';

  @override
  String get authEmailVerifiedCanSignIn =>
      'Email is already verified. You can sign in.';

  @override
  String get estimatedByAi => 'Estimated by AI';

  @override
  String get aiParseFallback =>
      'Could not parse AI response. Default estimate applied.';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snack => 'Snack';

  @override
  String get mealTypeBreakfast => 'Breakfast';

  @override
  String get mealTypeLunch => 'Lunch';

  @override
  String get mealTypeDinner => 'Dinner';

  @override
  String get mealTypeSnack => 'Snack';
}
