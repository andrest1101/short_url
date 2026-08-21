import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/short_url_entity.dart';
import '../../domain/exceptions/invalid_url_exception.dart';
import '../../domain/usecases/delete_history_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/shorten_url_usecase.dart';
import '../../injection.dart';

enum ShortenResult { success, invalidUrl, failure }

final urlHistoryNotifierProvider =
    AsyncNotifierProvider<UrlHistoryNotifier, List<ShortUrlEntity>>(
  UrlHistoryNotifier.new,
);

class UrlHistoryNotifier extends AsyncNotifier<List<ShortUrlEntity>> {
  @override
  Future<List<ShortUrlEntity>> build() {
    final GetHistoryUseCase useCase = ref.watch(getHistoryUseCaseProvider);
    return useCase();
  }

  Future<ShortenResult> shorten(String originalUrl) async {
    final ShortenUrlUseCase useCase = ref.read(shortenUrlUseCaseProvider);
    try {
      final ShortUrlEntity result = await useCase(originalUrl);
      final List<ShortUrlEntity> current = state.value ?? const [];
      state = AsyncData([result, ...current]);
      return ShortenResult.success;
    } on InvalidUrlException {
      return ShortenResult.invalidUrl;
    } catch (_) {
      return ShortenResult.failure;
    }
  }

  Future<bool> delete(ShortUrlEntity item) async {
    final DeleteHistoryUseCase useCase = ref.read(deleteHistoryUseCaseProvider);
    final List<ShortUrlEntity> previous = state.value ?? const [];
    state = AsyncData(
      previous.where((ShortUrlEntity entry) => entry != item).toList(),
    );
    try {
      await useCase(item.shortUrl);
      return true;
    } catch (_) {
      state = AsyncData(previous);
      return false;
    }
  }
}
