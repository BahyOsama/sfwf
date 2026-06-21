import 'dart:developer';
import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

class ImageOptimizer {
  static Future<void> optimizeAll(String inputDir, String outputDir,
      {int maxWidth = 1200, int quality = 85}) async {
    final input = Directory(inputDir);
    if (!await input.exists()) {
      log('⚠️ Input directory not found: $inputDir');
      return;
    }

    await Directory(outputDir).create(recursive: true);
    int optimized = 0;
    int skipped = 0;

    await for (var entity in input.list(recursive: true)) {
      if (entity is File && _isImage(entity.path)) {
        try {
          final bytes = await entity.readAsBytes();
          final image = img.decodeImage(bytes);
          if (image != null) {
            final resized = image.width > maxWidth
                ? img.copyResize(image, width: maxWidth)
                : image;
            final ext = p.extension(entity.path).toLowerCase();
            final newFileName =
                '${p.basenameWithoutExtension(entity.path)}${ext == '.png' ? '.png' : '.jpg'}';
            final outPath = p.join(outputDir, newFileName);

            List<int> optimizedBytes;
            if (ext == '.png') {
              optimizedBytes = img.encodePng(resized);
            } else if (ext == '.webp') {
              optimizedBytes = img.encodeJpg(resized, quality: quality);
            } else {
              optimizedBytes = img.encodeJpg(resized, quality: quality);
            }

            await File(outPath).writeAsBytes(optimizedBytes);
            final savedPercent =
                ((1 - optimizedBytes.length / bytes.length) * 100).toStringAsFixed(1);
            log('✅ Optimized: ${p.basename(entity.path)} -> $newFileName (saved $savedPercent%)');
            optimized++;
          } else {
            log('⚠️ Could not decode image: ${entity.path}');
            skipped++;
          }
        } catch (e) {
          log('❌ Error optimizing ${entity.path}: $e');
          skipped++;
        }
      }
    }
    log('🎉 Image optimization completed. $optimized optimized, $skipped skipped.');
  }

  static bool _isImage(String path) {
    final ext = p.extension(path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.webp', '.bmp', '.gif'].contains(ext);
  }
}
