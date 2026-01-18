import 'package:auth/src/data/user.dart';

abstract interface class AuthRepository {
  User getCurrentUser();
  Future<void> signOut();

  /// Signs in the user with Google authentication.
  ///
  /// Returns a [User] object if the sign-in is successful.
  /// Throws an exception if the sign-in fails.
  Future<User> signInWithGoogle();
}
