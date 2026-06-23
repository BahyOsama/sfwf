import 'package:puppeteer/puppeteer.dart';

import 'ssr_renderer_base.dart';

class PuppeteerSsrRenderer implements SsrRenderer {
  Browser? _browser;
  bool _initialized = false;

  PuppeteerSsrRenderer();

  Future<void> _ensureInit() async {
    if (_initialized && _browser != null) return;
    _browser = await puppeteer.launch(headless: true, args: ['--no-sandbox']);
    _initialized = true;
  }

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

  @override
  Future<void> close() async {
    if (_browser != null) {
      await _browser!.close();
      _browser = null;
      _initialized = false;
    }
  }
}
