import '../entities/short_url_entity.dart';

abstract interface class IUrlRepository {
  Future<ShortUrlEntity> shortenUrl(String originalUrl);

  Future<List<ShortUrlEntity>> loadHistory();

  Future<void> deleteHistory(String shortUrl);
}
