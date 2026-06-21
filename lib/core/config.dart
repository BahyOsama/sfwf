import 'package:flutter/material.dart';

/// Main configuration for the SFWF application.
class SFWFConfig {
  /// The display name of the application.
  final String appName;

  /// The base URL of the application.
  final String baseUrl;

  /// Default SEO metadata values.
  final SeoDefaults seoDefaults;

  /// The server-side rendering mode to use.
  final SsrMode ssrMode;

  /// Whether AI features are enabled.
  final bool enableAI;

  /// Optional OpenAI API key for AI features.
  final String? openAiApiKey;

  /// The list of locales the application supports.
  final List<Locale> supportedLocales;

  /// Duration that cached content remains valid.
  final Duration cacheDuration;

  /// Whether progressive web app support is enabled.
  final bool enablePwa;

  /// Creates a new [SFWFConfig] with the given parameters.
  const SFWFConfig({
    required this.appName,
    required this.baseUrl,
    this.seoDefaults = const SeoDefaults(),
    this.ssrMode = SsrMode.hybrid,
    this.enableAI = false,
    this.openAiApiKey,
    this.supportedLocales = const [Locale('en')],
    this.cacheDuration = const Duration(minutes: 5),
    this.enablePwa = true,
  });
}

/// Default SEO metadata values for the application.
class SeoDefaults {
  /// Suffix appended to the page title.
  final String titleSuffix;

  /// Default meta description for pages.
  final String defaultDescription;

  /// Default Open Graph image URL.
  final String defaultImage;

  /// Default Twitter handle for SEO.
  final String twitterHandle;

  /// Creates a new [SeoDefaults] with the given values.
  const SeoDefaults({
    this.titleSuffix = ' | SFWF',
    this.defaultDescription =
        'Built with Smart Flutter Web Framework',
    this.defaultImage = '/default-og.png',
    this.twitterHandle = '@sfwf',
  });
}

/// Server-side rendering modes for the application.
enum SsrMode {
  /// Server-side rendering is disabled.
  off,
  /// Only server-side rendering is used.
  ssrOnly,
  /// Hybrid mode combining SSR and client-side rendering.
  hybrid,
  /// Pre-renders pages at build time.
  prerenderOnly,
}
