import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sfwf/sfwf.dart';

final counterProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerWidget {
  // ✅ تغيير من StatelessWidget إلى ConsumerWidget
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seo = SeoController.of(context);
    seo.updatePage(const SeoData(
      title: 'Home - Bahy Developer',
      description:
          'Welcome to Bahy Developer portfolio. Expert in Flutter, Web, and AI.',
      structuredData: {
        '@context': 'https://schema.org',
        '@type': 'Person',
        'name': 'Bahy',
        'url': 'https://bahy.dev',
        'sameAs': ['https://twitter.com/bahydev', 'https://github.com/bahy'],
      },
    ));

    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bahy Developer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Bahy Developer',
                style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Text('Count: $count', style: const TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state++,
              child: const Text('Increment'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/projects'),
              child: const Text('View Projects'),
            ),
          ],
        ),
      ),
    );
  }
}
