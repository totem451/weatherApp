import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/weather_repository.dart';

class GetFavoriteCities implements UseCase<List<String>, NoParams> {
  final WeatherRepository repository;

  GetFavoriteCities(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getFavoriteCities();
  }
}
