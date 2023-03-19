import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:quantum_coherence/src/auth/repository/auth_repository.dart';
import 'package:quantum_coherence/src/core/domain/status/status.dart';
import 'package:quantum_coherence/src/user/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<LoggedInWithGoogle>(_onLoggedInWithGoogle);
    on<UserRequested>(_onUserRequested);
  }

  final IAuthRepository _authRepository;

  void _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) {
    final isAuthenticated = _authRepository.isAuthenticated();

    emit(
      state.copyWith(
        authStatus: isAuthenticated
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      ),
    );
  }

  Future<void> _onLoggedInWithGoogle(
    LoggedInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loginStatus: const Status.loading()));

    final failureOrUnit = await _authRepository.signInWithGoogle();

    emit(
      failureOrUnit.fold(
        (f) => state.copyWith(
          loginStatus: Status.failure(f),
          authStatus: AuthStatus.unauthenticated,
        ),
        (f) => state.copyWith(
          loginStatus: const Status.success(),
          authStatus: AuthStatus.authenticated,
        ),
      ),
    );

    if (state.authStatus == AuthStatus.authenticated) {
      add(UserRequested());
    }
  }

  void _onUserRequested(
    UserRequested event,
    Emitter<AuthState> emit,
  ) {
    final user = _authRepository.getCurrentUser();
    emit(state.copyWith(user: user));
  }
}
