import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../l10n/app_localizations.dart';
import 'google_auth_config.dart';
import 'user_service.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, UserService? userService})
      : _auth = auth ?? FirebaseAuth.instance,
        _userService = userService ?? UserService();

  final FirebaseAuth _auth;
  final UserService _userService;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.updateDisplayName(displayName.trim());
    await credential.user?.sendEmailVerification();
    await _auth.signOut();
    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.reload();
    final user = _auth.currentUser;

    if (user == null || !user.emailVerified) {
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email before signing in.',
      );
    }

    await user.getIdToken(true);

    await _userService.ensureUserDocument(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
    );

    return credential;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await GoogleAuthConfig.ensureInitialized();

      final googleUser = await _googleSignIn.authenticate(
        scopeHint: const ['email', 'profile'],
      );

      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await user.getIdToken(true);
        await _userService.ensureUserDocument(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
        );
      }

      return userCredential;
    } on GoogleAuthNotConfiguredException {
      rethrow;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> resendVerificationEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Account not found.',
      );
    }

    if (user.emailVerified) {
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'email-already-verified',
        message: 'Email is already verified. You can sign in.',
      );
    }

    await user.sendEmailVerification();
    await _auth.signOut();
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  String mapAuthError(FirebaseAuthException error, AppLocalizations l10n) {
    switch (error.code) {
      case 'email-not-verified':
        return l10n.authVerifyEmailBeforeSignIn;
      case 'email-already-verified':
        return l10n.authEmailAlreadyVerified;
      case 'invalid-email':
        return l10n.authInvalidEmail;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return l10n.authIncorrectCredentials;
      case 'email-already-in-use':
        return l10n.authEmailInUse;
      case 'weak-password':
        return l10n.authWeakPassword;
      case 'account-exists-with-different-credential':
        return l10n.authAccountExistsDifferentCredential;
      default:
        return error.message ?? l10n.authFailed;
    }
  }
}
