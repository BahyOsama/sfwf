import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfwf/sfwf.dart';
import '../providers/providers.dart';
import '../widgets/layout.dart';

class ProjectDetailPage extends ConsumerWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectByIdProvider(projectId));
    final isDesktop = DeviceDetector.isDesktop;
    final theme = Theme.of(context);

    if (project == null) {
      return AppLayout(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_off, size: 80, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text('Project not found',
                  style: TextStyle(fontSize: 20, color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, '/projects'),
                child: const Text('Back to Projects'),
              ),
            ],
          ),
        ),
      );
    }

    SeoController.of(context).updatePage(SeoData(
      title: '${project.title} - SFWF Showcase',
      description: project.shortDesc,
      ogType: 'article',
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
              onTap: () => Navigator.pushNamed(context, '/projects'),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, size: 20),
                  const SizedBox(width: 8),
                  Text('Back to Projects',
                      style: TextStyle(color: theme.colorScheme.primary)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(project.title,
                style: TextStyle(
                  fontSize: isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(project.shortDesc,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onSurfaceVariant,
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
                  color: theme.colorScheme.primary,
                )),
            const SizedBox(height: 16),
            ...project.features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 20,
                          color: theme.colorScheme.primary),
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
