import 'package:puppeteer/puppeteer.dart';

abstract class SsrRenderer {
  Future<String> renderToString(String url);
}

class PuppeteerSsrRenderer implements SsrRenderer {
  late Browser _browser;

  PuppeteerSsrRenderer() {
    _init();
  }

  Future<void> _init() async {
    _browser = await puppeteer.launch(headless: true, args: ['--no-sandbox']);
  }

  @override
  Future<String> renderToString(String url) async {
    final page = await _browser.newPage();
    try {
      await page.goto(url, wait: Until.networkIdle);
      final content = await page.content;
      // إصلاح: التأكد من عدم إرجاع null
      return content ?? '';
    } finally {
      await page.close();
    }
  }

  Future<void> close() async => _browser.close();
}
