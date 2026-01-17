import 'package:equatable/equatable.dart';

// Abstract base class representing a failure in the application
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Represent failures occurring at the server/API level
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Represent failures occurring at the local cache level
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Represent failures occurring at the network level (e.g., no internet)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
