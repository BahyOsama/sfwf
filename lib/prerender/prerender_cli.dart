import 'dart:io';

class PrerenderCli {
  static Future<void> prerenderRoutes(
      List<String> routes, String baseUrl, String outputDir) async {
    final process =
        await Process.start('dart', ['tool/prerender.dart', ...routes]);
    await process.exitCode;
  }
}
