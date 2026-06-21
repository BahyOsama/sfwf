import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';
import '../widgets/layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SeoController.of(context).updatePage(const SeoData(
      title: 'Home - Smart Flutter Web Framework',
      description:
          'SFWF is the ultimate Flutter web framework with SEO, SSR, PWA, and AI optimization. Build production-grade web apps with Flutter.',
      keywords: 'Flutter web, SEO, SSR, PWA, Flutter framework, web development',
      ogType: 'website',
      structuredData: {
        '@context': 'https://schema.org',
        '@type': 'SoftwareApplication',
        'name': 'Smart Flutter Web Framework',
        'applicationCategory': 'WebApplication',
        'operatingSystem': 'Web',
        'description':
            'Production-ready Flutter web framework with SEO, SSR, pre-rendering, and AI optimization.',
      },
    ));

    return AppLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _HeroSection(),
            _FeaturesSection(),
            _StatsSection(),
            _CTASection(),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = DeviceDetector.isDesktop;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: isDesktop ? 80 : 48,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.flutter_dash, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'Smart Flutter Web Framework',
            style: TextStyle(
              fontSize: isDesktop ? 48 : 32,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'The Ultimate Solution for Flutter Web — SEO, SSR, PWA, AI Optimization',
            style: TextStyle(
              fontSize: isDesktop ? 20 : 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/projects'),
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Get Started'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/contact'),
                icon: const Icon(Icons.chat),
                label: const Text('Contact Us'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  static const _features = [
    _FeatureData(Icons.search, 'SEO Engine',
        'Dynamic meta tags, Open Graph, JSON-LD structured data, sitemap.xml, robots.txt. Rank #1 on search engines.'),
    _FeatureData(Icons.dns, 'Server-Side Rendering',
        'Full SSR with Puppeteer or Dart server. Pre-rendering for static HTML. Hydration for interactivity.'),
    _FeatureData(Icons.phonelink, 'PWA Support',
        'Service Worker generation, offline caching, manifest.json. Your app works offline like native.'),
    _FeatureData(Icons.alt_route, 'Smart Router',
        'Clean URLs without hash. Dynamic route params (/user/:id). Middleware, guards, custom transitions.'),
    _FeatureData(Icons.speed, 'Performance',
        'Lazy loading, image optimization, code splitting patterns. Fast initial load and smooth interactions.'),
    _FeatureData(Icons.auto_awesome, 'AI Integration',
        'Automatic SEO analysis with OpenAI. Get recommendations to improve your site visibility.'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = DeviceDetector.isDesktop;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 64,
      ),
      child: Column(
        children: [
          Text(
            'Why SFWF?',
            style: TextStyle(
              fontSize: isDesktop ? 36 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Solving real Flutter web problems',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 3 : 1,
                childAspectRatio: isDesktop ? 1.1 : 1.3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
            itemCount: _features.length,
            itemBuilder: (ctx, i) => _FeatureCard(_features[i]),
          ),
        ],
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  const _FeatureData(this.icon, this.title, this.description);
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData data;
  const _FeatureCard(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(data.icon, size: 36, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(data.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: Text(data.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: const Wrap(
        spacing: 48,
        runSpacing: 32,
        alignment: WrapAlignment.center,
        children: [
          _StatItem('100%', 'SEO Score'),
          _StatItem('<2s', 'Load Time'),
          _StatItem('PWA', 'Ready'),
          _StatItem('SSR', 'Built-in'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _CTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Column(
        children: [
          Text('Ready to Build?',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface)),
          const SizedBox(height: 16),
          Text(
            'Join the future of Flutter web development',
            style: TextStyle(
                fontSize: 16, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/projects'),
            icon: const Icon(Icons.rocket_launch),
            label: const Text('Explore Projects'),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      color: theme.colorScheme.surfaceContainerHigh,
      child: Text(
        'Built with Smart Flutter Web Framework',
        textAlign: TextAlign.center,
        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}
