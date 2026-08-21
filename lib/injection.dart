import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/mock_url_data_source.dart';
import 'data/datasources/url_local_data_source.dart';
import 'data/repositories/url_repository_impl.dart';
import 'domain/repositories/url_repository.dart';
import 'domain/usecases/delete_history_usecase.dart';
import 'domain/usecases/get_history_usecase.dart';
import 'domain/usecases/shorten_url_usecase.dart';
import 'domain/utils/url_validator.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider harus di-override di main.dart',
  );
});

final mockUrlDataSourceProvider = Provider<MockUrlDataSource>((ref) {
  return MockUrlDataSource();
});

final urlLocalDataSourceProvider = Provider<UrlLocalDataSource>((ref) {
  return UrlLocalDataSource(ref.watch(sharedPreferencesProvider));
});

final urlRepositoryProvider = Provider<IUrlRepository>((ref) {
  return UrlRepositoryImpl(
    ref.watch(mockUrlDataSourceProvider),
    ref.watch(urlLocalDataSourceProvider),
  );
});

final urlValidatorProvider = Provider<UrlValidator>((ref) {
  return const UrlValidator();
});

final shortenUrlUseCaseProvider = Provider<ShortenUrlUseCase>((ref) {
  return ShortenUrlUseCase(
    ref.watch(urlRepositoryProvider),
    ref.watch(urlValidatorProvider),
  );
});

final getHistoryUseCaseProvider = Provider<GetHistoryUseCase>((ref) {
  return GetHistoryUseCase(ref.watch(urlRepositoryProvider));
});

final deleteHistoryUseCaseProvider = Provider<DeleteHistoryUseCase>((ref) {
  return DeleteHistoryUseCase(ref.watch(urlRepositoryProvider));
});
