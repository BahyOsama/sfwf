import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfwf/sfwf.dart';
import '../providers/providers.dart';
import '../widgets/layout.dart';

class BlogDetailPage extends ConsumerWidget {
  final String postId;
  const BlogDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(blogPostBySlugProvider(postId));
    final isDesktop = DeviceDetector.isDesktop;
    final theme = Theme.of(context);

    if (post == null) {
      return AppLayout(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article, size: 80, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text('Post not found',
                  style: TextStyle(fontSize: 20, color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, '/blog'),
                child: const Text('Back to Blog'),
              ),
            ],
          ),
        ),
      );
    }

    SeoController.of(context).updatePage(SeoData(
      title: '${post.title} - SFWF Blog',
      description: post.description,
      ogType: 'article',
      structuredData: {
        '@context': 'https://schema.org',
        '@type': 'Article',
        'headline': post.title,
        'description': post.description,
      },
    ));

    return AppLayout(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : 24,
          vertical: 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, size: 20),
                  const SizedBox(width: 8),
                  Text('Back to Blog',
                      style: TextStyle(color: theme.colorScheme.primary)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Chip(label: Text(post.category, style: const TextStyle(fontSize: 12))),
            const SizedBox(height: 12),
            Text(post.title,
                style: TextStyle(
                  fontSize: isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(post.author,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(post.date,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(width: 16),
                Text(post.readTime,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 24),
            Text(post.body,
                style: const TextStyle(fontSize: 16, height: 1.6)),
          ],
        ),
      ),
    );
  }
}
