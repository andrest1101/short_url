import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/firebase_url_data_source.dart';
import 'data/datasources/tiny_url_api_data_source.dart';
import 'data/repositories/url_repository_impl.dart';
import 'domain/repositories/url_repository.dart';
import 'domain/usecases/delete_history_usecase.dart';
import 'domain/usecases/get_history_usecase.dart';
import 'domain/usecases/shorten_url_usecase.dart';
import 'domain/utils/url_validator.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final tinyUrlApiDataSourceProvider = Provider<TinyUrlApiDataSource>((ref) {
  return TinyUrlApiDataSource(ref.watch(httpClientProvider));
});

final firebaseUrlDataSourceProvider = Provider<FirebaseUrlDataSource>((ref) {
  return FirebaseUrlDataSource(ref.watch(firestoreProvider));
});

final urlRepositoryProvider = Provider<IUrlRepository>((ref) {
  return UrlRepositoryImpl(
    ref.watch(tinyUrlApiDataSourceProvider),
    ref.watch(firebaseUrlDataSourceProvider),
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
