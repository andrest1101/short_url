import '../repositories/url_repository.dart';

class DeleteHistoryUseCase {
  final IUrlRepository _repository;

  const DeleteHistoryUseCase(this._repository);

  void call(String shortUrl) {
    _repository.deleteHistory(shortUrl);
  }
}
