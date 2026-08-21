class ShortUrlEntity {
  final String originalUrl;
  final String shortUrl;
  final DateTime createdAt;

  const ShortUrlEntity({
    required this.originalUrl,
    required this.shortUrl,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortUrlEntity &&
          runtimeType == other.runtimeType &&
          originalUrl == other.originalUrl &&
          shortUrl == other.shortUrl &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(originalUrl, shortUrl, createdAt);
}
