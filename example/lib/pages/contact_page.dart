import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';
import '../widgets/layout.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SeoController.of(context).updatePage(const SeoData(
      title: 'Contact Us - SFWF Showcase',
      description:
          'Get in touch with the SFWF team. We are here to help you build amazing Flutter web apps.',
      ogType: 'website',
    ));

    final isDesktop = DeviceDetector.isDesktop;
    final theme = Theme.of(context);

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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v?.isEmpty == true ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v?.contains('@') == true
                              ? null
                              : 'Enter valid email',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _messageCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Message',
                            prefixIcon: Icon(Icons.message),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                          validator: (v) =>
                              v?.isEmpty == true ? 'Enter your message' : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: _sending ? null : _submitForm,
                            icon: _sending
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.send),
                            label:
                                Text(_sending ? 'Sending...' : 'Send Message'),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      Icons.email,
                      'Email',
                      'dev.bahy1@gmail.com',
                      'We reply within 24 hours',
                    ),
                    SizedBox(height: 32),
                    _ContactInfo(
                      Icons.location_on,
                      'Location',
                      'Cairo, Egypt',
                      'Remote-first team',
                    ),
                    SizedBox(height: 32),
                    _ContactInfo(
                      Icons.access_time,
                      'Hours',
                      'Mon - Fri, 9AM - 6PM',
                      'Weekends by appointment',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent! We will get back to you soon.'),
          backgroundColor: Colors.green,
        ),
      );
      _nameCtrl.clear();
      _emailCtrl.clear();
      _messageCtrl.clear();
    });
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
