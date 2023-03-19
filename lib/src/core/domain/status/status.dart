import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quantum_coherence/src/core/domain/failure/failure.dart';

part 'status.freezed.dart';

@freezed
class Status with _$Status {
  const Status._();

  const factory Status.initial() = _Initial;
  const factory Status.loading() = _Loading;
  const factory Status.empty() = _Empty;
  const factory Status.success() = _Success;
  const factory Status.failure([Failure? failure]) = _StatusFailure;

  bool get isInitial => this == const Status.initial();
  bool get isLoading => this == const Status.loading();
  bool get isSuccess => this == const Status.success();
}
