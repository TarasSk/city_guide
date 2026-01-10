import 'package:auth/src/data/user.dart';
import 'package:auth/src/domain/auth_repository.dart';
import 'package:dependencies/dependencies.dart' hide User;

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  User getCurrentUser() {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return const User.empty();
    }

    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName,
    );
  }

  @override
  Future<User> signInWithGoogle() async {
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
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase sign-in failed');
      }

      return User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName,
      );
    } catch (e) {
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
