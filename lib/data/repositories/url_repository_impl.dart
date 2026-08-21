import '../../domain/entities/short_url_entity.dart';
import '../../domain/repositories/url_repository.dart';
import '../datasources/firebase_url_data_source.dart';
import '../datasources/tiny_url_api_data_source.dart';
import '../models/short_url_model.dart';

class UrlRepositoryImpl implements IUrlRepository {
  final TinyUrlApiDataSource _apiDataSource;
  final FirebaseUrlDataSource _remoteDataSource;

  const UrlRepositoryImpl(this._apiDataSource, this._remoteDataSource);

  @override
  Future<ShortUrlEntity> shortenUrl(String originalUrl) async {
    final ShortUrlModel model = await _apiDataSource.shorten(originalUrl);
    await _remoteDataSource.addUrl(model);
    return model;
  }

  @override
  Future<List<ShortUrlEntity>> loadHistory() async {
    final List<ShortUrlModel> history = await _remoteDataSource.getHistory();
    return List<ShortUrlEntity>.from(history);
  }

  @override
  Future<void> deleteHistory(String shortUrl) {
    return _remoteDataSource.deleteUrl(shortUrl);
  }
}
