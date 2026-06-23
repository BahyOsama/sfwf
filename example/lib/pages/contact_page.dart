import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfwf/sfwf.dart';
import '../providers/providers.dart';
import '../widgets/layout.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = DeviceDetector.isDesktop;
    final theme = Theme.of(context);

    SeoController.of(context).updatePage(const SeoData(
      title: 'Contact Us - SFWF Showcase',
      description:
          'Get in touch with the SFWF team. We are here to help you build amazing Flutter web apps.',
      ogType: 'website',
    ));

    return AppLayout(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : 24,
          vertical: 48,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: isDesktop ? 5 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Get in Touch',
                      style: TextStyle(
                        fontSize: isDesktop ? 36 : 28,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 8),
                  Text(
                    'Have a project in mind? We would love to hear from you.',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _ContactForm(),
                ],
              ),
            ),
            if (isDesktop) ...[
              const SizedBox(width: 80),
              const Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ContactInfo(
                      Icons.email, 'Email', 'dev.bahy1@gmail.com', 'We reply within 24 hours'),
                    SizedBox(height: 32),
                    _ContactInfo(
                      Icons.location_on, 'Location', 'Cairo, Egypt', 'Remote-first team'),
                    SizedBox(height: 32),
                    _ContactInfo(
                      Icons.access_time, 'Hours', 'Mon - Fri, 9AM - 6PM', 'Weekends by appointment'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contactFormProvider);
    final theme = Theme.of(context);

    if (state.sent) {
      return Column(
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          const Text('Message Sent!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Thank you for reaching out. We will get back to you within 24 hours.',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => ref.read(contactFormProvider.notifier).reset(),
            child: const Text('Send Another Message'),
          ),
        ],
      );
    }

    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => ref.read(contactFormProvider.notifier).setName(v),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) => ref.read(contactFormProvider.notifier).setEmail(v),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Message',
            prefixIcon: Icon(Icons.message),
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
          onChanged: (v) => ref.read(contactFormProvider.notifier).setMessage(v),
        ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(state.errorMessage!,
              style: TextStyle(color: theme.colorScheme.error)),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: state.isValid && !state.sending
                ? () => ref.read(contactFormProvider.notifier).submit()
                : null,
            icon: state.sending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send),
            label: Text(state.sending ? 'Sending...' : 'Send Message'),
          ),
        ),
      ],
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _ContactInfo(this.icon, this.title, this.value, this.subtitle);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                )),
            Text(value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                )),
          ],
        ),
      ],
    );
  }
}
