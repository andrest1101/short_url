import '../../domain/entities/short_url_entity.dart';

class ShortUrlModel extends ShortUrlEntity {
  const ShortUrlModel({
    required super.originalUrl,
    required super.shortUrl,
  });

  factory ShortUrlModel.fromJson(Map<String, dynamic> json) {
    return ShortUrlModel(
      originalUrl: json['originalUrl'] as String,
      shortUrl: json['shortUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'originalUrl': originalUrl,
        'shortUrl': shortUrl,
      };
}
