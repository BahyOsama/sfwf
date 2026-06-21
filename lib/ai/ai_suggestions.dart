class AISuggestion {
  final String title;
  final String description;
  final String impact;

  const AISuggestion({
    required this.title,
    required this.description,
    required this.impact,
  });
}

class AIReport {
  List<String> suggestions = [];
  String? aiSuggestions;
  String url;
  String? score;

  AIReport({this.url = ''});

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
