import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';

class ServiceWorkerGenerator {
  static Future<void> generate(String webOutputDir) async {
    final swPath = '$webOutputDir/service_worker.js';
    final dir = Directory(webOutputDir);
    if (!await dir.exists()) {
      log('⚠️ Web output directory not found: $webOutputDir');
      return;
    }

    final files = await _getAllFilesInDir(dir);
    final fileHashes = <String, String>{};

    for (var file in files) {
      final relativePath = file.path.replaceFirst(webOutputDir, '').replaceAll('\\', '/');
      if (relativePath.startsWith('/service_worker.js')) continue;
      try {
        final content = await file.readAsBytes();
        final hash = sha256.convert(content).toString().substring(0, 8);
        fileHashes[relativePath] = hash;
      } catch (_) {}
    }

    final swContent = '''
// SFWF Service Worker v2
const CACHE_NAME = 'sfwf-cache-v2';
const urlsToCache = ${jsonEncode(fileHashes.keys.toList())};
const versionHashes = ${jsonEncode(fileHashes)};

self.addEventListener('install', event => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      const cachePromises = urlsToCache.map(url => {
        return cache.add(url).catch(() => {
          // Skip failed resources
        });
      });
      return Promise.all(cachePromises);
    })
  );
});

self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET') return;
  
  event.respondWith(
    caches.match(event.request).then(cached => {
      const fetchPromise = fetch(event.request).then(networkResponse => {
        if (networkResponse.ok) {
          const responseToCache = networkResponse.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(event.request, responseToCache);
          });
        }
        return networkResponse;
      }).catch(() => cached);
      
      return cached || fetchPromise;
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
    }).then(() => self.clients.claim())
  );
});
''';

    await File(swPath).writeAsString(swContent);
    log('✅ Service Worker generated at $swPath');
  }

  static Future<List<File>> _getAllFilesInDir(Directory dir) async {
    final List<File> files = [];
    try {
      await for (var entity in dir.list(recursive: true)) {
        if (entity is File && !entity.path.contains(r'\.')) {
          files.add(entity);
        }
      }
    } catch (_) {}
    return files;
  }
}
