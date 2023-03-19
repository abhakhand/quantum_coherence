import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure implements Exception {
  const factory Failure.common(String? message) = _Common;
  const factory Failure.value(String? message) = _Value;
  const factory Failure.connection() = _Connection;
  const factory Failure.server({String? message, int? code}) = ServerError;
  const factory Failure.unexpected(String? message) = _Unexpected;
}
