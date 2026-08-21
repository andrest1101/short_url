import '../repositories/url_repository.dart';

class DeleteHistoryUseCase {
  final IUrlRepository _repository;

  const DeleteHistoryUseCase(this._repository);

  Future<void> call(String shortUrl) {
    return _repository.deleteHistory(shortUrl);
  }
}
