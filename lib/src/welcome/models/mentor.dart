import 'package:equatable/equatable.dart';

class Mentor extends Equatable {
  const Mentor({this.name = '', this.image = ''});

  final String name;
  final String image;

  static const empty = Mentor();
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  @override
  List<Object> get props => [name, image];
}
