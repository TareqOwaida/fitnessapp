// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Fitenne';

  @override
  String get appTagline => 'رفيقك الذكي لللياقة البدنية';

  @override
  String get loginTagline => 'تدرّب بذكاء. كلّ بصحة. عِش بقوة.';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInSubtitle => 'سجّل الدخول لمتابعة رحلتك الرياضية';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get orDivider => 'أو';

  @override
  String get continueWithGoogle => 'المتابعة مع Google';

  @override
  String get createAnAccount => 'إنشاء حساب';

  @override
  String get calories => 'السعرات';

  @override
  String get workouts => 'التمارين';

  @override
  String get aiCoach => 'المدرب الذكي';

  @override
  String get joinFitenne => 'انضم إلى Fitenne';

  @override
  String get signupSubtitle => 'أنشئ حسابك وابدأ التتبع اليوم';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get atLeast6Characters => '6 أحرف على الأقل';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get passwordMin6 => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب؟ سجّل الدخول';

  @override
  String get checkYourInbox => 'تحقق من بريدك';

  @override
  String get verificationSentTo => 'أرسلنا رابط التحقق إلى';

  @override
  String get verifyEmailBeforeSignIn =>
      'تحقق من بريدك قبل تسجيل الدخول للوصول إلى تجربتك الكاملة.';

  @override
  String get signInToResend =>
      'سجّل الدخول مرة واحدة بكلمة مرورك لإعادة إرسال رسالة التحقق.';

  @override
  String get verificationEmailSent => 'تم إرسال رسالة التحقق. تحقق من بريدك.';

  @override
  String get resendVerificationEmail => 'إعادة إرسال رسالة التحقق';

  @override
  String get backToSignIn => 'العودة لتسجيل الدخول';

  @override
  String get insights => 'الإحصائيات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get ai => 'ذكاء';

  @override
  String get todaysCalories => 'سعرات اليوم';

  @override
  String get mealsToday => 'وجبات اليوم';

  @override
  String get logged => 'مسجّل';

  @override
  String get logAMeal => 'سجّل وجبة';

  @override
  String get logAMealSubtitle =>
      'اكتب أو تحدّث أو التقط صورة — الذكاء الاصطناعي يقدّر السعرات';

  @override
  String get loadingYourMeals => 'جاري تحميل وجباتك...';

  @override
  String get noMealsLoggedYet => 'لا توجد وجبات مسجّلة بعد';

  @override
  String get noMealsLoggedHint =>
      'اكتب أو تحدّث أو صوّر ما أكلته وسيقدّر الذكاء الاصطناعي السعرات.';

  @override
  String dailyGoalKcal(int goal) {
    return 'الهدف اليومي: $goal سعرة';
  }

  @override
  String couldNotLoadMeals(String error) {
    return 'تعذّر تحميل الوجبات: $error';
  }

  @override
  String get voiceInputFailed =>
      'فشل الإدخال الصوتي. حاول مرة أخرى أو اكتب وجبتك.';

  @override
  String get voiceInputRestartLong =>
      'يتطلب الإدخال الصوتي إعادة تشغيل التطبيق بالكامل.';

  @override
  String get voiceInputUnavailable => 'الإدخال الصوتي غير متاح على هذا الجهاز.';

  @override
  String get voiceInputCouldNotStart =>
      'تعذّر بدء الإدخال الصوتي. جرّب كتابة وجبتك.';

  @override
  String get microphoneDenied =>
      'تم رفض إذن الميكروفون أو الإدخال الصوتي غير متاح.';

  @override
  String couldNotLoadImage(String error) {
    return 'تعذّر تحميل الصورة: $error';
  }

  @override
  String couldNotAnalyzeFood(String error) {
    return 'تعذّر تحليل الطعام: $error';
  }

  @override
  String get mealFromPhoto => 'وجبة من صورة';

  @override
  String get whatDidYouEat => 'ماذا أكلت؟';

  @override
  String get listeningDescribeMeal => 'جاري الاستماع... صف وجبتك';

  @override
  String get mealHintExample => 'مثال: بيضتان، توست، وقهوة سوداء';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get stop => 'إيقاف';

  @override
  String get voice => 'صوت';

  @override
  String get analyzePhotoAndLog => 'تحليل الصورة والتسجيل';

  @override
  String get analyzeAndLog => 'تحليل وتسجيل';

  @override
  String get recognizingFoodInPhoto => 'جاري التعرف على الطعام في الصورة...';

  @override
  String get analyzingWithAi => 'جاري التحليل بالذكاء الاصطناعي...';

  @override
  String get kcal => 'سعرة';

  @override
  String get overDailyGoal => 'تجاوزت الهدف اليومي';

  @override
  String get onTrack => 'على المسار الصحيح';

  @override
  String totalOfGoalKcal(int total, int goal) {
    return '$total من $goal سعرة';
  }

  @override
  String get remaining => 'المتبقي';

  @override
  String get goal => 'الهدف';

  @override
  String get meal => 'وجبة';

  @override
  String get mealDetected => 'تم اكتشاف وجبة';

  @override
  String get reviewBeforeAdding => 'راجع قبل إضافتها لسجل اليوم';

  @override
  String get estimatedCalories => 'السعرات المقدّرة';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get addMeal => 'إضافة الوجبة';

  @override
  String get gymTrainingPlan => 'خطة تمارين النادي';

  @override
  String get homeTrainingPlan => 'خطة تمارين المنزل';

  @override
  String get loadingWorkouts => 'جاري تحميل التمارين...';

  @override
  String get noWorkoutsYet => 'لا توجد تمارين بعد';

  @override
  String get noWorkoutsHint => 'ستظهر خطتك المخصصة هنا عندما تكون جاهزة.';

  @override
  String get gym => 'النادي';

  @override
  String get home => 'المنزل';

  @override
  String get today => 'اليوم';

  @override
  String exercisesCountMinutes(int count, int minutes) {
    return '$count تمارين · $minutes د';
  }

  @override
  String get exercises => 'التمارين';

  @override
  String get duration => 'المدة';

  @override
  String get intensity => 'الشدة';

  @override
  String get high => 'عالية';

  @override
  String get med => 'متوسطة';

  @override
  String minutesShort(int minutes) {
    return '$minutes د';
  }

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get yourPlan => 'خطتك';

  @override
  String get sessions => 'الجلسات';

  @override
  String workoutDaySummary(String day, int minutes, int count) {
    return '$day · $minutes د · $count تمارين';
  }

  @override
  String setsCount(int count) {
    return '$count مجموعات';
  }

  @override
  String restSeconds(int seconds) {
    return 'راحة $seconds ث';
  }

  @override
  String get trackProgress => 'تابع تقدّمك مع الوقت';

  @override
  String get nutritionTrends => 'اتجاهات التغذية';

  @override
  String get loadingInsights => 'جاري تحميل الإحصائيات...';

  @override
  String get noDataYet => 'لا توجد بيانات بعد';

  @override
  String get noDataHint =>
      'سجّل وجباتك في تبويب السعرات لبناء سجل التغذية ورؤية الاتجاهات.';

  @override
  String lastNDays(int days) {
    return 'آخر $days أيام';
  }

  @override
  String get kcalAvg => 'متوسط السعرات';

  @override
  String get dailyBreakdown => 'التفصيل اليومي';

  @override
  String get days => 'الأيام';

  @override
  String mealsLoggedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count وجبة مسجّلة',
      many: '$count وجبة مسجّلة',
      few: '$count وجبات مسجّلة',
      two: 'وجبتان مسجلتان',
      one: 'وجبة واحدة مسجّلة',
      zero: 'لا وجبات',
    );
    return '$_temp0';
  }

  @override
  String caloriesKcal(int calories) {
    return '$calories سعرة';
  }

  @override
  String get loadingProfile => 'جاري تحميل الملف...';

  @override
  String get settingUpProfile => 'جاري إعداد ملفك...';

  @override
  String get fitenneUser => 'مستخدم Fitenne';

  @override
  String get yourProfile => 'ملفك الشخصي';

  @override
  String get dailyGoal => 'الهدف اليومي';

  @override
  String get workout => 'التمرين';

  @override
  String get editProfile => 'تعديل الملف';

  @override
  String get displayName => 'اسم العرض';

  @override
  String get dailyCalorieGoal => 'هدف السعرات اليومي';

  @override
  String get preferredWorkoutLocation => 'مكان التمرين المفضل';

  @override
  String get enterDailyGoalRange => 'أدخل هدفاً يومياً بين 500 و 10,000';

  @override
  String get profileSaved => 'تم حفظ الملف بنجاح';

  @override
  String couldNotSaveProfile(String error) {
    return 'تعذّر حفظ الملف: $error';
  }

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get any => 'أي';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get welcomeToFitenne => 'مرحباً بك في Fitenne';

  @override
  String get personalizeExperience => 'لنخصّص تجربتك';

  @override
  String get aboutYou => 'عنك';

  @override
  String get calorieGoalStep => 'هدف السعرات';

  @override
  String get yourWorkouts => 'تمارينك';

  @override
  String get aboutYouHint => 'أخبرنا قليلاً عن نفسك لنصمّم خطتك.';

  @override
  String get age => 'العمر';

  @override
  String get years => 'سنة';

  @override
  String get height => 'الطول';

  @override
  String get cm => 'سم';

  @override
  String get weight => 'الوزن';

  @override
  String get kg => 'كغ';

  @override
  String get calorieGoalQuestion => 'كم سعرة تريد استهلاكها يومياً؟';

  @override
  String presetKcal(int value) {
    return '$value سعرة';
  }

  @override
  String get exerciseTypesQuestion => 'ما أنواع التمارين التي تهمك؟';

  @override
  String get workoutLocationQuestion => 'أين تفضل التمرين؟';

  @override
  String get strength => 'قوة';

  @override
  String get cardio => 'كارديو';

  @override
  String get hiit => 'HIIT';

  @override
  String get flexibility => 'مرونة';

  @override
  String get upperBody => 'الجزء العلوي';

  @override
  String get lowerBody => 'الجزء السفلي';

  @override
  String get enterValidAge => 'أدخل عمراً صالحاً (13–120)';

  @override
  String get enterValidHeight => 'أدخل الطول بالسم (100–250)';

  @override
  String get enterValidWeight => 'أدخل الوزن بالكغ (30–300)';

  @override
  String get enterDailyGoalRangeKcal =>
      'أدخل هدفاً يومياً بين 500 و 10,000 سعرة';

  @override
  String get selectExerciseType => 'اختر نوع تمرين واحد على الأقل';

  @override
  String get couldNotSavePreferences => 'تعذّر حفظ تفضيلاتك. حاول مرة أخرى.';

  @override
  String get back => 'رجوع';

  @override
  String get continueButton => 'متابعة';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get saving => 'جاري الحفظ...';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get checkWifiOrMobile => 'تحقق من Wi‑Fi أو بيانات الجوال.';

  @override
  String get loadingYourCoach => 'جاري تحميل مدربك...';

  @override
  String get personalizedFitnessGuidance => 'إرشاد لياقة مخصص';

  @override
  String coachGreetingWithProfile(String name, int goal) {
    return 'مرحباً $name! حمّلت ملفك — اسألني عن التمارين أو الوجبات أو هدف $goal سعرة أو التعافي.';
  }

  @override
  String get coachGreetingDefault =>
      'مرحباً! أنا مدربك الذكي. اسألني عن التمارين أو الوجبات أو السعرات أو التعافي.';

  @override
  String get promptHighProteinBreakfast =>
      'اقترح فطوراً غنياً بالبروtein لهدفي';

  @override
  String promptWorkoutPlan(String location) {
    return 'خطّط لي تمرين $location لمدة 30 دقيقة';
  }

  @override
  String promptCalorieGoal(int goal) {
    return 'كيف أبلي في هدف $goal سعرة؟';
  }

  @override
  String get promptRecoveryTips => 'أفضل نصائح التعافي بعد التمرين';

  @override
  String get coach => 'المدرب';

  @override
  String get coachIsThinking => 'المدرب يفكّر...';

  @override
  String get askYourCoach => 'اسأل مدربك...';

  @override
  String get noResponse => 'لا رد.';

  @override
  String coachError(String error) {
    return 'عذراً، لم أتمكن من الرد الآن. ($error)';
  }

  @override
  String get authVerifyEmailBeforeSignIn => 'تحقق من بريدك قبل تسجيل الدخول.';

  @override
  String get authEmailAlreadyVerified =>
      'تم التحقق من بريدك. سجّل الدخول للمتابعة.';

  @override
  String get authInvalidEmail => 'أدخل بريداً إلكترونياً صالحاً.';

  @override
  String get authIncorrectCredentials => 'البريد أو كلمة المرور غير صحيحة.';

  @override
  String get authEmailInUse => 'يوجد حساب بهذا البريد بالفعل.';

  @override
  String get authWeakPassword => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل.';

  @override
  String get authFailed => 'فشلت المصادقة.';

  @override
  String get authAccountExistsDifferentCredential =>
      'يوجد حساب بهذا البريد باستخدام طريقة تسجيل دخول مختلفة.';

  @override
  String get authGoogleNotConfigured =>
      'تسجيل الدخول عبر Google غير مهيأ بعد. فعّل Google في Firebase Authentication، وأضف بصمة SHA-1 لأندرويد، ثم أعد تنزيل google-services.json.';

  @override
  String get authAccountNotFound => 'الحساب غير موجود.';

  @override
  String get authEmailVerifiedCanSignIn =>
      'تم التحقق من البريد. يمكنك تسجيل الدخول.';

  @override
  String get estimatedByAi => 'تقدير بالذكاء الاصطناعي';

  @override
  String get aiParseFallback =>
      'تعذّر تحليل رد الذكاء الاصطناعي. تم تطبيق تقدير افتراضي.';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get sunday => 'الأحد';

  @override
  String get breakfast => 'فطور';

  @override
  String get lunch => 'غداء';

  @override
  String get dinner => 'عشاء';

  @override
  String get snack => 'وجبة خفيفة';

  @override
  String get mealTypeBreakfast => 'فطور';

  @override
  String get mealTypeLunch => 'غداء';

  @override
  String get mealTypeDinner => 'عشاء';

  @override
  String get mealTypeSnack => 'وجبة خفيفة';
}
