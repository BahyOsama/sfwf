class RouteDefinition {
  final String path;
  final String? name;
  final Map<String, dynamic>? meta;

  const RouteDefinition({
    required this.path,
    this.name,
    this.meta,
  });
}
