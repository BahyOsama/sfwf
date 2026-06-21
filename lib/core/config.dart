import 'package:flutter/material.dart';

class SFWFConfig {
  final String appName;
  final String baseUrl;
  final SeoDefaults seoDefaults;
  final SsrMode ssrMode;
  final bool enableAI;
  final String? openAiApiKey;
  final List<Locale> supportedLocales;
  final Duration cacheDuration;
  final bool enablePwa;

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

class SeoDefaults {
  final String titleSuffix;
  final String defaultDescription;
  final String defaultImage;
  final String twitterHandle;

  const SeoDefaults({
    this.titleSuffix = ' | SFWF',
    this.defaultDescription =
        'Built with Smart Flutter Web Framework',
    this.defaultImage = '/default-og.png',
    this.twitterHandle = '@sfwf',
  });
}

enum SsrMode { off, ssrOnly, hybrid, prerenderOnly }
