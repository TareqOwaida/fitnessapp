import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fitenne'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your AI fitness companion'**
  String get appTagline;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Train smarter. Eat better. Live stronger.'**
  String get loginTagline;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your fitness journey'**
  String get signInSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @workouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// No description provided for @aiCoach.
  ///
  /// In en, this message translates to:
  /// **'AI Coach'**
  String get aiCoach;

  /// No description provided for @joinFitenne.
  ///
  /// In en, this message translates to:
  /// **'Join Fitenne'**
  String get joinFitenne;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account and start tracking today'**
  String get signupSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @atLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get atLeast6Characters;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @passwordMin6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMin6;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @checkYourInbox.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox'**
  String get checkYourInbox;

  /// No description provided for @verificationSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification link to'**
  String get verificationSentTo;

  /// No description provided for @verifyEmailBeforeSignIn.
  ///
  /// In en, this message translates to:
  /// **'Verify your email before signing in to unlock your full fitness experience.'**
  String get verifyEmailBeforeSignIn;

  /// No description provided for @signInToResend.
  ///
  /// In en, this message translates to:
  /// **'Sign in once with your password to resend the verification email.'**
  String get signInToResend;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent. Check your inbox.'**
  String get verificationEmailSent;

  /// No description provided for @resendVerificationEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend verification email'**
  String get resendVerificationEmail;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @ai.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get ai;

  /// No description provided for @todaysCalories.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Calories'**
  String get todaysCalories;

  /// No description provided for @mealsToday.
  ///
  /// In en, this message translates to:
  /// **'Meals today'**
  String get mealsToday;

  /// No description provided for @logged.
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get logged;

  /// No description provided for @logAMeal.
  ///
  /// In en, this message translates to:
  /// **'Log a meal'**
  String get logAMeal;

  /// No description provided for @logAMealSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Type, speak, or snap a photo — AI estimates calories'**
  String get logAMealSubtitle;

  /// No description provided for @loadingYourMeals.
  ///
  /// In en, this message translates to:
  /// **'Loading your meals...'**
  String get loadingYourMeals;

  /// No description provided for @noMealsLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No meals logged yet'**
  String get noMealsLoggedYet;

  /// No description provided for @noMealsLoggedHint.
  ///
  /// In en, this message translates to:
  /// **'Type, speak, or photograph what you ate and AI will estimate the calories for you.'**
  String get noMealsLoggedHint;

  /// No description provided for @dailyGoalKcal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal: {goal} kcal'**
  String dailyGoalKcal(int goal);

  /// No description provided for @couldNotLoadMeals.
  ///
  /// In en, this message translates to:
  /// **'Could not load meals: {error}'**
  String couldNotLoadMeals(String error);

  /// No description provided for @voiceInputFailed.
  ///
  /// In en, this message translates to:
  /// **'Voice input failed. Try again or type your meal.'**
  String get voiceInputFailed;

  /// No description provided for @voiceInputRestartLong.
  ///
  /// In en, this message translates to:
  /// **'Voice input needs a full app restart. Stop the app, then run flutter run again.'**
  String get voiceInputRestartLong;

  /// No description provided for @voiceInputUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice input is not available on this device.'**
  String get voiceInputUnavailable;

  /// No description provided for @voiceInputCouldNotStart.
  ///
  /// In en, this message translates to:
  /// **'Voice input could not start. Try typing your meal instead.'**
  String get voiceInputCouldNotStart;

  /// No description provided for @microphoneDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied or voice input unavailable.'**
  String get microphoneDenied;

  /// No description provided for @couldNotLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Could not load image: {error}'**
  String couldNotLoadImage(String error);

  /// No description provided for @couldNotAnalyzeFood.
  ///
  /// In en, this message translates to:
  /// **'Could not analyze food: {error}'**
  String couldNotAnalyzeFood(String error);

  /// No description provided for @mealFromPhoto.
  ///
  /// In en, this message translates to:
  /// **'Meal from photo'**
  String get mealFromPhoto;

  /// No description provided for @whatDidYouEat.
  ///
  /// In en, this message translates to:
  /// **'What did you eat?'**
  String get whatDidYouEat;

  /// No description provided for @listeningDescribeMeal.
  ///
  /// In en, this message translates to:
  /// **'Listening... describe your meal'**
  String get listeningDescribeMeal;

  /// No description provided for @mealHintExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2 eggs, toast, and black coffee'**
  String get mealHintExample;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @analyzePhotoAndLog.
  ///
  /// In en, this message translates to:
  /// **'Analyze Photo & Log'**
  String get analyzePhotoAndLog;

  /// No description provided for @analyzeAndLog.
  ///
  /// In en, this message translates to:
  /// **'Analyze & Log'**
  String get analyzeAndLog;

  /// No description provided for @recognizingFoodInPhoto.
  ///
  /// In en, this message translates to:
  /// **'Recognizing food in photo...'**
  String get recognizingFoodInPhoto;

  /// No description provided for @analyzingWithAi.
  ///
  /// In en, this message translates to:
  /// **'Analyzing with AI...'**
  String get analyzingWithAi;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @overDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Over daily goal'**
  String get overDailyGoal;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get onTrack;

  /// No description provided for @totalOfGoalKcal.
  ///
  /// In en, this message translates to:
  /// **'{total} of {goal} kcal'**
  String totalOfGoalKcal(int total, int goal);

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @meal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get meal;

  /// No description provided for @mealDetected.
  ///
  /// In en, this message translates to:
  /// **'Meal detected'**
  String get mealDetected;

  /// No description provided for @reviewBeforeAdding.
  ///
  /// In en, this message translates to:
  /// **'Review before adding to today\'s log'**
  String get reviewBeforeAdding;

  /// No description provided for @estimatedCalories.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATED CALORIES'**
  String get estimatedCalories;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @addMeal.
  ///
  /// In en, this message translates to:
  /// **'Add meal'**
  String get addMeal;

  /// No description provided for @gymTrainingPlan.
  ///
  /// In en, this message translates to:
  /// **'Gym training plan'**
  String get gymTrainingPlan;

  /// No description provided for @homeTrainingPlan.
  ///
  /// In en, this message translates to:
  /// **'Home training plan'**
  String get homeTrainingPlan;

  /// No description provided for @loadingWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Loading workouts...'**
  String get loadingWorkouts;

  /// No description provided for @noWorkoutsYet.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get noWorkoutsYet;

  /// No description provided for @noWorkoutsHint.
  ///
  /// In en, this message translates to:
  /// **'Your personalized workout plan will appear here once it\'s ready.'**
  String get noWorkoutsHint;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @exercisesCountMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises · {minutes} min'**
  String exercisesCountMinutes(int count, int minutes);

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @intensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get intensity;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @med.
  ///
  /// In en, this message translates to:
  /// **'Med'**
  String get med;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String minutesShort(int minutes);

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @yourPlan.
  ///
  /// In en, this message translates to:
  /// **'Your plan'**
  String get yourPlan;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'SESSIONS'**
  String get sessions;

  /// No description provided for @workoutDaySummary.
  ///
  /// In en, this message translates to:
  /// **'{day} · {minutes} min · {count} exercises'**
  String workoutDaySummary(String day, int minutes, int count);

  /// No description provided for @setsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sets'**
  String setsCount(int count);

  /// No description provided for @restSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s rest'**
  String restSeconds(int seconds);

  /// No description provided for @trackProgress.
  ///
  /// In en, this message translates to:
  /// **'Track your progress over time'**
  String get trackProgress;

  /// No description provided for @nutritionTrends.
  ///
  /// In en, this message translates to:
  /// **'Your nutrition trends'**
  String get nutritionTrends;

  /// No description provided for @loadingInsights.
  ///
  /// In en, this message translates to:
  /// **'Loading insights...'**
  String get loadingInsights;

  /// No description provided for @noDataYet.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get noDataYet;

  /// No description provided for @noDataHint.
  ///
  /// In en, this message translates to:
  /// **'Log meals on the Calories tab to build your nutrition history and see trends.'**
  String get noDataHint;

  /// No description provided for @lastNDays.
  ///
  /// In en, this message translates to:
  /// **'Last {days} days'**
  String lastNDays(int days);

  /// No description provided for @kcalAvg.
  ///
  /// In en, this message translates to:
  /// **'kcal avg'**
  String get kcalAvg;

  /// No description provided for @dailyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Daily breakdown'**
  String get dailyBreakdown;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'DAYS'**
  String get days;

  /// No description provided for @mealsLoggedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 meal logged} other{{count} meals logged}}'**
  String mealsLoggedCount(int count);

  /// No description provided for @caloriesKcal.
  ///
  /// In en, this message translates to:
  /// **'{calories} kcal'**
  String caloriesKcal(int calories);

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// No description provided for @settingUpProfile.
  ///
  /// In en, this message translates to:
  /// **'Setting up your profile...'**
  String get settingUpProfile;

  /// No description provided for @fitenneUser.
  ///
  /// In en, this message translates to:
  /// **'Fitenne User'**
  String get fitenneUser;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get yourProfile;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get dailyGoal;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @dailyCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily calorie goal'**
  String get dailyCalorieGoal;

  /// No description provided for @preferredWorkoutLocation.
  ///
  /// In en, this message translates to:
  /// **'Preferred workout location'**
  String get preferredWorkoutLocation;

  /// No description provided for @enterDailyGoalRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a daily goal between 500 and 10,000'**
  String get enterDailyGoalRange;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully'**
  String get profileSaved;

  /// No description provided for @couldNotSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not save profile: {error}'**
  String couldNotSaveProfile(String error);

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @welcomeToFitenne.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Fitenne'**
  String get welcomeToFitenne;

  /// No description provided for @personalizeExperience.
  ///
  /// In en, this message translates to:
  /// **'Let\'s personalize your experience'**
  String get personalizeExperience;

  /// No description provided for @aboutYou.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get aboutYou;

  /// No description provided for @calorieGoalStep.
  ///
  /// In en, this message translates to:
  /// **'Calorie goal'**
  String get calorieGoalStep;

  /// No description provided for @yourWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Your workouts'**
  String get yourWorkouts;

  /// No description provided for @aboutYouHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about yourself so we can tailor your plan.'**
  String get aboutYouHint;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @calorieGoalQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many calories do you want to consume per day?'**
  String get calorieGoalQuestion;

  /// No description provided for @presetKcal.
  ///
  /// In en, this message translates to:
  /// **'{value} kcal'**
  String presetKcal(int value);

  /// No description provided for @exerciseTypesQuestion.
  ///
  /// In en, this message translates to:
  /// **'What types of exercises are you interested in?'**
  String get exerciseTypesQuestion;

  /// No description provided for @workoutLocationQuestion.
  ///
  /// In en, this message translates to:
  /// **'Where do you prefer to work out?'**
  String get workoutLocationQuestion;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @cardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get cardio;

  /// No description provided for @hiit.
  ///
  /// In en, this message translates to:
  /// **'HIIT'**
  String get hiit;

  /// No description provided for @flexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get flexibility;

  /// No description provided for @upperBody.
  ///
  /// In en, this message translates to:
  /// **'Upper body'**
  String get upperBody;

  /// No description provided for @lowerBody.
  ///
  /// In en, this message translates to:
  /// **'Lower body'**
  String get lowerBody;

  /// No description provided for @enterValidAge.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid age (13–120)'**
  String get enterValidAge;

  /// No description provided for @enterValidHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter height in cm (100–250)'**
  String get enterValidHeight;

  /// No description provided for @enterValidWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter weight in kg (30–300)'**
  String get enterValidWeight;

  /// No description provided for @enterDailyGoalRangeKcal.
  ///
  /// In en, this message translates to:
  /// **'Enter a daily goal between 500 and 10,000 kcal'**
  String get enterDailyGoalRangeKcal;

  /// No description provided for @selectExerciseType.
  ///
  /// In en, this message translates to:
  /// **'Select at least one exercise type'**
  String get selectExerciseType;

  /// No description provided for @couldNotSavePreferences.
  ///
  /// In en, this message translates to:
  /// **'Could not save your preferences. Please try again.'**
  String get couldNotSavePreferences;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @checkWifiOrMobile.
  ///
  /// In en, this message translates to:
  /// **'Check your Wi‑Fi or mobile data.'**
  String get checkWifiOrMobile;

  /// No description provided for @loadingYourCoach.
  ///
  /// In en, this message translates to:
  /// **'Loading your coach...'**
  String get loadingYourCoach;

  /// No description provided for @personalizedFitnessGuidance.
  ///
  /// In en, this message translates to:
  /// **'Personalized fitness guidance'**
  String get personalizedFitnessGuidance;

  /// No description provided for @coachGreetingWithProfile.
  ///
  /// In en, this message translates to:
  /// **'Hey {name}! I\'ve loaded your profile — ask me about workouts, meal ideas, your {goal} kcal goal, or recovery tips.'**
  String coachGreetingWithProfile(String name, int goal);

  /// No description provided for @coachGreetingDefault.
  ///
  /// In en, this message translates to:
  /// **'Hey! I\'m your AI fitness coach. Ask me about workouts, meal ideas, calorie goals, or recovery tips.'**
  String get coachGreetingDefault;

  /// No description provided for @promptHighProteinBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Suggest a high-protein breakfast for my goal'**
  String get promptHighProteinBreakfast;

  /// No description provided for @promptWorkoutPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan a 30-min {location} workout for me'**
  String promptWorkoutPlan(String location);

  /// No description provided for @promptCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'How am I doing on my {goal} kcal goal?'**
  String promptCalorieGoal(int goal);

  /// No description provided for @promptRecoveryTips.
  ///
  /// In en, this message translates to:
  /// **'Best post-workout recovery tips for me'**
  String get promptRecoveryTips;

  /// No description provided for @coach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get coach;

  /// No description provided for @coachIsThinking.
  ///
  /// In en, this message translates to:
  /// **'Coach is thinking...'**
  String get coachIsThinking;

  /// No description provided for @askYourCoach.
  ///
  /// In en, this message translates to:
  /// **'Ask your fitness coach...'**
  String get askYourCoach;

  /// No description provided for @noResponse.
  ///
  /// In en, this message translates to:
  /// **'No response.'**
  String get noResponse;

  /// No description provided for @coachError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I could not respond right now. ({error})'**
  String coachError(String error);

  /// No description provided for @authVerifyEmailBeforeSignIn.
  ///
  /// In en, this message translates to:
  /// **'Verify your email before signing in.'**
  String get authVerifyEmailBeforeSignIn;

  /// No description provided for @authEmailAlreadyVerified.
  ///
  /// In en, this message translates to:
  /// **'Your email is verified. Sign in to continue.'**
  String get authEmailAlreadyVerified;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authInvalidEmail;

  /// No description provided for @authIncorrectCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authIncorrectCredentials;

  /// No description provided for @authEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for this email.'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get authWeakPassword;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed.'**
  String get authFailed;

  /// No description provided for @authAccountExistsDifferentCredential.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email using a different sign-in method.'**
  String get authAccountExistsDifferentCredential;

  /// No description provided for @authGoogleNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In is not configured yet. Enable Google in Firebase Authentication, add your Android SHA-1 fingerprint, then re-download google-services.json.'**
  String get authGoogleNotConfigured;

  /// No description provided for @authAccountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found.'**
  String get authAccountNotFound;

  /// No description provided for @authEmailVerifiedCanSignIn.
  ///
  /// In en, this message translates to:
  /// **'Email is already verified. You can sign in.'**
  String get authEmailVerifiedCanSignIn;

  /// No description provided for @estimatedByAi.
  ///
  /// In en, this message translates to:
  /// **'Estimated by AI'**
  String get estimatedByAi;

  /// No description provided for @aiParseFallback.
  ///
  /// In en, this message translates to:
  /// **'Could not parse AI response. Default estimate applied.'**
  String get aiParseFallback;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @mealTypeBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealTypeBreakfast;

  /// No description provided for @mealTypeLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealTypeLunch;

  /// No description provided for @mealTypeDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealTypeDinner;

  /// No description provided for @mealTypeSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get mealTypeSnack;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
