import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../domain/entities/short_url_entity.dart';
import '../providers/url_shortener_provider.dart';

class UrlShortenerPage extends ConsumerStatefulWidget {
  const UrlShortenerPage({super.key});

  @override
  ConsumerState<UrlShortenerPage> createState() => _UrlShortenerPageState();
}

class _UrlShortenerPageState extends ConsumerState<UrlShortenerPage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isShortening = false;

  Future<void> _shortenUrl() async {
    if (_isShortening) return;
    final String input = _urlController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL tidak boleh kosong')),
      );
      return;
    }
    setState(() => _isShortening = true);
    final ShortenResult result =
        await ref.read(urlHistoryNotifierProvider.notifier).shorten(input);
    if (!mounted) return;
    setState(() => _isShortening = false);
    switch (result) {
      case ShortenResult.invalidUrl:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'URL tidak valid. Gunakan format https://... atau www...',
            ),
          ),
        );
      case ShortenResult.failure:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan. Periksa koneksi internet Anda'),
          ),
        );
      case ShortenResult.success:
        break;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link pendek disalin')),
    );
  }

  Future<void> _onHistoryDismissed(ShortUrlEntity item) async {
    final bool success =
        await ref.read(urlHistoryNotifierProvider.notifier).delete(item);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Riwayat dihapus' : 'Gagal menghapus riwayat'),
      ),
    );
  }

  Widget _buildDismissBackground(
    ColorScheme colorScheme,
    Alignment alignment,
  ) {
    return Container(
      alignment: alignment,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.error,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Icon(
          Icons.delete_rounded,
          color: colorScheme.onError,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildErrorSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded, size: 48, color: colorScheme.error),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat riwayat',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Periksa koneksi internet Anda',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => ref.invalidate(urlHistoryNotifierProvider),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(
    List<ShortUrlEntity> history,
    ColorScheme colorScheme,
  ) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 28),
        Row(
          children: [
            Icon(Icons.history, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Riwayat',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${history.length})',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final ShortUrlEntity item = history[index];
            return Dismissible(
              key: ValueKey<String>(item.shortUrl),
              direction: DismissDirection.horizontal,
              background: _buildDismissBackground(
                colorScheme,
                Alignment.centerLeft,
              ),
              secondaryBackground: _buildDismissBackground(
                colorScheme,
                Alignment.centerRight,
              ),
              onDismissed: (_) => _onHistoryDismissed(item),
              child: _HistoryItemCard(
                item: item,
                onCopy: () => _copyToClipboard(item.shortUrl),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AsyncValue<List<ShortUrlEntity>> historyAsync =
        ref.watch(urlHistoryNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'URL Shortener',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Card(
                elevation: 6,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _urlController,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _shortenUrl(),
                        decoration: InputDecoration(
                          labelText: 'Masukkan URL panjang',
                          hintText: 'https://contoh.com/artikel/sangat/panjang',
                          prefixIcon: const Icon(Icons.link),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.4),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isShortening ? null : _shortenUrl,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            elevation: 4,
                            shadowColor: colorScheme.primary
                                .withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: _isShortening
                              ? SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : const Text('Shorten'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              historyAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (Object error, StackTrace stackTrace) =>
                    _buildErrorSection(colorScheme),
                data: (List<ShortUrlEntity> history) =>
                    _buildHistorySection(history, colorScheme),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryItemCard extends StatefulWidget {
  final ShortUrlEntity item;
  final VoidCallback onCopy;

  const _HistoryItemCard({
    required this.item,
    required this.onCopy,
  });

  @override
  State<_HistoryItemCard> createState() => _HistoryItemCardState();
}

class _HistoryItemCardState extends State<_HistoryItemCard> {
  bool _showQr = false;

  void _toggleQr() {
    setState(() => _showQr = !_showQr);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  colorScheme.primaryContainer.withValues(alpha: 0.6),
              child: Icon(
                Icons.link,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            title: Text(
              widget.item.shortUrl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              widget.item.originalUrl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _toggleQr,
                  icon: Icon(_showQr ? Icons.qr_code_2 : Icons.qr_code),
                  tooltip: _showQr ? 'Sembunyikan QR' : 'Tampilkan QR',
                  color: _showQr
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                IconButton(
                  onPressed: widget.onCopy,
                  icon: const Icon(Icons.copy_rounded),
                  tooltip: 'Salin link',
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
          if (_showQr)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: QrImageView(
                    data: widget.item.shortUrl,
                    size: 150,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
