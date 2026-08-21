import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/short_url_entity.dart';
import '../../domain/exceptions/invalid_url_exception.dart';
import '../../domain/usecases/delete_history_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/shorten_url_usecase.dart';
import '../../injection.dart';

final urlHistoryNotifierProvider =
    NotifierProvider<UrlHistoryNotifier, List<ShortUrlEntity>>(
  UrlHistoryNotifier.new,
);

class UrlHistoryNotifier extends Notifier<List<ShortUrlEntity>> {
  @override
  List<ShortUrlEntity> build() {
    final GetHistoryUseCase useCase = ref.watch(getHistoryUseCaseProvider);
    return useCase();
  }

  bool shorten(String originalUrl) {
    final ShortenUrlUseCase useCase = ref.read(shortenUrlUseCaseProvider);
    try {
      final ShortUrlEntity result = useCase(originalUrl);
      state = [result, ...state];
      return true;
    } on InvalidUrlException {
      return false;
    }
  }

  void delete(ShortUrlEntity item) {
    final DeleteHistoryUseCase useCase = ref.read(deleteHistoryUseCaseProvider);
    useCase(item.shortUrl);
    state = state.where((ShortUrlEntity entry) => entry != item).toList();
  }
}
