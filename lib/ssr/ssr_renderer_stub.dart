import 'ssr_renderer_base.dart';

class PuppeteerSsrRenderer implements SsrRenderer {
  PuppeteerSsrRenderer();

  @override
  Future<String> renderToString(String url) {
    throw UnsupportedError(
      'PuppeteerSsrRenderer requires dart:io (not available on this platform).',
    );
  }

  @override
  Future<void> close() {
    throw UnsupportedError(
      'PuppeteerSsrRenderer requires dart:io (not available on this platform).',
    );
  }
}
