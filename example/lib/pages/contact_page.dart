import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final seo = SeoController.of(context);
    seo.updatePage(const SeoData(
      title: 'Contact Bahy Developer',
      description: 'Get in touch with Bahy for your next Flutter project.',
    ));

    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: const Center(child: Text('Contact form will be implemented.')),
    );
  }
}
