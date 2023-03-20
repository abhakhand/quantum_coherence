part of 'auth_bloc.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.authStatus = AuthStatus.initial,
    this.loginStatus = const Status.initial(),
    this.user = User.empty,
    this.logoutStatus = const Status.initial(),
  });

  final AuthStatus authStatus;
  final Status loginStatus;
  final User user;
  final Status logoutStatus;

  @override
  List<Object> get props => [authStatus, loginStatus, user, logoutStatus];

  AuthState copyWith({
    AuthStatus? authStatus,
    Status? loginStatus,
    User? user,
    Status? logoutStatus,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      loginStatus: loginStatus ?? this.loginStatus,
      user: user ?? this.user,
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }

  @override
  String toString() {
    return '''
AuthState(authStatus: $authStatus, loginStatus: $loginStatus, user: $user, logoutStatus: $logoutStatus)''';
  }
}
