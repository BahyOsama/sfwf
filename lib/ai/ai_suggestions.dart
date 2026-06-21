/// Represents a single AI-generated suggestion for improvement.
class AISuggestion {
  /// Short title of the suggestion.
  final String title;

  /// Detailed description of the issue or recommendation.
  final String description;

  /// The impact level of the suggestion (e.g. "high", "medium", "low").
  final String impact;

  /// Creates an [AISuggestion] with a [title], [description], and [impact].
  const AISuggestion({
    required this.title,
    required this.description,
    required this.impact,
  });
}

/// Holds the results of an SEO analysis, including suggestions and AI feedback.
class AIReport {
  /// List of detected SEO issues.
  List<String> suggestions = [];

  /// AI-generated recommendations, if available.
  String? aiSuggestions;

  /// The URL that was analyzed.
  String url;

  /// The computed SEO score as a percentage string.
  String? score;

  /// Creates an [AIReport] for the given [url].
  AIReport({this.url = ''});

  /// Returns a formatted string with the SEO score, suggestions, and AI recommendations.
  @override
  String toString() {
    final buf = StringBuffer();
    if (score != null) {
      buf.writeln('SEO Score: $score');
    }
    buf.writeln('URL: $url');
    buf.writeln('\nSuggestions:');
    if (suggestions.isEmpty) {
      buf.writeln('  - No issues found');
    } else {
      for (final s in suggestions) {
        buf.writeln('  - $s');
      }
    }
    if (aiSuggestions != null && aiSuggestions!.isNotEmpty) {
      buf.writeln('\nAI Recommendations:');
      buf.writeln(aiSuggestions);
    }
    return buf.toString();
  }
}
