import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';
import '../widgets/layout.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  static const _posts = [
    _BlogPost(
      'Flutter Web in 2026: The Complete Guide',
      'Discover why Flutter web has become the go-to framework for building production web apps. We cover SEO, performance, and real-world case studies.',
      'Flutter Web',
      '5 min read',
      Icons.web,
    ),
    _BlogPost(
      'Why SEO Matters for Flutter Web Apps',
      'Learn how to make your Flutter web app search-engine friendly with dynamic meta tags, structured data, and server-side rendering.',
      'SEO',
      '4 min read',
      Icons.search,
    ),
    _BlogPost(
      'Building PWA with Flutter: Complete Tutorial',
      'Step-by-step guide to adding Progressive Web App support to your Flutter web project. Service workers, manifests, offline support.',
      'PWA',
      '7 min read',
      Icons.phonelink,
    ),
    _BlogPost(
      'Performance Optimization for Flutter Web',
      'Tips and techniques to optimize your Flutter web app for speed. Lazy loading, image optimization, code splitting, and more.',
      'Performance',
      '6 min read',
      Icons.speed,
    ),
    _BlogPost(
      'Server-Side Rendering with Flutter',
      'Implement SSR in Flutter web apps using Puppeteer. Improve initial load time and SEO with pre-rendered HTML.',
      'SSR',
      '8 min read',
      Icons.dns,
    ),
    _BlogPost(
      'State Management in Flutter Web',
      'Compare Riverpod, Bloc, and Provider for Flutter web. Best practices for scalable state management in large web applications.',
      'State Management',
      '6 min read',
      Icons.account_tree,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SeoController.of(context).updatePage(const SeoData(
      title: 'Blog - SFWF Showcase',
      description:
          'Tutorials and guides about Flutter web development, SEO, PWA, performance optimization, and the Smart Flutter Web Framework.',
      keywords: 'Flutter blog, web development tutorials, Flutter SEO, PWA Flutter',
      ogType: 'blog',
    ));

    return AppLayout(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: DeviceDetector.isDesktop ? 80 : 24,
          vertical: 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Latest Articles',
                style: TextStyle(
                  fontSize: DeviceDetector.isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(
              'Tutorials, guides, and insights about Flutter web development',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 48),
            ..._posts.map((post) => _BlogCard(post)),
          ],
        ),
      ),
    );
  }
}

class _BlogPost {
  final String title;
  final String description;
  final String category;
  final String readTime;
  final IconData icon;
  const _BlogPost(this.title, this.description, this.category, this.readTime, this.icon);
}

class _BlogCard extends StatelessWidget {
  final _BlogPost post;
  const _BlogCard(this.post);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(post.icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(
                          label: Text(post.category,
                              style: const TextStyle(fontSize: 11)),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 8),
                        Text(post.readTime,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurfaceVariant,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(post.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(post.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
