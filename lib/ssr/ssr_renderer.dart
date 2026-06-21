import 'package:puppeteer/puppeteer.dart';

/// Interface for server-side rendering of pages to HTML strings.
abstract class SsrRenderer {
  /// Renders the page at [url] to a full HTML string.
  Future<String> renderToString(String url);
  /// Releases all resources held by this renderer.
  Future<void> close();
}

/// Server-side renderer that uses Puppeteer (headless Chrome) to render pages.
class PuppeteerSsrRenderer implements SsrRenderer {
  Browser? _browser;
  bool _initialized = false;

  /// Creates a new [PuppeteerSsrRenderer]; the browser is launched lazily.
  PuppeteerSsrRenderer();

  Future<void> _ensureInit() async {
    if (_initialized && _browser != null) return;
    _browser = await puppeteer.launch(headless: true, args: ['--no-sandbox']);
    _initialized = true;
  }

  /// Renders the page at [url] to an HTML string using headless Chrome.
  @override
  Future<String> renderToString(String url) async {
    await _ensureInit();
    final page = await _browser!.newPage();
    try {
      await page.goto(url, wait: Until.networkIdle);
      final content = await page.content;
      return content ?? '';
    } finally {
      await page.close();
    }
  }

  /// Closes the underlying browser instance and releases resources.
  @override
  Future<void> close() async {
    if (_browser != null) {
      await _browser!.close();
      _browser = null;
      _initialized = false;
    }
  }
}
