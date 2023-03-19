import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:quantum_coherence/src/core/domain/failure/failure.dart';
import 'package:quantum_coherence/src/user/models/user.dart';

abstract class IAuthRepository {
  bool isAuthenticated();
  Future<Either<Failure, Unit>> signInWithGoogle();
  User getCurrentUser();
}

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(this._firebaseAuth, this._googleSignIn);

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  bool isAuthenticated() => _firebaseAuth.currentUser != null;

  @override
  Future<Either<Failure, Unit>> signInWithGoogle() async {
    try {
      final googleAccount = await _googleSignIn.signIn();

      if (googleAccount == null) {
        return left(const Failure.common('Failed to Sign In!'));
      }

      final googleAuthentication = await googleAccount.authentication;

      final authcredential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken,
      );

      await _firebaseAuth.signInWithCredential(authcredential);

      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(Failure.common(e.toString()));
    } catch (e) {
      return left(Failure.common(e.toString()));
    }
  }

  @override
  User getCurrentUser() {
    final firebaseUser = _firebaseAuth.currentUser!;
    final user = User(
      uid: firebaseUser.uid,
      token: firebaseUser.refreshToken!,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
    );
    return user;
  }
}
