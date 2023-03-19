import 'package:equatable/equatable.dart';
import 'package:quantum_coherence/src/welcome/models/mentor.dart';

class Session extends Equatable {
  const Session({
    this.id = '',
    this.name = '',
    this.description = '',
    this.image = '',
    this.mentor = Mentor.empty,
  });

  final String id;
  final String name;
  final String description;
  final String image;
  final Mentor mentor;

  static const empty = Session();
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  @override
  List<Object> get props => [id, name, description, image, mentor];
}
