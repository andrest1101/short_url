import '../entities/short_url_entity.dart';
import '../repositories/url_repository.dart';

class ShortenUrlUseCase {
  final IUrlRepository _repository;

  const ShortenUrlUseCase(this._repository);

  ShortUrlEntity call(String originalUrl) {
    return _repository.shortenUrl(originalUrl);
  }
}
