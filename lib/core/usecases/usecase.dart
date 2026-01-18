import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

// Abstract base class for all UseCases in the application
// Type: The return type of the UseCase (wrapped in Either<Failure, Type>)
// Params: The parameters needed to execute the UseCase
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Class used when a UseCase does not requires any parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
