import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sfwf/core/config.dart';
import 'package:universal_html/html.dart' as html;
import 'seo_provider.dart';

class SeoController extends ChangeNotifier {
  final SFWFConfig config;
  SeoData _currentData = const SeoData();

  SeoController({required this.config});

  static SeoController of(BuildContext context) {
    return SeoControllerProvider.of(context);
  }

  void updatePage(SeoData data) {
    _currentData = _currentData.merge(data);
    _applyToDom();
    notifyListeners();
  }

  SeoData get currentData => _currentData;

  void _applyToDom() {
    if (!kIsWeb) return;

    try {
      final title = _currentData.title?.isNotEmpty == true
          ? '${_currentData.title}${config.seoDefaults.titleSuffix}'
          : config.appName;

      html.document.title = title;

      _setMeta('description',
          _currentData.description ?? config.seoDefaults.defaultDescription);

      // Open Graph
      _setMeta('og:title', _currentData.title ?? config.appName);
      _setMeta('og:description',
          _currentData.description ?? config.seoDefaults.defaultDescription);
      _setMeta('og:image',
          _currentData.image ?? config.seoDefaults.defaultImage);
      _setMeta('og:url', config.baseUrl + (html.window.location.pathname ?? ''));
      _setMeta('og:type', _currentData.ogType ?? 'website');
      _setMeta('og:site_name', config.appName);
      _setMeta('og:locale',
          _currentData.locale ?? config.supportedLocales.first.toLanguageTag());

      // Twitter Cards
      _setMeta('twitter:card', _currentData.twitterCard ?? 'summary_large_image');
      _setMeta('twitter:title', _currentData.title ?? config.appName);
      _setMeta('twitter:description',
          _currentData.description ?? config.seoDefaults.defaultDescription);
      _setMeta('twitter:image',
          _currentData.image ?? config.seoDefaults.defaultImage);
      _setMeta('twitter:site', config.seoDefaults.twitterHandle);

      // Additional meta tags
      if (_currentData.keywords != null) {
        _setMeta('keywords', _currentData.keywords!);
      }
      if (_currentData.themeColor != null) {
        _setMeta('theme-color', _currentData.themeColor!);
        _setMeta('msapplication-TileColor', _currentData.themeColor!);
      }
      if (_currentData.canonicalUrl != null) {
        _setLink('canonical', _currentData.canonicalUrl!);
      }

      // JSON-LD Structured Data
      if (_currentData.structuredData != null) {
        _injectJsonLd(_currentData.structuredData!);
      }

      // Robots meta
      if (_currentData.noIndex != null && _currentData.noIndex!) {
        _setMeta('robots', 'noindex, nofollow');
      }
    } catch (_) {}
  }

  void _setMeta(String name, String content) {
    try {
      var meta = html.document.querySelector(
          'meta[name="$name"]') as html.MetaElement?;
      if (meta == null) {
        meta = html.document.createElement('meta') as html.MetaElement;
        meta.setAttribute('name', name);
        html.document.head!.append(meta);
      }
      meta.setAttribute('content', content);
    } catch (_) {}
  }

  void _setLink(String rel, String href) {
    try {
      var link = html.document.querySelector(
          'link[rel="$rel"]') as html.LinkElement?;
      if (link == null) {
        link = html.document.createElement('link') as html.LinkElement;
        link.setAttribute('rel', rel);
        html.document.head!.append(link);
      }
      link.setAttribute('href', href);
    } catch (_) {}
  }

  void _injectJsonLd(Map<String, dynamic> json) {
    try {
      final script = html.document.querySelector(
              '#sfwf-json-ld') as html.ScriptElement? ??
          html.document.createElement('script') as html.ScriptElement;
      script.id = 'sfwf-json-ld';
      script.setAttribute('type', 'application/ld+json');
      script.text = jsonEncode(json);
      if (script.parent == null) html.document.head!.append(script);
    } catch (_) {}
  }

  void setThemeColor(String color) {
    updatePage(SeoData(themeColor: color));
  }
}

class SeoData {
  final String? title;
  final String? description;
  final String? image;
  final String? ogType;
  final String? twitterCard;
  final String? keywords;
  final String? themeColor;
  final String? canonicalUrl;
  final String? locale;
  final bool? noIndex;
  final Map<String, dynamic>? structuredData;

  const SeoData({
    this.title,
    this.description,
    this.image,
    this.ogType,
    this.twitterCard,
    this.keywords,
    this.themeColor,
    this.canonicalUrl,
    this.locale,
    this.noIndex,
    this.structuredData,
  });

  SeoData merge(SeoData other) => SeoData(
        title: other.title ?? title,
        description: other.description ?? description,
        image: other.image ?? image,
        ogType: other.ogType ?? ogType,
        twitterCard: other.twitterCard ?? twitterCard,
        keywords: other.keywords ?? keywords,
        themeColor: other.themeColor ?? themeColor,
        canonicalUrl: other.canonicalUrl ?? canonicalUrl,
        locale: other.locale ?? locale,
        noIndex: other.noIndex ?? noIndex,
        structuredData: other.structuredData ?? structuredData,
      );
}
