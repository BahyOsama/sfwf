import 'dart:developer';
import 'dart:html' as html;
import 'dart:convert';
import 'package:sfwf/seo/seo_controller.dart';

class SsrClient {
  final SeoController seoController;

  SsrClient({required this.seoController});

  void hydrate() {
    final stateScript = html.document.getElementById('__SFWF_STATE__');
    if (stateScript != null) {
      // استخدم text بدلاً من textContent
      final jsonString = stateScript.text;
      if (jsonString != null && jsonString.isNotEmpty) {
        final state = jsonDecode(jsonString);
        log('Hydrating with state: $state');
      }
    }
    final title = html.document.title;
    final description = _getMetaContent('description');
    seoController.updatePage(SeoData(title: title, description: description));
  }

  String? _getMetaContent(String name) {
    final meta = html.document.querySelector('meta[name="$name"]');
    return meta?.getAttribute('content');
  }
}
