import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.uid = '',
    this.token = '',
    this.name = '',
    this.email = '',
  });

  final String uid;
  final String token;
  final String name;
  final String email;

  static const empty = User();
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  @override
  List<Object> get props => [uid, token, name, email];
}
