import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sfwf/core/config.dart';
import 'seo_provider.dart'; // استيراد المزوّد

class SeoController extends ChangeNotifier {
  final SFWFConfig config;
  SeoData _currentData = SeoData();

  SeoController({required this.config});

  // تعديل: استخدام SeoControllerProvider.of
  static SeoController of(BuildContext context) {
    return SeoControllerProvider.of(context);
  }

  void updatePage(SeoData data) {
    _currentData = _currentData.merge(data);
    _applyToDom();
    notifyListeners();
  }

  void _applyToDom() {
    if (!kIsWeb) return;

    final title = _currentData.title?.isNotEmpty == true
        ? '${_currentData.title}${config.seoDefaults.titleSuffix}'
        : config.appName;
    html.document.title = title;

    _setMeta('description',
        _currentData.description ?? config.seoDefaults.defaultDescription);
    _setMeta('og:title', _currentData.title ?? config.appName);
    _setMeta('og:description',
        _currentData.description ?? config.seoDefaults.defaultDescription);
    _setMeta('og:image', _currentData.image ?? config.seoDefaults.defaultImage);
    _setMeta('og:url', config.baseUrl + (html.window.location.pathname ?? ''));
    _setMeta('twitter:card', 'summary_large_image');
    _setMeta('twitter:title', _currentData.title ?? config.appName);
    _setMeta('twitter:description', _currentData.description ?? '');
    _setMeta(
        'twitter:image', _currentData.image ?? config.seoDefaults.defaultImage);
    _setMeta('twitter:site', config.seoDefaults.twitterHandle);

    if (_currentData.structuredData != null) {
      _injectJsonLd(_currentData.structuredData!);
    }
  }

  void _setMeta(String name, String content) {
    var meta =
        html.document.querySelector('meta[name="$name"]') as html.MetaElement?;
    if (meta == null) {
      meta = html.document.createElement('meta') as html.MetaElement;
      meta.setAttribute('name', name);
      html.document.head!.append(meta);
    }
    meta.setAttribute('content', content);
  }

  void _injectJsonLd(Map<String, dynamic> json) {
    final script =
        html.document.querySelector('#sfwf-json-ld') as html.ScriptElement? ??
            html.document.createElement('script') as html.ScriptElement;
    script.id = 'sfwf-json-ld';
    script.setAttribute('type', 'application/ld+json');
    script.text = jsonEncode(json);
    if (script.parent == null) html.document.head!.append(script);
  }
}

class SeoData {
  final String? title;
  final String? description;
  final String? image;
  final Map<String, dynamic>? structuredData;

  const SeoData(
      {this.title, this.description, this.image, this.structuredData});

  SeoData merge(SeoData other) => SeoData(
        title: other.title ?? title,
        description: other.description ?? description,
        image: other.image ?? image,
        structuredData: other.structuredData ?? structuredData,
      );
}
