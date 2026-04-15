import 'dart:developer';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

class ImageOptimizer {
  static Future<void> optimizeAll(String inputDir, String outputDir) async {
    final input = Directory(inputDir);
    if (!await input.exists()) {
      log('⚠️ Input directory not found: $inputDir');
      return;
    }
    await Directory(outputDir).create(recursive: true);
    await for (var entity in input.list(recursive: true)) {
      if (entity is File && _isImage(entity.path)) {
        try {
          final bytes = await entity.readAsBytes();
          final image = img.decodeImage(bytes);
          if (image != null) {
            // تغيير الحجم إلى عرض 1200 مع الحفاظ على النسبة
            final resized = img.copyResize(image, width: 1200);
            // ترميز بصيغة JPEG بجودة 85%
            final optimized = img.encodeJpg(resized, quality: 85);
            final newFileName =
                '${p.basenameWithoutExtension(entity.path)}.jpg';
            final outPath = p.join(outputDir, newFileName);
            await File(outPath).writeAsBytes(optimized);
            log('✅ Optimized: ${entity.path} -> $outPath');
          } else {
            log('⚠️ Could not decode image: ${entity.path}');
          }
        } catch (e) {
          log('❌ Error optimizing ${entity.path}: $e');
        }
      }
    }
    log('🎉 Image optimization completed.');
  }

  static bool _isImage(String path) {
    final ext = p.extension(path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.webp', '.bmp', '.gif'].contains(ext);
  }
}
