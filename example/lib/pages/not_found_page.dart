import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';
import '../widgets/layout.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    SeoController.of(context).updatePage(const SeoData(
      title: '404 - Page Not Found | SFWF Showcase',
      description: 'The page you are looking for does not exist or has been moved.',
      noIndex: true,
    ));

    final theme = Theme.of(context);
    return AppLayout(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 120, color: theme.colorScheme.error),
              const SizedBox(height: 24),
              Text('404',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  )),
              const SizedBox(height: 8),
              Text('Page Not Found',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  )),
              const SizedBox(height: 16),
              Text(
                'The page you are looking for does not exist or has been moved.',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () =>
                    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
