import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> register({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw 'THIS EMAIL IS ALREADY REGISTERED';
        case 'weak-password':
          throw 'PASSWORD IS TOO WEAK';
        case 'too-many-requests':
          throw 'TOO MANY ATTEMPTS. TRY AGAIN LATER';
        default:
          throw 'INVALID REGISTRATION DETAILS, TRY AGAIN';
      }
    }
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await user.reload();
        user = _auth.currentUser;

        if (!user!.emailVerified) {
          await _auth.signOut();
          throw 'EMAIL NOT VERIFIED. PLEASE CHECK YOUR INBOX.';
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'ACCOUNT NOT FOUND';
        case 'wrong-password':
          throw 'INCORRECT PASSWORD';
        case 'too-many-requests':
          throw 'TOO MANY ATTEMPTS. TRY AGAIN LATER';
        default:
          throw 'INCORRECT LOGIN DETAILS, TRY AGAIN';
      }
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        throw 'PLEASE WAIT BEFORE REQUESTING ANOTHER EMAIL';
      }
      throw 'UNABLE TO RESEND VERIFICATION EMAIL';
    }
  }

  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;

    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }

    return false;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}