import '../../domain/entities/short_url_entity.dart';
import '../../domain/repositories/url_repository.dart';
import '../datasources/mock_url_data_source.dart';

class UrlRepositoryImpl implements IUrlRepository {
  final MockUrlDataSource _dataSource;

  const UrlRepositoryImpl(this._dataSource);

  @override
  ShortUrlEntity shortenUrl(String originalUrl) {
    return _dataSource.generateShortUrl(originalUrl);
  }
}
