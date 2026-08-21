import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/datasources/firebase_url_data_source.dart';
import 'data/datasources/mock_url_data_source.dart';
import 'data/repositories/url_repository_impl.dart';
import 'domain/repositories/url_repository.dart';
import 'domain/usecases/delete_history_usecase.dart';
import 'domain/usecases/get_history_usecase.dart';
import 'domain/usecases/shorten_url_usecase.dart';
import 'domain/utils/url_validator.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final mockUrlDataSourceProvider = Provider<MockUrlDataSource>((ref) {
  return MockUrlDataSource();
});

final firebaseUrlDataSourceProvider = Provider<FirebaseUrlDataSource>((ref) {
  return FirebaseUrlDataSource(ref.watch(firestoreProvider));
});

final urlRepositoryProvider = Provider<IUrlRepository>((ref) {
  return UrlRepositoryImpl(
    ref.watch(mockUrlDataSourceProvider),
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
