import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final seo = SeoController.of(context);
    seo.updatePage(const SeoData(
      title: 'Projects - Bahy Developer',
      description: 'Explore the amazing Flutter projects built by Bahy.',
    ));

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: const Center(
          child: Text('List of projects will be loaded from API.')),
    );
  }
}
