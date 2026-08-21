import '../entities/short_url_entity.dart';
import '../repositories/url_repository.dart';

class GetHistoryUseCase {
  final IUrlRepository _repository;

  const GetHistoryUseCase(this._repository);

  List<ShortUrlEntity> call() {
    return _repository.loadHistory();
  }
}
