/// Abstract interface for server-side rendering of pages to HTML strings.
abstract class SsrRenderer {
  /// Renders the page at [url] to a full HTML string.
  Future<String> renderToString(String url);

  /// Releases all resources held by this renderer.
  Future<void> close();
}
