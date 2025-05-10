import 'package:city_guide_app/features/auth/data/user.dart' as user_model;
import 'package:city_guide_app/features/auth/domain/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  user_model.User getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return const user_model.User.empty();
    }

    return user_model.User(
      id: user.uid,
      name: user.displayName,
    );
  }

  @override
  Future<user_model.User> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw Exception('Firebase sign-in failed');
      }

      return user_model.User(
        id: user.uid,
        name: user.displayName,
      );
    } on Exception catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() {
    try {
      return Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      rethrow;
    }
  }
}
