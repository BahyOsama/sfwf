import 'package:sfwf/ssr/ssr_server.dart';

Future<void> main(List<String> args) async {
  final port = int.tryParse(args.firstWhere(
        (a) => a.startsWith('--port='),
        orElse: () => '--port=3000',
      ).split('=').last) ?? 3000;

  final buildDirPath = args.firstWhere(
        (a) => a.startsWith('--build-dir='),
        orElse: () => '--build-dir=build/web',
      ).split('=').last;

  await startSsrServer(buildDirPath: buildDirPath, port: port);
}
