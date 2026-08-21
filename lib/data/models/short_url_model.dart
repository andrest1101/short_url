import '../../domain/entities/short_url_entity.dart';

class ShortUrlModel extends ShortUrlEntity {
  const ShortUrlModel({
    required super.originalUrl,
    required super.shortUrl,
  });
}
