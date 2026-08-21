import '../entities/short_url_entity.dart';
import '../exceptions/invalid_url_exception.dart';
import '../repositories/url_repository.dart';
import '../utils/url_validator.dart';

class ShortenUrlUseCase {
  final IUrlRepository _repository;
  final UrlValidator _validator;

  const ShortenUrlUseCase(this._repository, this._validator);

  ShortUrlEntity call(String originalUrl) {
    final String? normalizedUrl = _validator.normalize(originalUrl);
    if (normalizedUrl == null) {
      throw InvalidUrlException(originalUrl);
    }
    return _repository.shortenUrl(normalizedUrl);
  }
}
