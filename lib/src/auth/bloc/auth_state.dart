part of 'auth_bloc.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.authStatus = AuthStatus.initial,
    this.loginStatus = const Status.initial(),
    this.user = User.empty,
  });

  final AuthStatus authStatus;
  final Status loginStatus;
  final User user;

  @override
  List<Object> get props => [authStatus, loginStatus, user];

  AuthState copyWith({
    AuthStatus? authStatus,
    Status? loginStatus,
    User? user,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      loginStatus: loginStatus ?? this.loginStatus,
      user: user ?? this.user,
    );
  }

  @override
  String toString() =>
      '''
AuthState(authStatus: $authStatus, loginStatus: $loginStatus, user: $user)''';
}
