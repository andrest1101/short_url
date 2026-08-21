import '../entities/short_url_entity.dart';

abstract interface class IUrlRepository {
  ShortUrlEntity shortenUrl(String originalUrl);

  List<ShortUrlEntity> loadHistory();
}
