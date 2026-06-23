import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sfwf/core/config.dart';
import 'package:sfwf/seo/seo_data.dart';
import 'package:universal_html/html.dart' as html;

class DomOperations {
  void applyToDom(SeoData data, SFWFConfig config) {
    if (!kIsWeb) return;

    try {
      final title = data.title?.isNotEmpty == true
          ? '${data.title}${config.seoDefaults.titleSuffix}'
          : config.appName;

      html.document.title = title;

      _setMeta('description',
          data.description ?? config.seoDefaults.defaultDescription);

      _setMeta('og:title', data.title ?? config.appName);
      _setMeta('og:description',
          data.description ?? config.seoDefaults.defaultDescription);
      _setMeta('og:image', data.image ?? config.seoDefaults.defaultImage);
      _setMeta('og:url',
          config.baseUrl + (html.window.location.pathname ?? ''));
      _setMeta('og:type', data.ogType ?? 'website');
      _setMeta('og:site_name', config.appName);
      _setMeta('og:locale',
          data.locale ?? config.supportedLocales.first.toLanguageTag());

      _setMeta(
          'twitter:card', data.twitterCard ?? 'summary_large_image');
      _setMeta('twitter:title', data.title ?? config.appName);
      _setMeta('twitter:description',
          data.description ?? config.seoDefaults.defaultDescription);
      _setMeta('twitter:image',
          data.image ?? config.seoDefaults.defaultImage);
      _setMeta('twitter:site', config.seoDefaults.twitterHandle);

      if (data.keywords != null) {
        _setMeta('keywords', data.keywords!);
      }
      if (data.themeColor != null) {
        _setMeta('theme-color', data.themeColor!);
        _setMeta('msapplication-TileColor', data.themeColor!);
      }
      if (data.canonicalUrl != null) {
        _setLink('canonical', data.canonicalUrl!);
      }

      if (data.structuredData != null) {
        _injectJsonLd(data.structuredData!);
      }

      if (data.noIndex == true) {
        _setMeta('robots', 'noindex, nofollow');
      }
    } catch (_) {}
  }

  void _setMeta(String name, String content) {
    try {
      var meta = html.document.querySelector(
          'meta[name="$name"]') as html.MetaElement?;
      if (meta == null) {
        meta =
            html.document.createElement('meta') as html.MetaElement;
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
        link =
            html.document.createElement('link') as html.LinkElement;
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
}
