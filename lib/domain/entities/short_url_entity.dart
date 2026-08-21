class ShortUrlEntity {
  final String originalUrl;
  final String shortUrl;

  const ShortUrlEntity({
    required this.originalUrl,
    required this.shortUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortUrlEntity &&
          runtimeType == other.runtimeType &&
          originalUrl == other.originalUrl &&
          shortUrl == other.shortUrl;

  @override
  int get hashCode => Object.hash(originalUrl, shortUrl);
}
