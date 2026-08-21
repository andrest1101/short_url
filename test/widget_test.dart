import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:short_url/main.dart';

void main() {
  testWidgets('shortening a url adds an entry to history', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('URL Shortener'), findsOneWidget);
    expect(find.text('Riwayat'), findsNothing);

    await tester.enterText(
      find.byType(TextField),
      'https://contoh.com/artikel/sangat/panjang',
    );
    await tester.tap(find.text('Shorten'));
    await tester.pump();

    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.textContaining('https://short.url/'), findsOneWidget);
    expect(
      find.text('https://contoh.com/artikel/sangat/panjang'),
      findsOneWidget,
    );
  });

  testWidgets('empty input shows validation snackbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    await tester.tap(find.text('Shorten'));
    await tester.pump();

    expect(find.text('URL tidak boleh kosong'), findsOneWidget);
    expect(find.text('Riwayat'), findsNothing);
  });
}
