import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';
import '../widgets/layout.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  static const _projects = [
    _ProjectData(
      'E-Commerce Platform',
      'A full-featured online store built with Flutter web. Features include product catalog, cart, checkout, and admin dashboard.',
      'Flutter, Stripe, Firebase',
      Icons.shopping_cart,
      '/projects/1',
    ),
    _ProjectData(
      'Real-Time Dashboard',
      'Real-time analytics dashboard with live charts, data tables, and export capabilities. Handles millions of data points.',
      'Flutter, WebSockets, Charts',
      Icons.dashboard,
      '/projects/2',
    ),
    _ProjectData(
      'Social Media App',
      'A social media platform with posts, stories, messaging, and notifications. Fully responsive web app.',
      'Flutter, GraphQL, Firebase',
      Icons.people,
      '/projects/3',
    ),
    _ProjectData(
      'AI Content Generator',
      'Leverage AI to generate blog posts, social media content, and marketing copy. Built-in SEO optimization.',
      'Flutter, OpenAI, Riverpod',
      Icons.auto_awesome,
      '/projects/4',
    ),
    _ProjectData(
      'Portfolio CMS',
      'A headless CMS for developers to manage their portfolio. Drag-and-drop builder with live preview.',
      'Flutter, Supabase, Riverpod',
      Icons.web,
      '/projects/5',
    ),
    _ProjectData(
      'Task Management Tool',
      'Kanban-style project management tool with real-time collaboration, file sharing, and team management.',
      'Flutter, WebRTC, Hive',
      Icons.checklist,
      '/projects/6',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SeoController.of(context).updatePage(const SeoData(
      title: 'Projects - SFWF Showcase',
      description:
          'Explore amazing Flutter web projects built with Smart Flutter Web Framework. E-commerce, dashboards, AI apps, and more.',
      keywords: 'Flutter projects, web apps, portfolio, Flutter showcase',
      ogType: 'website',
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
            Text('Our Projects',
                style: TextStyle(
                  fontSize: DeviceDetector.isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(
              'Real-world Flutter web applications built with SFWF',
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
                crossAxisCount: DeviceDetector.isDesktop ? 3 : 1,
                childAspectRatio: DeviceDetector.isDesktop ? 1.0 : 1.2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              itemCount: _projects.length,
              itemBuilder: (ctx, i) => _ProjectCard(_projects[i]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectData {
  final String title;
  final String description;
  final String tech;
  final IconData icon;
  final String route;
  const _ProjectData(this.title, this.description, this.tech, this.icon, this.route);
}

class _ProjectCard extends StatelessWidget {
  final _ProjectData data;
  const _ProjectCard(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, data.route),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(data.icon, size: 32, color: theme.colorScheme.primary),
                  const Spacer(),
                  Icon(Icons.arrow_forward,
                      size: 20, color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 16),
              Text(data.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Expanded(
                child: Text(data.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 12),
              Chip(
                label: Text(data.tech, style: const TextStyle(fontSize: 11)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
