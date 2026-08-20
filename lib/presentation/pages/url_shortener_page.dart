import 'package:flutter/material.dart';

import '../../domain/repositories/url_shortener_repository.dart';
import '../../data/models/short_url_model.dart';

class UrlShortenerPage extends StatefulWidget {
  const UrlShortenerPage({super.key});

  @override
  State<UrlShortenerPage> createState() => _UrlShortenerPageState();
}

class _UrlShortenerPageState extends State<UrlShortenerPage> {
  final TextEditingController _urlController = TextEditingController();
  final UrlShortenerRepository _repository = UrlShortenerRepository();

  String? _shortUrl;

  void _shortenUrl() {
    final input = _urlController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL tidak boleh kosong')),
      );
      return;
    }
    final ShortUrlModel result = _repository.shorten(input);
    setState(() {
      _shortUrl = result.shortUrl;
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Shortener'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Masukkan URL panjang',
                hintText: 'https://contoh.com/artikel/sangat/panjang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _shortenUrl,
              child: const Text('Shorten'),
            ),
            const SizedBox(height: 24),
            if (_shortUrl != null)
              Column(
                children: [
                  const Text('Link pendek:'),
                  const SizedBox(height: 8),
                  SelectableText(
                    _shortUrl!,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}