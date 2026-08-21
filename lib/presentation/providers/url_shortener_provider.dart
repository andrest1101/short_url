import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/short_url_entity.dart';
import '../../domain/usecases/shorten_url_usecase.dart';
import '../../injection.dart';

final urlHistoryNotifierProvider =
    NotifierProvider<UrlHistoryNotifier, List<ShortUrlEntity>>(
  UrlHistoryNotifier.new,
);

class UrlHistoryNotifier extends Notifier<List<ShortUrlEntity>> {
  @override
  List<ShortUrlEntity> build() => const [];

  void shorten(String originalUrl) {
    final ShortenUrlUseCase useCase = ref.read(shortenUrlUseCaseProvider);
    final ShortUrlEntity result = useCase(originalUrl);
    state = [result, ...state];
  }
}
