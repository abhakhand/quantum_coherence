part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStatusChecked extends AuthEvent {}

class LoggedInWithGoogle extends AuthEvent {}

class UserRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
