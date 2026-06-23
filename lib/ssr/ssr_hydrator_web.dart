import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sfwf/seo/seo_controller.dart';
import 'package:universal_html/html.dart' as html;

class SsrHydrator {
  final SeoController seoController;

  SsrHydrator({required this.seoController});

  void hydrate() {
    if (!kIsWeb) return;

    try {
      final stateScript = html.document.getElementById('__SFWF_STATE__');
      if (stateScript != null) {
        final jsonString = stateScript.text;
        if (jsonString != null && jsonString.isNotEmpty) {
          final state = jsonDecode(jsonString);
          log('Hydrating with state: $state');
        }
      }

      final title = html.document.title;
      final metaDesc = _getMetaContent('description');
      final safeTitle = (title as String?) ?? '';
      if (safeTitle.isNotEmpty || (metaDesc?.isNotEmpty == true)) {
        seoController.updatePage(
            SeoData(title: safeTitle, description: metaDesc));
      }
    } catch (e) {
      log('SSR hydration error: $e');
    }
  }

  String? _getMetaContent(String name) {
    try {
      final meta = html.document.querySelector('meta[name="$name"]');
      return meta?.getAttribute('content');
    } catch (_) {
      return null;
    }
  }
}
