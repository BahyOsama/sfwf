/// Defines a route pattern with an optional name and metadata.
class RouteDefinition {
  /// The route path pattern (may contain `:param` segments).
  final String path;

  /// An optional name for the route.
  final String? name;

  /// Optional metadata associated with the route.
  final Map<String, dynamic>? meta;

  /// Creates a [RouteDefinition] with the required path.
  const RouteDefinition({
    required this.path,
    this.name,
    this.meta,
  });
}
