import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ServiceWorkerGenerator {
  static Future<void> generate(String webOutputDir) async {
    final swPath = '$webOutputDir/service_worker.js';
    final files = await _getAllFilesInDir(Directory(webOutputDir));
    final fileHashes = <String, String>{};

    for (var file in files) {
      final relativePath = file.path.replaceFirst(webOutputDir, '');
      if (relativePath.startsWith('/service_worker.js')) continue;
      final content = await file.readAsBytes();
      final hash = sha256.convert(content).toString().substring(0, 8);
      fileHashes[relativePath] = hash;
    }

    final swContent = '''
// SFWF Service Worker
const CACHE_NAME = 'sfwf-cache-v1';
const urlsToCache = ${jsonEncode(fileHashes.keys.toList())};
const versionHashes = ${jsonEncode(fileHashes)};

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      if (response) return response;
      return fetch(event.request).then(networkResponse => {
        if (networkResponse.ok && event.request.method === 'GET') {
          const responseToCache = networkResponse.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(event.request, responseToCache);
          });
        }
        return networkResponse;
      });
    })
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});
''';

    await File(swPath).writeAsString(swContent);
    log('✅ Service Worker generated at $swPath');
  }

  static Future<List<File>> _getAllFilesInDir(Directory dir) async {
    final List<File> files = [];
    await for (var entity in dir.list(recursive: true)) {
      if (entity is File && !entity.path.contains('/.')) {
        files.add(entity);
      }
    }
    return files;
  }
}
