import 'dart:io';

class PrerenderCli {
  static Future<void> prerenderRoutes(
      List<String> routes, String baseUrl, String outputDir) async {
    const toolPath = 'tool/prerender.dart';
    final toolFile = File(toolPath);
    if (!await toolFile.exists()) {
      stdout.writeln('⚠️ Pre-render tool not found at $toolPath');
      stdout.writeln('Creating default prerender script...');
      await toolFile.create(recursive: true);
      await toolFile.writeAsString('''
import 'dart:io';
import 'package:puppeteer/puppeteer.dart';

Future<void> main(List<String> args) async {
  final routes = args.isNotEmpty ? args : ['/'];
  final baseUrl = 'http://localhost:8080';
  final outputDir = Directory('build/web');

  final browser = await puppeteer.launch(headless: true, args: ['--no-sandbox']);
  for (final route in routes) {
    stdout.writeln('📄 Pre-rendering \$route');
    final page = await browser.newPage();
    try {
      await page.goto('\$baseUrl\$route', wait: Until.networkIdle);
      final content = await page.content;
      final routePath = route == '/' ? '' : route;
      final file = File('\${outputDir.path}\$routePath/index.html');
      await file.create(recursive: true);
      await file.writeAsString(content ?? '');
    } catch (e) {
      stderr.writeln('❌ Error pre-rendering \$route: \$e');
    } finally {
      await page.close();
    }
  }
  await browser.close();
  stdout.writeln('✅ Pre-rendering completed.');
}
''');
    }

    final process = await Process.start('dart', ['run', toolPath, ...routes]);
    await process.stdout.pipe(stdout);
    await process.stderr.pipe(stderr);
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      stderr.writeln('❌ Pre-rendering failed with exit code $exitCode');
    }
  }
}
