import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';
import '../widgets/layout.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  static const _projects = {
    '1': _ProjectDetail(
      'E-Commerce Platform',
      'A full-featured online store built with Flutter web.',
      'Flutter, Stripe, Firebase, Riverpod',
      'This project demonstrates a complete e-commerce solution with product management, shopping cart, secure checkout via Stripe, order tracking, and an admin dashboard. Built entirely with Flutter web and SFWF for optimal SEO and performance.',
      ['Product catalog with search & filters', 'Shopping cart & wishlist',
       'Secure Stripe checkout', 'Admin dashboard', 'Order management',
       'Analytics & reporting'],
    ),
    '2': _ProjectDetail(
      'Real-Time Dashboard',
      'Analytics dashboard with live data visualization.',
      'Flutter, WebSockets, Charts',
      'A high-performance real-time dashboard capable of handling millions of data points. Features interactive charts, data tables, export functionality, and customizable widgets.',
      ['Live WebSocket data streaming', 'Interactive charts & graphs',
       'Data export (CSV, PDF)', 'Customizable widgets',
       'Real-time notifications', 'Dark/light theme'],
    ),
    '3': _ProjectDetail(
      'Social Media App',
      'Social platform with real-time messaging.',
      'Flutter, GraphQL, Firebase',
      'A fully responsive social media application with news feed, stories, direct messaging, push notifications, and content moderation.',
      ['News feed with algorithm', 'Stories & media sharing',
       'Real-time messaging', 'Push notifications',
       'Content moderation', 'Profile management'],
    ),
  };

  static const _fallback = _ProjectDetail(
    'Project Details',
    'Project details coming soon.',
    'Various',
    'This project is currently being documented. Check back soon for a full case study.',
    ['More details coming soon'],
  );

  @override
  Widget build(BuildContext context) {
    final project = _projects[projectId] ?? _fallback;

    SeoController.of(context).updatePage(SeoData(
      title: '${project.title} - SFWF Showcase',
      description: project.shortDesc,
      ogType: 'article',
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
            InkWell(
              onTap: () => Navigator.pushNamed(context, '/projects'),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, size: 20),
                  const SizedBox(width: 8),
                  Text('Back to Projects',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(project.title,
                style: TextStyle(
                  fontSize: DeviceDetector.isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(project.shortDesc,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )),
            const SizedBox(height: 16),
            Chip(label: Text(project.tech)),
            const SizedBox(height: 32),
            Text(project.description,
                style: const TextStyle(fontSize: 16, height: 1.6)),
            const SizedBox(height: 32),
            Text('Key Features',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                )),
            const SizedBox(height: 16),
            ...project.features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Text(f, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _ProjectDetail {
  final String title;
  final String shortDesc;
  final String tech;
  final String description;
  final List<String> features;

  const _ProjectDetail(
      this.title, this.shortDesc, this.tech, this.description, this.features);
}
