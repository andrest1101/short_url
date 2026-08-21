import 'dart:async';

import '../../domain/entities/short_url_entity.dart';
import '../../domain/repositories/url_repository.dart';
import '../datasources/mock_url_data_source.dart';
import '../datasources/url_local_data_source.dart';
import '../models/short_url_model.dart';

class UrlRepositoryImpl implements IUrlRepository {
  final MockUrlDataSource _dataSource;
  final UrlLocalDataSource _localDataSource;

  const UrlRepositoryImpl(this._dataSource, this._localDataSource);

  @override
  ShortUrlEntity shortenUrl(String originalUrl) {
    final ShortUrlModel model = _dataSource.generateShortUrl(originalUrl);
    unawaited(_localDataSource.addUrl(model));
    return model;
  }

  @override
  List<ShortUrlEntity> loadHistory() => _localDataSource.loadHistory();
}
