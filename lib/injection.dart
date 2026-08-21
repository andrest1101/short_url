import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/datasources/mock_url_data_source.dart';
import 'data/repositories/url_repository_impl.dart';
import 'domain/repositories/url_repository.dart';
import 'domain/usecases/shorten_url_usecase.dart';

final mockUrlDataSourceProvider = Provider<MockUrlDataSource>((ref) {
  return MockUrlDataSource();
});

final urlRepositoryProvider = Provider<IUrlRepository>((ref) {
  return UrlRepositoryImpl(ref.watch(mockUrlDataSourceProvider));
});

final shortenUrlUseCaseProvider = Provider<ShortenUrlUseCase>((ref) {
  return ShortenUrlUseCase(ref.watch(urlRepositoryProvider));
});
